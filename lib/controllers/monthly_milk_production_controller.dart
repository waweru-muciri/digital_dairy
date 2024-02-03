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
  final List<Map<String, double>> _monthDailyMilkProductionList = [];
  final List<Map<int, double>> _yearMonthlyMilkProductionList = [];
  final List<Map<Cow, double>> _allCowsMonthMilkProductionTotalsList = [];
  // Allow Widgets to read the filtered dailyMilkProductions list.
  List<Map<String, double>> get monthDailyMilkProductionsList =>
      _monthDailyMilkProductionList;

  List<Map<int, double>> get yearMonthlyMilkProductionsList =>
      _yearMonthlyMilkProductionList;
  List<Map<Cow, double>> get allCowsTotalMonthMilkProductionList =>
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

  void getMonthDailyMilkProductions(int month, int year) async {
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
    Map<Cow, List<DailyMilkProduction>> dailyMilkProductionsGroupedByCow =
        groupBy(
            fetchedList, (dailyMilkProduction) => dailyMilkProduction.getCow);
    List<Map<Cow, double>> totalMonthMilkProductionGroupedByCow =
        dailyMilkProductionsGroupedByCow.entries
            .map((cowMonthMilkProduction) => {
                  cowMonthMilkProduction.key: cowMonthMilkProduction.value.fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue + element.totalMilkQuantity)
                })
            .toList();
    _allCowsMonthMilkProductionTotalsList.clear();
    _allCowsMonthMilkProductionTotalsList
        .addAll(totalMonthMilkProductionGroupedByCow);
    //group the milk productions for the month by each date of the month
    Map<String, List<DailyMilkProduction>> milkProductionsGroupedByDate =
        groupBy(fetchedList,
            (dailyMilkProduction) => dailyMilkProduction.getMilkProductionDate);
    List<Map<String, double>> totalDailyMilkProductionList =
        milkProductionsGroupedByDate.entries
            .map((dateMilkProduction) => {
                  dateMilkProduction.key: dateMilkProduction.value.fold(
                      0.0,
                      (previousValue, milkProduction) =>
                          (previousValue + milkProduction.totalMilkQuantity))
                })
            .toList();
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

    Map<int, List<DailyMilkProduction>> milkProductionsGroupedByMonth = groupBy(
        fetchedList,
        (dailyMilkProduction) =>
            getDateFromString(dailyMilkProduction.getMilkProductionDate).month);
    List<Map<int, double>> totalMonthlyMilkProductionList =
        milkProductionsGroupedByMonth.entries
            .map((monthMilkProduction) => {
                  monthMilkProduction.key: monthMilkProduction.value.fold(
                      0.0,
                      (previousValue, milkProduction) =>
                          (previousValue + milkProduction.totalMilkQuantity))
                })
            .toList();
    _yearMonthlyMilkProductionList.addAll(totalMonthlyMilkProductionList);
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
