import 'package:DigitalDairy/models/cow_sale.dart';
import "db_service.dart";

/// A service that gets, updates and deletes cowSale information.
///
class CowSaleService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _cowSaleReference = DbService.currentUserDbReference
      .collection('cow-sales')
      .withConverter<CowSale>(
        fromFirestore: CowSale.fromFirestore,
        toFirestore: (CowSale cowSale, _) => cowSale.toFirestore(),
      );

  /// Loads the cowSales list from firebase firestore.
  Future<List<CowSale>> getCowSalesList() async {
    return await _cowSaleReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

  Future<List<CowSale>> getCowSalesListBetweenDates(String startDate,
      {String? endDate}) async {
    if (startDate.isNotEmpty && endDate != null) {
      return await _cowSaleReference
          .where("date", isGreaterThanOrEqualTo: startDate)
          .where("date", isLessThanOrEqualTo: endDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    } else {
      return await _cowSaleReference
          .where("date", isEqualTo: startDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    }
  }

//add a cowSale
  Future<CowSale?> addCowSale(CowSale cowSale) async {
    return await _cowSaleReference
        .add(cowSale)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a cowSale
  Future<void> deleteCowSale(CowSale cowSale) async {
    return await _cowSaleReference.doc(cowSale.getId).delete();
  }

//update a cowSale
  Future<CowSale> editCowSale(CowSale cowSale) async {
    await _cowSaleReference.doc(cowSale.getId).update(cowSale.toFirestore());
    return cowSale;
  }
}
