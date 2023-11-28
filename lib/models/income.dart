import "package:cloud_firestore/cloud_firestore.dart";

class Income {
  final String id;
  final String source;
  final double amount;
  final DateTime incomeDate;

  Income(
      {this.id = "",
      required this.amount,
      required this.source,
      required this.incomeDate});

  factory Income.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return Income(
        source: data?["source"],
        incomeDate: data?["incomeDate"],
        amount: data?["amount"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'incomeDate': incomeDate,
      'source': source,
    };
  }

  String get getIncomeDetails => '$source Ksh: $amount';
}
