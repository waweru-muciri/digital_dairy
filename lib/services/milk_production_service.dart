import 'package:intl/intl.dart';

import '../models/daily_milk_production.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A service that gets, updates and deletes milk production information.
///
class DailyMilkProductionService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _milkProductionReference = FirebaseFirestore.instance
      .collection('milk_production')
      .withConverter<DailyMilkProduction>(
        fromFirestore: DailyMilkProduction.fromFirestore,
        toFirestore: (DailyMilkProduction dailyMilkProduction, _) =>
            dailyMilkProduction.toFirestore(),
      );

  /// Loads the current day's milk production from the database.
  Future<List<DailyMilkProduction>> getTodaysMilkProduction() async =>
      await getMilkProductionByDate(
          DateFormat("dd/MM/yyyy").format(DateTime.now()));

  Future<List<DailyMilkProduction>> getMilkProductionByDate(String date) async {
    List<DailyMilkProduction> milkProductionListForDate =
        await _milkProductionReference
            .orderBy("milk_production_date")
            .where("milk_production_date", isEqualTo: date)
            .get()
            .then((querySnapshot) => querySnapshot.docs
                .map((documentSnapshot) => documentSnapshot.data())
                .toList());

    return milkProductionListForDate;
  }

//add a milk production
  Future<DailyMilkProduction?> addMilkProduction(
      DailyMilkProduction milkProduction) async {
    return await _milkProductionReference
        .add(milkProduction)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a milk production
  Future<void> deleteMilkProduction(DailyMilkProduction milkProduction) async {
    return await _milkProductionReference.doc(milkProduction.getId).delete();
  }

//update a milk production
  Future<DailyMilkProduction> editMilkProduction(
      DailyMilkProduction milkProduction) async {
    await _milkProductionReference
        .doc(milkProduction.getId)
        .update(milkProduction.toFirestore());
    return milkProduction;
  }
}
