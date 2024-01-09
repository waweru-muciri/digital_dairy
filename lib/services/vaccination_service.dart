import '../models/vaccination.dart';
import "db_service.dart";

/// A service that gets, updates and deletes vaccination information.
///
class VaccinationService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _vaccinationReference = DbService.currentUserDbReference
      .collection('vaccinations')
      .withConverter<Vaccination>(
        fromFirestore: Vaccination.fromFirestore,
        toFirestore: (Vaccination vaccination, _) => vaccination.toFirestore(),
      );

  /// Loads the vaccinations list from firebase firestore.
  Future<List<Vaccination>> getVaccinationsList() async {
    return await _vaccinationReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a vaccination
  Future<Vaccination?> addVaccination(Vaccination vaccination) async {
    return await _vaccinationReference
        .add(vaccination)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a vaccination
  Future<void> deleteVaccination(Vaccination vaccination) async {
    return await _vaccinationReference.doc(vaccination.getId).delete();
  }

//update a vaccination
  Future<Vaccination> editVaccination(Vaccination vaccination) async {
    await _vaccinationReference
        .doc(vaccination.getId)
        .update(vaccination.toFirestore());
    return vaccination;
  }
}
