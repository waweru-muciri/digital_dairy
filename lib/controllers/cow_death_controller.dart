import 'package:DigitalDairy/models/cow_death.dart';
import 'package:DigitalDairy/services/cow_death_service.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read cowDeath, update and delete
/// cowDeath details.
///
class CowDeathController with ChangeNotifier {
  CowDeathController();

  // Make CowDeathService a private variable so it is not used directly.
  final CowDeathService _cowDeathService = CowDeathService();

  /// Internal, private state of the current day cowDeath.
  final List<CowDeath> _cowDeathList = [];
  final List<CowDeath> _filteredCowDeathList = [];

  // Allow Widgets to read the filtered cowDeaths list.
  List<CowDeath> get cowDeathsList => _filteredCowDeathList;

  void filterCowDeathsByQueryString(String? query) {
    if (query != null && query.isNotEmpty) {
      List<CowDeath> fetchedList = _cowDeathList
          .where((item) => item.getCow.cowName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredCowDeathList.clear();
      _filteredCowDeathList.addAll(fetchedList);
    } else {
      _filteredCowDeathList.clear();
      _filteredCowDeathList.addAll(_cowDeathList);
    }
    notifyListeners();
  }

  Future<void> filterCowDeathsByDate(String startDate,
      {String? endDate}) async {
    List<CowDeath> fetchedList = await _cowDeathService
        .getCowDeathsListBetweenDates(startDate, endDate: endDate);
    _cowDeathList.clear();
    _filteredCowDeathList.clear();
    _cowDeathList.addAll(fetchedList);
    _filteredCowDeathList.addAll(fetchedList);
    notifyListeners();
  }

  Future<void> addCowDeath(CowDeath cowDeath) async {
    //call to the service to add the item to the database
    final savedCowDeath = await _cowDeathService.addCowDeath(cowDeath);
    // add the cowDeath item to today's list of items
    if (savedCowDeath != null) {
      _cowDeathList.add(savedCowDeath);
      _filteredCowDeathList.add(savedCowDeath);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editCowDeath(CowDeath cowDeath) async {
    final savedCowDeath = await _cowDeathService.editCowDeath(cowDeath);
    //remove the old cowDeath from the list
    _filteredCowDeathList.removeWhere(
        (cowDeathToFilter) => cowDeathToFilter.getId == cowDeath.getId);
    _cowDeathList.removeWhere(
        (cowDeathToFilter) => cowDeathToFilter.getId == cowDeath.getId);
    //add the updated cowDeath to the list
    _cowDeathList.add(savedCowDeath);
    _filteredCowDeathList.add(savedCowDeath);
    notifyListeners();
  }

  Future<void> deleteCowDeath(CowDeath cowDeath) async {
    //call to the service to delete the item in the database
    await _cowDeathService.deleteCowDeath(cowDeath);
    // remove the cowDeath item to today's list of items
    _filteredCowDeathList.removeWhere(
        (cowDeathToFilter) => cowDeathToFilter.getId == cowDeath.getId);
    _cowDeathList.removeWhere(
        (cowDeathToFilter) => cowDeathToFilter.getId == cowDeath.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
