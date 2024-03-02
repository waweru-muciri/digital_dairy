import "package:cloud_firestore/cloud_firestore.dart";

class FeedingItem {
  String? _id;
  late String _name;
  late double _quantity;
  late double _unitPrice;
  late int _alertQuantity;

  FeedingItem();

  String? get getId => _id;

  set setId(id) => _id = id;

  String get getName => _name;

  set setName(String name) => _name = name;

  double get getCurrentQuantity => _quantity;

  set setCurrentQuantity(double quantity) => _quantity = quantity;

  int get getAlertQuantity => _alertQuantity;

  set setAlertQuantity(int quantity) => _alertQuantity = quantity;

  double get getUnitPrice => _unitPrice;

  set setUnitPrice(double unitPrice) => _unitPrice = unitPrice;

  factory FeedingItem.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    FeedingItem newFeedingItem = FeedingItem();
    newFeedingItem.setName = data?["name"];
    newFeedingItem.setCurrentQuantity = data?["current_quantity"];
    newFeedingItem.setAlertQuantity = data?["alert_quantity"];
    newFeedingItem.setUnitPrice = data?["unit_price"];
    newFeedingItem.setId = id;

    return newFeedingItem;
  }

  factory FeedingItem.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["feeding_item"];
    final String id = snapshot.id;

    FeedingItem newFeedingItem = FeedingItem();
    newFeedingItem.setName = data?["name"];
    newFeedingItem.setCurrentQuantity = data?["current_quantity"];
    newFeedingItem.setAlertQuantity = data?["alert_quantity"];
    newFeedingItem.setUnitPrice = data?["unit_price"];
    newFeedingItem.setId = id;

    return newFeedingItem;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'current_quantity': _quantity,
      'alert_quantity': _alertQuantity,
      'name': _name,
      'unit_price': _unitPrice,
      'id': _id,
    };
  }
}
