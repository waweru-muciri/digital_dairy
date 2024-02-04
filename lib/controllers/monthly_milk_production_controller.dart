import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_production_service.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';

class MonthlyMilkProductionController with ChangeNotifier {
  MonthlyMilkProductionController();

  final DailyMilkProductionService _dailyMilkProductionService =
      DailyMilkProductionService();

  final List<DailyMilkProduction> _monthMilkProductionList = [];
  final Map<String, double> _monthDailyMilkProductionList = {};
  final Map<int, double> _yearMonthlyMilkProductionList = {};
  final List<Map<String, dynamic>> _allCowsMonthMilkProductionTotalsList = [];
  // Allow Widgets to read the filtered dailyMilkProductions list.
  Map<String, double> get monthDailyMilkProductionsList =>
      _monthDailyMilkProductionList;

  Map<int, double> get yearMonthlyMilkProductionsList =>
      _yearMonthlyMilkProductionList;
  List<Map<String, dynamic>> get allCowsTotalMonthMilkProductionList =>
      _allCowsMonthMilkProductionTotalsList;

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

  void getMonthDailyMilkProductions(
      {required int year, required int month}) async {
    DateTime monthStartDate = DateTime(year, month, 1);
    DateTime monthEndDate = DateTime(year, month + 1, 0);
    String monthStartDateString = getStringFromDate(monthStartDate);
    String monthEndDateString = getStringFromDate(monthEndDate);
    //get the milk production list for all the days of the month
    List<DailyMilkProduction> fetchedList = await _dailyMilkProductionService
        .getDailyMilkProductionsListBetweenDates(monthStartDateString,
            endDate: monthEndDateString);
    //add all the fetched milk productions to the local list for computations later
    _monthMilkProductionList.clear();
    _monthMilkProductionList.addAll(fetchedList);

    //group milk productions by cow id
    List<Map<String, dynamic>> totalMonthMilkProductionGroupedByCow =
        fetchedList
            .groupFoldBy<Cow, Map<String, double>>(
                (element) => element.getCow,
                (previousValue, element) => {
                      'am_quantity': previousValue?['am_quantity'] ??
                          0 + element.getAmQuantity,
                      'noon_quantity': previousValue?['noon_quantity'] ??
                          0 + element.getNoonQuantity,
                      'pm_quantity': previousValue?['pm_quantity'] ??
                          0 + element.getPmQuantity,
                      'total_quantity': previousValue?['total_quantity'] ??
                          0 + element.totalMilkQuantity,
                    })
            .entries
            .map((e) => {...e.value, 'cow': e.key})
            .toList();
    _allCowsMonthMilkProductionTotalsList.clear();
    _allCowsMonthMilkProductionTotalsList
        .addAll(totalMonthMilkProductionGroupedByCow);

    //group the milk productions for the month by each date of the month
    Map<String, List<DailyMilkProduction>> milkProductionsGroupedByDate =
        groupBy(fetchedList,
            (dailyMilkProduction) => dailyMilkProduction.getMilkProductionDate);
    final Map<String, double> totalDailyMilkProductionList = {};
    for (var dateMilkProduction in milkProductionsGroupedByDate.entries) {
      totalDailyMilkProductionList[dateMilkProduction.key] =
          dateMilkProduction.value.fold(
              0.0,
              (previousValue, milkProduction) =>
                  (previousValue + milkProduction.totalMilkQuantity));
    }
    _monthDailyMilkProductionList.clear();
    _monthDailyMilkProductionList.addAll(totalDailyMilkProductionList);
    notifyListeners();
  }

  void getYearMonthlyMilkProductions({required int year}) async {
    DateTime yearStartDate = DateTime(year, 1, 1);
    DateTime yearEndDate = DateTime(year + 1, 1, 0);
    String yearStartDateString = getStringFromDate(yearStartDate);
    String yearEndDateString = getStringFromDate(yearEndDate);
    //get the milk production list for all the months of the year
    List<DailyMilkProduction> fetchedList = await _dailyMilkProductionService
        .getDailyMilkProductionsListBetweenDates(yearStartDateString,
            endDate: yearEndDateString);
    //group the milk productions by the month number
    Map<int, List<DailyMilkProduction>> milkProductionsGroupedByMonth = groupBy(
        fetchedList,
        (dailyMilkProduction) =>
            getDateFromString(dailyMilkProduction.getMilkProductionDate).month);
    final Map<int, double> monthsMilkProductionList = {};
    for (var monthMilkProduction in milkProductionsGroupedByMonth.entries) {
      monthsMilkProductionList[monthMilkProduction.key] =
          monthMilkProduction.value.fold(
              0.0,
              (previousValue, milkProduction) =>
                  (previousValue + milkProduction.totalMilkQuantity));
    }
    _yearMonthlyMilkProductionList.addAll(monthsMilkProductionList);
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
