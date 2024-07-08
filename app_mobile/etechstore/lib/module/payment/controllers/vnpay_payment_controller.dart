import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';

class VNPAY extends GetxController {
  static VNPAY get instance => Get.find();
  RxString urlVNPay = ''.obs;

  Future getUrlPayment(
    int amount,
  ) async {
    final NetworkInfo networkInfo = NetworkInfo();
    final wifiIP = await networkInfo.getWifiIP();
    final params = <String, String>{
      'vnp_Amount': (amount * 100).toStringAsFixed(0),
      'vnp_Command': 'pay',
      'vnp_CreateDate':
          DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
      'vnp_CurrCode': 'VND',
      'vnp_ExpireDate': DateFormat('yyyyMMddHHmmss')
          .format(DateTime.now().add(const Duration(hours: 1)))
          .toString(),
      'vnp_IpAddr': wifiIP!,
      'vnp_Locale': 'vn',
      'vnp_OrderInfo': 'ThanhToanHoaDon',
      'vnp_OrderType': 'other',
      'vnp_ReturnUrl': 'etechstore-abe5c.web.app',
      'vnp_TmnCode': '0G4WEGNW',
      'vnp_TxnRef': DateTime.now().millisecondsSinceEpoch.toString(),
      'vnp_Version': '2.1.0',
    };
    final hashDataBuffer = StringBuffer();
    params.forEach((key, value) {
      hashDataBuffer.write(key);
      hashDataBuffer.write('=');
      hashDataBuffer.write(value);
      hashDataBuffer.write('&');
    });
    String hashData =
        hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
    String query = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&'); //Uri(host: url, queryParameters: sortedParam).query;
    String vnpSecureHash = "";

    vnpSecureHash =
        Hmac(sha512, utf8.encode('K8KK1B7RAO9D108W9WP84NLL43NYS5UK'))
            .convert(utf8.encode(hashData))
            .toString();
    String url = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
    String paymentUrl =
        "$url?$query&vnp_SecureHashType=HMACSHA512&vnp_SecureHash=$vnpSecureHash";
    urlVNPay = paymentUrl.obs;
  }
}
