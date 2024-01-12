import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_consumption_service.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';
import 'package:intl/intl.dart';

/// A class that many Widgets can interact with to read milkConsumption, update and delete
/// milkConsumption details.
///
class MilkConsumptionController with ChangeNotifier {
  MilkConsumptionController();

  // Make MilkConsumptionService a private variable so it is not used directly.
  final MilkConsumptionService _milkConsumptionService =
      MilkConsumptionService();

  /// Internal, private state of the current day milkConsumption.
  final List<MilkConsumption> _milkConsumptionList = [];
  final List<MilkConsumption> _filteredMilkConsumptionList = [];

  // Allow Widgets to read the filtered milkConsumptions list.
  List<MilkConsumption> get milkConsumptionsList =>
      _filteredMilkConsumptionList;

  void filterMilkConsumptionByDate(String filterDate) async {
    List<MilkConsumption> filteredList =
        await _milkConsumptionService.getMilkConsumptionsList(filterDate);
    _filteredMilkConsumptionList.clear();
    _filteredMilkConsumptionList.addAll(filteredList);
    notifyListeners();
  }

  Future<void> getTodayMilkConsumptions() async {
    List<MilkConsumption> loadedList = await _milkConsumptionService
        .getMilkConsumptionsList(getStringFromDate(DateTime.now()));
    _milkConsumptionList.clear();
    _filteredMilkConsumptionList.clear();
    _milkConsumptionList.addAll(loadedList);
    _filteredMilkConsumptionList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addMilkConsumption(MilkConsumption milkConsumption) async {
    //call to the service to add the item to the database
    final savedMilkConsumption =
        await _milkConsumptionService.addMilkConsumption(milkConsumption);
    // add the milkConsumption item to today's list of items
    if (savedMilkConsumption != null) {
      _milkConsumptionList.add(savedMilkConsumption);
      _filteredMilkConsumptionList.add(savedMilkConsumption);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkConsumption(MilkConsumption milkConsumption) async {
    final savedMilkConsumption =
        await _milkConsumptionService.editMilkConsumption(milkConsumption);
    //remove the old milkConsumption from the list
    _filteredMilkConsumptionList.removeWhere((milkConsumptionToFilter) =>
        milkConsumptionToFilter.getId == milkConsumption.getId);
    _milkConsumptionList.removeWhere((milkConsumptionToFilter) =>
        milkConsumptionToFilter.getId == milkConsumption.getId);
    //add the updated milkConsumption to the list
    _milkConsumptionList.add(savedMilkConsumption);
    _filteredMilkConsumptionList.add(savedMilkConsumption);
    notifyListeners();
  }

  Future<void> deleteMilkConsumption(MilkConsumption milkConsumption) async {
    //call to the service to delete the item in the database
    await _milkConsumptionService.deleteMilkConsumption(milkConsumption);
    // remove the milkConsumption item to today's list of items
    _filteredMilkConsumptionList.removeWhere((milkConsumptionToFilter) =>
        milkConsumptionToFilter.getId == milkConsumption.getId);
    _milkConsumptionList.removeWhere((milkConsumptionToFilter) =>
        milkConsumptionToFilter.getId == milkConsumption.getId);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
