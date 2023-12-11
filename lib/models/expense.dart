import "package:cloud_firestore/cloud_firestore.dart";

class Expense {
  String? _id;
  late double _expenseAmount;
  late DateTime _expenseDate;
  late String _details;

  Expense();

  set setExpenseId(String? id) {
    _id = id;
  }

  set setExpenseDate(DateTime expenseDate) {
    _expenseDate = expenseDate;
  }

  set seExpenseDetails(String details) {
    _details = details;
  }

  set setExpenseAmount(double expenseAmount) {
    _expenseAmount = expenseAmount;
  }

  double get getExpenseAmount => _expenseAmount;
  DateTime get getExpenseDate => _expenseDate;
  String? get getId => _id;
  String get getDetails => _details;

  factory Expense.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Expense newExpense = Expense();
    newExpense._id = data?["id"];
    newExpense._expenseDate = data?["expenseDate"];
    newExpense._expenseAmount = data?["expenseAmount"];
    newExpense._details = data?["details"];

    return newExpense;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'details': _details,
      'expenseDate': _expenseDate,
      'expenseAmount': _expenseAmount,
    };
  }
}
