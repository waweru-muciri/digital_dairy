import 'package:intl/intl.dart';

DateTime getDateFromString(String dateString) {
  late final DateTime date;
  try {
    date = DateFormat("dd/MM/yyyy").parse(dateString);
  } catch (e) {
    date = DateTime.now();
  }
  return date;
}

String getStringFromDate(DateTime? date) {
  late final String dateString;
  try {
    dateString = DateFormat("dd/MM/yyyy").format(date!);
  } catch (e) {
    dateString = "";
  }
  return dateString;
}
