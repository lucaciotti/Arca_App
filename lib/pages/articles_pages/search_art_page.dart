import 'dart:async';
import 'package:arca_flutter_app/confRoutes/application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:arca_flutter_app/helpers/barcodeScan.dart';
import 'package:arca_flutter_app/controllers/searchController.dart';

class ArtSeachPage extends StatefulWidget {
  static String tag = 'home-page';
  // static String tag = 'login-page';
  @override
  ArtSeachPageState createState() => new ArtSeachPageState();
}

class ArtSeachPageState extends State<ArtSeachPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String barcode = "";
  SearchController _seachController = new SearchController();
  BarcodeScan _barcodeScan = new BarcodeScan();
  TextEditingController _textcontroller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showDialog<T>(title, content, [route]) {
    // flutter defined function
    showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then<void>((T value) {
      if (route != null) {
        Application.router.navigateTo(context, route, transition: TransitionType.inFromBottom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.green[50],
            ]),
      ),
      child: Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column( children: <Widget>[
              TextField(
                autofocus: false,
                decoration: const InputDecoration(labelText: "Barcode or Cod.Art.:"),
                controller:  new TextEditingController.fromValue(new TextEditingValue(text: barcode,selection: new TextSelection.collapsed(offset: barcode.length))),//new TextEditingController(text: barcode), 
                onChanged: (String value) => this.barcode = value,
              ),
            ],)
          ),
          // new Text("Barcode Number after Scan : " + barcode),
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          new Container(
            child: new RaisedButton(
              onPressed: () { this.barcodeSeach(this.barcode);}, 
              child: new Row(children: <Widget>[ new Icon(Icons.search), new Text("Seach")], mainAxisAlignment: MainAxisAlignment.center,) 
            ),
            padding: const EdgeInsets.all(8.0),
          ),
        ],
      ),
    );

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Search Articles'),
      ),
      body: body,
      bottomNavigationBar: new BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                // color: Colors.white,
                onPressed: () {
                  Application.router.navigateTo(context, '/home', transition: TransitionType.inFromRight, replace: true, clearStack: true);
                  //  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ],
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(FontAwesomeIcons.barcode),
          onPressed: () {
            this.barcodeScanning();
          },
        ),
    );
  }

  Future barcodeScanning() async {
    String res = await this._barcodeScan.scan();
    if (res.startsWith('error:')) {
      this._showDialog('Scan Error', res.substring(6));
    } else {
      setState(() {
        this.barcode = res;
        this.barcodeSeach(res);
      });
    }
  }

  Future<dynamic> barcodeSeach(String barcode) async {
    String res = await this._seachController.searchScan(barcode);
    if (res == "error"){
       _showDialog("Empty Result", "No Article Found!");
    } else {
      //_showDialog("Result for: "+barcode, res, '/art/'+res);
      Application.router.navigateTo(context, '/art/'+res, transition: TransitionType.inFromBottom);
      // Application.router.navigateTo(context, '/art/'+res, transition: TransitionType.inFromBottom);
      // Navigator.of(context).pushNamed('/article');
    }
  }

}