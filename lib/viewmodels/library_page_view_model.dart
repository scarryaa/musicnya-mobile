import 'package:flutter/cupertino.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';

class LibraryPageViewModel extends ChangeNotifier {
  LibraryPageViewModel(this.mainVm);

  MainPageNavigationViewModel mainVm;
  int? categorySelection;
  int localSelection = 1;

  void setCategorySelection(index) {
    categorySelection = index;
    notifyListeners();
  }

  void setLocalSelection(index) {
    localSelection = index;
    notifyListeners();
  }
}
