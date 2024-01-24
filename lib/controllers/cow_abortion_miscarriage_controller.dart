import 'package:DigitalDairy/models/cow_abortion_miscarriage.dart';
import 'package:DigitalDairy/services/cow_abortion_miscarriage_service.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read abortionMiscarriage, update and delete
/// abortionMiscarriage details.
///
class AbortionMiscarriageController with ChangeNotifier {
  AbortionMiscarriageController();

  // Make AbortionMiscarriageService a private variable so it is not used directly.
  final AbortionMiscarriageService _abortionMiscarriageService =
      AbortionMiscarriageService();

  /// Internal, private state of the current day abortionMiscarriage.
  final List<AbortionMiscarriage> _abortionMiscarriageList = [];
  final List<AbortionMiscarriage> _filteredAbortionMiscarriageList = [];

  // Allow Widgets to read the filtered abortionMiscarriages list.
  List<AbortionMiscarriage> get abortionMiscarriagesList =>
      _filteredAbortionMiscarriageList;

  void filterAbortionMiscarriages(String? query) {
    if (query != null && query.isNotEmpty) {
      List<AbortionMiscarriage> fetchedList = _abortionMiscarriageList
          .where((item) => item.getCow.cowName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredAbortionMiscarriageList.clear();
      _filteredAbortionMiscarriageList.addAll(fetchedList);
    } else {
      _filteredAbortionMiscarriageList.clear();
      _filteredAbortionMiscarriageList.addAll(_abortionMiscarriageList);
    }
    notifyListeners();
  }

  Future<void> getAbortionMiscarriages() async {
    List<AbortionMiscarriage> fetchedList =
        await _abortionMiscarriageService.getAbortionMiscarriagesList();
    _abortionMiscarriageList.clear();
    _filteredAbortionMiscarriageList.clear();
    _abortionMiscarriageList.addAll(fetchedList);
    _filteredAbortionMiscarriageList.addAll(fetchedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addAbortionMiscarriage(
      AbortionMiscarriage abortionMiscarriage) async {
    //call to the service to add the item to the database
    final savedAbortionMiscarriage = await _abortionMiscarriageService
        .addAbortionMiscarriage(abortionMiscarriage);
    // add the abortionMiscarriage item to today's list of items
    if (savedAbortionMiscarriage != null) {
      _abortionMiscarriageList.add(savedAbortionMiscarriage);
      _filteredAbortionMiscarriageList.add(savedAbortionMiscarriage);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editAbortionMiscarriage(
      AbortionMiscarriage abortionMiscarriage) async {
    final savedAbortionMiscarriage = await _abortionMiscarriageService
        .editAbortionMiscarriage(abortionMiscarriage);
    //remove the old abortionMiscarriage from the list
    _filteredAbortionMiscarriageList.removeWhere(
        (abortionMiscarriageToFilter) =>
            abortionMiscarriageToFilter.getId == abortionMiscarriage.getId);
    _abortionMiscarriageList.removeWhere((abortionMiscarriageToFilter) =>
        abortionMiscarriageToFilter.getId == abortionMiscarriage.getId);
    //add the updated abortionMiscarriage to the list
    _abortionMiscarriageList.add(savedAbortionMiscarriage);
    _filteredAbortionMiscarriageList.add(savedAbortionMiscarriage);
    notifyListeners();
  }

  Future<void> deleteAbortionMiscarriage(
      AbortionMiscarriage abortionMiscarriage) async {
    //call to the service to delete the item in the database
    await _abortionMiscarriageService
        .deleteAbortionMiscarriage(abortionMiscarriage);
    // remove the abortionMiscarriage item to today's list of items
    _filteredAbortionMiscarriageList.removeWhere(
        (abortionMiscarriageToFilter) =>
            abortionMiscarriageToFilter.getId == abortionMiscarriage.getId);
    _abortionMiscarriageList.removeWhere((abortionMiscarriageToFilter) =>
        abortionMiscarriageToFilter.getId == abortionMiscarriage.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
