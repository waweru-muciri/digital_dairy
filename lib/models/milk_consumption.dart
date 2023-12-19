import "package:DigitalDairy/models/milk_consumer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class MilkConsumption {
  String? _id;
  late double _milkConsumptionAmount;
  late DateTime _milkConsumptionDate;
  late MilkConsumer _milkConsumer;

  MilkConsumption();

  set setId(String? id) {
    _id = id;
  }

  set setMilkConsumptionDate(DateTime milkConsumptionDate) {
    _milkConsumptionDate = milkConsumptionDate;
  }

  set setMilkConsumptionDetails(MilkConsumer milkConsumer) {
    _milkConsumer = milkConsumer;
  }

  set setMilkConsumptionAmount(double milkConsumptionAmount) {
    _milkConsumptionAmount = milkConsumptionAmount;
  }

  double get getMilkConsumptionAmount => _milkConsumptionAmount;
  DateTime get getMilkConsumptionDate => _milkConsumptionDate;
  String? get getId => _id;
  MilkConsumer get getMilkConsumer => _milkConsumer;

  factory MilkConsumption.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    MilkConsumption newMilkConsumption = MilkConsumption();
    newMilkConsumption.setId = id;
    newMilkConsumption.setMilkConsumptionDate =
        (data?["milkConsumptionDate"] as Timestamp).toDate();
    newMilkConsumption.setMilkConsumptionAmount =
        data?["milkConsumptionAmount"];
    newMilkConsumption.setMilkConsumptionDetails = data?["consumer"];

    return newMilkConsumption;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'consumer': _milkConsumer,
      'milkConsumptionDate': _milkConsumptionDate,
      'milkConsumptionAmount': _milkConsumptionAmount,
      'id': _id,
    };
  }
}
