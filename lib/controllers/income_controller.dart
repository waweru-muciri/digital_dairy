import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/income_service.dart';
import 'package:DigitalDairy/models/income.dart';

/// A class that many Widgets can interact with to read income, update and delete
/// income details.
///
class IncomeController with ChangeNotifier {
  IncomeController();

  // Make IncomeService a private variable so it is not used directly.
  final IncomeService _incomeService = IncomeService();

  /// Internal, private state of the current day income.
  final List<Income> _incomeList = [];
  final List<Income> _filteredIncomeList = [];

  // Allow Widgets to read the filtered incomes list.
  List<Income> get incomesList => _filteredIncomeList;

  void filterIncomes(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Income> filteredList = _incomeList
          .where((item) => item.getDetails
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredIncomeList.clear();
      _filteredIncomeList.addAll(filteredList);
    } else {
      _filteredIncomeList.clear();
      _filteredIncomeList.addAll(_incomeList);
    }
    notifyListeners();
  }

  double get getTotalIncome => _filteredIncomeList
      .map((income) => (income.getIncomeAmount))
      .fold(0, (previousValue, element) => previousValue + element);

  void filterIncomeByDates(String startDate, {String? endDate}) async {
    List<Income> filteredList =
        await _incomeService.getIncomesList(startDate, endDate: endDate);
    _incomeList.clear();
    _incomeList.clear();
    _filteredIncomeList.clear();
    _filteredIncomeList.addAll(filteredList);
    _incomeList.addAll(filteredList);
    notifyListeners();
  }

  Future<void> addIncome(Income income) async {
    //call to the service to add the item to the database
    final savedIncome = await _incomeService.addIncome(income);
    // add the income item to today's list of items
    if (savedIncome != null) {
      _incomeList.add(savedIncome);
      _filteredIncomeList.add(savedIncome);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editIncome(Income income) async {
    final savedIncome = await _incomeService.editIncome(income);
    //remove the old income from the list
    _filteredIncomeList
        .removeWhere((incomeToFilter) => incomeToFilter.getId == income.getId);
    _incomeList
        .removeWhere((incomeToFilter) => incomeToFilter.getId == income.getId);
    //add the updated income to the list
    _incomeList.add(savedIncome);
    _filteredIncomeList.add(savedIncome);
    notifyListeners();
  }

  Future<void> deleteIncome(Income income) async {
    //call to the service to delete the item in the database
    await _incomeService.deleteIncome(income);
    // remove the income item to today's list of items
    _filteredIncomeList
        .removeWhere((incomeToFilter) => incomeToFilter.getId == income.getId);
    _incomeList
        .removeWhere((incomeToFilter) => incomeToFilter.getId == income.getId);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
