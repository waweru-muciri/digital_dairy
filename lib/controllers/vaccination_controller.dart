import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/vaccination_service.dart';
import 'package:DigitalDairy/models/vaccination.dart';

/// A class that many Widgets can interact with to read vaccination, update and delete
/// vaccination details.
///
class VaccinationController with ChangeNotifier {
  VaccinationController();

  // Make VaccinationService a private variable so it is not used directly.
  final VaccinationService _vaccinationService = VaccinationService();

  /// Internal, private state of the current day vaccination.
  final List<Vaccination> _vaccinationList = [];
  final List<Vaccination> _filteredVaccinationList = [];

  // Allow Widgets to read the filtered vaccinations list.
  List<Vaccination> get vaccinationsList => _filteredVaccinationList;

  void filterVaccinations(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Vaccination> fetchedList = _vaccinationList
          .where((item) => item.getVaccination
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredVaccinationList.clear();
      _filteredVaccinationList.addAll(fetchedList);
    } else {
      _filteredVaccinationList.clear();
      _filteredVaccinationList.addAll(_vaccinationList);
    }
    notifyListeners();
  }

  Future<void> getVaccinations() async {
    List<Vaccination> loadedList =
        await _vaccinationService.getVaccinationsList();
    _vaccinationList.clear();
    _filteredVaccinationList.clear();
    _vaccinationList.addAll(loadedList);
    _filteredVaccinationList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addVaccination(Vaccination vaccination) async {
    //call to the service to add the item to the database
    final savedVaccination =
        await _vaccinationService.addVaccination(vaccination);
    // add the vaccination item to today's list of items
    if (savedVaccination != null) {
      _vaccinationList.add(savedVaccination);
      _filteredVaccinationList.add(savedVaccination);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editVaccination(Vaccination vaccination) async {
    final savedVaccination =
        await _vaccinationService.editVaccination(vaccination);
    //remove the old vaccination from the list
    _filteredVaccinationList.removeWhere((vaccinationToFilter) =>
        vaccinationToFilter.getId == vaccination.getId);
    _vaccinationList.removeWhere((vaccinationToFilter) =>
        vaccinationToFilter.getId == vaccination.getId);
    //add the updated vaccination to the list
    _vaccinationList.add(savedVaccination);
    _filteredVaccinationList.add(savedVaccination);
    notifyListeners();
  }

  Future<void> deleteVaccination(Vaccination vaccination) async {
    //call to the service to delete the item in the database
    await _vaccinationService.deleteVaccination(vaccination);
    // remove the vaccination item to today's list of items
    _filteredVaccinationList.removeWhere((vaccinationToFilter) =>
        vaccinationToFilter.getId == vaccination.getId);
    _vaccinationList.removeWhere((vaccinationToFilter) =>
        vaccinationToFilter.getId == vaccination.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
