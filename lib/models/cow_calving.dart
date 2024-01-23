import "package:DigitalDairy/models/cow.dart";
import "package:DigitalDairy/util/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Calving {
  String? _id;
  late String _calfName;
  late String _calfCode;
  late CalvingType _calvingType;
  late String? _calvingDate;
  late CalfSexType? _calfSex;
  late CowBreed? _breed;
  late String? _color;
  late Cow? _sire;
  late Cow? _dam;
  late double? _birthWeight;

  Calving();

  String? get getCalvingDate => _calvingDate;

  set setCalvingDate(String dateOfBirth) => _calvingDate = dateOfBirth;

  CalfSexType? get getSex => _calfSex;

  set setSex(CalfSexType grade) => _calfSex = grade;

  CowBreed? get getBreed => _breed;

  set setBreed(CowBreed? breed) => _breed = breed;

  String? get getColor => _color;

  set setColor(String? color) => _color = color;

  Cow? get getSire => _sire;

  set setSire(Cow? sire) => _sire = sire;

  Cow? get getDam => _dam;

  set setDam(Cow? dam) => _dam = dam;

  double? get getBirthWeight => _birthWeight;

  set setBirthWeight(double? birthWeight) => _birthWeight = birthWeight;

  CalvingType get getCalvingType => _calvingType;

  set setCalvingType(CalvingType cowType) => _calvingType = cowType;

  String? get getId => _id;

  set setId(String id) => _id = id;

  String get getCalfName => _calfName;

  set setCalfName(String calfName) => _calfName = calfName;

  String get getCalfCode => _calfCode;

  set setCalfCode(String calfCode) => _calfCode = calfCode;

  factory Calving.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Calving newCow = Calving();
    newCow.setId = id;
    newCow.setCalfCode = data?["calf_code"];
    newCow.setCalfName = data?["calf_name"];
    newCow.setCalvingType = data?["calving_type"];
    newCow.setCalvingDate = data?["calving_date"];
    newCow.setSex = data?["calf_sex"];
    newCow.setBreed = data?["calf_breed"];
    newCow.setColor = data?["calf_color"];
    newCow.setBirthWeight = data?["birth_weight"];
    // newCow.setDam = Cow.fromAnotherFirestoreDoc(snapshot, options);
    // newCow.setSire = data?["calf_color"];

    return newCow;
  }

  factory Calving.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["cow"];
    final String id = snapshot.id;

    Calving newCow = Calving();
    newCow.setId = id;
    newCow.setCalfCode = data?["calf_code"];
    newCow.setCalfName = data?["calf_name"];
    newCow.setCalvingType = data?["calving_type"];
    newCow.setCalvingDate = data?["calving_date"];
    newCow.setSex = data?["calf_sex"];
    newCow.setBreed = data?["calf_breed"];
    newCow.setColor = data?["calf_color"];
    newCow.setBirthWeight = data?["birth_weight"];
    // newCow.setDam = Cow.fromAnotherFirestoreDoc(snapshot, options);
    // newCow.setSire = data?["calf_color"];

    return newCow;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': _id,
      'calf_code': _calfCode,
      'calf_name': _calfName,
      'calving_type': _calvingType,
      'calving_date': _calvingDate,
      'calf_sex': _calfSex,
      'calf_breed': _breed,
      'calf_color': _color,
      'birth_weight': _birthWeight,
      // 'dam': Cow.fromAnotherFirestoreDoc(snapshot, options),
      // 'sire': Cow.fromAnotherFirestoreDoc(snapshot, options),
    };
  }

  String get cowName => '$_calfCode $_calfName ';
}
