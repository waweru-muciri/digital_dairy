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

enum Foo {
  one(1),
  two(2);

  const Foo(this.value);
  final num value;
}

enum CowType {
  calf("Calf"),
  heifer("Heifer"),
  yearling("Yearling"),
  cow("Cow"),
  dryCow("Dry Cow"),
  weaner("Weaner");

  const CowType(this.name);
  final String name;
}
