import "package:cloud_firestore/cloud_firestore.dart";

class FeedingItem {
  String? _id;
  late String name;
  late String _quantity;
  late double _unitPrice;

  FeedingItem();

  String? get getId => _id;

  set setId(id) => _id = id;

  String get getName => name;

  set setName(String name) => name = name;

  String get getLocation => _quantity;

  set setLocation(String location) => _quantity = location;

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
    newFeedingItem.setLocation = data?["location"];
    newFeedingItem.setUnitPrice = data?["unitPrice"];
    newFeedingItem.setId = id;

    return newFeedingItem;
  }

  factory FeedingItem.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["client"];
    final String id = snapshot.id;

    FeedingItem newFeedingItem = FeedingItem();
    newFeedingItem.setName = data?["name"];
    newFeedingItem.setLocation = data?["location"];
    newFeedingItem.setUnitPrice = data?["unitPrice"];
    newFeedingItem.setId = id;

    return newFeedingItem;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'location': _quantity,
      'name': name,
      'unitPrice': _unitPrice,
      'id': _id,
    };
  }
}
