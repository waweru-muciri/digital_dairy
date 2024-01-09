import "package:cloud_firestore/cloud_firestore.dart";

class MilkConsumer {
  String? _id;
  late String _firstName;
  late String _lastName;
  late String _contacts;
  late String _location;

  String? get getId => _id;

  set setId(String id) => _firstName = id;

  String get getFirstName => _firstName;

  set setFirstName(String firstName) => _firstName = firstName;

  String get getLastName => _lastName;

  set setLastName(String lastName) => _lastName = lastName;

  String get getContacts => _contacts;

  set setContacts(String contacts) => _contacts = contacts;

  String get getLocation => _location;

  set setLocation(String location) => _location = location;
  MilkConsumer();

  factory MilkConsumer.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["consumer"];
    final String id = snapshot.id;
    final newMilkConsumer = MilkConsumer();
    newMilkConsumer.setFirstName = data?["firstName"];
    newMilkConsumer.setLastName = data?["lastName"];
    newMilkConsumer.setLocation = data?["location"];
    newMilkConsumer.setContacts = data?["contacts"];
    newMilkConsumer.setId = id;

    return newMilkConsumer;
  }

  factory MilkConsumer.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    final newMilkConsumer = MilkConsumer();
    newMilkConsumer.setFirstName = data?["firstName"];
    newMilkConsumer.setLastName = data?["lastName"];
    newMilkConsumer.setLocation = data?["location"];
    newMilkConsumer.setContacts = data?["contacts"];
    newMilkConsumer.setId = id;

    return newMilkConsumer;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'location': _location,
      'lastName': _lastName,
      'firstName': _firstName,
      'contacts': _contacts,
      "id": _id,
    };
  }

  String get milkConsumerName => '$_firstName  $_lastName';
}
