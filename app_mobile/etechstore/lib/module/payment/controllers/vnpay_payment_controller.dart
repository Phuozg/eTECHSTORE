import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VNPAYPaymnent extends GetxController {
  static VNPAYPaymnent get instance => Get.find();

  Future<void> paymentVNPay(RxString response, BuildContext context) async {
    final NetworkInfo networkInfo = NetworkInfo();
    final wifiIP = await networkInfo.getWifiIP();
    final now = DateTime.now();
    final formattedTime = DateFormat('yyyyMMddHHmmss').format(now);
    const orderType = '&vnp_OrderType=other';
    final paymentURL = VNPAYFlutter.instance.generatePaymentUrl(
        url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
        version: '2.1.0',
        tmnCode: '0G4WEGNW',
        txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
        orderInfo: 'Thanh+toan+don+hang+%3A5&',
        amount: 1806000,
        createDate: formattedTime,
        returnUrl: 'https://etechstore-abe5c.web.app',
        ipAdress: wifiIP!,
        vnpayHashKey: 'K8KK1B7RAO9D108W9WP84NLL43NYS5UK');

    VNPAYFlutter.instance.show(
      paymentUrl: paymentURL,
      onPaymentSuccess: (params) {
        response.value = params['vnp_ResponseCode'];
        Navigator.pop(context);
      },
      onPaymentError: (params) {
        response.value = 'Error';
        Navigator.pop(context);
      },
    );
    print(paymentURL);
  }
}

enum VNPayHashType {
  SHA256,
  HMACSHA512,
}

class VNPAYFlutter {
  static final VNPAYFlutter _instance = VNPAYFlutter();
  static VNPAYFlutter get instance => _instance;
  Map<String, dynamic> _sortParams(Map<String, dynamic> params) {
    final sortedParams = <String, dynamic>{};
    final keys = params.keys.toList()..sort();
    for (String key in keys) {
      sortedParams[key] = params[key];
    }
    return sortedParams;
  }

  String generatePaymentUrl({
    String url = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    required String version,
    String command = 'pay',
    required String createDate,
    required String tmnCode,
    String locale = 'vn',
    String currencyCode = 'VND',
    required String txnRef,
    String orderInfo = 'Pay Order',
    String orderType = 'order',
    required double amount,
    required String returnUrl,
    required String ipAdress,
    String? createAt,
    required String vnpayHashKey,
    VNPayHashType vnPayHashType = VNPayHashType.SHA256,
  }) {
    final params = <String, dynamic>{
      'vnp_Version': version,
      'vnp_Command': command,
      'vnp_CreateDate': createDate,
      'vnp_TmnCode': tmnCode,
      'vnp_Locale': locale,
      'vnp_CurrCode': currencyCode,
      'vnp_TxnRef': txnRef,
      'vnp_OrderInfo': orderInfo,
      'vnp_OrderType': orderType,
      'vnp_Amount': (amount * 100).toStringAsFixed(0),
      'vnp_ReturnUrl': returnUrl,
      'vnp_IpAddr': ipAdress,
      'vnp_CreateDate': createAt ??
          DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
    };
    var sortedParam = _sortParams(params);
    final hashDataBuffer = StringBuffer();
    sortedParam.forEach((key, value) {
      hashDataBuffer.write(key);
      hashDataBuffer.write('=');
      hashDataBuffer.write(value);
      hashDataBuffer.write('&');
    });
    String hashData =
        hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
    String query = Uri(queryParameters: sortedParam).query;
    String vnpSecureHash = "";

    if (vnPayHashType == VNPayHashType.SHA256) {
      List<int> bytes = utf8.encode(vnpayHashKey + hashData.toString());
      vnpSecureHash = sha256.convert(bytes).toString();
    } else {
      vnpSecureHash = Hmac(sha512, utf8.encode(vnpayHashKey))
          .convert(utf8.encode(hashData))
          .toString();
    }
    String paymentUrl =
        "$url?$query&vnp_SecureHashType=${vnPayHashType == VNPayHashType.HMACSHA512 ? "HmacSHA512" : "SHA256"}&vnp_SecureHash=$vnpSecureHash";
    return paymentUrl;
  }

  void show({
    required String paymentUrl,
    Function(Map<String, dynamic>)? onPaymentSuccess,
    Function(Map<String, dynamic>)? onPaymentError,
    Function()? onWebPaymentComplete,
  }) async {
    if (kIsWeb) {
      await launchUrlString(
        paymentUrl,
        webOnlyWindowName: '_self',
      );
      if (onWebPaymentComplete != null) {
        onWebPaymentComplete();
      }
    } else {
      final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
      flutterWebviewPlugin.launch(paymentUrl);
      flutterWebviewPlugin.onUrlChanged.listen((url) async {
        if (url.contains('vnp_ResponseCode')) {
          final params = Uri.parse(url).queryParameters;
          if (params['vnp_ResponseCode'] == '00') {
            if (onPaymentSuccess != null) {
              onPaymentSuccess(params);
            }
          } else {
            if (onPaymentError != null) {
              onPaymentError(params);
            }
          }
          flutterWebviewPlugin.close();
        } else {
          flutterWebviewPlugin.close();
        }
      });
    }
  }
}
