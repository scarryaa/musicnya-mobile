import 'package:flutter/material.dart';
import 'package:musicnya/viewmodels/appbar_navigation_view_model.dart';
import 'package:musicnya/viewmodels/page_body_view_model.dart';

class MainPageNavigationViewModel extends ChangeNotifier {
  late AppbarNavigationViewModel appbarNavigationViewModel;
  late PageBodyViewModel pageBodyViewModel;
  late TabController tabController;

  MainPageNavigationViewModel() {
    appbarNavigationViewModel = AppbarNavigationViewModel(this);
    pageBodyViewModel = PageBodyViewModel(this);
  }

  double? statusBarHeight;
  FocusNode searchBarFocusNode = FocusNode();
  bool searchOpen = false;
  bool settingsOpen = false;
  bool albumViewOpen = false;
  bool playlistViewOpen = false;
  String searchInput = '';
  Future<dynamic> futureSearchResults = Future<dynamic>(() => null);

  void updateStatusBarHeight(double value) {
    statusBarHeight = value;
    pageBodyViewModel.albumDetailsViewModel!.statusBarHeight = value;
    pageBodyViewModel.albumDetailsViewModel!.setIndicatorOffset();
  }

  void updateSearchResults(Future<dynamic> searchResults) {
    futureSearchResults = searchResults;
    pageBodyViewModel.updateSearchResults();
  }

  void updateSearchInput(String value) {
    searchInput = value;
    appbarNavigationViewModel.updateSearchInput();
    pageBodyViewModel.updateSearchInput();
    appbarNavigationViewModel.adjustHeightIfSearching();
  }

  void setAlbum({Object? arguments}) {
    pageBodyViewModel.setAlbum(arguments: arguments);
  }

  void toggleAlbumView() {
    albumViewOpen = !albumViewOpen;
    notifyListeners();
  }

  void setPlaylist({Object? arguments}) {
    pageBodyViewModel.setPlaylist(arguments: arguments);
  }

  void togglePlaylistView() {
    playlistViewOpen = !playlistViewOpen;
    notifyListeners();
  }

  void toggleSearch() {
    searchOpen = !searchOpen;
    appbarNavigationViewModel.toggleSearch();
    pageBodyViewModel.toggleSearch();
  }

  void toggleSettings() {
    settingsOpen = !settingsOpen;
    appbarNavigationViewModel.toggleSettings();
    pageBodyViewModel.toggleSettings();
  }
}
