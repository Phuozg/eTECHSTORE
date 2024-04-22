import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(DateTime? dateTime) {
    dateTime ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

    static String formatPhone(String countryCode, String phone) {
    if (phone.startsWith("0")) {
      return countryCode + phone.substring(1);
    }
    return countryCode + phone;
  }
}
