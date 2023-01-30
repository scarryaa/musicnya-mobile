import 'package:flutter/material.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';

class SearchResultsViewModel extends ChangeNotifier {
  SearchResultsViewModel(this.mainVm) {
    searchFocusNode = mainVm.searchBarFocusNode;
  }

  MainPageNavigationViewModel mainVm;
  Future<dynamic> futureSearchResults = Future<dynamic>(() => null);
  List tmpSearchResults = List.generate(15, (i) => i);
  List tmpRecentSearches = List.generate(6, (i) => i);
  List tmpCategories = List.generate(20, (i) => i);
  String prevSearchTerms = '';
  bool searching = false;
  late FocusNode searchFocusNode;

  void toggleSearch() {
    searching = mainVm.searchOpen;
    notifyListeners();
  }
}
