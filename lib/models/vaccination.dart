import "package:DigitalDairy/models/cow.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Vaccination {
  String? _id;
  late String _vaccination;
  late String _vaccinationDate;
  late String _vetName;
  late double _vaccinationCost;
  late Cow _cow;

  Vaccination();

  String get getVetName => _vetName;

  set setVetName(String vetName) => _vetName = vetName;

  get getCow => _cow;

  set setCow(Cow cow) => _cow = cow;

  double get getVaccinationCost => _vaccinationCost;

  set setVaccinationCost(double vaccinationCost) =>
      _vaccinationCost = vaccinationCost;

  String? get getId => _id;

  set setId(String? id) => _id = id;

  String get getVaccination => _vaccination;

  set setVaccination(String value) => _vaccination = value;

  String get getVaccinationDate => _vaccinationDate;

  set setVaccinationDate(String value) => _vaccinationDate = value;

  factory Vaccination.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newVaccination = Vaccination();
    newVaccination.setVaccinationDate = data?["vaccination_date"];
    newVaccination._vaccination = data?["vaccination"];
    newVaccination._vaccinationCost = data?["cost"];
    newVaccination._vetName = data?["vet_name"];
    newVaccination._id = id;
    newVaccination._cow = Cow.getCowPropertiesFromMap(data?['cow']);
    return newVaccination;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow': _cow.toFirestore(),
      'vaccination_date': _vaccinationDate,
      'vaccination': _vaccination,
      "vet_name": _vetName,
      "cost": _vaccinationCost,
      'id': _id
    };
  }
}
