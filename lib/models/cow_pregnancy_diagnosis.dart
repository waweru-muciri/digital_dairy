import "package:DigitalDairy/models/cow.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class PregnancyDiagnosis {
  String? _id;
  late bool _diagnosisResult;
  late String _diagnosisDate;
  late String? _vetName;
  late double _diagnosisCost;
  late Cow _cow;
  late String? _cowId;

  PregnancyDiagnosis();

  String? get getCowId => _cowId;

  set setCowId(String? cowId) => _cowId = cowId;

  String? get getVetName => _vetName;

  set setVetName(String? vetName) => _vetName = vetName;

  Cow get getCow => _cow;

  set setCow(Cow cow) {
    _cow = cow;
    setCowId = cow.getId;
  }

  double get getPregnancyDiagnosisCost => _diagnosisCost;

  set setPregnancyDiagnosisCost(double diagnosisCost) =>
      _diagnosisCost = diagnosisCost;

  String? get getId => _id;

  set setId(String? id) => _id = id;

  bool get getPregnancyDiagnosisResult => _diagnosisResult;

  set setPregnancyDiagnosisResult(bool value) => _diagnosisResult = value;

  String get getPregnancyDiagnosisDate => _diagnosisDate;

  set setPregnancyDiagnosisDate(String value) => _diagnosisDate = value;

  factory PregnancyDiagnosis.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newPregnancyDiagnosis = PregnancyDiagnosis();
    newPregnancyDiagnosis.setPregnancyDiagnosisDate = data?["diagnosis_date"];
    newPregnancyDiagnosis.setPregnancyDiagnosisResult =
        data?["diagnosis_result"];
    newPregnancyDiagnosis.setPregnancyDiagnosisCost = data?["cost"];
    newPregnancyDiagnosis.setVetName = data?["vet_name"];
    newPregnancyDiagnosis.setId = id;
    newPregnancyDiagnosis.setCow =
        Cow.fromAnotherFirestoreDoc(snapshot, options);
    return newPregnancyDiagnosis;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow': _cow.toFirestore(),
      'diagnosis_date': _diagnosisDate,
      'diagnosis_result': _diagnosisResult,
      'cow_id': _cowId,
      "vet_name": _vetName,
      "cost": _diagnosisCost,
      'id': _id
    };
  }
}
