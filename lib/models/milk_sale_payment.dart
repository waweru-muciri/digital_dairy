import "package:DigitalDairy/models/milk_sale.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class MilkSalePayment {
  String? _id;
  late double _milkSalePaymentAmount;
  late String _milkSalePaymentDate;
  late MilkSale _milkSale;

  MilkSalePayment();

  set setId(String? id) {
    _id = id;
  }

  set setMilkSalePaymentDate(String milkSalePaymentDate) {
    _milkSalePaymentDate = milkSalePaymentDate;
  }

  set setMilkSale(MilkSale milkSale) {
    _milkSale = milkSale;
  }

  set setMilkSalePaymentAmount(double milkSalePaymentAmount) {
    _milkSalePaymentAmount = milkSalePaymentAmount;
  }

  double get getMilkSalePaymentAmount => _milkSalePaymentAmount;
  String get getMilkSalePaymentDate => _milkSalePaymentDate;
  String? get getId => _id;
  MilkSale get getMilkSale => _milkSale;

  double get getMilkSaleOutstandingPayment =>
      (_milkSalePaymentAmount - getMilkSale.getMilkSaleMoneyAmount);

  factory MilkSalePayment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    MilkSalePayment newMilkSalePayment = MilkSalePayment();
    newMilkSalePayment.setId = id;
    newMilkSalePayment.setMilkSalePaymentDate = (data?["payment_date"]);
    newMilkSalePayment.setMilkSalePaymentAmount = data?["payment_amount"];
    newMilkSalePayment.setMilkSale =
        MilkSale.fromAnotherFirestoreDoc(snapshot, options);

    return newMilkSalePayment;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'milk_sale': _milkSale.toFirestore(),
      'payment_date': _milkSalePaymentDate,
      'payment_amount': _milkSalePaymentAmount,
      'id': _id,
    };
  }
}
