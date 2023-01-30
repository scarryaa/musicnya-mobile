import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';

class AlbumDetailsViewModel extends ChangeNotifier {
  AlbumDetailsViewModel(this.mainVm);

  MainPageNavigationViewModel mainVm;
  double statusBarHeight = 0;
  Offset indicatorOffset = Offset.zero;

  Offset getIndicatorOffset(Offset offset) {
    const double x = 0;
    final double y = ((300 + statusBarHeight - offset.dy))
        .clamp(statusBarHeight - 15, screenHeight);
    return Offset(x, y);
  }

  void updateIndicator(Notification notif) {
    if (notif is ScrollNotification) {
      indicatorOffset = getIndicatorOffset(Offset(0, notif.metrics.pixels));
    }
    notifyListeners();
  }

  void setIndicatorOffset() {
    indicatorOffset = getIndicatorOffset(Offset.zero);
    notifyListeners();
  }
}
