import '../models/treatment.dart';
import "db_service.dart";

/// A service that gets, updates and deletes treatment information.
///
class TreatmentService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _treatmentReference = DbService.currentUserDbReference
      .collection('treatments')
      .withConverter<Treatment>(
        fromFirestore: Treatment.fromFirestore,
        toFirestore: (Treatment treatment, _) => treatment.toFirestore(),
      );

  /// Loads the treatments list from firebase firestore.
  Future<List<Treatment>> getTreatmentsList() async {
    return await _treatmentReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a treatment
  Future<Treatment?> addTreatment(Treatment treatment) async {
    return await _treatmentReference
        .add(treatment)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a treatment
  Future<void> deleteTreatment(Treatment treatment) async {
    return await _treatmentReference.doc(treatment.getId).delete();
  }

//update a treatment
  Future<Treatment> editTreatment(Treatment treatment) async {
    await _treatmentReference
        .doc(treatment.getId)
        .update(treatment.toFirestore());
    return treatment;
  }
}
