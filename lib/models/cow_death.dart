import "package:DigitalDairy/models/cow.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class CowDeath {
  String? _id;
  late String _causeOfDeath;
  late String _dateOfDeath;
  late String _vetName;
  late double _cost;
  late Cow _cow;

  String get getVetName => _vetName;

  set setVetName(String vetName) => _vetName = vetName;

  Cow get getCow => _cow;

  set setCow(Cow cow) => _cow = cow;

  double get getCowDeathCost => _cost;

  set setCowDeathCost(double treatmentCost) => _cost = treatmentCost;

  String? get getId => _id;

  set setId(String? id) => _id = id;

  String get getCauseOfDeath => _causeOfDeath;

  set setCauseOfDeath(String value) => _causeOfDeath = value;

  String get getDateOfDeath => _dateOfDeath;

  set setDateOfDeath(String value) => _dateOfDeath = value;

  CowDeath();

  factory CowDeath.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newCowDeath = CowDeath();
    newCowDeath.setDateOfDeath = data?["date_of_death"];
    newCowDeath._causeOfDeath = data?["cause_of_death"];
    newCowDeath._cost = data?["cost"];
    newCowDeath._vetName = data?["vet_name"];
    newCowDeath._id = id;
    newCowDeath._cow = Cow.getCowPropertiesFromMap(data?['cow']);
    return newCowDeath;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow': _cow.toFirestore(),
      'date_of_death': _dateOfDeath,
      "cause_of_death": _causeOfDeath,
      "vet_name": _vetName,
      "cost": _cost,
      'id': _id
    };
  }
}
