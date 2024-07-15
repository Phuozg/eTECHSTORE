import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class ZaloPay extends GetxController {
  static ZaloPay get instance => Get.find();

  createOrder(int amount) {
    const url = 'https://sandbox.zalopay.com.vn/v001/tpe/createorder';
    final apptransid = DateTime.now().millisecondsSinceEpoch;
    final appTime = DateTime.now().millisecondsSinceEpoch;
    String hmacInput = '2554|$apptransid|etechstore|$amount|$appTime|{}|[]';
    String key1 = 'sdngKKJmqEMzvh5QQcdD2A9XBSKUNaYn';
    String key2 = 'trMrHtvjo6myautxDUiAcYsVtaeQ8nhf';
    var hmacSha256 = Hmac(sha256, utf8.encode(key1));
    var mac = hmacSha256.convert(utf8.encode(hmacInput));
    var params = {
      'appid': 2554,
      'appuser': 'etechstore',
      'apptime': appTime,
      'amount': amount,
      'apptransid': apptransid,
      'embeddata': {},
      'item': [],
      'bankcode': "",
      'mac': mac,
    };
    final hashDataBuffer = StringBuffer();
    params.forEach((key, value) {
      hashDataBuffer.write(key);
      hashDataBuffer.write('=');
      hashDataBuffer.write(value);
      hashDataBuffer.write('&');
    });
    String query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return "$url?$query";
  }
}
