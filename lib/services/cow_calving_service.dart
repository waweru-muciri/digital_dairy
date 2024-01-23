import 'package:DigitalDairy/models/cow_calving.dart';
import "db_service.dart";

/// A service that gets, updates and deletes calving information.
///
class CalvingService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _calvingReference = DbService.currentUserDbReference
      .collection('calvings')
      .withConverter<Calving>(
        fromFirestore: Calving.fromFirestore,
        toFirestore: (Calving calving, _) => calving.toFirestore(),
      );

  /// Loads the calvings list from firebase firestore.
  Future<List<Calving>> getCalvingsList() async {
    return await _calvingReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a calving
  Future<Calving?> addCalving(Calving calving) async {
    return await _calvingReference
        .add(calving)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a calving
  Future<void> deleteCalving(Calving calving) async {
    return await _calvingReference.doc(calving.getId).delete();
  }

//update a calving
  Future<Calving> editCalving(Calving calving) async {
    await _calvingReference.doc(calving.getId).update(calving.toFirestore());
    return calving;
  }
}
