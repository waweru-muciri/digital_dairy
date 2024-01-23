import 'package:DigitalDairy/models/cow_calving.dart';
import 'package:DigitalDairy/services/cow_calving_service.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read calving, update and delete
/// calving details.
///
class CalvingController with ChangeNotifier {
  CalvingController();

  // Make CalvingService a private variable so it is not used directly.
  final CalvingService _calvingService = CalvingService();

  /// Internal, private state of the current day calving.
  final List<Calving> _calvingList = [];
  final List<Calving> _filteredCalvingList = [];

  // Allow Widgets to read the filtered calvings list.
  List<Calving> get calvingsList => _filteredCalvingList;

  void filterCalvings(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Calving> fetchedList = _calvingList
          .where((item) => item.cowName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredCalvingList.clear();
      _filteredCalvingList.addAll(fetchedList);
    } else {
      _filteredCalvingList.clear();
      _filteredCalvingList.addAll(_calvingList);
    }
    notifyListeners();
  }

  Future<void> getCalvings() async {
    List<Calving> loadedList = await _calvingService.getCalvingsList();
    _calvingList.clear();
    _filteredCalvingList.clear();
    _calvingList.addAll(loadedList);
    _filteredCalvingList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addCalving(Calving calving) async {
    //call to the service to add the item to the database
    final savedCalving = await _calvingService.addCalving(calving);
    // add the calving item to today's list of items
    if (savedCalving != null) {
      _calvingList.add(savedCalving);
      _filteredCalvingList.add(savedCalving);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editCalving(Calving calving) async {
    final savedCalving = await _calvingService.editCalving(calving);
    //remove the old calving from the list
    _filteredCalvingList.removeWhere(
        (calvingToFilter) => calvingToFilter.getId == calving.getId);
    _calvingList.removeWhere(
        (calvingToFilter) => calvingToFilter.getId == calving.getId);
    //add the updated calving to the list
    _calvingList.add(savedCalving);
    _filteredCalvingList.add(savedCalving);
    notifyListeners();
  }

  Future<void> deleteCalving(Calving calving) async {
    //call to the service to delete the item in the database
    await _calvingService.deleteCalving(calving);
    // remove the calving item to today's list of items
    _filteredCalvingList.removeWhere(
        (calvingToFilter) => calvingToFilter.getId == calving.getId);
    _calvingList.removeWhere(
        (calvingToFilter) => calvingToFilter.getId == calving.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
