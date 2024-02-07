import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/services/milk_sale_service.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class MonthlyMilkSaleController with ChangeNotifier {
  MonthlyMilkSaleController();

  final MilkSaleService _dailyMilkSaleService = MilkSaleService();
  final List<MilkSale> _monthMilkSaleList = [];
  final Map<String, double> _eachDayOfTheMonthMilkSalesMap = {};
  final Map<int, double> _yearMonthlyMilkSaleMap = {};
  final List<Map<String, dynamic>> _allClientsMonthMilkSaleTotalsList = [];
  // Allow Widgets to read the filtered dailyMilkSales list.
  Map<String, double> get eachMonthMilkSalesGraphData =>
      _eachDayOfTheMonthMilkSalesMap;

  Map<int, double> get yearMonthlyMilkSalesGraphData => _yearMonthlyMilkSaleMap;
  List<Map<String, dynamic>> get allClientsTotalMonthMilkSaleList =>
      _allClientsMonthMilkSaleTotalsList;

  void groupMonthMilkSalesByDate(List<MilkSale> fetchedList) {
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
    print(eachDayTotalMilkSalesMap);
    _eachDayOfTheMonthMilkSalesMap.clear();
    _eachDayOfTheMonthMilkSalesMap.addAll(eachDayTotalMilkSalesMap);
    notifyListeners();
  }

  void getMonthMilkSales({required int year, required int month}) async {
    DateTime monthStartDate = DateTime(year, month, 1);
    DateTime monthEndDate = DateTime(year, month + 1, 0);
    String monthStartDateString = getStringFromDate(monthStartDate);
    String monthEndDateString = getStringFromDate(monthEndDate);
    //get the milk production list for all the days of the month
    List<MilkSale> fetchedList = await _dailyMilkSaleService
        .getMilkSalesListBetweenDates(monthStartDateString,
            endDate: monthEndDateString);
    //add all the fetched milk productions to the local list for computations later
    _monthMilkSaleList.clear();
    _monthMilkSaleList.addAll(fetchedList);

    //group milk productions by cow id
    final clientsWithMilkSales = fetchedList.map((e) => e.getClient).toSet();
    List<Map<String, dynamic>> totalMonthMilkSalesGroupedByClient =
        groupBy(fetchedList, (dailyMilkSale) => dailyMilkSale.getClientId)
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
    _allClientsMonthMilkSaleTotalsList.clear();
    _allClientsMonthMilkSaleTotalsList
        .addAll(totalMonthMilkSalesGroupedByClient);
    notifyListeners();
    groupMonthMilkSalesByDate(fetchedList);
  }

  void getYearMonthlyMilkSalesMoneyAmount({required int year}) async {
    DateTime yearStartDate = DateTime(year, 1, 1);
    DateTime yearEndDate = DateTime(year + 1, 1, 0);
    String yearStartDateString = getStringFromDate(yearStartDate);
    String yearEndDateString = getStringFromDate(yearEndDate);
    //get the milk production list for all the months of the year
    List<MilkSale> fetchedList = await _dailyMilkSaleService
        .getMilkSalesListBetweenDates(yearStartDateString,
            endDate: yearEndDateString);
    //group the milk productions by the month number
    Map<int, List<MilkSale>> milkSalesGroupedByMonth = groupBy(
        fetchedList,
        (dailyMilkSale) =>
            getDateFromString(dailyMilkSale.getMilkSaleDate).month);
    final Map<int, double> monthsMilkSaleList = {};
    for (var monthMilkSale in milkSalesGroupedByMonth.entries) {
      monthsMilkSaleList[monthMilkSale.key] = monthMilkSale.value.fold(
          0.0,
          (previousValue, milkSale) =>
              (previousValue + milkSale.getMilkSaleMoneyAmount));
    }
    _yearMonthlyMilkSaleMap.addAll(monthsMilkSaleList);
    notifyListeners();
  }

  double get getTotalYearMilkSalesMoneyAmount =>
      _yearMonthlyMilkSaleMap.values.fold(
          0,
          (previousValue, monthMilkSalesMoneyAmount) =>
              (previousValue + monthMilkSalesMoneyAmount));

  double get getTotalMonthMilkSalesMoneyAmount => _monthMilkSaleList.fold(
      0,
      (previousValue, dailyMilkSale) =>
          (previousValue + dailyMilkSale.getMilkSaleMoneyAmount));

  double get getTotalMonthMilkSalesQuantity => _monthMilkSaleList.fold(
      0,
      (previousValue, dailyMilkSale) =>
          (previousValue + dailyMilkSale.getMilkSaleQuantity));
}
