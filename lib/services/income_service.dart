import 'package:intl/intl.dart';

import '../models/income.dart';
import "db_service.dart";

/// A service that gets, updates and deletes income information.
///
class IncomeService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _incomeReference = DbService.currentUserDbReference
      .collection('incomes')
      .withConverter<Income>(
        fromFirestore: Income.fromFirestore,
        toFirestore: (Income income, _) => income.toFirestore(),
      );

  Future<List<Income>> getIncomeListBetweenDates(String startDate,
      {String? endDate}) async {
    if (endDate != null) {
      return await _incomeReference
          .where("incomeDate", isGreaterThanOrEqualTo: startDate)
          .where("incomeDate", isLessThanOrEqualTo: endDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    } else {
      return await _incomeReference
          .where("incomeDate", isEqualTo: startDate)
          .get()
          .then((querySnapshot) => querySnapshot.docs
              .map((documentSnapshot) => documentSnapshot.data())
              .toList());
    }
  }

//add a income
  Future<Income?> addIncome(Income income) async {
    return await _incomeReference
        .add(income)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a income
  Future<void> deleteIncome(Income income) async {
    return await _incomeReference.doc(income.getId).delete();
  }

//update a income
  Future<Income> editIncome(Income income) async {
    await _incomeReference.doc(income.getId).update(income.toFirestore());
    return income;
  }
}
