import '../models/milk_sale.dart';
import "db_service.dart";

/// A service that gets, updates and deletes milkSale information.
///
class MilkSaleService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _milkSaleReference = DbService.currentUserDbReference
      .collection('milk_sales')
      .withConverter<MilkSale>(
        fromFirestore: MilkSale.fromFirestore,
        toFirestore: (MilkSale milkSale, _) => milkSale.toFirestore(),
      );

  /// Loads the milkSales list from firebase firestore.
  Future<List<MilkSale>> getMilkSalesList(DateTime dateTime) async {
    return await _milkSaleReference
        .where("_milkSaleDate", isEqualTo: dateTime)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a milkSale
  Future<MilkSale?> addMilkSale(MilkSale milkSale) async {
    return await _milkSaleReference
        .add(milkSale)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milkSale
  Future<void> deleteMilkSale(MilkSale milkSale) async {
    return await _milkSaleReference.doc(milkSale.getId).delete();
  }

//update a milkSale
  Future<MilkSale> editMilkSale(MilkSale milkSale) async {
    await _milkSaleReference.doc(milkSale.getId).update(milkSale.toFirestore());
    return milkSale;
  }
}
