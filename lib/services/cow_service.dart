import '../models/cow.dart';
import "db_service.dart";

/// A service that gets, updates and deletes cow information.
///
class CowService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _cowReference =
      DbService.currentUserDbReference.collection('cows').withConverter<Cow>(
            fromFirestore: Cow.fromFirestore,
            toFirestore: (Cow cow, _) => cow.toFirestore(),
          );

  /// Loads the cows list from firebase firestore.
  Future<List<Cow>> getCowsList() async {
    return await _cowReference.get().then((querySnapshot) => querySnapshot.docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a cow
  Future<Cow?> addCow(Cow cow) async {
    return await _cowReference
        .add(cow)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a cow
  Future<void> deleteCow(Cow cow) async {
    return await _cowReference.doc(cow.getId).delete();
  }

//update a cow
  Future<Cow> editCow(Cow cow) async {
    await _cowReference.doc(cow.getId).update(cow.toFirestore());
    return cow;
  }
}
