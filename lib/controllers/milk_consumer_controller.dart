import 'package:flutter/material.dart';
import '../services/milk_consumer_service.dart';
import '../models/milk_consumer.dart';

/// A class that many Widgets can interact with to read milkConsumer, update and delete
/// milkConsumer details.
///
class MilkConsumerController with ChangeNotifier {
  MilkConsumerController();

  // Make MilkConsumerService a private variable so it is not used directly.
  final MilkConsumerService _milkConsumerService = MilkConsumerService();

  /// Internal, private state of the current day milkConsumer.
  final List<MilkConsumer> _milkConsumerList = [];

  // Allow Widgets to read the milkConsumers list.
  List<MilkConsumer> get milkConsumersList => _milkConsumerList;

  Future<void> getMilkConsumers() async {
    _milkConsumerList.clear();
    List<MilkConsumer> loadedList =
        await _milkConsumerService.getMilkConsumersList();
    _milkConsumerList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addMilkConsumer(MilkConsumer milkConsumer) async {
    //call to the service to add the item to the database
    final savedConsumer =
        await _milkConsumerService.addMilkConsumer(milkConsumer);
    // add the milkConsumer item to today's list of items
    if (savedConsumer != null) {
      _milkConsumerList.add(savedConsumer);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkConsumer(MilkConsumer milkConsumer) async {
    final savedConsumer =
        await _milkConsumerService.editMilkConsumer(milkConsumer);
    //remove the old milkConsumer from the list
    _milkConsumerList.retainWhere(
        (milkConsumerToFilter) => milkConsumerToFilter.id != milkConsumer.id);
    //add the updated milkConsumer to the list
    _milkConsumerList.add(savedConsumer);
    notifyListeners();
  }

  Future<void> deleteMilkConsumer(MilkConsumer milkConsumer) async {
    //call to the service to delete the item in the database
    await _milkConsumerService.deleteMilkConsumer(milkConsumer);
    // remove the milkConsumer item to today's list of items
    _milkConsumerList.retainWhere(
        (milkConsumerToFilter) => milkConsumerToFilter.id != milkConsumer.id);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
