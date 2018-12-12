import 'dart:async';
// import 'package:arca_flutter_app/helpers/barcodeScan.dart';
import 'package:arca_flutter_app/helpers/network_api.dart';
import 'package:arca_flutter_app/models/giac.dart';

class GiacController {
  NetApiHelper _netUtil = new NetApiHelper();

  Future<List<Giac>> fetchGiac(String codart, [String esercizio='2018']) {
    final url = Uri.http("172.16.2.102:3018","/api/v1/giacArt/"+esercizio+"/"+codart, {'col': 'articolo,magazzino', 'onlygiac': '1'});
    return _netUtil.get(url).then((dynamic json) async {
      if(json is List){
        List<Giac> artList = this._parseJson(json);
        return artList;
      }
      return json;
    });
  }

  List<Giac> _parseJson(dynamic json) {
    return json.map<Giac>((data) => Giac.fromJson(data)).toList();
  }

}