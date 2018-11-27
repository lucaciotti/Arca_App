import 'dart:async';
import 'package:arca_flutter_app/helpers/network_api.dart';
import 'package:arca_flutter_app/models/magana.dart';

class MaganaController {
  NetApiHelper _netUtil = new NetApiHelper();

  Future<List<Magana>> fetchRightMag(String rMag) {
    final url = Uri.http("172.16.2.9:3018","/api/v1/magana/right/"+rMag);
    return _netUtil.get(url).then((dynamic json) async {
      if(json is List){
        List<Magana> magList = this._parseMagJson(json);
        return magList;
      }
      print(json);
      return json;
    });
  }

  List<Magana> _parseMagJson(dynamic json) {
    return json.map<Magana>((data) => Magana.fromJson(data)).toList();
  }

}