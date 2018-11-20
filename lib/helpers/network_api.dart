import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetApiHelper {
  // next three lines makes this class a Singleton
  static NetApiHelper _instance = new NetApiHelper.internal();
  NetApiHelper.internal();
  factory NetApiHelper() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(Uri url, {Map headers}) {
    // if (headers == null) headers={"Accept": "application/json"};
    try {
      return http.get(url, headers: headers).then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        if (statusCode == 200 && res != null) {
          print(res);
          dynamic json = _decoder.convert(res);
          if(json['success'] != null){
            json = json['success'];
            if(json.length>0){
              return json;
            } else {
              print('emptyJson');
              return {"errorMessage": "Empty Json!"};
            }
          } else {
            print(json['errorMessage']);
            return json;
          }
        } else if (statusCode == 400) {
          return {"errorMessage": "Bad request"};
        } else if (statusCode == 401) {
          return {"errorMessage": "Unauthorized"};
        } else {
          throw new Exception("Error while fetching data");
        }
      }).catchError((e) {
        print("Got error: ${e.error}");     // Finally, callback fires.
        return {"errorMessage": "${e.error}"};
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> post(Uri url, {Map headers, body, encoding}) {
    // if (headers == null) headers={"Accept": "application/json"};
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if ((statusCode != 200 && statusCode != 401) || res == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}