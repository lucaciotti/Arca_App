import 'dart:async';
// import 'package:arca_flutter_app/helpers/barcodeScan.dart';
import 'package:arca_flutter_app/helpers/network_api.dart';


class SearchController {
  // static final _baseUrl = env['BASE_URL'];
  // static final _apiKey = env['APY_KEY'];
  // static final _apiScope = env['APY_SCOPE'];
  // static final _apiClientId = env['APY_CLIENT_ID'];
  // static final _apiGrantType = env['APY_GRANT_TYPE'];

  // BarcodeScan _barcodeScan = new BarcodeScan();
  NetApiHelper _netUtil = new NetApiHelper();



  Future<String> searchScan (String code) async {
    String res = await this.barcodeSeach(code);
    if (res==null || res.isEmpty) res = await this.barcodeAltSeach(code);
    if (res==null || res.isEmpty) res = await this.articleSeach(code);
    if (res==null || res.isEmpty) return 'error';
    return res;
  }

  Future<String> barcodeSeach(String barcode) {
    final artUrl = Uri.http("172.16.2.102:3018","/api/v1/artBarcode/"+barcode);
    return _netUtil.get(artUrl).then((dynamic json) async {
      if(json is List){
        print(json[0]['codicearti']);
        return json[0]['codicearti'];
      }
      print(json);
      return null;
    });
  }

  Future<String> barcodeAltSeach(String barcode) {
    final artUrl = Uri.http("172.16.2.102:3018","/api/v1/artbarcode2/"+barcode);
    return _netUtil.get(artUrl).then((dynamic json) async {
       if(json is List){
        print(json[0]['codicearti']);
        return json[0]['codicearti'];
      }
      print(json);
      return null;
    });
  }

  Future<String> articleSeach(String artcode) {
    final artUrl = Uri.http("172.16.2.102:3018","/api/v1/article/"+artcode, {'col': 'codice'});
    return _netUtil.get(artUrl).then((dynamic json) async {
       if(json is List){
        print(json[0]['codice']);
        return json[0]['codice'];
      }
      print(json);
      return null;
      // if(res['success'] != null){
      //   res = res['success'];
      //   if(res.length>0){
      //     // _showDialog("Result for: "+barcode, res[0].toString());
      //     print(res[0]['codice']);
      //     return res[0]['codice'];
      //   } else {
      //     // _showDialog("Empty Result", "No Article Found!");
      //     print('emptyBarcode');
      //     return null;
      //   }
      // } else {
      //   print(res['errorMessage']);
      //   // _showDialog("Empty Result", "No Article Found!");
      // }
      // // print(res[0]['codicearti']);
      // return res;
    });
  }

}