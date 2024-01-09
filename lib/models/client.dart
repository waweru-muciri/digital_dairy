import "package:cloud_firestore/cloud_firestore.dart";

class Client {
  String? _id;
  late String _firstName;
  late String _lastName;
  late String _contacts;
  late String _location;
  late double _unitPrice;

  Client();

  get getId => _id;

  set setId(id) => _id = id;

  get getFirstName => _firstName;

  set setFirstName(firstName) => _firstName = firstName;

  get getLastName => _lastName;

  set setLastName(lastName) => _lastName = lastName;

  get getContacts => _contacts;

  set setContacts(contacts) => _contacts = contacts;

  get getLocation => _location;

  set setLocation(location) => _location = location;

  get getUnitPrice => _unitPrice;

  set setUnitPrice(unitPrice) => _unitPrice = unitPrice;

  factory Client.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final String id = snapshot.id;

    Client newClient = Client();
    newClient._firstName = data?["firstName"];
    newClient._lastName = data?["lastName"];
    newClient._location = data?["location"];
    newClient._unitPrice = data?["unitPrice"];
    newClient._contacts = data?["contacts"];
    newClient._id = id;

    return newClient;
  }

  factory Client.fromAnotherFirestoreDoc(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?["client"];
    final String id = snapshot.id;

    Client newClient = Client();
    newClient._firstName = data?["firstName"];
    newClient._lastName = data?["lastName"];
    newClient._location = data?["location"];
    newClient._unitPrice = data?["unitPrice"];
    newClient._contacts = data?["contacts"];
    newClient._id = id;

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
