import 'package:DigitalDairy/models/milk_sale.dart';
import 'package:DigitalDairy/services/milk_sale_service.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class YearMilkSaleController with ChangeNotifier {
  YearMilkSaleController();

  final MilkSaleService _milkSaleService = MilkSaleService();

  final Map<int, double> _yearMonthlyMilkSaleList = {};

  Map<int, double> get yearYearMilkSalesList => _yearMonthlyMilkSaleList;

  Future<void> getYearMonthlyMilkSales({required int year}) async {
    DateTime yearStartDate = DateTime(year, 1, 1);
    DateTime yearEndDate = DateTime(year + 1, 1, 0);
    String yearStartDateString = getStringFromDate(yearStartDate);
    String yearEndDateString = getStringFromDate(yearEndDate);
    //get the milk production list for all the months of the year
    List<MilkSale> fetchedList =
        await _milkSaleService.getMilkSalesListBetweenDates(yearStartDateString,
            endDate: yearEndDateString);
    Map<int, double> milkProductionGroupedByMonthMap =
        await compute(groupMilkSalesByMonth, fetchedList);
    _yearMonthlyMilkSaleList.clear();
    _yearMonthlyMilkSaleList.addAll(milkProductionGroupedByMonthMap);
    notifyListeners();
  }
}

Map<int, double> groupMilkSalesByMonth(List<MilkSale> fetchedList) {
  //group the milk productions by the month number
  Map<int, List<MilkSale>> milkProductionsGroupedByMonth = groupBy(
      fetchedList,
      (dailyMilkSale) =>
          getDateFromString(dailyMilkSale.getMilkSaleDate).month);
  final Map<int, double> monthsMilkSaleList = {};
  for (var monthMilkSale in milkProductionsGroupedByMonth.entries) {
    monthsMilkSaleList[monthMilkSale.key] = monthMilkSale.value.fold(
        0.0,
        (previousValue, milkSale) =>
            (previousValue + milkSale.getMilkSaleMoneyAmount));
  }

  return monthsMilkSaleList;
}
