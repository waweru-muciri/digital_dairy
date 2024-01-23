import "package:DigitalDairy/models/cow_pregnancy_diagnosis.dart";

import "db_service.dart";

/// A service that gets, updates and deletes pregnancyDiagnosis information.
///
class PregnancyDiagnosisService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _pregnancyDiagnosisReference = DbService.currentUserDbReference
      .collection('pregnancy_diagnosis')
      .withConverter<PregnancyDiagnosis>(
        fromFirestore: PregnancyDiagnosis.fromFirestore,
        toFirestore: (PregnancyDiagnosis pregnancyDiagnosis, _) =>
            pregnancyDiagnosis.toFirestore(),
      );

  /// Loads the pregnancyDiagnosiss list from firebase firestore.
  Future<List<PregnancyDiagnosis>> getPregnancyDiagnosissList() async {
    return await _pregnancyDiagnosisReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a pregnancyDiagnosis
  Future<PregnancyDiagnosis?> addPregnancyDiagnosis(
      PregnancyDiagnosis pregnancyDiagnosis) async {
    return await _pregnancyDiagnosisReference
        .add(pregnancyDiagnosis)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a pregnancyDiagnosis
  Future<void> deletePregnancyDiagnosis(
      PregnancyDiagnosis pregnancyDiagnosis) async {
    return await _pregnancyDiagnosisReference
        .doc(pregnancyDiagnosis.getId)
        .delete();
  }

//update a pregnancyDiagnosis
  Future<PregnancyDiagnosis> editPregnancyDiagnosis(
      PregnancyDiagnosis pregnancyDiagnosis) async {
    await _pregnancyDiagnosisReference
        .doc(pregnancyDiagnosis.getId)
        .update(pregnancyDiagnosis.toFirestore());
    return pregnancyDiagnosis;
  }
}
