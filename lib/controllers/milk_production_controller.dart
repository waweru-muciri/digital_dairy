import 'package:flutter/material.dart';
import '../services/milk_production_service.dart';
import '../models/daily_milk_production.dart';

/// A class that many Widgets can interact with to read milk production, update and delete
/// milk production details.
///
class MilkProductionController with ChangeNotifier {
  MilkProductionController();

  // Make MilkProductionService a private variable so it is not used directly.
  final MilkProductionService _milkProductionService = MilkProductionService();

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

  Future<void> loadTodaysMilkProduction() async {
    _currentDayMilkProductionList.clear();
    List<DailyMilkProduction> loadedList =
        await _milkProductionService.getTodaysMilkProduction();
    _currentDayMilkProductionList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> addMilkProduction(DailyMilkProduction milkProduction) async {
    //call to the service to add the item to the database
    final savedMilkProduction =
        await _milkProductionService.addMilkProduction(milkProduction);
    // add the milk production item to today's list of items
    if (savedMilkProduction != null) {
      _currentDayMilkProductionList.add(savedMilkProduction);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkProduction(DailyMilkProduction milkProduction) async {
    //call to the service to edit the item in the database
    final savedMilkProduction =
        await _milkProductionService.editMilkProduction(milkProduction);
    // remove the old milk production item and replace with today's in the list of items
    _currentDayMilkProductionList.retainWhere(
        (milkProductionFilter) => milkProductionFilter.id != milkProduction.id);
    _currentDayMilkProductionList.add(savedMilkProduction);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> deleteMilkProduction(DailyMilkProduction milkProduction) async {
    //call to the service to delete the item in the database
    await _milkProductionService.deleteMilkProduction(milkProduction);
    // remove the milk production item to today's list of items
    _currentDayMilkProductionList.retainWhere(
        (milkProductionFilter) => milkProductionFilter.id != milkProduction.id);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
