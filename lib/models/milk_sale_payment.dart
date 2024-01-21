import "package:DigitalDairy/models/milk_sale.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class MilkSalePayment {
  String? _id;
  late double _milkSalePaymentAmount = 0;
  late String _milkSalePaymentDate;
  late String? _details;
  late MilkSale _milkSale;
  late String? _milkSaleId;
  late String? _clientId;

  MilkSalePayment();

  String? get getDetails => _details;

  set setDetails(String? details) => _details = details;

  set setId(String? id) {
    _id = id;
  }

  set setMilkSalePaymentDate(String milkSalePaymentDate) {
    _milkSalePaymentDate = milkSalePaymentDate;
  }

  set setMilkSale(MilkSale milkSale) {
    _milkSale = milkSale;
    _milkSaleId = milkSale.getId;
    _clientId = milkSale.getClient.getId;
  }

  set setMilkSalePaymentAmount(double milkSalePaymentAmount) {
    _milkSalePaymentAmount = milkSalePaymentAmount;
  }

  double get getMilkSalePaymentAmount => _milkSalePaymentAmount;
  String get getMilkSalePaymentDate => _milkSalePaymentDate;
  String? get getId => _id;
  String? get getMilkSaleId => _milkSaleId;
  String? get getClientId => _clientId;

  MilkSale get getMilkSale => _milkSale;

  double getMilkSaleOutstandingPayment() {
    double outstandingPayment =
        getMilkSale.getMilkSaleMoneyAmount - _milkSalePaymentAmount;
    return outstandingPayment < 0 ? 0 : outstandingPayment;
  }

  factory MilkSalePayment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    MilkSalePayment newMilkSalePayment = MilkSalePayment();
    newMilkSalePayment.setId = id;
    newMilkSalePayment._milkSaleId = (data?["_milkSaleId"]);
    newMilkSalePayment._clientId = (data?["client_id"]);
    newMilkSalePayment.setMilkSalePaymentDate = (data?["payment_date"]);
    newMilkSalePayment.setMilkSalePaymentAmount = data?["payment_amount"];
    newMilkSalePayment.setMilkSale =
        MilkSale.fromAnotherFirestoreDoc(snapshot, options);

    return newMilkSalePayment;
  }

  Map<String, dynamic> toFirestore() {
    return {
      "_milkSaleId": _milkSaleId,
      'milk_sale': _milkSale.toFirestore(),
      'client_id': _clientId,
      'payment_date': _milkSalePaymentDate,
      'payment_amount': _milkSalePaymentAmount,
      'id': _id,
    };
  }
}
