import 'package:flutter/material.dart';
// import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:arca_flutter_app/confRoutes/routes.dart';
import 'package:arca_flutter_app/confRoutes/application.dart';
import 'package:arca_flutter_app/pages/home_page.dart';

void main() {
  Routes routes = new Routes();
  Application.router = routes.router;

  runApp(new MaterialApp(
    home: new HomePage(),
    theme: ThemeData(
      fontFamily: 'PT_Sans_Narrow',
      primarySwatch: Colors.lightGreen,
      ),
    onGenerateRoute: Application.router.generator,
  ));
}