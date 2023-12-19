import "package:DigitalDairy/models/client.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class MilkSale {
  String? _id;
  late double _milkSaleAmount;
  late DateTime _milkSaleDate;
  late Client _client;

  MilkSale();

  set setId(String? id) {
    _id = id;
  }

  set setMilkSaleDate(DateTime milkSaleDate) {
    _milkSaleDate = milkSaleDate;
  }

  set setMilkSaleDetails(Client client) {
    _client = client;
  }

  set setMilkSaleAmount(double milkSaleAmount) {
    _milkSaleAmount = milkSaleAmount;
  }

  double get getMilkSaleAmount => _milkSaleAmount;
  DateTime get getMilkSaleDate => _milkSaleDate;
  String? get getId => _id;
  Client get getClient => _client;

  factory MilkSale.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    MilkSale newMilkSale = MilkSale();
    newMilkSale.setId = id;
    newMilkSale.setMilkSaleDate = (data?["milkSaleDate"] as Timestamp).toDate();
    newMilkSale.setMilkSaleAmount = data?["milkSaleAmount"];
    newMilkSale.setMilkSaleDetails = data?["client"];

    return newMilkSale;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'client': _client,
      'milkSaleDate': _milkSaleDate,
      'milkSaleAmount': _milkSaleAmount,
      'id': _id,
    };
  }
}
