import "package:cloud_firestore/cloud_firestore.dart";

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String employeeId;
  final String contacts;
  final String location;
  final double salary;
  final DateTime? dateHired;
  final String designation;

  Employee(
      {this.id = "",
      this.location = "",
      this.designation = "",
      this.dateHired,
      this.salary = 0,
      this.employeeId = "",
      this.contacts = "",
      required this.firstName,
      required this.lastName});

  factory Employee.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return Employee(
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        location: data?["location"],
        contacts: data?["contacts"],
        employeeId: data?["employeeId"],
        salary: data?["salary"],
        dateHired: data?["dateHired"],
        designation: data?["designation"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'location': location,
      'contacts': contacts,
      "dateHired": dateHired,
      "salary": salary,
      "employeeId": employeeId,
      "designation": designation,
    };
  }

  String get getEmployeeName => '$firstName  $lastName';
}
