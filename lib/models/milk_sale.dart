import "package:cloud_firestore/cloud_firestore.dart";

class MilkSale {
  final String id;
  final String firstName;
  final String lastName;
  final String contacts;
  final String location;

  MilkSale(
      {this.id = "",
      this.location = "",
      this.contacts = "",
      required this.firstName,
      required this.lastName});

  factory MilkSale.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return MilkSale(
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        location: data?["location"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'location': location,
      'lastName': lastName,
      'firstName': firstName,
      //only return the id if it is not null
      if (id != null) "id": id,
    };
  }

  String get clientName => '$firstName  $lastName';
}
