import "package:cloud_firestore/cloud_firestore.dart";

class Cow {
  String? _id;
  late String _cowCode;
  late String _name;
  String? _cowType;
  String? _dateOfBirth = "";
  String? _grade;
  String? _breed;
  String? _color;
  Cow? _sire;
  Cow? _dam;
  double? _birthWeight;
  String? _KSBNumber;
  String? _datePurchased;
  String? _source;

  Cow();

  String? get getKSBNumber => _KSBNumber;

  set setKSBNumber(String? KSBNumber) => _KSBNumber = KSBNumber;

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

  set setSire(Cow? sire) => _sire = sire;

  Cow? get getDam => _dam;

  set setDam(Cow? dam) => _dam = dam;

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

  factory Cow.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Cow newCow = Cow();
    newCow.setId = id;
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

    return newCow;
  }

  factory Cow.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["cow"];
    final String id = snapshot.id;

    Cow newCow = Cow();
    newCow.setId = id;
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

    return newCow;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow_code': _cowCode,
      'name': _name,
      'id': _id,
      'ksb_number': _KSBNumber,
      'breed': _breed,
      'type': _cowType,
      'grade': _grade,
      'color': _color,
      'date_of_birth': _dateOfBirth,
      'purchase_date': _datePurchased,
      'birth_weight': _birthWeight,
      'source': _source,
      'dam': null
    };
  }

  String get cowName => '$_cowCode $_name ';
}
