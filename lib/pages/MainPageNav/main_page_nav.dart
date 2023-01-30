import 'package:flutter/material.dart';
import 'package:musicnya/assets/ui_components/chip_row.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/pages/MainPageNav/Components/AlbumDetails/album_details.dart';
import 'package:musicnya/pages/MainPageNav/Components/PlaylistDetails/playlist_details.dart';
import 'package:musicnya/pages/MainPageNav/Components/appbar_navigation.dart';
import 'package:musicnya/pages/MainPageNav/Components/page_body.dart';
import 'package:musicnya/pages/MainPageNav/Components/appbar_player.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/navigation_service.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import '../PlayerView/player_view.dart';

class MainPageNav extends StatefulWidget {
  const MainPageNav({super.key});

  @override
  State<StatefulWidget> createState() => MainPageNavState();
}

class MainPageNavState extends State<MainPageNav>
    with TickerProviderStateMixin {
  bool searchActive = false;
  bool settingsOpen = false;
  GlobalKey searchButton = GlobalKey();
  GlobalKey settingsButton = GlobalKey();
  double searchButtonXPosition = 0;
  double settingsButtonXPosition = 0;
  bool triggerAnimation = false;
  late ChipRow chips;

  @override
  void initState() {
    Provider.of<MainPageNavigationViewModel>(context, listen: false)
        .updateStatusBarHeight(
            MediaQueryData.fromView(WidgetsBinding.instance.window)
                .viewPadding
                .top);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    TabController tabController = TabController(length: 4, vsync: this);
    MainPageNavigationViewModel p =
        Provider.of<MainPageNavigationViewModel>(context, listen: false);
    p.tabController = tabController;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainPageNavigationViewModel>(
        builder: (context, model, child) {
      return WillPopScope(
          onWillPop: () async {
            if (model.settingsOpen) {
              setState(() => model.settingsOpen = false);
              return false;
            } else if (model.searchOpen) {
              setState(() => model.searchOpen = false);
              return false;
            } else if (model.albumViewOpen) {
              serviceLocator<NavigationService>().toggleAlbumView(context);
              return false;
            }
            return true;
          },
          child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) =>
                      model.pageBodyViewModel.albumDetailsViewModel,
                ),
                ChangeNotifierProvider(
                    create: (context) => model.appbarNavigationViewModel),
                ChangeNotifierProvider(
                    create: (context) => model.pageBodyViewModel),
              ],
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  bottomSheet: Visibility(
                      visible: MediaQuery.of(context).viewInsets.bottom > 75
                          ? false
                          : true,
                      child: Stack(children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => showPlayerModal(context),
                            child: const AppbarPlayer())
                      ])),
                  body: AnimatedSwitcher(
                    transitionBuilder: (child, animation) => FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                                parent: animation,
                                curve: Curves.fastLinearToSlowEaseIn)),
                        child: child),
                    duration: const Duration(milliseconds: 300),
                    child: model.albumViewOpen
                        ? AlbumDetails(
                            arguments: model
                                .pageBodyViewModel.homeViewModel!.albumInfo)
                        : model.playlistViewOpen
                            ? PlaylistDetails(
                                arguments: model.pageBodyViewModel
                                    .homeViewModel!.playlistInfo)
                            : Scaffold(
                                extendBody: true,
                                resizeToAvoidBottomInset: true,
                                appBar: AppbarNavigation(),
                                body: const PageBody(),
                              ),
                  ))));
    });
  }

  showPlayerModal(BuildContext context) {
    showSlidingBottomSheet(
      context,
      builder: (context) => SlidingSheetDialog(
          color: Colors.transparent,
          dismissOnBackdropTap: false,
          cornerRadius: 5,
          cornerRadiusOnFullscreen: 0,
          duration: const Duration(milliseconds: 250),
          snapSpec: const SnapSpec(snappings: [1.0]),
          builder: (context, state) =>
              SizedBox(height: screenHeight, child: const PlayerView())),
    );
  }
}
