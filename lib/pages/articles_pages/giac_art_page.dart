import 'dart:async';
import 'package:arca_flutter_app/confRoutes/application.dart';
import 'package:arca_flutter_app/models/giac.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:arca_flutter_app/controllers/giacController.dart';

class GiacArtPage extends StatefulWidget {
  
  final String _codart;
  GiacArtPage(this._codart);
  
  @override
  GiacArtPageState createState() => new GiacArtPageState();
}

class GiacArtPageState extends State<GiacArtPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GiacController _giacController = new GiacController();

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

    Widget body = new FutureBuilder<List<Giac>>(
        future: _giacController.fetchGiac(widget._codart),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Column(
                    children: <Widget>[
                      Card(
                        // child: Text(snapshot.data[0].descrizion),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text(snapshot.data[index].magazzino+' - '+snapshot.data[index].descrMag),
                              subtitle: Text(snapshot.data[index].unmisura+' '+snapshot.data[index].esistenza.toString()),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),)
                          ],
                        ),
                      ),
                    ],
                  );   
                }
              ),
            );
          } else if (snapshot.hasError) {
            _showDialog('Error', snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );


    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Giac: '+widget._codart),
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
    );
  }

}