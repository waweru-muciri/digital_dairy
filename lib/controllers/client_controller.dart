import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/client_service.dart';
import 'package:DigitalDairy/models/client.dart';

/// A class that many Widgets can interact with to read client, update and delete
/// client details.
///
class ClientController with ChangeNotifier {
  ClientController();

  //used to show loading
  bool _isLoading = false;

  // Make ClientService a private variable so it is not used directly.
  final ClientService _clientService = ClientService();

  /// Internal, private state of the current day client.
  final List<Client> _clientList = [];

  // Allow Widgets to read the clients list.
  List<Client> get clientsList => _clientList;
  bool get loadingStatus => _isLoading;

  Future<void> getClients() async {
    _isLoading = true;
    notifyListeners();
    _clientList.clear();
    List<Client> loadedList = await _clientService.getClientsList();
    _clientList.addAll(loadedList);
    _isLoading = false;
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addClient(Client client) async {
    _isLoading = true;
    notifyListeners();
    //call to the service to add the item to the database
    final savedClient = await _clientService.addClient(client);
    // add the client item to today's list of items
    if (savedClient != null) {
      _clientList.add(savedClient);
    }
    _isLoading = false;
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editClient(Client client) async {
    _isLoading = true;
    notifyListeners();
    final savedClient = await _clientService.editClient(client);
    //remove the old client from the list
    _clientList.retainWhere((clientToFilter) => clientToFilter.id != client.id);
    //add the updated client to the list
    _clientList.add(savedClient);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteClient(Client client) async {
    _isLoading = true;
    notifyListeners();
    //call to the service to delete the item in the database
    await _clientService.deleteClient(client);
    // remove the client item to today's list of items
    _clientList.retainWhere((clientToFilter) => clientToFilter.id != client.id);
    // Important! Inform listeners a change has occurred.
    _isLoading = false;
    notifyListeners();
  }
}
