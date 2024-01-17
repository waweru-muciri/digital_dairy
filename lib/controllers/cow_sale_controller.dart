import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/cow_sale_service.dart';
import 'package:DigitalDairy/models/cow_sale.dart';

class CowSaleController with ChangeNotifier {
  CowSaleController();

  // Make CowSaleService a private variable so it is not used directly.
  final CowSaleService _cowSaleService = CowSaleService();

  /// Internal, private state of the current day cowSale.
  final List<CowSale> _cowSaleList = [];
  final List<CowSale> _filteredCowSaleList = [];

  // Allow Widgets to read the filtered cowSales list.
  List<CowSale> get cowSalesList => _filteredCowSaleList;

  double get getTotalCowSales => _filteredCowSaleList.fold(
      0, (previousValue, milkSale) => previousValue + milkSale.getCowSaleCost);

  void filterCowSales(String? query) {
    if (query != null && query.isNotEmpty) {
      List<CowSale> fetchedList = _cowSaleList
          .where((item) => item.getCow.cowName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredCowSaleList.clear();
      _filteredCowSaleList.addAll(fetchedList);
    } else {
      _filteredCowSaleList.clear();
      _filteredCowSaleList.addAll(_cowSaleList);
    }
    notifyListeners();
  }

  void filterCowSalesByDates(String startDate, {String? endDate}) async {
    List<CowSale> fetchedList = await _cowSaleService
        .getCowSalesListBetweenDates(startDate, endDate: endDate);
    _cowSaleList.clear();
    _filteredCowSaleList.clear();
    _cowSaleList.addAll(fetchedList);
    _filteredCowSaleList.addAll(fetchedList);

    notifyListeners();
  }

  Future<void> getCowSales() async {
    List<CowSale> loadedList = await _cowSaleService.getCowSalesList();
    _cowSaleList.clear();
    _filteredCowSaleList.clear();
    _cowSaleList.addAll(loadedList);
    _filteredCowSaleList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addCowSale(CowSale cowSale) async {
    //call to the service to add the item to the database
    final savedCowSale = await _cowSaleService.addCowSale(cowSale);
    // add the cowSale item to today's list of items
    if (savedCowSale != null) {
      _cowSaleList.add(savedCowSale);
      _filteredCowSaleList.add(savedCowSale);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editCowSale(CowSale cowSale) async {
    final savedCowSale = await _cowSaleService.editCowSale(cowSale);
    //remove the old cowSale from the list
    _filteredCowSaleList.removeWhere(
        (cowSaleToFilter) => cowSaleToFilter.getId == cowSale.getId);
    _cowSaleList.removeWhere(
        (cowSaleToFilter) => cowSaleToFilter.getId == cowSale.getId);
    //add the updated cowSale to the list
    _cowSaleList.add(savedCowSale);
    _filteredCowSaleList.add(savedCowSale);
    notifyListeners();
  }

  Future<void> deleteCowSale(CowSale cowSale) async {
    //call to the service to delete the item in the database
    await _cowSaleService.deleteCowSale(cowSale);
    // remove the cowSale item to today's list of items
    _filteredCowSaleList.removeWhere(
        (cowSaleToFilter) => cowSaleToFilter.getId == cowSale.getId);
    _cowSaleList.removeWhere(
        (cowSaleToFilter) => cowSaleToFilter.getId == cowSale.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
