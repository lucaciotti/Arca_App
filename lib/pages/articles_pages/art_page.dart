import 'dart:async';
import 'package:arca_flutter_app/confRoutes/application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:arca_flutter_app/controllers/articleController.dart';

class ArticlePage extends StatefulWidget {
  
  final String _codart;
  ArticlePage(this._codart);
  
  @override
  ArticlePageState createState() => new ArticlePageState();
}

class ArticlePageState extends State<ArticlePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ArticleController _artController = new ArticleController();

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

    Widget body = new FutureBuilder(
        future: _artController.fetchArticle(widget._codart),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new Container(
              child: Column(
                children: <Widget>[
                  Card(
                    // child: Text(snapshot.data[0].descrizion),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text(snapshot.data[0].codice),
                          subtitle: Text(snapshot.data[0].descrizion),
                        ),
                        Row(children: <Widget>[
                          Text('Gruppo Prodotto: '),
                          Text(snapshot.data[0].gruppo)
                        ],),
                        Row(children: <Widget>[
                          Text('Un. Misura: '),
                          Text(snapshot.data[0].unmisura)
                        ],),
                        Row(children: <Widget>[
                          Text('Peso: '),
                          Text(snapshot.data[0].pesounit.toString()+" Kg")
                        ],),
                        Row(children: <Widget>[
                          Text('Misure (LxHxS): '),
                          Text(snapshot.data[0].misural.toString()+" x "+snapshot.data[0].misurah.toString()+" x "+snapshot.data[0].misuras.toString()+" mm")
                        ],),
                        Divider(),
                        Text('Unità Misura Alternative', style: TextStyle( fontWeight: FontWeight.bold),),
                        Row(children: <Widget>[
                          // Text('Un. Misura 2: '),
                          Text(snapshot.data[0].unmisura2+" = "+snapshot.data[0].fatt2.toString()+" "+snapshot.data[0].unmisura)
                        ],),
                        Row(children: <Widget>[
                          // Text('Un. Misura 3: '),
                          Text(snapshot.data[0].unmisura3+" = "+snapshot.data[0].fatt3.toString()+" "+snapshot.data[0].unmisura)
                        ],),
                        Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),)
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text("Giacenza"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => Application.router.navigateTo(context, '/giacArt/'+snapshot.data[0].codice, transition: TransitionType.inFromRight),
                  ),
                ],
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
        title: Text('Art: '+widget._codart),
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