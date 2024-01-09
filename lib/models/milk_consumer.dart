import "package:cloud_firestore/cloud_firestore.dart";

class MilkConsumer {
  final String? id;
  final String firstName;
  final String lastName;
  final String contacts;
  final String location;

  MilkConsumer(
      {this.id,
      this.location = "",
      this.contacts = "",
      required this.firstName,
      required this.lastName});

  factory MilkConsumer.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["consumer"];
    final String id = snapshot.id;

    return MilkConsumer(
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        location: data?["location"],
        contacts: data?["contacts"],
        id: id);
  }

  factory MilkConsumer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    return MilkConsumer(
        firstName: data?["firstName"],
        lastName: data?["lastName"],
        contacts: data?["contacts"],
        location: data?["location"],
        id: id);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'location': location,
      'lastName': lastName,
      'firstName': firstName,
      'contacts': contacts,
      "id": id,
    };
  }

  String get milkConsumerName => '$firstName  $lastName';
}
