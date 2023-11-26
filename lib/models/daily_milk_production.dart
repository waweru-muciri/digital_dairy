import "package:cloud_firestore/cloud_firestore.dart";

class DailyMilkProduction {
  late String? id;
  late final double amQuantity;
  late final double noonQuantity;
  late final double pmQuantity;
  late final DateTime milkProductionDate;

  DailyMilkProduction(
      {this.amQuantity = 0,
      this.noonQuantity = 0,
      this.pmQuantity = 0,
      this.id,
      required this.milkProductionDate});

  factory DailyMilkProduction.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return DailyMilkProduction(
        milkProductionDate: data?["milkProductionDate"],
        amQuantity: data?["amQuantity"],
        noonQuantity: data?["noonQuantity"],
        pmQuantity: data?["pmQuantity"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'milkProductionDate': milkProductionDate,
      'amQuantity': amQuantity,
      'noonQuantity': noonQuantity,
      'pmQuantity': pmQuantity,
      //only return the id if it is not null
      if (id != null) "id": id,
    };
  }

  double get totalMilkQuantity => (amQuantity + noonQuantity + pmQuantity);
}
