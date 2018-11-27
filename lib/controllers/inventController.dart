import 'dart:async';
// import 'package:arca_flutter_app/helpers/barcodeScan.dart';
import 'package:arca_flutter_app/helpers/network_api.dart';
import 'package:arca_flutter_app/models/coupon.dart';

class InventController {
  NetApiHelper _netUtil = new NetApiHelper();

  Future<List<Coupon>> fetchCoupon(String codcoupon) {
    final couponUrl = Uri.http("172.16.2.9:3018","/api/v1/invent/getCoupon/"+codcoupon);
    return _netUtil.get(couponUrl).then((dynamic json) async {
      if(json is List){
        List<Coupon> couponList = this._parseCouponJson(json);
        return couponList;
      }
      print(json);
      return new List<Coupon>();
    });
  }

  List<Coupon> _parseCouponJson(dynamic json) {
    return json.map<Coupon>((data) => Coupon.fromJson(data)).toList();
  }

}