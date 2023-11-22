import 'package:flutter/material.dart';
import '../models/daily_milk_production.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A service that gets, updates and deletes milk production information.
///
class MilkProductionService {
  // Create a CollectionReference called milk_production that references the firestore collection
  CollectionReference milkProductionReference =
      FirebaseFirestore.instance.collection('milk_production');

  List<DailyMilkProduction> todaysMilkProductionList = [];

  /// Loads the current day's milk production from firebase firestore.
  Future<List<DailyMilkProduction>> getTodaysMilkProduction() async =>
      todaysMilkProductionList;

  Future<List<DailyMilkProduction>> getMilkProductionByDate(
      DateTime date) async {
    List<DailyMilkProduction> milkProductionListForDate =
        await milkProductionReference
            .where("milk_production_date", isEqualTo: date)
            .get()
            .then((querySnapshot) => querySnapshot.docs
                .map((documentSnapshot) => DailyMilkProduction(
                    amQuantity: documentSnapshot["amQuantity"],
                    pmQuantity: documentSnapshot["pmQuantity"],
                    noonQuantity: documentSnapshot["noonQuantity"],
                    milkProductionDate: date))
                .toList());

    return milkProductionListForDate;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }
}
