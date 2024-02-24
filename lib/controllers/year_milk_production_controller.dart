import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/milk_production_service.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';

class YearMilkProductionController with ChangeNotifier {
  YearMilkProductionController();

  final DailyMilkProductionService _dailyMilkProductionService =
      DailyMilkProductionService();

  final Map<int, double> _yearYearMilkProductionList = {};

  Map<int, double> get yearYearMilkProductionsList =>
      _yearYearMilkProductionList;

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
    _yearYearMilkProductionList.addAll(monthsMilkProductionList);
    notifyListeners();
  }
}
