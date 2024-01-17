import 'package:DigitalDairy/models/semen_catalog.dart';
import "db_service.dart";

class SemenCatalogService {
  final _semenCatalogReference = DbService.currentUserDbReference
      .collection('semenCatalogs')
      .withConverter<SemenCatalog>(
        fromFirestore: SemenCatalog.fromFirestore,
        toFirestore: (SemenCatalog semenCatalog, _) =>
            semenCatalog.toFirestore(),
      );

  /// Loads the semenCatalogs list from firebase firestore.
  Future<List<SemenCatalog>> getSemenCatalogsList() async {
    return await _semenCatalogReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a semenCatalog
  Future<SemenCatalog?> addSemenCatalog(SemenCatalog semenCatalog) async {
    return await _semenCatalogReference
        .add(semenCatalog)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a semenCatalog
  Future<void> deleteSemenCatalog(SemenCatalog semenCatalog) async {
    return await _semenCatalogReference.doc(semenCatalog.getId).delete();
  }

//update a semenCatalog
  Future<SemenCatalog> editSemenCatalog(SemenCatalog semenCatalog) async {
    await _semenCatalogReference
        .doc(semenCatalog.getId)
        .update(semenCatalog.toFirestore());
    return semenCatalog;
  }
}
