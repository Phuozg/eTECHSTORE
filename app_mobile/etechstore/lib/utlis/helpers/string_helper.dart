import 'dart:math';

import 'package:intl/intl.dart';

class StringHelper {
  static bool isNullOrEmpty(String? text) {
    if (text == null || text.isEmpty) return true;
    return false;
  }

  static String generateRandomString(int len) {
    final r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

 static String priceFormat(int price) {
  final priceOutput = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  return priceOutput.format(price);
}
}