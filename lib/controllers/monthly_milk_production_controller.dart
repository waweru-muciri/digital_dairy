import 'package:DigitalDairy/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_production_service.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';
import 'package:intl/intl.dart';

class MonthlyMilkProductionController with ChangeNotifier {
  MonthlyMilkProductionController();

  final DailyMilkProductionService _dailyMilkProductionService =
      DailyMilkProductionService();

  final List<DailyMilkProduction> _monthMilkProductionList = [];
  final List<Map<String, double>> _monthDailyMilkProductionList = [];
  final List<Map<String, double>> _yearMonthlyMilkProductionList = [];

  // Allow Widgets to read the filtered dailyMilkProductions list.
  List<Map<String, double>> get monthDailyMilkProductionsList =>
      _monthDailyMilkProductionList;

  List<Map<String, double>> getMonthDailyMilkProduction(DateTime monthStartDate,
      DateTime monthEndDate, List<DailyMilkProduction> milkProductionList) {
    List<Map<String, double>> selectedMonthMilkProductions = [];
    for (var date = monthStartDate;
        date.compareTo(monthEndDate) <= 0;
        date.add(const Duration(days: 1))) {
      String dateString = getStringFromDate(date);
      double totalMonthMilkProduction = milkProductionList
          .where((milkProduction) =>
              milkProduction.getMilkProductionDate == dateString)
          .fold(
              0.0,
              (previousValue, milkProduction) =>
                  previousValue + milkProduction.totalMilkQuantity);

      selectedMonthMilkProductions
          .add(<String, double>{dateString: totalMonthMilkProduction});
    }
    return selectedMonthMilkProductions;
  }

  void filterMonthlyMilkProductionsByMonth(int month, int year) async {
    DateTime monthStartDate = DateTime(year, month, 1);
    DateTime monthEndDate = DateTime(year, month + 1, 0);
    String monthStartDateString = getStringFromDate(monthStartDate);
    String monthEndDateString = getStringFromDate(monthEndDate);
    //get the milk production list for all the days of the month
    List<DailyMilkProduction> fetchedList = await _dailyMilkProductionService
        .getDailyMilkProductionsListBetweenDates(monthStartDateString,
            endDate: monthEndDateString);
    _monthMilkProductionList.clear();
    _monthMilkProductionList.addAll(fetchedList);
    List<Map<String, double>> totalDailyMilkProductionList =
        getMonthDailyMilkProduction(monthStartDate, monthEndDate, fetchedList);
    _monthDailyMilkProductionList.addAll(totalDailyMilkProductionList);
    notifyListeners();
  }

  void getYearMonthlyMilkProductions(int year) async {
    DateTime yearStartDate = DateTime(year, 1, 1);
    DateTime yearEndDate = DateTime(year + 1, 1, 0);
    String yearStartDateString = getStringFromDate(yearStartDate);
    String yearEndDateString = getStringFromDate(yearEndDate);
    //get the milk production list for all the months of the year
    List<DailyMilkProduction> fetchedList = await _dailyMilkProductionService
        .getDailyMilkProductionsListBetweenDates(yearStartDateString,
            endDate: yearEndDateString);

    List<Map<String, double>> selectedYearMonthlyMilkProductions = [];
    for (var i = 1; i <= 12; i++) {
      DateTime monthStartDate = DateTime(year, i, 1);
      DateTime monthEndDate = DateTime(year, i + 1, 0);
      List<Map<String, double>> monthMilkProductionList =
          getMonthDailyMilkProduction(
              monthStartDate, monthEndDate, fetchedList);
      double totalMonthMilkProductionQuantity = monthMilkProductionList.fold(
          0.0,
          (previousValue, element) =>
              element.values.reduce((value, element) => element));
      _yearMonthlyMilkProductionList.add({
        DateFormat("MMMM").format(monthStartDate):
            totalMonthMilkProductionQuantity
      });
    }
    _yearMonthlyMilkProductionList.addAll(selectedYearMonthlyMilkProductions);
    notifyListeners();
  }

  double get getTotalMilkProductionQuantity =>
      getTotalAmMilkProductionQuantity +
      getTotalNoonMilkProductionQuantity +
      getTotalPmMilkProductionQuantity;

  double get getTotalAmMilkProductionQuantity => _monthMilkProductionList.fold(
      0,
      (previousValue, dailyMilkProduction) =>
          (previousValue + dailyMilkProduction.getAmQuantity));

  double get getTotalNoonMilkProductionQuantity =>
      _monthMilkProductionList.fold(
          0,
          (previousValue, dailyMilkProduction) =>
              previousValue +
              (previousValue + dailyMilkProduction.getNoonQuantity));

  double get getTotalPmMilkProductionQuantity => _monthMilkProductionList.fold(
      0,
      (previousValue, dailyMilkProduction) =>
          (previousValue + dailyMilkProduction.getPmQuantity));
}
