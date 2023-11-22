import 'package:flutter/material.dart';
import '../models/daily_milk_production.dart';

/// A service that gets, updates and deletes milk production information.
///
class MilkProductionService {
  List<DailyMilkProduction> todaysMilkProductionList = [];

  /// Loads the current day's milk production from firebase firestore.
  Future<List<DailyMilkProduction>> getTodaysMilkProduction() async =>
      todaysMilkProductionList;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }
}
