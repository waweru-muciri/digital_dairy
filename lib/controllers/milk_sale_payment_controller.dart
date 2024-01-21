import 'package:DigitalDairy/models/milk_sale_payment.dart';
import 'package:DigitalDairy/services/milk_sale_payment_service.dart';
import 'package:flutter/material.dart';

class MilkSalePaymentController with ChangeNotifier {
  MilkSalePaymentController();

  final MilkSalePaymentService _milkSalePaymentService =
      MilkSalePaymentService();

  final List<MilkSalePayment> _milkSalePaymentList = [];
  final List<MilkSalePayment> _filteredMilkSalePaymentList = [];

  List<MilkSalePayment> get milkSalePaymentsList =>
      _filteredMilkSalePaymentList;

  double get getTotalMilkSalesPayment => _filteredMilkSalePaymentList.fold(
      0,
      (previousValue, milkSalePayment) =>
          previousValue + milkSalePayment.getMilkSalePaymentAmount);

  double get getTotalMilkSales => _filteredMilkSalePaymentList.fold(
      0,
      (previousValue, milkSalePayment) =>
          previousValue + milkSalePayment.getMilkSale.getMilkSaleMoneyAmount);

  double get getOutstandingAmount =>
      getTotalMilkSalesPayment - getTotalMilkSales;

  void filterMilkSalePaymentsByClientName(String? query) {
    if (query != null && query.isNotEmpty) {
      List<MilkSalePayment> fetchedList = _milkSalePaymentList
          .where((item) => item.getMilkSale.getClient.clientName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredMilkSalePaymentList.clear();
      _filteredMilkSalePaymentList.addAll(fetchedList);
    } else {
      _filteredMilkSalePaymentList.clear();
      _filteredMilkSalePaymentList.addAll(_milkSalePaymentList);
    }
    notifyListeners();
  }

  Future<List<MilkSalePayment>> getPaymentsForMilkSale(String id) async {
    return await _milkSalePaymentService.getPaymentsForMilkSale(id);
  }

  void filterMilkSalePaymentsByDates(String startDate,
      {String? endDate}) async {
    List<MilkSalePayment> fetchedList = await _milkSalePaymentService
        .getMilkSalePaymentsListBetweenDates(startDate, endDate: endDate);
    _milkSalePaymentList.clear();
    _filteredMilkSalePaymentList.clear();
    _milkSalePaymentList.addAll(fetchedList);
    _filteredMilkSalePaymentList.addAll(fetchedList);

    notifyListeners();
  }

  Future<void> addMilkSalePayment(MilkSalePayment milkSalePayment) async {
    //call to the service to add the item to the database
    final savedMilkSalePayment =
        await _milkSalePaymentService.addMilkSalePayment(milkSalePayment);
    // add the milkSalePayment item to today's list of items
    if (savedMilkSalePayment != null) {
      _milkSalePaymentList.add(savedMilkSalePayment);
      _filteredMilkSalePaymentList.add(savedMilkSalePayment);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editMilkSalePayment(MilkSalePayment milkSalePayment) async {
    final savedMilkSalePayment =
        await _milkSalePaymentService.editMilkSalePayment(milkSalePayment);
    //remove the old milkSalePayment from the list
    _filteredMilkSalePaymentList.removeWhere((milkSalePaymentToFilter) =>
        milkSalePaymentToFilter.getId == milkSalePayment.getId);
    _milkSalePaymentList.removeWhere((milkSalePaymentToFilter) =>
        milkSalePaymentToFilter.getId == milkSalePayment.getId);
    //add the updated milkSalePayment to the list
    _milkSalePaymentList.add(savedMilkSalePayment);
    _filteredMilkSalePaymentList.add(savedMilkSalePayment);
    notifyListeners();
  }

  Future<void> deleteMilkSalePayment(MilkSalePayment milkSalePayment) async {
    //call to the service to delete the item in the database
    await _milkSalePaymentService.deleteMilkSalePayment(milkSalePayment);
    // remove the milkSalePayment item to today's list of items
    _filteredMilkSalePaymentList.removeWhere((milkSalePaymentToFilter) =>
        milkSalePaymentToFilter.getId == milkSalePayment.getId);
    _milkSalePaymentList.removeWhere((milkSalePaymentToFilter) =>
        milkSalePaymentToFilter.getId == milkSalePayment.getId);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
