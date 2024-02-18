import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/treatment_service.dart';
import 'package:DigitalDairy/models/treatment.dart';

/// A class that many Widgets can interact with to read treatment, update and delete
/// treatment details.
///
class TreatmentController with ChangeNotifier {
  TreatmentController();

  // Make TreatmentService a private variable so it is not used directly.
  final TreatmentService _treatmentService = TreatmentService();

  /// Internal, private state of the current day treatment.
  final List<Treatment> _treatmentList = [];
  final List<Treatment> _filteredTreatmentList = [];

  // Allow Widgets to read the filtered treatments list.
  List<Treatment> get treatmentsList => _filteredTreatmentList;

  void filterTreatmentsByQueryString(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Treatment> fetchedList = _treatmentList
          .where((item) => item.getTreatment
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredTreatmentList.clear();
      _filteredTreatmentList.addAll(fetchedList);
    } else {
      _filteredTreatmentList.clear();
      _filteredTreatmentList.addAll(_treatmentList);
    }
    notifyListeners();
  }

  Future<void> filterTreatmentsByDate(String startDate,
      {String? endDate}) async {
    List<Treatment> fetchedList = await _treatmentService
        .getTreatmentsListBetweenDates(startDate, endDate: endDate);
    _treatmentList.clear();
    _filteredTreatmentList.clear();
    _treatmentList.addAll(fetchedList);
    _filteredTreatmentList.addAll(fetchedList);
    notifyListeners();
  }

  Future<void> addTreatment(Treatment treatment) async {
    //call to the service to add the item to the database
    final savedTreatment = await _treatmentService.addTreatment(treatment);
    // add the treatment item to today's list of items
    if (savedTreatment != null) {
      _treatmentList.add(savedTreatment);
      _filteredTreatmentList.add(savedTreatment);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editTreatment(Treatment treatment) async {
    final savedTreatment = await _treatmentService.editTreatment(treatment);
    //remove the old treatment from the list
    _filteredTreatmentList.removeWhere(
        (treatmentToFilter) => treatmentToFilter.getId == treatment.getId);
    _treatmentList.removeWhere(
        (treatmentToFilter) => treatmentToFilter.getId == treatment.getId);
    //add the updated treatment to the list
    _treatmentList.add(savedTreatment);
    _filteredTreatmentList.add(savedTreatment);
    notifyListeners();
  }

  Future<void> deleteTreatment(Treatment treatment) async {
    //call to the service to delete the item in the database
    await _treatmentService.deleteTreatment(treatment);
    // remove the treatment item to today's list of items
    _filteredTreatmentList.removeWhere(
        (treatmentToFilter) => treatmentToFilter.getId == treatment.getId);
    _treatmentList.removeWhere(
        (treatmentToFilter) => treatmentToFilter.getId == treatment.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
