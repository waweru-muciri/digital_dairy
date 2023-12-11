import 'package:DigitalDairy/services/db_service.dart';

import '../models/milk_consumer.dart';

/// A service that gets, updates and deletes milkConsumer information.
///
class MilkConsumerService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _milkConsumerReference = DbService.clientReference
      .collection('consumers')
      .withConverter<MilkConsumer>(
        fromFirestore: MilkConsumer.fromFirestore,
        toFirestore: (MilkConsumer milkConsumer, _) =>
            milkConsumer.toFirestore(),
      );

  /// Loads the milkConsumers list from firebase firestore.
  Future<List<MilkConsumer>> getMilkConsumersList() async {
    return await _milkConsumerReference.get().then((querySnapshot) =>
        querySnapshot.docs
            .map((documentSnapshot) => documentSnapshot.data())
            .toList());
  }

//add a milkConsumer
  Future<MilkConsumer?> addMilkConsumer(MilkConsumer milkConsumer) async {
    return await _milkConsumerReference
        .add(milkConsumer)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milkConsumer
  Future<void> deleteMilkConsumer(MilkConsumer milkConsumer) async {
    return await _milkConsumerReference.doc(milkConsumer.id).delete();
  }

//update a milkConsumer
  Future<MilkConsumer> editMilkConsumer(MilkConsumer milkConsumer) async {
    await _milkConsumerReference
        .doc(milkConsumer.id)
        .update(milkConsumer.toFirestore());
    return milkConsumer;
  }
}
