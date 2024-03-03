import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/services/milk_sale_service.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class MonthlyMilkSaleController with ChangeNotifier {
  MonthlyMilkSaleController();

  final MilkSaleService _milkSaleService = MilkSaleService();

  final List<MilkSale> _monthMilkSaleList = [];
  final Map<String, double> _eachDayOfTheMonthMilkSalesMap = {};
  final List<Map<String, dynamic>> _allClientsMonthMilkSaleTotalsList = [];
  // Allow Widgets to read the filtered dailyMilkSales list.
  Map<String, double> get eachMonthMilkSalesGraphData =>
      _eachDayOfTheMonthMilkSalesMap;

  List<Map<String, dynamic>> get allClientsTotalMonthMilkSaleList =>
      _allClientsMonthMilkSaleTotalsList;

  Future<void> getMonthMilkSales(
      {required int year, required int month}) async {
    DateTime monthStartDate = DateTime(year, month, 1);
    DateTime monthEndDate = DateTime(year, month + 1, 0);
    String monthStartDateString = getStringFromDate(monthStartDate);
    String monthEndDateString = getStringFromDate(monthEndDate);
    //get the milk production list for all the days of the month
    List<MilkSale> fetchedList = await _milkSaleService
        .getMilkSalesListBetweenDates(monthStartDateString,
            endDate: monthEndDateString);
    //add all the fetched milk productions to the local list for computations later
    _monthMilkSaleList.clear();
    _monthMilkSaleList.addAll(fetchedList);

    //group milk sales by client
    List<Map<String, dynamic>> totalMonthMilkSalesGroupedByClient =
        await compute(groupMilkSalesByClient, fetchedList);
    _allClientsMonthMilkSaleTotalsList.clear();
    _allClientsMonthMilkSaleTotalsList
        .addAll(totalMonthMilkSalesGroupedByClient);
    notifyListeners();
    Map<String, double> milkSalesGroupedByDate =
        await compute(groupMilkSalesByDateAndReduceByMoneyAmount, fetchedList);
    _eachDayOfTheMonthMilkSalesMap.clear();
    _eachDayOfTheMonthMilkSalesMap.addAll(milkSalesGroupedByDate);
    notifyListeners();
  }

  double get getTotalMonthMilkSalesMoneyAmount => _monthMilkSaleList.fold(
      0,
      (previousValue, dailyMilkSale) =>
          (previousValue + dailyMilkSale.getMilkSaleMoneyAmount));

  double get getTotalMonthMilkSalesQuantity => _monthMilkSaleList.fold(
      0,
      (previousValue, dailyMilkSale) =>
          (previousValue + dailyMilkSale.getMilkSaleQuantity));
}

Map<String, double> groupMilkSalesByDateAndReduceByMoneyAmount(
    List<MilkSale> fetchedList) {
  //group the milk productions for the month by each date of the month
  Map<String, List<MilkSale>> milkSalesGroupedByDate =
      groupBy(fetchedList, (dailyMilkSale) => dailyMilkSale.getMilkSaleDate);
  final Map<String, double> eachDayTotalMilkSalesMap = {};
  for (var dateMilkSale in milkSalesGroupedByDate.entries) {
    eachDayTotalMilkSalesMap[dateMilkSale.key] = dateMilkSale.value.fold(
        0.0,
        (previousValue, milkSale) =>
            (previousValue + milkSale.getMilkSaleMoneyAmount));
  }
  return eachDayTotalMilkSalesMap;
}

List<Map<String, dynamic>> groupMilkSalesByClient(List<MilkSale> fetchedList) {
  final clientsWithMilkSales = fetchedList.map((e) => e.getClient).toSet();
  return groupBy(fetchedList, (dailyMilkSale) => dailyMilkSale.getClientId)
      .entries
      .map((e) => {
            'client': clientsWithMilkSales
                .firstWhereOrNull((element) => element.getId == e.key),
            'milk_quantity': e.value
                .fold(
                    0.0,
                    (previousValue, element) =>
                        previousValue + element.getMilkSaleQuantity)
                .toStringAsFixed(2),
            'money_amount': e.value
                .fold(
                    0.0,
                    (previousValue, element) =>
                        previousValue + element.getMilkSaleMoneyAmount)
                .toStringAsFixed(2),
          })
      .toList();
}
