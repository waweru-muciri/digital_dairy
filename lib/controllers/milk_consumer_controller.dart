import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_consumer_service.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';

/// A class that many Widgets can interact with to read milkConsumer, update and delete
/// milkConsumer details.
///
class MilkConsumerController with ChangeNotifier {
  MilkConsumerController();

  // Make MilkConsumerService a private variable so it is not used directly.
  final MilkConsumerService _milkConsumerService = MilkConsumerService();

  /// Internal, private state of the current day milkConsumer.
  final List<MilkConsumer> _milkConsumerList = [];
  final List<MilkConsumer> _filteredMilkConsumersList = [];

  // Allow Widgets to read the filtered milkConsumers list.
  List<MilkConsumer> get milkConsumersList => _filteredMilkConsumersList;

  Future<void> getMilkConsumers() async {
    List<MilkConsumer> loadedList =
        await _milkConsumerService.getMilkConsumersList();
    //clear the items present in the list to avoid duplication
    _milkConsumerList.clear();
    _filteredMilkConsumersList.clear();
    //add loaded items to the lists
    _milkConsumerList.addAll(loadedList);
    _filteredMilkConsumersList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  void filterMilkConsumers(String? query) {
    if (query != null && query.isNotEmpty) {
      List<MilkConsumer> fetchedList = _milkConsumerList
          .where((item) => item.milkConsumerName
              .trim()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      _filteredMilkConsumersList.clear();
      _filteredMilkConsumersList.addAll(fetchedList);
    } else {
      _filteredMilkConsumersList.clear();
      _filteredMilkConsumersList.addAll(_milkConsumerList);
    }
    notifyListeners();
  }

  Future<void> addMilkConsumer(MilkConsumer milkConsumer) async {
    //call to the service to add the item to the database
    final savedConsumer =
        await _milkConsumerService.addMilkConsumer(milkConsumer);
    // add the milkConsumer item to today's list of items
    if (savedConsumer != null) {
      _milkConsumerList.add(savedConsumer);
      _filteredMilkConsumersList.add(savedConsumer);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkConsumer(MilkConsumer milkConsumer) async {
    final savedConsumer =
        await _milkConsumerService.editMilkConsumer(milkConsumer);
    //remove the old milkConsumer from the list
    _milkConsumerList.removeWhere((milkConsumerToFilter) =>
        milkConsumerToFilter.getId == milkConsumer.getId);
    _filteredMilkConsumersList.removeWhere((milkConsumerToFilter) =>
        milkConsumerToFilter.getId == milkConsumer.getId);
    //add the updated milkConsumer to the list
    _milkConsumerList.add(savedConsumer);
    _filteredMilkConsumersList.add(savedConsumer);
    notifyListeners();
  }

  Future<void> deleteMilkConsumer(MilkConsumer milkConsumer) async {
    //call to the service to delete the item in the database
    await _milkConsumerService.deleteMilkConsumer(milkConsumer);
    // remove the milkConsumer item to today's list of items
    _milkConsumerList.removeWhere((milkConsumerToFilter) =>
        milkConsumerToFilter.getId == milkConsumer.getId);
    _filteredMilkConsumersList.removeWhere((milkConsumerToFilter) =>
        milkConsumerToFilter.getId == milkConsumer.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
