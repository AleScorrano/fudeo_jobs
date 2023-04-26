import 'package:annunci_lavoro_flutter/extension/first_where_or_null.dart';
import 'package:annunci_lavoro_flutter/models/freelance_positions_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

//*****************************************************************************
//* classe che si occupa di gestire lo stream della lista con tutti i metodi
//* per la ricerca l'ordinamento e i filtri,gestisce anche la lista dei preferiti
//*****************************************************************************

class FreeLanceAdsController {
  final BehaviorSubject<List<FreeLancePosition>> _listController =
      BehaviorSubject<List<FreeLancePosition>>.seeded([]);

  final BehaviorSubject<List<FreeLancePosition>> _favoriteListController =
      BehaviorSubject<List<FreeLancePosition>>.seeded([]);

  List<FreeLancePosition> adsList;
  List<NDA> ndaFilters;
  List<Relationship> relationshipFilter;
  TextEditingController searchController;
  late List<FreeLancePosition> favouriteList;
  late ValueNotifier<bool> isNdafiltersEmpty;
  late ValueNotifier<bool> isRelationshipFiltersEmpty;
  FreeLanceAdsController(this.adsList)
      : searchController = TextEditingController(),
        ndaFilters = [],
        relationshipFilter = [] {
    isNdafiltersEmpty = ValueNotifier(ndaFilters.isEmpty);
    isRelationshipFiltersEmpty = ValueNotifier(relationshipFilter.isEmpty);
    favouriteList = adsList.where((ads) => ads.isFavourite).toList();
    searchController.addListener(
      () {
        if (searchController.text.isNotEmpty) {
          searchResults();
        }
      },
    );
  }
  void addToFavorite(String id) {
    final selectedAd =
        _listController.value.firstWhere((ad) => ad.metaData.id == id);
    favouriteList.add(selectedAd);
    _favoriteListController.add(favouriteList);
    selectedAd.isFavourite = true;
    if (searchController.text.isEmpty) {
      applyFilters();
    }
  }

  void removeFromFavorite(String id) {
//* controllo se l'oggetto è già in memoria quindi nella lista principale
    FreeLancePosition? selectedAd = _listController.value.firstWhereOrNull(
      (ad) => ad.metaData.id == id,
    );
    //* altrimenti lo cerco nella lista dei favoriti e poi lo elimino.
    if (selectedAd == null) {
      selectedAd = _favoriteListController.value.firstWhere(
        (ad) => ad.metaData.id == id,
      );
      favouriteList.remove(selectedAd);
      _favoriteListController.add(favouriteList);
    } else {
      favouriteList.remove(selectedAd);
      _favoriteListController.add(favouriteList);
    }

    if (searchController.text.isEmpty) {
      applyFilters();
    }
  }

//* metodo per aggiornare la lista dei favoriti con gli eventuali annunci restituiti
//* dal repository , che non sono ancora presenti in memoria.
  void updateFovorites(List<FreeLancePosition> newList) {
    favouriteList = newList;
    _favoriteListController.add(favouriteList);
  }

//* metodo richiamato quando l'utente chiude il textfield della ricerca.
  void stopSearch() {
    _listController.add(adsList);
    applyFilters();
  }

  void searchResults() {
    List<FreeLancePosition> searchingResults =
        adsList.where((freelanceposition) {
      return freelanceposition.adsTitle
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          freelanceposition.jobRequest.descriptionText
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          freelanceposition.budget.descriptionText
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          freelanceposition.workTiming.descriptionText
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          freelanceposition.adsDescription.descriptionText
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
    }).toList();
    _listController.add(searchingResults);
  }

  void addItems(List<FreeLancePosition> ads) {
    adsList.addAll(ads);
    applyFilters();
  }

  void addNdaFilter(NDA filter) {
    ndaFilters.add(filter);
    isNdafiltersEmpty.value = ndaFilters.isEmpty;
    applyFilters();
  }

  void removeNdaFilter(NDA filter) {
    ndaFilters.remove(filter);
    isNdafiltersEmpty.value = ndaFilters.isEmpty;
    applyFilters();
  }

  void addRelationshipFilter(Relationship filter) {
    relationshipFilter.add(filter);
    isRelationshipFiltersEmpty.value = relationshipFilter.isEmpty;
    applyFilters();
  }

  void removeRelationshipFilter(Relationship filter) {
    relationshipFilter.remove(filter);
    isRelationshipFiltersEmpty.value = relationshipFilter.isEmpty;
    applyFilters();
  }

  void applyFilters() {
    final filteredList = adsList.where(
      (jobPosition) {
        bool ndaFilter =
            ndaFilters.isEmpty || ndaFilters.contains(jobPosition.nda);
        bool relationshipfilter = relationshipFilter.isEmpty ||
            relationshipFilter.contains(jobPosition.realtionship);

        return ndaFilter && relationshipfilter;
      },
    ).toList();
    _listController.add(filteredList);
  }

  void resetFilter() {
    ndaFilters.clear();
    relationshipFilter.clear();
    isNdafiltersEmpty.value = ndaFilters.isEmpty;
    isRelationshipFiltersEmpty.value = relationshipFilter.isEmpty;
    applyFilters();
  }

  Stream<List<FreeLancePosition>> get stream => _listController.stream;

  Stream<List<FreeLancePosition>> get favstream =>
      _favoriteListController.stream;

  void dispose() {
    _listController.close();
  }
}
