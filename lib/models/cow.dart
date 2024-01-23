import "package:DigitalDairy/util/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Cow {
  String? _id;
  late String _name;
  late String _cowCode;
  late CowType _cowType;
  late String? _dateOfBirth;
  late CowGrade? _grade;
  late CowBreed? _breed;
  late String? _color;
  late Cow? _sire;
  late Cow? _dam;
  late String _category;
  late double? _birthWeight;
  late String? _group;
  late String? _KSBNumber;
  late String? _datePurchased;
  late String? _source;

  String? get getKSBNumber => _KSBNumber;

  set setKSBNumber(String? KSBNumber) => _KSBNumber = KSBNumber;

  String? get getDatePurchased => _datePurchased;

  set setDatePurchased(String? datePurchased) => _datePurchased = datePurchased;

  String? get getSource => _source;

  set setSource(String? source) => _source = source;
  Cow();

  String? get getDateOfBirth => _dateOfBirth;

  set setDateOfBirth(String dateOfBirth) => _dateOfBirth = dateOfBirth;

  CowGrade? get getGrade => _grade;

  set setGrade(CowGrade grade) => _grade = grade;

  CowBreed? get getBreed => _breed;

  set setBreed(CowBreed? breed) => _breed = breed;

  String? get getColor => _color;

  set setColor(String? color) => _color = color;

  Cow? get getSire => _sire;

  set setSire(Cow? sire) => _sire = sire;

  Cow? get getDam => _dam;

  set setDam(Cow? dam) => _dam = dam;

  get getCategory => _category;

  set setCategory(category) => _category = category;

  double? get getBirthWeight => _birthWeight;

  set setBirthWeight(double? birthWeight) => _birthWeight = birthWeight;

  get getGroup => _group;

  set setGroup(group) => _group = group;

  CowType get getCowType => _cowType;

  set setCowType(CowType cowType) => _cowType = cowType;

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
    newCow.setName = data?["name"];
    newCow.setCowCode = data?["cow_id"];
    newCow.setId = id;

    return newCow;
  }

  factory Cow.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["cow"];
    final String id = snapshot.id;

    Cow newCow = Cow();
    newCow.setName = data?["name"];
    newCow.setCowCode = data?["cow_code"];
    newCow.setId = id;

    return newCow;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow_code': _cowCode,
      'name': _name,
      'id': _id,
    };
  }

  String get cowName => '$_cowCode $_name ';
}
