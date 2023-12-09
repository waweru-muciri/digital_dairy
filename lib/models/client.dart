import "package:cloud_firestore/cloud_firestore.dart";

class Client {
  final String? id;
  final String firstName;
  final String lastName;
  final String contacts;
  final String location;
  final double unitPrice;

  Client(
      {this.id = "",
      this.location = "",
      this.contacts = "",
      this.unitPrice = 0,
      required this.firstName,
      required this.lastName});

  factory Client.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return Client(
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        location: data?["location"],
        unitPrice: data?["unitPrice"],
        contacts: data?["contacts"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'location': location,
      'lastName': lastName,
      'firstName': firstName,
      'contacts': contacts,
      'unitPrice': unitPrice,
      'id': id,
    };
  }

  String get clientName => '$firstName $lastName';
}
