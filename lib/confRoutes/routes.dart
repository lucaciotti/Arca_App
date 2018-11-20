import 'package:arca_flutter_app/pages/articles_pages/art_page.dart';
import 'package:arca_flutter_app/pages/articles_pages/giac_art_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
// import './route_handlers.dart';

import 'package:arca_flutter_app/pages/home_page.dart';
import 'package:arca_flutter_app/pages/articles_pages/search_art_page.dart';

class Routes {
  Router router;
  static String home = "/home";
  static String searchArt = "/search_art";
  static String article = "/article";

  Routes(){
    this.router = new Router();
    configureRoutes(router);
  }

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    
    router.define("/home", handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new HomePage();
      }
    ));
    
    router.define("/search_art", handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new ArtSeachPage();
      }
    ));

    router.define("/art/:codart", handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new ArticlePage(params["codart"][0]);
      }
    ));

    router.define("/giacArt/:codart", handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new GiacArtPage(params["codart"][0]);
      }
    ));
  }
}