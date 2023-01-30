import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'package:provider/provider.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final locator = GetIt.instance;

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  toggleAlbumView(BuildContext context, {Object? arguments}) {
    MainPageNavigationViewModel p =
        Provider.of<MainPageNavigationViewModel>(context, listen: false);
    if (!p.albumViewOpen) {
      p.pageBodyViewModel.albumDetailsViewModel!.setIndicatorOffset();
    }
    p.setAlbum(arguments: arguments);
    p.toggleAlbumView();
  }

  togglePlaylistView(BuildContext context, {Object? arguments}) {
    MainPageNavigationViewModel p =
        Provider.of<MainPageNavigationViewModel>(context, listen: false);
    p.setPlaylist(arguments: arguments);
    p.togglePlaylistView();
  }
}
