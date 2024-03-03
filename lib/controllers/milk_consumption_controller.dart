import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_consumption_service.dart';
import 'package:DigitalDairy/models/milk_consumption.dart';

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

  double get getTotalMilkConsumptionKgsAmount => _filteredMilkConsumptionList
      .map((milkConsumption) => (milkConsumption.getMilkConsumptionAmount))
      .fold(0, (previousValue, element) => previousValue + element);

  void filterMilkConsumptionBySearchTerm(String? query) {
    if (query != null && query.isNotEmpty) {
      List<MilkConsumption> fetchedList = _milkConsumptionList
          .where((item) => item.getMilkConsumer.getMilkConsumerName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredMilkConsumptionList.clear();
      _filteredMilkConsumptionList.addAll(fetchedList);
    } else {
      _filteredMilkConsumptionList.clear();
      _filteredMilkConsumptionList.addAll(_milkConsumptionList);
    }
    notifyListeners();
  }

  Future<void> filterMilkConsumptionsByDatesAndMilkConsumerId(
      String startDate, String endDate, String clientId) async {
    if (startDate.isNotEmpty && endDate.isNotEmpty && clientId.isNotEmpty) {
      List<MilkConsumption> fetchedList = await _milkConsumptionService
          .filterMilkConsumptionsByDatesAndMilkConsumerId(
              startDate, endDate, clientId);
      _milkConsumptionList.clear();
      _filteredMilkConsumptionList.clear();
      _milkConsumptionList.addAll(fetchedList);
      _filteredMilkConsumptionList.addAll(fetchedList);
      notifyListeners();
    }
  }

  Future<void> filterMilkConsumptionsByMilkConsumerId(
      String milkConsumerId) async {
    List<MilkConsumption> fetchedList = await _milkConsumptionService
        .getMilkConsumptionsForMilkConsumer(milkConsumerId);
    _milkConsumptionList.clear();
    _filteredMilkConsumptionList.clear();
    _milkConsumptionList.addAll(fetchedList);
    _filteredMilkConsumptionList.addAll(fetchedList);
    notifyListeners();
  }

  void filterMilkConsumptionsByDate(String startDate, {String? endDate}) async {
    List<MilkConsumption> fetchedList = await _milkConsumptionService
        .getMilkConsumptionsListBetweenDates(startDate, endDate: endDate);
    _milkConsumptionList.clear();
    _filteredMilkConsumptionList.clear();
    _milkConsumptionList.addAll(fetchedList);
    _filteredMilkConsumptionList.addAll(fetchedList);

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
