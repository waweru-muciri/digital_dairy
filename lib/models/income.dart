import "package:cloud_firestore/cloud_firestore.dart";

class Income {
  String? _id;
  late double _incomeAmount;
  late DateTime _incomeDate;
  late String _details;

  Income();

  set setId(String? id) {
    _id = id;
  }

  set setIncomeDate(DateTime incomeDate) {
    _incomeDate = incomeDate;
  }

  set setIncomeDetails(String details) {
    _details = details;
  }

  set setIncomeAmount(double incomeAmount) {
    _incomeAmount = incomeAmount;
  }

  double get getIncomeAmount => _incomeAmount;
  DateTime get getIncomeDate => _incomeDate;
  String? get getId => _id;
  String get getDetails => _details;

  factory Income.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Income newIncome = Income();
    newIncome.setId = id;
    newIncome.setIncomeDate = (data?["incomeDate"] as Timestamp).toDate();
    newIncome.setIncomeAmount = data?["incomeAmount"];
    newIncome.setIncomeDetails = data?["details"];

    return newIncome;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'details': _details,
      'incomeDate': _incomeDate,
      'incomeAmount': _incomeAmount,
      'id': _id,
    };
  }
}
