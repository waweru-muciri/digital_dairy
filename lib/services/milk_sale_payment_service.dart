import 'package:DigitalDairy/models/milk_sale_payment.dart';
import "db_service.dart";

/// A service that gets, updates and deletes milkSalePayment information.
///
class MilkSalePaymentService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _milkSalePaymentReference = DbService.currentUserDbReference
      .collection('milk_sales_payments')
      .withConverter<MilkSalePayment>(
        fromFirestore: MilkSalePayment.fromFirestore,
        toFirestore: (MilkSalePayment milkSalePayment, _) =>
            milkSalePayment.toFirestore(),
      );

  /// Loads the milkSalePayments list from firebase firestore.
  Future<List<MilkSalePayment>> getMilkSalePaymentsListBetweenDates(
      String startDate,
      {String? endDate}) async {
    if (startDate.isNotEmpty && endDate != null) {
      return await _milkSalePaymentReference
          .where("payment_date", isGreaterThanOrEqualTo: startDate)
          .where("payment_date", isLessThanOrEqualTo: endDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    } else {
      return await _milkSalePaymentReference
          .where("payment_date", isEqualTo: startDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    }
  }

//add a milkSalePayment
  Future<MilkSalePayment?> addMilkSalePayment(
      MilkSalePayment milkSalePayment) async {
    return await _milkSalePaymentReference
        .add(milkSalePayment)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milkSalePayment
  Future<void> deleteMilkSalePayment(MilkSalePayment milkSalePayment) async {
    return await _milkSalePaymentReference.doc(milkSalePayment.getId).delete();
  }

//update a milkSalePayment
  Future<MilkSalePayment> editMilkSalePayment(
      MilkSalePayment milkSalePayment) async {
    await _milkSalePaymentReference
        .doc(milkSalePayment.getId)
        .update(milkSalePayment.toFirestore());
    return milkSalePayment;
  }
}
