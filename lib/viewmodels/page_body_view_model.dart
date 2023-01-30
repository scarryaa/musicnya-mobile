import 'package:flutter/material.dart';
import 'package:musicnya/viewmodels/album_details_view_model.dart';
import 'package:musicnya/viewmodels/chip_library_view_model.dart';
import 'package:musicnya/viewmodels/chip_search_view_model.dart';
import 'package:musicnya/viewmodels/home_view_model.dart';
import 'package:musicnya/viewmodels/library_page_view_model.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'package:musicnya/viewmodels/search_results_view_model.dart';

class PageBodyViewModel extends ChangeNotifier {
  PageBodyViewModel(this.mainVm) {
    searchResultsViewModel = SearchResultsViewModel(mainVm);
    chipSearchViewModel = ChipSearchViewModel(mainVm);
    libraryPageViewModel = LibraryPageViewModel(mainVm);
    chipLibraryViewModel = ChipLibraryViewModel(mainVm);
    homeViewModel = HomeViewModel(mainVm);
    albumDetailsViewModel = AlbumDetailsViewModel(mainVm);
  }

  MainPageNavigationViewModel mainVm;
  Future<dynamic> futureSearchResults = Future<dynamic>(() => null);
  late double searchButtonXPos;
  late double settingsButtonXPos;
  bool searchOpen = false;
  bool settingsOpen = false;
  get tabController => mainVm.tabController;
  int currentIndex = 0;
  String searchInput = '';
  int? categorySelection;
  int localSelection = 1;
  late SearchResultsViewModel searchResultsViewModel;
  ChipSearchViewModel? chipSearchViewModel;
  LibraryPageViewModel? libraryPageViewModel;
  ChipLibraryViewModel? chipLibraryViewModel;
  HomeViewModel? homeViewModel;
  AlbumDetailsViewModel? albumDetailsViewModel;

  void setCurrentTabIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void updateSearchResults() {
    searchResultsViewModel.futureSearchResults = mainVm.futureSearchResults;
    notifyListeners();
  }

  void updateSearchInput() {
    searchInput = mainVm.searchInput;
    notifyListeners();
  }

  void setAlbum({Object? arguments}) {
    homeViewModel!.setAlbum(arguments: arguments);
  }

  void setPlaylist({Object? arguments}) {
    homeViewModel!.setPlaylist(arguments: arguments);
  }

  void toggleSearch() {
    searchOpen = mainVm.searchOpen;
    notifyListeners();
    searchResultsViewModel.toggleSearch();
  }

  void toggleSettings() {
    settingsOpen = mainVm.settingsOpen;
    notifyListeners();
  }
}
