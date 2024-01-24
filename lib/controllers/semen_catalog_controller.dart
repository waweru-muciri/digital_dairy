import 'package:flutter/material.dart';
import 'package:DigitalDairy/services/semen_catalog_service.dart';
import 'package:DigitalDairy/models/semen_catalog.dart';

class SemenCatalogController with ChangeNotifier {
  SemenCatalogController();

  // Make SemenCatalogService a private variable so it is not used directly.
  final SemenCatalogService _semenCatalogService = SemenCatalogService();

  /// Internal, private state of the current day semenCatalog.
  final List<SemenCatalog> _semenCatalogList = [];
  final List<SemenCatalog> _filteredSemenCatalogList = [];

  // Allow Widgets to read the filtered semenCatalogs list.
  List<SemenCatalog> get semenCatalogsList => _filteredSemenCatalogList;

  void filterSemenCatalogs(String? query) {
    if (query != null && query.isNotEmpty) {
      List<SemenCatalog> fetchedList = _semenCatalogList
          .where((item) => item.getBullName
              .trim()
              .toLowerCase()
              .contains(query.trim().toLowerCase()))
          .toList();
      _filteredSemenCatalogList.clear();
      _filteredSemenCatalogList.addAll(fetchedList);
    } else {
      _filteredSemenCatalogList.clear();
      _filteredSemenCatalogList.addAll(_semenCatalogList);
    }
    notifyListeners();
  }

  Future<void> getSemenCatalogs() async {
    List<SemenCatalog> fetchedList =
        await _semenCatalogService.getSemenCatalogsList();
    _semenCatalogList.clear();
    _filteredSemenCatalogList.clear();
    _semenCatalogList.addAll(fetchedList);
    _filteredSemenCatalogList.addAll(fetchedList);
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> addSemenCatalog(SemenCatalog semenCatalog) async {
    //call to the service to add the item to the database
    final savedSemenCatalog =
        await _semenCatalogService.addSemenCatalog(semenCatalog);
    // add the semenCatalog item to today's list of items
    if (savedSemenCatalog != null) {
      _semenCatalogList.add(savedSemenCatalog);
      _filteredSemenCatalogList.add(savedSemenCatalog);
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<void> editSemenCatalog(SemenCatalog semenCatalog) async {
    final savedSemenCatalog =
        await _semenCatalogService.editSemenCatalog(semenCatalog);
    //remove the old semenCatalog from the list
    _filteredSemenCatalogList.removeWhere((semenCatalogToFilter) =>
        semenCatalogToFilter.getId == semenCatalog.getId);
    _semenCatalogList.removeWhere((semenCatalogToFilter) =>
        semenCatalogToFilter.getId == semenCatalog.getId);
    //add the updated semenCatalog to the list
    _semenCatalogList.add(savedSemenCatalog);
    _filteredSemenCatalogList.add(savedSemenCatalog);
    notifyListeners();
  }

  Future<void> deleteSemenCatalog(SemenCatalog semenCatalog) async {
    //call to the service to delete the item in the database
    await _semenCatalogService.deleteSemenCatalog(semenCatalog);
    // remove the semenCatalog item to today's list of items
    _filteredSemenCatalogList.removeWhere((semenCatalogToFilter) =>
        semenCatalogToFilter.getId == semenCatalog.getId);
    _semenCatalogList.removeWhere((semenCatalogToFilter) =>
        semenCatalogToFilter.getId == semenCatalog.getId);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
