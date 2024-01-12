import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/expense_service.dart';
import 'package:DigitalDairy/models/expense.dart';

/// A class that many Widgets can interact with to read expense, update and delete
/// expense details.
///
class ExpenseController with ChangeNotifier {
  ExpenseController();

  // Make ExpenseService a private variable so it is not used directly.
  final ExpenseService _expenseService = ExpenseService();

  /// Internal, private state of the current day expense.
  final List<Expense> _expenseList = [];
  final List<Expense> _filteredExpenseList = [];

  // Allow Widgets to read the filtered expenses list.
  List<Expense> get expensesList => _filteredExpenseList;

  void filterExpenses(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Expense> filteredList = _expenseList
          .where((item) => item.getDetails
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredExpenseList.clear();
      _filteredExpenseList.addAll(filteredList);
    } else {
      _filteredExpenseList.clear();
      _filteredExpenseList.addAll(_expenseList);
    }
    notifyListeners();
  }

  double get getTotalExpenses => _filteredExpenseList
      .map((expense) => (expense.getExpenseAmount))
      .fold(0, (previousValue, element) => previousValue + element);

  void filterExpenseByDates(String startDate, {String? endDate}) async {
    List<Expense> filteredList = await _expenseService
        .getExpensesListBetweenDates(startDate, endDate: endDate);
    _expenseList.clear();
    _filteredExpenseList.clear();
    _filteredExpenseList.addAll(filteredList);
    _expenseList.addAll(filteredList);
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    //call to the service to add the item to the database
    final savedExpense = await _expenseService.addExpense(expense);
    // add the expense item to today's list of items
    if (savedExpense != null) {
      _expenseList.add(savedExpense);
      _filteredExpenseList.add(savedExpense);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editExpense(Expense expense) async {
    final savedExpense = await _expenseService.editExpense(expense);
    //remove the old expense from the list
    _filteredExpenseList.removeWhere(
        (expenseToFilter) => expenseToFilter.getId == expense.getId);
    _expenseList.removeWhere(
        (expenseToFilter) => expenseToFilter.getId == expense.getId);
    //add the updated expense to the list
    _expenseList.add(savedExpense);
    _filteredExpenseList.add(savedExpense);
    notifyListeners();
  }

  Future<void> deleteExpense(Expense expense) async {
    //call to the service to delete the item in the database
    await _expenseService.deleteExpense(expense);
    // remove the expense item to today's list of items
    _filteredExpenseList.removeWhere(
        (expenseToFilter) => expenseToFilter.getId == expense.getId);
    _expenseList.removeWhere(
        (expenseToFilter) => expenseToFilter.getId == expense.getId);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
