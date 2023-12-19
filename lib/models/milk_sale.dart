import "package:cloud_firestore/cloud_firestore.dart";

class MilkSale {
  String? _id;
  late double _incomeAmount;
  late DateTime _incomeDate;
  late String _details;

  MilkSale();

  set setId(String? id) {
    _id = id;
  }

  set setMilkSaleDate(DateTime incomeDate) {
    _incomeDate = incomeDate;
  }

  set setMilkSaleDetails(String details) {
    _details = details;
  }

  set setMilkSaleAmount(double incomeAmount) {
    _incomeAmount = incomeAmount;
  }

  double get getMilkSaleAmount => _incomeAmount;
  DateTime get getMilkSaleDate => _incomeDate;
  String? get getId => _id;
  String get getDetails => _details;

  factory MilkSale.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    MilkSale newMilkSale = MilkSale();
    newMilkSale.setId = id;
    newMilkSale.setMilkSaleDate = (data?["incomeDate"] as Timestamp).toDate();
    newMilkSale.setMilkSaleAmount = data?["incomeAmount"];
    newMilkSale.setMilkSaleDetails = data?["details"];

    return newMilkSale;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'details': _details,
      'incomeDate': _incomeDate,
      'incomeAmount': _incomeAmount,
      'id': _id,
    };
  }
}
