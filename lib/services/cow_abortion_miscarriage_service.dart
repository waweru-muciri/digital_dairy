import "package:DigitalDairy/models/cow_abortion_miscarriage.dart";

import "db_service.dart";

/// A service that gets, updates and deletes abortionMiscarriage information.
///
class AbortionMiscarriageService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _abortionMiscarriageReference = DbService.currentUserDbReference
      .collection('abortion_miscarriages')
      .withConverter<AbortionMiscarriage>(
        fromFirestore: AbortionMiscarriage.fromFirestore,
        toFirestore: (AbortionMiscarriage abortionMiscarriage, _) =>
            abortionMiscarriage.toFirestore(),
      );

  /// Loads the abortionMiscarriages list from firebase firestore.
  Future<List<AbortionMiscarriage>> getAbortionMiscarriagesList() async {
    return await _abortionMiscarriageReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a abortionMiscarriage
  Future<AbortionMiscarriage?> addAbortionMiscarriage(
      AbortionMiscarriage abortionMiscarriage) async {
    return await _abortionMiscarriageReference
        .add(abortionMiscarriage)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a abortionMiscarriage
  Future<void> deleteAbortionMiscarriage(
      AbortionMiscarriage abortionMiscarriage) async {
    return await _abortionMiscarriageReference
        .doc(abortionMiscarriage.getId)
        .delete();
  }

//update a abortionMiscarriage
  Future<AbortionMiscarriage> editAbortionMiscarriage(
      AbortionMiscarriage abortionMiscarriage) async {
    await _abortionMiscarriageReference
        .doc(abortionMiscarriage.getId)
        .update(abortionMiscarriage.toFirestore());
    return abortionMiscarriage;
  }
}
