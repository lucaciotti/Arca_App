import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class BarcodeScan {

  Future<String> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print(e);
        return 'error: No camera permission!';
      } else {
        print('Unknown error: $e');
        return 'error: Unknown';
      }
    } on FormatException {
      return 'error: Nothing captured.';
    } catch (e) {
      print('Unknown error: $e');
      return 'error: Unknown';
    }
  }

}