import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_sale_service.dart';
import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/util/utils.dart';

/// A class that many Widgets can interact with to read milkSale, update and delete
/// milkSale details.
///
class MilkSaleController with ChangeNotifier {
  MilkSaleController();

  // Make MilkSaleService a private variable so it is not used directly.
  final MilkSaleService _milkSaleService = MilkSaleService();

  /// Internal, private state of the current day milkSale.
  final List<MilkSale> _milkSaleList = [];
  final List<MilkSale> _filteredMilkSaleList = [];

  // Allow Widgets to read the filtered milkSales list.
  List<MilkSale> get milkSalesList => _filteredMilkSaleList;

  double get getTotalMilkSalesKgsAmount => _filteredMilkSaleList.fold(0,
      (previousValue, milkSale) => previousValue + milkSale.getMilkSaleAmount);

  double get getTotalMilkSalesMoneyAmount => _filteredMilkSaleList.fold(
      0,
      (previousValue, milkSale) =>
          previousValue +
          (milkSale.getMilkSaleAmount) * (milkSale.getClient.getUnitPrice));

  void filterMilkSalesByClientName(String? query) {
    if (query != null && query.isNotEmpty) {
      List<MilkSale> fetchedList = _milkSaleList
          .where((item) => item.getClient.clientName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredMilkSaleList.clear();
      _filteredMilkSaleList.addAll(fetchedList);
    } else {
      _filteredMilkSaleList.clear();
      _filteredMilkSaleList.addAll(_milkSaleList);
    }
    notifyListeners();
  }

  void filterMilkSalesByDates(String startDate, {String? endDate}) async {
    List<MilkSale> fetchedList = await _milkSaleService
        .getMilkSalesListBetweenDates(startDate, endDate: endDate);
    _milkSaleList.clear();
    _filteredMilkSaleList.clear();
    _milkSaleList.addAll(fetchedList);
    _filteredMilkSaleList.addAll(fetchedList);

    notifyListeners();
  }

  Future<void> addMilkSale(MilkSale milkSale) async {
    //call to the service to add the item to the database
    final savedMilkSale = await _milkSaleService.addMilkSale(milkSale);
    // add the milkSale item to today's list of items
    if (savedMilkSale != null) {
      _milkSaleList.add(savedMilkSale);
      _filteredMilkSaleList.add(savedMilkSale);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkSale(MilkSale milkSale) async {
    final savedMilkSale = await _milkSaleService.editMilkSale(milkSale);
    //remove the old milkSale from the list
    _filteredMilkSaleList.removeWhere(
        (milkSaleToFilter) => milkSaleToFilter.getId == milkSale.getId);
    _milkSaleList.removeWhere(
        (milkSaleToFilter) => milkSaleToFilter.getId == milkSale.getId);
    //add the updated milkSale to the list
    _milkSaleList.add(savedMilkSale);
    _filteredMilkSaleList.add(savedMilkSale);
    notifyListeners();
  }

  Future<void> deleteMilkSale(MilkSale milkSale) async {
    //call to the service to delete the item in the database
    await _milkSaleService.deleteMilkSale(milkSale);
    // remove the milkSale item to today's list of items
    _filteredMilkSaleList.removeWhere(
        (milkSaleToFilter) => milkSaleToFilter.getId == milkSale.getId);
    _milkSaleList.removeWhere(
        (milkSaleToFilter) => milkSaleToFilter.getId == milkSale.getId);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
