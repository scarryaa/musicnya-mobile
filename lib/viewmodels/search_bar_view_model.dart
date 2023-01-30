import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';

class SearchBarViewModel extends ChangeNotifier {
  SearchBarViewModel(this.mainVm) {
    mainVm = mainVm;
    searchBarFocusNode = mainVm.searchBarFocusNode;
  }

  MainPageNavigationViewModel mainVm;
  TextEditingController textEditingController = TextEditingController();
  String searchInput = '';
  int? categorySelection;
  FocusNode? searchBarFocusNode;
  int localSelection = 1;
  String prevSearchInput = '';
  bool searching = false;
  int? prevSearchCategory;
  int prevLocalSearch = 1;
  Timer? debounce;
  Future<dynamic> futureSearchResults = Future<dynamic>(() => null);
  List tmpSearchResults = List.generate(15, (i) => i);
  List tmpRecentSearches = List.generate(6, (i) => i);
  List tmpCategories = List.generate(20, (i) => i);

  void setCategorySelection(index) {
    categorySelection = index;
    notifyListeners();
    search();
  }

  void setLocalSelection(index) {
    localSelection = index;
    notifyListeners();
    search();
  }

  void toggleSearch() {
    searching = mainVm.searchOpen;
    notifyListeners();
  }

  void updateSearchInput(value) {
    searchInput = value;
    mainVm.updateSearchInput(value);
    notifyListeners();
  }

  void search() {
    // If the previous search criteria is defined and the same as the last search, do nothing
    if (prevSearchInput.isNotEmpty) {
      if (prevSearchInput == searchInput &&
          prevSearchCategory == categorySelection &&
          prevLocalSearch == localSelection) return;
    }

    // Otherwise, update to the new values
    prevSearchInput = searchInput;
    prevSearchCategory = categorySelection;
    prevLocalSearch = localSelection;

    if (debounce?.isActive ?? false) debounce?.cancel();

    mainVm.updateSearchResults(Future<dynamic>(() => null));
    debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchInput.isNotEmpty) {
        futureSearchResults = MusicPlayer()
            .search(searchInput, categorySelection, localSelection);
      }
      mainVm.updateSearchResults(futureSearchResults);
    });
  }
}
