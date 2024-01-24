import "package:DigitalDairy/models/cow.dart";
import "package:DigitalDairy/util/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class AbortionMiscarriage {
  String? _id;
  String? _cause;
  String? _vetName;
  late double _diagnosisCost;
  late Cow _cow;
  String? _cowId;
  late AbortionOrMiscarriage _abortionOrMiscarriage;

  AbortionMiscarriage();

  AbortionOrMiscarriage get getAbortionOrMiscarriage => _abortionOrMiscarriage;

  set setAbortionOrMiscarriage(AbortionOrMiscarriage abortionOrMiscarriage) =>
      _abortionOrMiscarriage = abortionOrMiscarriage;

  late String _diagnosisDate;
  String? get getCowId => _cowId;

  set setCowId(String? cowId) => _cowId = cowId;

  String? get getVetName => _vetName;

  set setVetName(String? vetName) => _vetName = vetName;

  Cow get getCow => _cow;

  set setCow(Cow cow) {
    _cow = cow;
    setCowId = cow.getId;
  }

  double get getAbortionMiscarriageCost => _diagnosisCost;

  set setAbortionMiscarriageCost(double diagnosisCost) =>
      _diagnosisCost = diagnosisCost;

  String? get getId => _id;

  set setId(String? id) => _id = id;

  String? get getAbortionMiscarriageResult => _cause;

  set setAbortionMiscarriageResult(String? value) => _cause = value;

  String get getAbortionMiscarriageDate => _diagnosisDate;

  set setAbortionMiscarriageDate(String value) => _diagnosisDate = value;

  factory AbortionMiscarriage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newAbortionMiscarriage = AbortionMiscarriage();
    newAbortionMiscarriage.setAbortionMiscarriageDate = data?["diagnosis_date"];
    newAbortionMiscarriage.setAbortionMiscarriageResult =
        data?["diagnosis_result"];
    newAbortionMiscarriage.setAbortionMiscarriageCost = data?["cost"];
    newAbortionMiscarriage.setVetName = data?["vet_name"];
    newAbortionMiscarriage.setId = id;
    newAbortionMiscarriage.setCow = Cow.getCowPropertiesFromMap(data?['cow']);
    return newAbortionMiscarriage;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow': _cow.toFirestore(),
      'diagnosis_date': _diagnosisDate,
      'diagnosis_result': _cause,
      'cow_id': _cowId,
      "vet_name": _vetName,
      "cost": _diagnosisCost,
      'id': _id
    };
  }
}
