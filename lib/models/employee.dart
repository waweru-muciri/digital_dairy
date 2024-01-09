import "package:cloud_firestore/cloud_firestore.dart";

class Employee {
  String? _id;
  late String _firstName;
  late String _lastName;
  late String _employeeId;
  late String _contacts;
  late String _location;
  late double _salary;
  late String? _dateHired;
  late String _designation;

  Employee();

  String? get getId => _id;

  set id(String? value) => _id = value;

  get getFirstName => _firstName;

  set setFirstName(value) => _firstName = value;

  get getLastName => _lastName;

  set setLastName(value) => _lastName = value;

  get getEmployeeId => _employeeId;

  set setEmployeeId(value) => _employeeId = value;

  get getContacts => _contacts;

  set setContacts(value) => _contacts = value;

  get getLocation => _location;

  set setLocation(value) => _location = value;

  get getSalary => _salary;

  set setSalary(value) => _salary = value;

  get getDateHired => _dateHired;

  set setDateHired(value) => _dateHired = value;

  get getDesignation => _designation;

  set seDesignation(value) => _designation = value;

  factory Employee.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Employee newEmployee = Employee();
    newEmployee._firstName = data?["firstName"];
    newEmployee._lastName = data?["lastName"];
    newEmployee._location = data?["location"];
    newEmployee._contacts = data?["contacts"];
    newEmployee._employeeId = data?["employeeId"];
    newEmployee._salary = data?["salary"];
    newEmployee._dateHired = data?["dateHired"];
    newEmployee._designation = data?["designation"];
    newEmployee._id = id;
    return newEmployee;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': _firstName,
      'lastName': _lastName,
      'location': _location,
      'contacts': _contacts,
      "dateHired": _dateHired,
      "salary": _salary,
      "employeeId": _employeeId,
      "designation": _designation,
    };
  }

  String get getEmployeeName => '$_firstName  $_lastName';
}
