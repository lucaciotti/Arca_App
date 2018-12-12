import 'dart:async';
// import 'package:arca_flutter_app/helpers/barcodeScan.dart';
import 'package:arca_flutter_app/helpers/network_api.dart';
import 'package:arca_flutter_app/models/coupon.dart';

class InventController {
  NetApiHelper _netUtil = new NetApiHelper();

  Future<List<Coupon>> fetchCoupon(String codcoupon) {
    final couponUrl = Uri.http("172.16.2.102:3018","/api/v1/invent/getCoupon/"+codcoupon);
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

  Future<List<Coupon>> insertCoupon(Coupon coupon) {
    final couponUrl = Uri.http("172.16.2.102:3018","/api/v1/invent/insertCoupon/");
    Map<String, dynamic> couponMap = coupon.toMap();
    return _netUtil.post(couponUrl, headers: couponMap).then((dynamic json) async {
      print(json);
      List<Coupon> couponList = new List<Coupon>();
      if(json['success'] != null) {
        couponList.add(coupon);
      } 
      return couponList;
    });
  }

  Future<List<Coupon>> markCoupon(String codcart){
    final couponUrl = Uri.http("172.16.2.102:3018","/api/v1/invent/markWarnCoupon/"+codcart);
    return _netUtil.put(couponUrl).then((dynamic json) async {
      if(json is List){
        return new List<Coupon>();
      }
      print(json);
      return new List<Coupon>();
    });
  }

}