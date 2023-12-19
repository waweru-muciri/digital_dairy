import '../models/expense.dart';
import "db_service.dart";

/// A service that gets, updates and deletes expense information.
///
class ExpenseService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _expenseReference = DbService.currentUserDbReference
      .collection('expenses')
      .withConverter<Expense>(
        fromFirestore: Expense.fromFirestore,
        toFirestore: (Expense expense, _) => expense.toFirestore(),
      );

  /// Loads the expenses list from firebase firestore.
  Future<List<Expense>> getExpensesList() async {
    return await _expenseReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a expense
  Future<Expense?> addExpense(Expense expense) async {
    return await _expenseReference
        .add(expense)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a expense
  Future<void> deleteExpense(Expense expense) async {
    return await _expenseReference.doc(expense.getId).delete();
  }

//update a expense
  Future<Expense> editExpense(Expense expense) async {
    await _expenseReference.doc(expense.getId).update(expense.toFirestore());
    return expense;
  }
}
