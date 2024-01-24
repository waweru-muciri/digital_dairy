import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/cow_service.dart';
import 'package:DigitalDairy/models/cow.dart';

/// A class that many Widgets can interact with to read cow, update and delete
/// cow details.
///
class CowController with ChangeNotifier {
  CowController();

  // Make CowService a private variable so it is not used directly.
  final CowService _cowService = CowService();

  /// Internal, private state of the current day cow.
  final List<Cow> _cowList = [];
  final List<Cow> _filteredCowList = [];

  // Allow Widgets to read the filtered cows list.
  List<Cow> get cowsList => _filteredCowList;

  void filterCows(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Cow> fetchedList = _cowList
          .where((item) => item.cowName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredCowList.clear();
      _filteredCowList.addAll(fetchedList);
    } else {
      _filteredCowList.clear();
      _filteredCowList.addAll(_cowList);
    }
    notifyListeners();
  }

  Future<void> getCows() async {
    List<Cow> fetchedList = await _cowService.getCowsList();
    _cowList.clear();
    _filteredCowList.clear();
    _cowList.addAll(fetchedList);
    _filteredCowList.addAll(fetchedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addCow(Cow cow) async {
    //call to the service to add the item to the database
    final savedCow = await _cowService.addCow(cow);
    // add the cow item to today's list of items
    if (savedCow != null) {
      _cowList.add(savedCow);
      _filteredCowList.add(savedCow);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editCow(Cow cow) async {
    final savedCow = await _cowService.editCow(cow);
    //remove the old cow from the list
    _filteredCowList
        .removeWhere((cowToFilter) => cowToFilter.getId == cow.getId);
    _cowList.removeWhere((cowToFilter) => cowToFilter.getId == cow.getId);
    //add the updated cow to the list
    _cowList.add(savedCow);
    _filteredCowList.add(savedCow);
    notifyListeners();
  }

  Future<void> deleteCow(Cow cow) async {
    //call to the service to delete the item in the database
    await _cowService.deleteCow(cow);
    // remove the cow item to today's list of items
    _filteredCowList
        .removeWhere((cowToFilter) => cowToFilter.getId == cow.getId);
    _cowList.removeWhere((cowToFilter) => cowToFilter.getId == cow.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
