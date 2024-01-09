import '../models/disease.dart';
import "db_service.dart";

/// A service that gets, updates and deletes disease information.
///
class DiseaseService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _diseaseReference = DbService.currentUserDbReference
      .collection('diseases')
      .withConverter<Disease>(
        fromFirestore: Disease.fromFirestore,
        toFirestore: (Disease disease, _) => disease.toFirestore(),
      );

  /// Loads the diseases list from firebase firestore.
  Future<List<Disease>> getDiseasesList() async {
    return await _diseaseReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a disease
  Future<Disease?> addDisease(Disease disease) async {
    return await _diseaseReference
        .add(disease)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a disease
  Future<void> deleteDisease(Disease disease) async {
    return await _diseaseReference.doc(disease.getId).delete();
  }

//update a disease
  Future<Disease> editDisease(Disease disease) async {
    await _diseaseReference.doc(disease.getId).update(disease.toFirestore());
    return disease;
  }
}
