import 'package:flutter/material.dart';
import 'package:musicnya/models/abstract_chip_model.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';

class ChipLibraryViewModel extends ChangeNotifier implements AbstractChipModel {
  ChipLibraryViewModel(this.mainVm);

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
    mainVm.pageBodyViewModel.libraryPageViewModel!.setCategorySelection(index);
  }

  @override
  void setLocalSelection(index) {
    localSelection = index;
    notifyListeners();
    mainVm.pageBodyViewModel.libraryPageViewModel!.setLocalSelection(index);
  }
}
