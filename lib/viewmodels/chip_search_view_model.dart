import 'package:flutter/material.dart';
import 'package:musicnya/models/abstract_chip_model.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';

class ChipSearchViewModel extends ChangeNotifier implements AbstractChipModel {
  ChipSearchViewModel(this.mainVm);

  MainPageNavigationViewModel mainVm;

  @override
  int? categorySelection;

  @override
  int localSelection = 1;

  @override
  void clearCategorySelection() {
    categorySelection = null;
    notifyListeners();
  }

  @override
  void setCategorySelection(index) {
    categorySelection = index;
    notifyListeners();
    mainVm.appbarNavigationViewModel.searchBarViewModel
        .setCategorySelection(index);
  }

  @override
  void setLocalSelection(index) {
    localSelection = index;
    notifyListeners();
    mainVm.appbarNavigationViewModel.searchBarViewModel
        .setLocalSelection(index);
  }
}
