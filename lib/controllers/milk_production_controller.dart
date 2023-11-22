import 'package:flutter/material.dart';

import '../services/milk_production_service.dart';
import '../models/daily_milk_production.dart';

/// A class that many Widgets can interact with to read milk production, update and delete
/// milk production details.
///
class MilkProductionController with ChangeNotifier {
  MilkProductionController(this._milkProductionService);

  // Make MilkProductionService a private variable so it is not used directly.
  final MilkProductionService _milkProductionService;

  /// Internal, private state of the current day milk production.
  final List<DailyMilkProduction> _currentDayMilkProductionList = [];

  double get todayTotalMilkProductionQuantity => _currentDayMilkProductionList
      .map((milkProduction) => (milkProduction.amQuantity +
          milkProduction.noonQuantity +
          milkProduction.pmQuantity))
      .reduce((value, element) => value + element);

  // Allow Widgets to read the current day milk production.
  List<DailyMilkProduction> get todaysMilkProductionList =>
      _currentDayMilkProductionList;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> addMilkProduction(DailyMilkProduction milkProduction) async {
    //call to the service to add the item to the database
    // add the milk production item to today's list of items
    _currentDayMilkProductionList.add(milkProduction);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkProduction(DailyMilkProduction milkProduction) async {
    //call to the service to edit the item in the database
    // remove the old milk production item and replace with today's in the list of items
    _currentDayMilkProductionList.add(milkProduction);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> deleteMilkProduction(DailyMilkProduction milkProduction) async {
    //call to the service to delete the item in the database
    // add the milk production item to today's list of items
    _currentDayMilkProductionList.remove(milkProduction);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
