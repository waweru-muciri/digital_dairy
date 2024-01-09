import '../models/employee.dart';
import "db_service.dart";

/// A service that gets, updates and deletes employee information.
///
class EmployeeService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _employeeReference = DbService.currentUserDbReference
      .collection('employees')
      .withConverter<Employee>(
        fromFirestore: Employee.fromFirestore,
        toFirestore: (Employee employee, _) => employee.toFirestore(),
      );

  /// Loads the employees list from firebase firestore.
  Future<List<Employee>> getEmployeesList() async {
    return await _employeeReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a employee
  Future<Employee?> addEmployee(Employee employee) async {
    return await _employeeReference
        .add(employee)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a employee
  Future<void> deleteEmployee(Employee employee) async {
    return await _employeeReference.doc(employee.getId).delete();
  }

//update a employee
  Future<Employee> editEmployee(Employee employee) async {
    await _employeeReference.doc(employee.getId).update(employee.toFirestore());
    return employee;
  }
}
