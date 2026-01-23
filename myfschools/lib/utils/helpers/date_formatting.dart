import 'package:intl/intl.dart';

class DateFormatting {
  static String formatDayMonthYear(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
