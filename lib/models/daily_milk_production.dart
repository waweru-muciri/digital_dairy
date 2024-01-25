import "package:DigitalDairy/models/cow.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class DailyMilkProduction {
  String? _id;
  late double _amQuantity = 0;
  late double _noonQuantity = 0;
  late double _pmQuantity = 0;
  late String _milkProductionDate;
  late Cow _cow;
  String? _cowId;

  DailyMilkProduction();

  Cow get getCow => _cow;

  set setCow(Cow cow) {
    _cow = cow;
    _cowId = cow.getId;
  }

  String? get getId => _id;

  String? get getCowId => _cowId;

  set setId(String id) => _id = id;

  set setCowId(String id) => _cowId = id;

  double get getAmQuantity => _amQuantity;

  set setAmQuantity(double amQuantity) => _amQuantity = amQuantity;

  double get getNoonQuantity => _noonQuantity;

  set setNoonQuantity(double noonQuantity) => _noonQuantity = noonQuantity;

  double get getPmQuantity => _pmQuantity;

  set setPmQuantity(double pmQuantity) => _pmQuantity = pmQuantity;

  String get getMilkProductionDate => _milkProductionDate;

  set setMilkProductionDate(String milkProductionDate) =>
      _milkProductionDate = milkProductionDate;

  factory DailyMilkProduction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    final newMilkProduction = DailyMilkProduction();
    newMilkProduction.setMilkProductionDate = data?["milk_production_date"];
    newMilkProduction.setAmQuantity = data?["am_quantity"];
    newMilkProduction.setNoonQuantity = data?["noon_quantity"];
    newMilkProduction.setPmQuantity = data?["pm_quantity"];
    newMilkProduction.setCowId = data?["cow_id"];
    newMilkProduction.setCow = Cow.getCowPropertiesFromMap(data?['cow']);
    newMilkProduction.setId = id;
    return newMilkProduction;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'milk_production_date': _milkProductionDate,
      'am_quantity': _amQuantity,
      'noon_quantity': _noonQuantity,
      'pm_quantity': _pmQuantity,
      "cow_id": _cowId,
      "cow": _cow.toFirestore(),
      "id": _id,
    };
  }

  @override
  String toString() {
    return '$_amQuantity $_noonQuantity $_pmQuantity $_cowId $_milkProductionDate';
  }

  double get totalMilkQuantity => (_amQuantity + _noonQuantity + _pmQuantity);
}
