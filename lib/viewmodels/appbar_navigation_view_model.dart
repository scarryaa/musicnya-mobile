import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'package:musicnya/viewmodels/search_bar_view_model.dart';

class AppbarNavigationViewModel extends ChangeNotifier {
  AppbarNavigationViewModel(this.mainVm) {
    searchBarViewModel = SearchBarViewModel(mainVm);
  }

  late SearchBarViewModel searchBarViewModel;
  MainPageNavigationViewModel mainVm;
  bool searchOpen = false;
  bool settingsOpen = false;
  String searchInput = '';
  double? searchButtonXPosition;
  double? settingsButtonXPosition;
  double height = 41;
  FocusNode? searchFocusNode;
  Size preferredSize = Size(screenWidth, 41);
  get tabController => mainVm.tabController;
  GlobalKey searchButtonKey = GlobalKey();
  GlobalKey settingsButtonKey = GlobalKey();

  void adjustHeight() {
    preferredSize = (preferredSize == const Size(0, 0))
        ? Size(screenWidth, height)
        : const Size(0, 0);
    notifyListeners();
  }

  void adjustHeightIfSearching() {
    preferredSize = mainVm.searchInput == ''
        ? Size(screenWidth, height)
        : Size(screenWidth, height + 50);
    notifyListeners();
  }

  void updateSearchInput() {
    searchInput = mainVm.searchInput;
    notifyListeners();
  }

  void toggleSearch() {
    searchOpen = mainVm.searchOpen;
    notifyListeners();
  }

  void toggleSettings() {
    settingsOpen = mainVm.settingsOpen;
    notifyListeners();
  }
}
