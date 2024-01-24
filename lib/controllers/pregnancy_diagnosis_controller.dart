import 'package:DigitalDairy/models/cow_pregnancy_diagnosis.dart';
import 'package:DigitalDairy/services/pregnancy_diagnosis_service.dart';
import 'package:flutter/material.dart';

/// A class that many Widgets can interact with to read pregnancyDiagnosis, update and delete
/// pregnancyDiagnosis details.
///
class PregnancyDiagnosisController with ChangeNotifier {
  PregnancyDiagnosisController();

  // Make PregnancyDiagnosisService a private variable so it is not used directly.
  final PregnancyDiagnosisService _pregnancyDiagnosisService =
      PregnancyDiagnosisService();

  /// Internal, private state of the current day pregnancyDiagnosis.
  final List<PregnancyDiagnosis> _pregnancyDiagnosisList = [];
  final List<PregnancyDiagnosis> _filteredPregnancyDiagnosisList = [];

  // Allow Widgets to read the filtered pregnancyDiagnosiss list.
  List<PregnancyDiagnosis> get pregnancyDiagnosissList =>
      _filteredPregnancyDiagnosisList;

  void filterPregnancyDiagnosiss(String? query) {
    if (query != null && query.isNotEmpty) {
      List<PregnancyDiagnosis> fetchedList = _pregnancyDiagnosisList
          .where((item) => item.getCow.cowName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredPregnancyDiagnosisList.clear();
      _filteredPregnancyDiagnosisList.addAll(fetchedList);
    } else {
      _filteredPregnancyDiagnosisList.clear();
      _filteredPregnancyDiagnosisList.addAll(_pregnancyDiagnosisList);
    }
    notifyListeners();
  }

  Future<void> getPregnancyDiagnosiss() async {
    List<PregnancyDiagnosis> fetchedList =
        await _pregnancyDiagnosisService.getPregnancyDiagnosissList();
    _pregnancyDiagnosisList.clear();
    _filteredPregnancyDiagnosisList.clear();
    _pregnancyDiagnosisList.addAll(fetchedList);
    _filteredPregnancyDiagnosisList.addAll(fetchedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addPregnancyDiagnosis(
      PregnancyDiagnosis pregnancyDiagnosis) async {
    //call to the service to add the item to the database
    final savedPregnancyDiagnosis = await _pregnancyDiagnosisService
        .addPregnancyDiagnosis(pregnancyDiagnosis);
    // add the pregnancyDiagnosis item to today's list of items
    if (savedPregnancyDiagnosis != null) {
      _pregnancyDiagnosisList.add(savedPregnancyDiagnosis);
      _filteredPregnancyDiagnosisList.add(savedPregnancyDiagnosis);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editPregnancyDiagnosis(
      PregnancyDiagnosis pregnancyDiagnosis) async {
    final savedPregnancyDiagnosis = await _pregnancyDiagnosisService
        .editPregnancyDiagnosis(pregnancyDiagnosis);
    //remove the old pregnancyDiagnosis from the list
    _filteredPregnancyDiagnosisList.removeWhere((pregnancyDiagnosisToFilter) =>
        pregnancyDiagnosisToFilter.getId == pregnancyDiagnosis.getId);
    _pregnancyDiagnosisList.removeWhere((pregnancyDiagnosisToFilter) =>
        pregnancyDiagnosisToFilter.getId == pregnancyDiagnosis.getId);
    //add the updated pregnancyDiagnosis to the list
    _pregnancyDiagnosisList.add(savedPregnancyDiagnosis);
    _filteredPregnancyDiagnosisList.add(savedPregnancyDiagnosis);
    notifyListeners();
  }

  Future<void> deletePregnancyDiagnosis(
      PregnancyDiagnosis pregnancyDiagnosis) async {
    //call to the service to delete the item in the database
    await _pregnancyDiagnosisService
        .deletePregnancyDiagnosis(pregnancyDiagnosis);
    // remove the pregnancyDiagnosis item to today's list of items
    _filteredPregnancyDiagnosisList.removeWhere((pregnancyDiagnosisToFilter) =>
        pregnancyDiagnosisToFilter.getId == pregnancyDiagnosis.getId);
    _pregnancyDiagnosisList.removeWhere((pregnancyDiagnosisToFilter) =>
        pregnancyDiagnosisToFilter.getId == pregnancyDiagnosis.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
