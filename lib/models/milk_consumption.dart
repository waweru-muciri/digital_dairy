import "package:DigitalDairy/models/milk_consumer.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class MilkConsumption {
  String? _id;
  late double _milkConsumptionAmount;
  late String _milkConsumptionDate;
  late MilkConsumer _milkConsumer;
  late String? _milkConsumerId;

  MilkConsumption();

  String? get getMilkConsumerId => _milkConsumerId;

  set milkConsumerId(String value) => _milkConsumerId = value;
  set setId(String? id) {
    _id = id;
  }

  set setMilkConsumptionDate(String milkConsumptionDate) {
    _milkConsumptionDate = milkConsumptionDate;
  }

  set setMilkConsumer(MilkConsumer milkConsumer) {
    _milkConsumer = milkConsumer;
    _milkConsumerId = milkConsumer.getId;
  }

  set setMilkConsumptionAmount(double milkConsumptionAmount) {
    _milkConsumptionAmount = milkConsumptionAmount;
  }

  double get getMilkConsumptionAmount => _milkConsumptionAmount;
  String get getMilkConsumptionDate => _milkConsumptionDate;
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
    newMilkConsumption.setMilkConsumptionDate = (data?["milkConsumptionDate"]);
    newMilkConsumption.setMilkConsumptionAmount =
        data?["milkConsumptionAmount"];
    newMilkConsumption.setMilkConsumer =
        MilkConsumer.fromAnotherFirestoreDoc(snapshot, options);

    return newMilkConsumption;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'consumer': _milkConsumer.toFirestore(),
      'milkConsumptionDate': _milkConsumptionDate,
      'milkConsumptionAmount': _milkConsumptionAmount,
      'milk_consumer_id': _milkConsumerId,
      'id': _id,
    };
  }
}
