import 'package:DigitalDairy/models/feeding_item.dart';
import 'package:DigitalDairy/services/feeding_item_service.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read feedingItem, update and delete
/// feedingItem details.
///
class FeedingItemController with ChangeNotifier {
  FeedingItemController();

  // Make FeedingItemService a private variable so it is not used directly.
  final FeedingItemService _feedingItemService = FeedingItemService();

  /// Internal, private state of the current day feedingItem.
  final List<FeedingItem> _feedingItemList = [];
  final List<FeedingItem> _filteredFeedingItemList = [];

  // Allow Widgets to read the filtered feedingItems list.
  List<FeedingItem> get feedingItemsList => _filteredFeedingItemList;

  void filterFeedingItems(String? query) {
    if (query != null && query.isNotEmpty) {
      List<FeedingItem> fetchedList = _feedingItemList
          .where((item) => item.getName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredFeedingItemList.clear();
      _filteredFeedingItemList.addAll(fetchedList);
    } else {
      _filteredFeedingItemList.clear();
      _filteredFeedingItemList.addAll(_feedingItemList);
    }
    notifyListeners();
  }

  Future<void> getFeedingItems() async {
    List<FeedingItem> fetchedList =
        await _feedingItemService.getFeedingItemsList();
    _feedingItemList.clear();
    _filteredFeedingItemList.clear();
    _feedingItemList.addAll(fetchedList);
    _filteredFeedingItemList.addAll(fetchedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addFeedingItem(FeedingItem feedingItem) async {
    //call to the service to add the item to the database
    final savedFeedingItem =
        await _feedingItemService.addFeedingItem(feedingItem);
    // add the feedingItem item to today's list of items
    if (savedFeedingItem != null) {
      _feedingItemList.add(savedFeedingItem);
      _filteredFeedingItemList.add(savedFeedingItem);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editFeedingItem(FeedingItem feedingItem) async {
    final savedFeedingItem =
        await _feedingItemService.editFeedingItem(feedingItem);
    //remove the old feedingItem from the list
    _filteredFeedingItemList.removeWhere((feedingItemToFilter) =>
        feedingItemToFilter.getId == feedingItem.getId);
    _feedingItemList.removeWhere((feedingItemToFilter) =>
        feedingItemToFilter.getId == feedingItem.getId);
    //add the updated feedingItem to the list
    _feedingItemList.add(savedFeedingItem);
    _filteredFeedingItemList.add(savedFeedingItem);
    notifyListeners();
  }

  Future<void> deleteFeedingItem(FeedingItem feedingItem) async {
    //call to the service to delete the item in the database
    await _feedingItemService.deleteFeedingItem(feedingItem);
    // remove the feedingItem item to today's list of items
    _filteredFeedingItemList.removeWhere((feedingItemToFilter) =>
        feedingItemToFilter.getId == feedingItem.getId);
    _feedingItemList.removeWhere((feedingItemToFilter) =>
        feedingItemToFilter.getId == feedingItem.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
