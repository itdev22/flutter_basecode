import 'package:intl/intl.dart';

class GlobalMethodHelper {
  static String locale = "id_ID";
  static final _oCcy = NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0);

  static String formatNumberCurrency(num value) {
    String format = _oCcy.format(value);
    return format;
  }

  static String dateFormat(DateTime? value,
      {String? formatDate = "dd MMM yyyy"}) {
    String format = value != null?DateFormat(formatDate, locale).format(value):DateFormat(formatDate, locale).format(DateTime.now());
    return format;
  }

  static bool isEmpty(text) {
    if (text == "" || text == null || text == "null") {
      return true;
    } else {
      return false;
    }
  }

  static bool isEmptyList(List<dynamic>? list) {
    if (list == null) {
      return true;
    } else if (list.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static String formatNumberToString(String text, {String defaultValue = "0"}) {
    if (GlobalMethodHelper.isEmpty(text)) {
      return defaultValue;
    }
    return int.parse(double.parse(text).toStringAsFixed(0)).toString();
  }
}
