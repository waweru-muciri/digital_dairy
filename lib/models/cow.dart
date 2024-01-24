import "package:DigitalDairy/util/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Cow {
  String? _id;
  late String _cowCode;
  late String _name;
  String? _cowType;
  String? _dateOfBirth = "12/01/2020";
  String? _grade;
  String? _breed;
  String? _color;
  Cow? _sire;
  Cow? _dam;
  double? _birthWeight;
  String? _kSBNumber;
  String? _datePurchased;
  String? _source;
  bool _activeStatus = true;
  String? _damId;
  String? _sireId;

  Cow();

  String? get getDamId => _damId;

  set setDamId(String? damId) => _damId = damId;

  get getSireId => _sireId;

  set setSireId(String? sireId) => _sireId = sireId;

  bool get getActiveStatus => _activeStatus;

  set setActiveStatus(bool activeStatus) => _activeStatus = activeStatus;

  String? get getKSBNumber => _kSBNumber;

  set setKSBNumber(String? kSBNumber) => _kSBNumber = kSBNumber;

  String? get getDatePurchased => _datePurchased;

  set setDatePurchased(String? datePurchased) => _datePurchased = datePurchased;

  String? get getSource => _source;

  set setSource(String? source) => _source = source;

  String? get getDateOfBirth => _dateOfBirth;

  set setDateOfBirth(String dateOfBirth) => _dateOfBirth = dateOfBirth;

  String? get getGrade => _grade;

  set setGrade(String? grade) => _grade = grade;

  String? get getBreed => _breed;

  set setBreed(String? breed) => _breed = breed;

  String? get getColor => _color;

  set setColor(String? color) => _color = color;

  Cow? get getSire => _sire;

  set setSire(Cow? sire) {
    _sire = sire;
    _sireId = sire?.getId;
  }

  Cow? get getDam => _dam;

  set setDam(Cow? dam) {
    _dam = dam;
    _damId = dam?.getId;
  }

  double? get getBirthWeight => _birthWeight;

  set setBirthWeight(double? birthWeight) => _birthWeight = birthWeight;

  String? get getCowType => _cowType;

  set setCowType(String? cowType) => _cowType = cowType;

  String? get getId => _id;

  set setId(String id) => _id = id;

  String get getName => _name;

  set setName(String cowName) => _name = cowName;

  String get getCowCode => _cowCode;

  set setCowCode(String cowCode) => _cowCode = cowCode;

  factory Cow.getCowPropertiesFromMap(Map<String, dynamic>? data) {
    Cow newCow = Cow();
    newCow.setId = data?['id'];
    newCow.setName = data?["name"];
    newCow.setCowCode = data?["cow_code"];
    newCow.setName = data?["name"];
    newCow.setColor = data?["color"];
    newCow.setBreed = data?["breed"];
    newCow.setGrade = data?["grade"];
    newCow.setCowType = data?["type"];
    newCow.setKSBNumber = data?["ksb_number"];
    newCow.setDateOfBirth = data?["date_of_birth"];
    newCow.setDatePurchased = data?["purchase_date"];
    newCow.setSource = data?["source"];
    newCow.setDam = Cow.getCowPropertiesFromMap(data?['dam']);
    newCow.setSire = Cow.getCowPropertiesFromMap(data?['sire']);
    return newCow;
  }

  factory Cow.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data();
    final String id = snapshot.id;
    data?.addAll({id: snapshot.id});
    Cow cowDetails = Cow.getCowPropertiesFromMap(data);
    return cowDetails;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow_code': _cowCode,
      'name': _name,
      'id': _id,
      'ksb_number': _kSBNumber,
      'breed': _breed,
      'type': _cowType,
      'grade': _grade,
      'color': _color,
      'date_of_birth': _dateOfBirth,
      'purchase_date': _datePurchased,
      'birth_weight': _birthWeight,
      'source': _source,
      'dam': _dam?.toFirestore(),
      'sire': _sire?.toFirestore(),
    };
  }

  String getAge() {
    DateTime date1 = DateTime.now();
    DateTime date2 = getDateFromString(_dateOfBirth ?? "");
    Duration diff = date1.difference(date2);
    int diffYears = diff.inDays ~/ 365;
    int diffMonths = diff.inDays ~/ 30;

    return diffYears > 0 ? '$diffYears Yr(s)' : "$diffMonths Mon(s)";
  }

  String get cowName => '$_cowCode $_name ';
}
