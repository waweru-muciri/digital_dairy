import '../models/milk_sale.dart';
import "db_service.dart";

/// A service that gets, updates and deletes milkSale information.
///
class MilkSaleService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final milkSaleCollectionReference = DbService.currentUserDbReference
      .collection('milk_sales')
      .withConverter<MilkSale>(
        fromFirestore: MilkSale.fromFirestore,
        toFirestore: (MilkSale milkSale, _) => milkSale.toFirestore(),
      );

  /// Loads the milkSales list from firebase firestore.
  Future<List<MilkSale>> getMilkSalesList() async {
    return await milkSaleCollectionReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a milkSale
  Future<MilkSale?> addMilkSale(MilkSale milkSale) async {
    return await milkSaleCollectionReference
        .add(milkSale)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milkSale
  Future<void> deleteMilkSale(MilkSale milkSale) async {
    return await milkSaleCollectionReference.doc(milkSale.getId).delete();
  }

//update a milkSale
  Future<MilkSale> editMilkSale(MilkSale milkSale) async {
    await milkSaleCollectionReference
        .doc(milkSale.getId)
        .update(milkSale.toFirestore());
    return milkSale;
  }
}
