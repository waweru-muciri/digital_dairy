import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_production_service.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:DigitalDairy/util/utils.dart';

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
      List<DailyMilkProduction> filteredList = _dailyMilkProductionList
          .where((item) => item.getCow.getName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredDailyMilkProductionList.clear();
      _filteredDailyMilkProductionList.addAll(filteredList);
    } else {
      _filteredDailyMilkProductionList.clear();
      _filteredDailyMilkProductionList.addAll(_dailyMilkProductionList);
    }
    notifyListeners();
  }

  void filterDailyMilkProductionsByDate(String filterDate) async {
    List<DailyMilkProduction> filteredList =
        await _dailyMilkProductionService.getMilkProductionByDate(filterDate);
    _filteredDailyMilkProductionList.clear();
    _filteredDailyMilkProductionList.addAll(filteredList);
    debugPrint("fetched items after filter => ${filteredList.length}");
    notifyListeners();
  }

  double get getTotalMilkProductionQuantity =>
      _filteredDailyMilkProductionList.fold(
          0,
          (previousValue, dailyMilkProduction) =>
              previousValue +
              (dailyMilkProduction.getAmQuantity +
                  dailyMilkProduction.getNoonQuantity +
                  dailyMilkProduction.getPmQuantity));

  Future<void> getTodaysDailyMilkProductions() async {
    List<DailyMilkProduction> loadedList = await _dailyMilkProductionService
        .getMilkProductionByDate(getStringFromDate(DateTime.now()));
    _dailyMilkProductionList.clear();
    _filteredDailyMilkProductionList.clear();
    _dailyMilkProductionList.addAll(loadedList);
    _filteredDailyMilkProductionList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addDailyMilkProduction(
      DailyMilkProduction dailyMilkProduction) async {
    //call to the service to add the item to the database
    final savedDailyMilkProduction = await _dailyMilkProductionService
        .addMilkProduction(dailyMilkProduction);
    // add the dailyMilkProduction item to today's list of items
    if (savedDailyMilkProduction != null) {
      _dailyMilkProductionList.add(savedDailyMilkProduction);
      _filteredDailyMilkProductionList.add(savedDailyMilkProduction);
    }
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
