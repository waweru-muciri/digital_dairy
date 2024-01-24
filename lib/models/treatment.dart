import "package:DigitalDairy/models/cow.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Treatment {
  String? _id;
  late String _treatment;
  late String _diagnosis;
  late String _treamentDate;
  late String _vetName;
  late double _treatmentCost;
  late Cow _cow;

  String get getVetName => _vetName;

  set setVetName(String vetName) => _vetName = vetName;

  Cow get getCow => _cow;

  set setCow(Cow cow) => _cow = cow;

  double get getTreatmentCost => _treatmentCost;

  set setTreatmentCost(double treatmentCost) => _treatmentCost = treatmentCost;

  String? get getId => _id;

  set setId(String? id) => _id = id;

  String get getTreatment => _treatment;

  set setTreatment(String value) => _treatment = value;

  String get getDiagnosis => _diagnosis;

  set setDiagnosis(String value) => _diagnosis = value;

  String get getTreatmentDate => _treamentDate;

  set setTreatmentDate(String value) => _treamentDate = value;

  Treatment();

  factory Treatment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newTreatment = Treatment();
    newTreatment.setTreatmentDate = data?["treatment_date"];
    newTreatment._treatment = data?["treatment"];
    newTreatment._diagnosis = data?["diagnosis"];
    newTreatment._treatmentCost = data?["cost"];
    newTreatment._vetName = data?["vet_name"];
    newTreatment._id = id;
    newTreatment._cow = Cow.getCowPropertiesFromMap(data?['cow']);
    return newTreatment;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow': _cow.toFirestore(),
      'treatment_date': _treamentDate,
      'treatment': _treatment,
      "diagnosis": _diagnosis,
      "vet_name": _vetName,
      "cost": _treatmentCost,
      'id': _id
    };
  }
}
