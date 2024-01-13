import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/disease_service.dart';
import 'package:DigitalDairy/models/disease.dart';

/// A class that many Widgets can interact with to read disease, update and delete
/// disease details.
///
class DiseaseController with ChangeNotifier {
  DiseaseController();

  // Make DiseaseService a private variable so it is not used directly.
  final DiseaseService _diseaseService = DiseaseService();

  /// Internal, private state of the current day disease.
  final List<Disease> _diseaseList = [];
  final List<Disease> _filteredDiseaseList = [];

  // Allow Widgets to read the filtered diseases list.
  List<Disease> get diseasesList => _filteredDiseaseList;

  void filterDiseases(String? query) {
    if (query != null && query.isNotEmpty) {
      List<Disease> fetchedList = _diseaseList
          .where((item) => item.getName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredDiseaseList.clear();
      _filteredDiseaseList.addAll(fetchedList);
    } else {
      _filteredDiseaseList.clear();
      _filteredDiseaseList.addAll(_diseaseList);
    }
    notifyListeners();
  }

  Future<void> getDiseases() async {
    List<Disease> loadedList = await _diseaseService.getDiseasesList();
    _diseaseList.clear();
    _filteredDiseaseList.clear();
    _diseaseList.addAll(loadedList);
    _filteredDiseaseList.addAll(loadedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addDisease(Disease disease) async {
    //call to the service to add the item to the database
    final savedDisease = await _diseaseService.addDisease(disease);
    // add the disease item to today's list of items
    if (savedDisease != null) {
      _diseaseList.add(savedDisease);
      _filteredDiseaseList.add(savedDisease);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editDisease(Disease disease) async {
    final savedDisease = await _diseaseService.editDisease(disease);
    //remove the old disease from the list
    _filteredDiseaseList.removeWhere(
        (diseaseToFilter) => diseaseToFilter.getId == disease.getId);
    _diseaseList.removeWhere(
        (diseaseToFilter) => diseaseToFilter.getId == disease.getId);
    //add the updated disease to the list
    _diseaseList.add(savedDisease);
    _filteredDiseaseList.add(savedDisease);
    notifyListeners();
  }

  Future<void> deleteDisease(Disease disease) async {
    //call to the service to delete the item in the database
    await _diseaseService.deleteDisease(disease);
    // remove the disease item to today's list of items
    _filteredDiseaseList.removeWhere(
        (diseaseToFilter) => diseaseToFilter.getId == disease.getId);
    _diseaseList.removeWhere(
        (diseaseToFilter) => diseaseToFilter.getId == disease.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
