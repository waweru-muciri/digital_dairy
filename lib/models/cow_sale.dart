import "package:DigitalDairy/models/cow.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class CowSale {
  String? _id;
  String? _saleRemarks;
  late String _soldDate;
  late String? _clientName;
  late double _cowSaleCost;
  late Cow _cow;

  String? get getClientName => _clientName;

  set setClientName(String clientName) => _clientName = clientName;

  Cow get getCow => _cow;

  set setCow(Cow cow) => _cow = cow;

  double get getCowSaleCost => _cowSaleCost;

  set setCowSaleCost(double cowSaleCost) => _cowSaleCost = cowSaleCost;

  String? get getId => _id;

  set setId(String? id) => _id = id;

  String? get getRemarks => _saleRemarks;

  set setRemarks(String value) => _saleRemarks = value;

  String get getCowSaleDate => _soldDate;

  set setCowSaleDate(String value) => _soldDate = value;

  CowSale();

  factory CowSale.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;
    final newCowSale = CowSale();
    newCowSale.setCowSaleDate = data?["date"];
    newCowSale._saleRemarks = data?["remarks"];
    newCowSale._cowSaleCost = data?["cost"];
    newCowSale._clientName = data?["client"];
    newCowSale._id = id;
    newCowSale._cow = Cow.fromAnotherFirestoreDoc(snapshot, options);
    return newCowSale;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cow': _cow.toFirestore(),
      'date': _soldDate,
      "remarks": _saleRemarks,
      "client": _clientName,
      "cost": _cowSaleCost,
      'id': _id
    };
  }
}
