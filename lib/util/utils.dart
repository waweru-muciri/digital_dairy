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

enum CowGrade {
  pedigree("Pedigree"),
  appendix("Appendix"),
  pool("Pool"),
  intermediate("Intermediate"),
  foundation("Foundation");

  const CowGrade(this.grade);
  final String grade;
}

enum CowBreed {
  ayrshire("Ayrshire"),
  boran("Boran"),
  swiss("Swiss"),
  brown("Brown"),
  fleckview("Fleckview"),
  guernsey("Guernsey"),
  holstein("Holstein"),
  fresian("Fresian"),
  jersey("Jersey"),
  redFresian("Red Fresian"),
  sahiwal("Sahiwal"),
  other("Other");

  const CowBreed(this.breed);
  final String breed;
}

enum SexedOrConvenction {
  sexed("Sexed"),
  convection("Convection");

  const SexedOrConvenction(this.type);
  final String type;
}

enum AbortionOrMiscarriage {
  abortion("Abortion"),
  miscarriage("Miscarriage");

  const AbortionOrMiscarriage(this.type);
  final String type;
}

enum CalvingType {
  single("Single"),
  twin("Twin");

  const CalvingType(this.type);
  final String type;
}

enum CalfSexType {
  bull("Bull"),
  heifer("Heifer");

  const CalfSexType(this.type);
  final String type;
}

enum CowType {
  calf("Calf 0-4 months"),
  weaner("Weaner 4-10 months"),
  heifer("Heifer 10-15 months"),
  bulling("Bulling 15-18 Months"),
  yearling("Yearling"),
  inCalfHeifer("InCalf Heifer 18+ months"),
  milker("Milker"),
  dryCow("Dry Cow"),
  bull("Bull");

  const CowType(this.type);
  final String type;
}
