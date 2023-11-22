import 'package:flutter/material.dart';
import '../models/daily_milk_production.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A service that gets, updates and deletes milk production information.
///
class MilkProductionService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final CollectionReference _milkProductionReference = FirebaseFirestore
      .instance
      .collection('milk_production')
      .withConverter<DailyMilkProduction>(
        fromFirestore: (snapshot, _) => DailyMilkProduction.fromJson(
            {"id": snapshot.id, ...snapshot.data()!}),
        toFirestore: (dailyMilkProduction, _) => dailyMilkProduction.toJson(),
      );

  /// Loads the current day's milk production from firebase firestore.
  Future<List<DailyMilkProduction>> getTodaysMilkProduction() async =>
      await getMilkProductionByDate(DateTime.now());

  Future<List<DailyMilkProduction>> getMilkProductionByDate(
      DateTime date) async {
    List<DailyMilkProduction> milkProductionListForDate =
        await _milkProductionReference
            .orderBy("milkProductionDate")
            .where("milkProductionDate", isEqualTo: date)
            .get()
            .then((querySnapshot) => querySnapshot.docs
                .map((documentSnapshot) => DailyMilkProduction(
                    id: documentSnapshot.id,
                    amQuantity: documentSnapshot["amQuantity"],
                    pmQuantity: documentSnapshot["pmQuantity"],
                    noonQuantity: documentSnapshot["noonQuantity"],
                    milkProductionDate: date))
                .toList());

    return milkProductionListForDate;
  }

//add a milk production
  Future<DailyMilkProduction> addMilkProduction(
      DailyMilkProduction milkProduction) async {
    String milkProductionId = await _milkProductionReference
        .add(milkProduction)
        .then((docRef) => docRef.id);
    return milkProduction;
  }

//update a milk production
  Future<DailyMilkProduction> updateMilkProduction(
      DailyMilkProduction milkProduction) async {
    await _milkProductionReference.doc(milkProduction.id)
        .update(milkProduction.toJson())
    return milkProduction;
  }
}
