import '../models/expense.dart';
import "db_service.dart";

/// A service that gets, updates and deletes client information.
///
class ExpenseService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _clientReference =
      DbService.clientReference.collection('expenses').withConverter<Expense>(
            fromFirestore: Expense.fromFirestore,
            toFirestore: (Expense client, _) => client.toFirestore(),
          );

  /// Loads the clients list from firebase firestore.
  Future<List<Expense>> getExpensesList() async {
    return await _clientReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a client
  Future<Expense?> addExpense(Expense client) async {
    return await _clientReference
        .add(client)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a client
  Future<void> deleteExpense(Expense client) async {
    return await _clientReference.doc(client.getId).delete();
  }

//update a client
  Future<Expense> editExpense(Expense client) async {
    await _clientReference.doc(client.getId).update(client.toFirestore());
    return client;
  }
}
