import 'dart:async';
// import 'package:arca_flutter_app/helpers/barcodeScan.dart';
import 'package:arca_flutter_app/helpers/network_api.dart';
import 'package:arca_flutter_app/models/article.dart';

class ArticleController {
  NetApiHelper _netUtil = new NetApiHelper();

  Future<List<Article>> fetchArticle(String codart) {
    final artUrl = Uri.http("172.16.2.9:3018","/api/v1/article/"+codart, {'col': 'codice,descrizion,gruppo,pesounit,u_misural,u_misurah,u_misuras,unmisura,unmisura2,unmisura3,fatt2,fatt3,lotti'});
    return _netUtil.get(artUrl).then((dynamic json) async {
      if(json is List){
        List<Article> artList = this._parseJson(json);
        return artList;
      }
      return json;
    });
  }

  List<Article> _parseJson(dynamic json) {
    return json.map<Article>((data) => Article.fromJson(data)).toList();
  }

}