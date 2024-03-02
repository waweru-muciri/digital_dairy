import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/client_service.dart';
import 'package:DigitalDairy/models/client.dart';

/// A class that many Widgets can interact with to read client, update and delete
/// client details.
///
class FeedingItemController with ChangeNotifier {
  FeedingItemController();

  // Make FeedingItemService a private variable so it is not used directly.
  final FeedingItemService _clientService = FeedingItemService();

  /// Internal, private state of the current day client.
  final List<FeedingItem> _clientList = [];
  final List<FeedingItem> _filteredFeedingItemList = [];

  // Allow Widgets to read the filtered clients list.
  List<FeedingItem> get clientsList => _filteredFeedingItemList;

  void filterFeedingItems(String? query) {
    if (query != null && query.isNotEmpty) {
      List<FeedingItem> fetchedList = _clientList
          .where((item) => item.clientName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredFeedingItemList.clear();
      _filteredFeedingItemList.addAll(fetchedList);
    } else {
      _filteredFeedingItemList.clear();
      _filteredFeedingItemList.addAll(_clientList);
    }
    notifyListeners();
  }

  Future<void> getFeedingItems() async {
    List<FeedingItem> fetchedList = await _clientService.getFeedingItemsList();
    _clientList.clear();
    _filteredFeedingItemList.clear();
    _clientList.addAll(fetchedList);
    _filteredFeedingItemList.addAll(fetchedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addFeedingItem(FeedingItem client) async {
    //call to the service to add the item to the database
    final savedFeedingItem = await _clientService.addFeedingItem(client);
    // add the client item to today's list of items
    if (savedFeedingItem != null) {
      _clientList.add(savedFeedingItem);
      _filteredFeedingItemList.add(savedFeedingItem);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editFeedingItem(FeedingItem client) async {
    final savedFeedingItem = await _clientService.editFeedingItem(client);
    //remove the old client from the list
    _filteredFeedingItemList
        .removeWhere((clientToFilter) => clientToFilter.getId == client.getId);
    _clientList
        .removeWhere((clientToFilter) => clientToFilter.getId == client.getId);
    //add the updated client to the list
    _clientList.add(savedFeedingItem);
    _filteredFeedingItemList.add(savedFeedingItem);
    notifyListeners();
  }

  Future<void> deleteFeedingItem(FeedingItem client) async {
    //call to the service to delete the item in the database
    await _clientService.deleteFeedingItem(client);
    // remove the client item to today's list of items
    _filteredFeedingItemList
        .removeWhere((clientToFilter) => clientToFilter.getId == client.getId);
    _clientList
        .removeWhere((clientToFilter) => clientToFilter.getId == client.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
