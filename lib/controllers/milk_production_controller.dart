import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_production_service.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';

/// A class that many Widgets can interact with to read milk production, update and delete
/// milk production details.
///
class DailyMilkProductionController with ChangeNotifier {
  DailyMilkProductionController();

  // Make DailyMilkProductionService a private variable so it is not used directly.
  final DailyMilkProductionService _dailyMilkProductionService =
      DailyMilkProductionService();

  /// Internal, private state of the current day dailyMilkProduction.
  final List<DailyMilkProduction> _dailyMilkProductionList = [];
  final List<DailyMilkProduction> _filteredDailyMilkProductionList = [];

  // Allow Widgets to read the filtered dailyMilkProductions list.
  List<DailyMilkProduction> get dailyMilkProductionsList =>
      _filteredDailyMilkProductionList;

  void filterDailyMilkProductionsByCowName(String? query) {
    if (query != null && query.isNotEmpty) {
      List<DailyMilkProduction> fetchedList = _dailyMilkProductionList
          .where((item) => item.getCow.getName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredDailyMilkProductionList.clear();
      _filteredDailyMilkProductionList.addAll(fetchedList);
    } else {
      _filteredDailyMilkProductionList.clear();
      _filteredDailyMilkProductionList.addAll(_dailyMilkProductionList);
    }
    notifyListeners();
  }

  void filterDailyMilkProductionsByDates(String startDate,
      {String? endDate}) async {
    List<DailyMilkProduction> fetchedList = await _dailyMilkProductionService
        .getDailyMilkProductionsListBetweenDates(startDate, endDate: endDate);
    _filteredDailyMilkProductionList.clear();
    _dailyMilkProductionList.clear();
    _dailyMilkProductionList.addAll(fetchedList);
    _filteredDailyMilkProductionList.addAll(fetchedList);
    notifyListeners();
  }

  double get getTotalMilkProductionQuantity =>
      getTotalAmMilkProductionQuantity +
      getTotalNoonMilkProductionQuantity +
      getTotalPmMilkProductionQuantity;

  double get getTotalAmMilkProductionQuantity =>
      _filteredDailyMilkProductionList.fold(
          0,
          (previousValue, dailyMilkProduction) =>
              (previousValue + dailyMilkProduction.getAmQuantity));

  double get getTotalNoonMilkProductionQuantity =>
      _filteredDailyMilkProductionList.fold(
          0,
          (previousValue, dailyMilkProduction) =>
              previousValue +
              (previousValue + dailyMilkProduction.getNoonQuantity));

  double get getTotalPmMilkProductionQuantity =>
      _filteredDailyMilkProductionList.fold(
          0,
          (previousValue, dailyMilkProduction) =>
              (previousValue + dailyMilkProduction.getPmQuantity));

  Future<void> addDailyMilkProduction(
      DailyMilkProduction dailyMilkProduction) async {
    //call to the service to add the item to the database
    await _dailyMilkProductionService.addMilkProduction(dailyMilkProduction);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editDailyMilkProduction(
      DailyMilkProduction dailyMilkProduction) async {
    final savedDailyMilkProduction = await _dailyMilkProductionService
        .editMilkProduction(dailyMilkProduction);
    //remove the old dailyMilkProduction from the list
    _filteredDailyMilkProductionList.removeWhere(
        (dailyMilkProductionToFilter) =>
            dailyMilkProductionToFilter.getId == dailyMilkProduction.getId);
    _dailyMilkProductionList.removeWhere((dailyMilkProductionToFilter) =>
        dailyMilkProductionToFilter.getId == dailyMilkProduction.getId);
    //add the updated dailyMilkProduction to the list
    _dailyMilkProductionList.add(savedDailyMilkProduction);
    _filteredDailyMilkProductionList.add(savedDailyMilkProduction);
    notifyListeners();
  }

  Future<void> deleteDailyMilkProduction(
      DailyMilkProduction dailyMilkProduction) async {
    //call to the service to delete the item in the database
    await _dailyMilkProductionService.deleteMilkProduction(dailyMilkProduction);
    // remove the dailyMilkProduction item to today's list of items
    _filteredDailyMilkProductionList.removeWhere(
        (dailyMilkProductionToFilter) =>
            dailyMilkProductionToFilter.getId == dailyMilkProduction.getId);
    _dailyMilkProductionList.removeWhere((dailyMilkProductionToFilter) =>
        dailyMilkProductionToFilter.getId == dailyMilkProduction.getId);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
