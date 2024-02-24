import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:DigitalDairy/services/milk_production_service.dart';
import 'package:DigitalDairy/models/daily_milk_production.dart';

class MonthlyMilkProductionController with ChangeNotifier {
  MonthlyMilkProductionController();

  final DailyMilkProductionService _dailyMilkProductionService =
      DailyMilkProductionService();

  final List<DailyMilkProduction> _monthMilkProductionList = [];
  final Map<String, double> _monthDailyMilkProductionList = {};
  final List<Map<String, dynamic>> _cowsTotalDailyMilkProductionList = [];

  Map<String, double> get monthDailyMilkProductionsList =>
      _monthDailyMilkProductionList;

  List<Map<String, dynamic>> get allCowsTotalMonthMilkProductionList =>
      _cowsTotalDailyMilkProductionList;

  Map<String, double> groupMonthMilkProductionsByDate(
      List<DailyMilkProduction> fetchedList) {
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
    return totalDailyMilkProductionList;
  }

  List<Map<String, dynamic>> groupMilkProductionsByCow(
      List<DailyMilkProduction> fetchedList) {
    final cowsWithMilkData = fetchedList.map((e) => e.getCow).toSet();

    return groupBy(fetchedList,
            (dailyMilkProduction) => dailyMilkProduction.getCow.getId)
        .entries
        .map((e) => {
              'cow': cowsWithMilkData
                  .firstWhereOrNull((element) => element.getId == e.key),
              'am_quantity': e.value
                  .fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue + element.getAmQuantity)
                  .toStringAsFixed(2),
              'noon_quantity': e.value
                  .fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue + element.getNoonQuantity)
                  .toStringAsFixed(2),
              'pm_quantity': e.value
                  .fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue + element.getPmQuantity)
                  .toStringAsFixed(2),
              'total_quantity': e.value
                  .fold(
                      0.0,
                      (previousValue, element) =>
                          previousValue + element.totalMilkQuantity)
                  .toStringAsFixed(2),
            })
        .toList();
  }

  Future<void> getMonthDailyMilkProductions(
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
    List<Map<String, dynamic>> milkProductionsGroupedByCow =
        await compute(groupMilkProductionsByCow, fetchedList);
    _cowsTotalDailyMilkProductionList.clear();
    _cowsTotalDailyMilkProductionList.addAll(milkProductionsGroupedByCow);
    //group milk productions by cow id
    Map<String, double> milkProductionsGroupedByDate =
        await compute(groupMonthMilkProductionsByDate, fetchedList);
    _monthDailyMilkProductionList.clear();
    _monthDailyMilkProductionList.addAll(milkProductionsGroupedByDate);
    notifyListeners();
  }

  double get getTotalAmMilkProductionQuantity => _monthMilkProductionList.fold(
      0,
      (previousValue, dailyMilkProduction) =>
          (previousValue + dailyMilkProduction.getAmQuantity));

  double get getTotalNoonMilkProductionQuantity =>
      _monthMilkProductionList.fold(
          0,
          (previousValue, dailyMilkProduction) =>
              (previousValue + dailyMilkProduction.getNoonQuantity));

  double get getTotalPmMilkProductionQuantity => _monthMilkProductionList.fold(
      0,
      (previousValue, dailyMilkProduction) =>
          (previousValue + dailyMilkProduction.getPmQuantity));
}
