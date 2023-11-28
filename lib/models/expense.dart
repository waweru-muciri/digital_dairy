import "package:cloud_firestore/cloud_firestore.dart";

class Expense {
  final String id;
  final String source;
  final double amount;
  final DateTime expenseDate;

  Expense(
      {this.id = "",
      required this.amount,
      required this.source,
      required this.expenseDate});

  factory Expense.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return Expense(
        source: data?["source"],
        expenseDate: data?["expenseDate"],
        amount: data?["amount"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'expenseDate': expenseDate,
      'source': source,
    };
  }

  String get getExpenseDetails => '$source Ksh: $amount';
}
