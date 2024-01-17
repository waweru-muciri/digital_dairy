import "package:cloud_firestore/cloud_firestore.dart";

class SemenCatalog {
  String? _id;
  late String _bullName;
  late String _bullCode;
  late String _breed;
  late String _supplierName;
  late double _costPerStraw;
  late int _numberOfStraws;

  SemenCatalog();

  String get getSupplier => _supplierName;

  set setSupplierName(String supplier) => _supplierName = supplier;

  double get getCostPerStraw => _costPerStraw;

  set setCostPerStraw(double value) => _costPerStraw = value;

  int get getNumberOfStraws => _numberOfStraws;

  set setNumberOfStraws(int numberOfStraws) => _numberOfStraws = numberOfStraws;

  String? get getId => _id;

  set setId(String? value) => _id = value;

  get getBullName => _bullName;

  set setBullName(value) => _bullName = value;

  get getBullCode => _bullCode;

  set setBullCode(value) => _bullCode = value;

  get getBreed => _breed;

  set setBreed(value) => _breed = value;

  factory SemenCatalog.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    final newDisease = SemenCatalog();
    newDisease.setId = id;
    newDisease.setBreed = data?["breed"];
    newDisease.setBullCode = data?["bull_code"];
    newDisease.setBullName = data?["bull_name"];
    newDisease.setNumberOfStraws = data?["number_of_straws"];
    newDisease.setCostPerStraw = data?["cost_per_straw"];
    newDisease.setSupplierName = data?["supplier_name"];
    return newDisease;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bull_code': _bullCode,
      'bull_name': _bullName,
      "breed": _breed,
      "number_of_straws": _numberOfStraws,
      "cost_per_straw": _costPerStraw,
      "supplier_name": _supplierName,
      'id': _id
    };
  }
}
