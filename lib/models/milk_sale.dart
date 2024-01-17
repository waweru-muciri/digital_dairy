import "package:DigitalDairy/models/client.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class MilkSale {
  String? _id;
  late double _milkSaleQuantity;
  late double _milkSaleUnitPrice;
  late String _milkSaleDate;
  late Client _client;

  MilkSale();

  set setId(String? id) {
    _id = id;
  }

  set setMilkSaleDate(String milkSaleDate) {
    _milkSaleDate = milkSaleDate;
  }

  set setClient(Client client) {
    _client = client;
    _milkSaleUnitPrice = client.getUnitPrice;
  }

  set setMilkSaleQuantity(double milkSaleQuantity) {
    _milkSaleQuantity = milkSaleQuantity;
  }

  double get getMilkSaleQuantity => _milkSaleQuantity;
  String get getMilkSaleDate => _milkSaleDate;
  String? get getId => _id;
  Client get getClient => _client;

  double get getMilkSaleMoneyAmount => (_milkSaleQuantity * _milkSaleUnitPrice);

  factory MilkSale.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    MilkSale newMilkSale = MilkSale();
    newMilkSale.setId = id;
    newMilkSale.setMilkSaleDate = (data?["milkSaleDate"]);
    newMilkSale.setMilkSaleQuantity = data?["milkSaleAmount"];
    newMilkSale.setClient = Client.fromAnotherFirestoreDoc(snapshot, options);

    return newMilkSale;
  }

  factory MilkSale.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["milk_sale"];
    final String id = snapshot.id;

    MilkSale newMilkSale = MilkSale();
    newMilkSale.setId = id;
    newMilkSale.setMilkSaleDate = (data?["milkSaleDate"]);
    newMilkSale.setMilkSaleQuantity = data?["milkSaleAmount"];
    newMilkSale.setClient = Client.fromAnotherFirestoreDoc(snapshot, options);

    return newMilkSale;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'client': _client.toFirestore(),
      'milkSaleDate': _milkSaleDate,
      'milkSaleAmount': _milkSaleQuantity,
      'unit_price': _milkSaleUnitPrice,
      'id': _id,
    };
  }
}
