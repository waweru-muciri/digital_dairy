import '../models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A service that gets, updates and deletes client information.
///
class ClientService {
  // Create a CollectionReference called milk_production that references the firestore collection
  final _clientReference = FirebaseFirestore.instance
      .collection("farmers")
      .doc("UYeFZgo47bsbaLDsRGnA")
      .collection('clients')
      .withConverter<Client>(
        fromFirestore: Client.fromFirestore,
        toFirestore: (Client client, _) => client.toFirestore(),
      );

  /// Loads the clients list from firebase firestore.
  Future<List<Client>> getClientsList() async {
    return await _clientReference.get().then((querySnapshot) => querySnapshot
        .docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList());
  }

//add a client
  Future<Client?> addClient(Client client) async {
    return await _clientReference
        .add(client)
        .then((docRef) => docRef.get())
        .then((docSnap) => docSnap.data());
  }

//add a client
  Future<void> deleteClient(Client client) async {
    return await _clientReference.doc(client.id).delete();
  }

//update a client
  Future<Client> editClient(Client client) async {
    await _clientReference.doc(client.id).update(client.toFirestore());
    return client;
  }
}
