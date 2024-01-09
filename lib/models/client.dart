import "package:cloud_firestore/cloud_firestore.dart";

class Client {
  String? _id;
  late String _firstName;
  late String _lastName;
  late String _contacts;
  late String _location;
  late double _unitPrice;

  Client();

  String? get getId => _id;

  set setId(id) => _id = id;

  String get getFirstName => _firstName;

  set setFirstName(String firstName) => _firstName = firstName;

  String get getLastName => _lastName;

  set setLastName(String lastName) => _lastName = lastName;

  String get getContacts => _contacts;

  set setContacts(String contacts) => _contacts = contacts;

  String get getLocation => _location;

  set setLocation(String location) => _location = location;

  double get getUnitPrice => _unitPrice;

  set setUnitPrice(double unitPrice) => _unitPrice = unitPrice;

  factory Client.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Client newClient = Client();
    newClient.setFirstName = data?["firstName"];
    newClient.setLastName = data?["lastName"];
    newClient.setLocation = data?["location"];
    newClient.setUnitPrice = data?["unitPrice"];
    newClient.setContacts = data?["contacts"];
    newClient.setId = id;

    return newClient;
  }

  factory Client.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["client"];
    final String id = snapshot.id;

    Client newClient = Client();
    newClient.setFirstName = data?["firstName"];
    newClient.setLastName = data?["lastName"];
    newClient.setLocation = data?["location"];
    newClient.setUnitPrice = data?["unitPrice"];
    newClient.setContacts = data?["contacts"];
    newClient.setId = id;

    return newClient;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'location': _location,
      'lastName': _lastName,
      'firstName': _firstName,
      'contacts': _contacts,
      'unitPrice': _unitPrice,
      'id': _id,
    };
  }

  String get clientName => '$_firstName $_lastName';
}
