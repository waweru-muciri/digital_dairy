import '../models/milk_consumption.dart';
import "db_service.dart";

/// A service that gets, updates and deletes milkConsumption information.
///
class MilkConsumptionService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _milkConsumptionReference = DbService.currentUserDbReference
      .collection('milk_consumptions')
      .withConverter<MilkConsumption>(
        fromFirestore: MilkConsumption.fromFirestore,
        toFirestore: (MilkConsumption milkConsumption, _) =>
            milkConsumption.toFirestore(),
      );

  /// Loads the milkConsumptions list from firebase firestore.
  Future<List<MilkConsumption>> getMilkConsumptionsListBetweenDates(
      String startDate,
      {String? endDate}) async {
    if (startDate.isNotEmpty && endDate != null) {
      return await _milkConsumptionReference
          .where("milkConsumptionDate", isGreaterThanOrEqualTo: startDate)
          .where("milkConsumptionDate", isLessThanOrEqualTo: endDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    } else {
      return await _milkConsumptionReference
          .where("milkConsumptionDate", isEqualTo: startDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    }
  }

  Future<List<MilkConsumption>> getMilkConsumptionsForClient(
      String milkConsumerId) async {
    return await _milkConsumptionReference
        .where("milk_consumer_id", isEqualTo: milkConsumerId)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a milkConsumption
  Future<MilkConsumption?> addMilkConsumption(
      MilkConsumption milkConsumption) async {
    return await _milkConsumptionReference
        .add(milkConsumption)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milkConsumption
  Future<void> deleteMilkConsumption(MilkConsumption milkConsumption) async {
    return await _milkConsumptionReference.doc(milkConsumption.getId).delete();
  }

//update a milkConsumption
  Future<MilkConsumption> editMilkConsumption(
      MilkConsumption milkConsumption) async {
    await _milkConsumptionReference
        .doc(milkConsumption.getId)
        .update(milkConsumption.toFirestore());
    return milkConsumption;
  }
}
