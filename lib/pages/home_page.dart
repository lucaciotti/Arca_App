import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:arca_flutter_app/confRoutes/application.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  // static String tag = 'login-page';
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showNotImplementedMessage() {
    // Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(
        const SnackBar(content: Text("Not yet implemented...")));
  }

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 32.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/logo.png'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome to Arca App',
        style: TextStyle(
          fontSize: 28.0,
        ),
      ),
    );

    final menu1 = Expanded( 
      child: SafeArea( 
        child: new GridView(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Center(
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.search),
                  new Text('Ricerca Articoli'),
                ]),
              ),
            ),
            onTap: () { Application.router.navigateTo(context, '/search_art', transition: TransitionType.inFromBottom); },
          ),
          new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Center(
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.locationArrow),
                  new Text('Ubicazione'),
                ]),
              ),
            ),
            onTap: () { _showNotImplementedMessage(); },
          ),
          new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Center(
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.truckLoading),
                  new Text('Gestione PackingList'),
                ]),
              ),
            ),
            onTap: () { _showNotImplementedMessage(); },
          ),
        ]),
      ),
    );

    final menu2 = Expanded( 
      child: SafeArea( 
        child: new GridView(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Center(
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.truckLoading),
                  new Text('Gestione PackingList'),
                ]),
              ),
            ),
            onTap: () { },
          ),
          new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Center(
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.print),
                  new Text('Ristampa Etichette'),
                ]),
              ),
            ),
            onTap: () { },
          ),
        ]),
      ),
    );

    final menu3 = Expanded( 
      child: SafeArea( 
        child: new GridView(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          new GestureDetector(
            child: new Card(
              elevation: 5.0,
              child: new Center(
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.boxes),
                  new Text('Procedura Inventario'),
                ]),
              ),
            ),
            onTap: () { Application.router.navigateTo(context, '/invCoupon', transition: TransitionType.inFromBottom); },
          ),
        ]),
      ),
    );

    Widget drawer = new Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Arca APP'),
            accountEmail: Text('Menù'),
            decoration: BoxDecoration(
              color: Colors.lightGreen[300],
            ),
          ),
          ListTile(
            leading: new Icon(FontAwesomeIcons.barcode),
            title: Text('Search Article', style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
            onTap: () {
              Application.router.navigateTo(context, '/search_art', transition: TransitionType.inFromBottom);
              //  Navigator.of(context).pushNamed('/search_art');
            },
          ),
          ListTile(
            leading: new Icon(FontAwesomeIcons.search),
            title: Text('Item 2', style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
            onTap: () {
              this._showNotImplementedMessage();
            },
          ),
        ],
      ),
    );

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
          logo,
          welcome,
          Padding(
            padding: EdgeInsets.symmetric( vertical: 8.0),
            child: Text(
              'Funzioni per Magazzino',
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          menu1,
          Padding(
            padding: EdgeInsets.symmetric( vertical: 8.0),
            child: Text(
              'Inventario',
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          menu3
        ],
      ),
    );

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Arca APP'),
      ),
      // drawer: drawer,
      body: body,
    );
  }
}
