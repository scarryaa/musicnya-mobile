import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/services/responsive_layout.dart';
import 'package:musicnya/viewmodels/appbar_navigation_view_model.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'package:provider/provider.dart';

import 'SearchBar/search_bar.dart';

class AppbarNavigation extends StatefulWidget implements PreferredSizeWidget {
  AppbarNavigation({super.key});

  @override
  State<StatefulWidget> createState() => AppbarNavigationState();

  @override
  final Size preferredSize = Size(screenWidth, 41);
}

class AppbarNavigationState extends State<AppbarNavigation>
    with TickerProviderStateMixin {
  bool triggerSearchIconAnimation = false;
  bool triggerSettingsIconAnimation = false;
  bool searchIconVisible = true;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var provider =
          Provider.of<AppbarNavigationViewModel>(context, listen: false);
      provider.searchButtonXPosition = (provider.searchButtonKey.currentContext!
              .findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero)
          .dx;

      provider.settingsButtonXPosition =
          (provider.settingsButtonKey.currentContext!.findRenderObject()
                  as RenderBox)
              .localToGlobal(Offset.zero)
              .dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppbarNavigationViewModel>(
        builder: (context, model, child) {
      model.mainVm.albumViewOpen
          ? _controller!.forward()
          : _controller!.reverse();
      return AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) => AnimatedScale(
              scale: 1,
              duration: const Duration(milliseconds: 300),
              child: AppBar(
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                titleSpacing: 0,
                bottom: PreferredSize(
                    preferredSize: const Size(0, 1),
                    child: Column(children: const [
                      Divider(height: 1, thickness: 0.5, color: Colors.black26),
                    ])),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: ChangeNotifierProvider(
                              create: (context) => model.searchBarViewModel,
                              child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Positioned(
                                        right: 50,
                                        child: AnimatedContainer(
                                            alignment: !model.searchOpen
                                                ? Alignment.centerRight
                                                : Alignment.centerRight,
                                            width: 50,
                                            transform: model.searchOpen
                                                ? Matrix4.translationValues(
                                                    -model
                                                        .searchButtonXPosition!,
                                                    0,
                                                    0)
                                                : Matrix4.identity(),
                                            duration: const Duration(
                                                milliseconds: 250),
                                            onEnd: () => setState(() {
                                                  triggerSearchIconAnimation =
                                                      !triggerSearchIconAnimation;
                                                }),
                                            curve: Curves.decelerate,
                                            child: Visibility(
                                                visible: !model.settingsOpen &&
                                                    searchIconVisible,
                                                child: IconButton(
                                                  icon: AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 150),
                                                      transitionBuilder:
                                                          (child, animation) {
                                                        return FadeTransition(
                                                            opacity: child
                                                                        .key ==
                                                                    const ValueKey(
                                                                        'searchIcon')
                                                                ? Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end: 1)
                                                                    .animate(
                                                                        animation)
                                                                : Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end: 1)
                                                                    .animate(
                                                                        animation),
                                                            child:
                                                                ScaleTransition(
                                                                    scale:
                                                                        animation,
                                                                    child:
                                                                        child));
                                                      },
                                                      child: !triggerSearchIconAnimation
                                                          ? const Icon(
                                                              Icons
                                                                  .search_rounded,
                                                              key: ValueKey(
                                                                  'searchIcon'))
                                                          : const Icon(
                                                              Icons.arrow_back,
                                                              key: ValueKey(
                                                                  'arrowIcon'))),
                                                  key: model.searchButtonKey,
                                                  onPressed: () {
                                                    var p = Provider.of<
                                                            MainPageNavigationViewModel>(
                                                        context,
                                                        listen: false);
                                                    p.toggleSearch();
                                                  },
                                                  splashRadius: 18,
                                                )))),
                                    AnimatedContainer(
                                        alignment: Alignment.centerRight,
                                        width: 50,
                                        transform: model.settingsOpen
                                            ? Matrix4.translationValues(
                                                -model.settingsButtonXPosition!,
                                                0,
                                                0)
                                            : Matrix4.identity(),
                                        duration:
                                            const Duration(milliseconds: 250),
                                        onEnd: () => setState(() {
                                              triggerSettingsIconAnimation =
                                                  !triggerSettingsIconAnimation;
                                              searchIconVisible =
                                                  !searchIconVisible;
                                            }),
                                        curve: Curves.decelerate,
                                        child: Visibility(
                                            visible: true,
                                            child: IconButton(
                                              icon: model.searchOpen
                                                  ? AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 350),
                                                      transitionBuilder:
                                                          (child, animation) {
                                                        return FadeTransition(
                                                            opacity: child
                                                                        .key ==
                                                                    const ValueKey(
                                                                        'settingsIcon')
                                                                ? Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end: 1)
                                                                    .animate(
                                                                        animation)
                                                                : Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end: 1)
                                                                    .animate(
                                                                        animation),
                                                            child:
                                                                ScaleTransition(
                                                                    scale:
                                                                        animation,
                                                                    child:
                                                                        child));
                                                      },
                                                      child: !(model
                                                                  .searchOpen ||
                                                              triggerSearchIconAnimation)
                                                          ? const Icon(
                                                              Icons.settings,
                                                              key: ValueKey(
                                                                  'settingsIcon'))
                                                          : const Icon(
                                                              Icons.close,
                                                              key: ValueKey(
                                                                  'closeIcon')))
                                                  : AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 350),
                                                      transitionBuilder:
                                                          (child, animation) {
                                                        return FadeTransition(
                                                            opacity: child
                                                                        .key ==
                                                                    const ValueKey(
                                                                        'settingsIcon')
                                                                ? Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end: 1)
                                                                    .animate(
                                                                        animation)
                                                                : Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end: 1)
                                                                    .animate(
                                                                        animation),
                                                            child:
                                                                ScaleTransition(
                                                                    scale:
                                                                        animation,
                                                                    child:
                                                                        child));
                                                      },
                                                      child: !triggerSettingsIconAnimation
                                                          ? const Icon(
                                                              Icons.settings_rounded,
                                                              key: ValueKey('settingsIcon'))
                                                          : const Icon(Icons.arrow_back_rounded, key: ValueKey('arrowIcon'))),
                                              key: model.settingsButtonKey,
                                              onPressed: () {
                                                !(model.searchOpen ||
                                                        triggerSearchIconAnimation)
                                                    ? Provider.of<
                                                                MainPageNavigationViewModel>(
                                                            context,
                                                            listen: false)
                                                        .toggleSettings()
                                                    : Provider.of<
                                                                AppbarNavigationViewModel>(
                                                            context,
                                                            listen: false)
                                                        .searchBarViewModel
                                                        .updateSearchInput('');
                                              },
                                              splashRadius: 18,
                                            ))),
                                    model.searchOpen
                                        ? Container(
                                            alignment: Alignment.centerLeft,
                                            //add padding to ensure back arrow is visible
                                            padding:
                                                const EdgeInsets.only(left: 45),
                                            child: const SearchBar())
                                        : model.settingsOpen
                                            ? Container(
                                                alignment: Alignment.centerLeft,
                                                //add padding to ensure back arrow is visible
                                                padding: const EdgeInsets.only(
                                                    left: 45),
                                                child: const Text('Settings'))
                                            : Container(
                                                alignment: Alignment.centerLeft,
                                                height: topAppBarHeightCompact,
                                                child: Visibility(
                                                  visible: !model.searchOpen,
                                                  child: TabBar(
                                                      automaticIndicatorColorAdjustment:
                                                          true,
                                                      indicatorSize:
                                                          TabBarIndicatorSize
                                                              .tab,
                                                      isScrollable: true,
                                                      indicatorWeight: 2,
                                                      labelColor: Colors.black,
                                                      tabs: [
                                                        if (!ResponsiveLayout
                                                            .isMobile(context))
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  topAppBarHeightCompact,
                                                              child: const Text(
                                                                  "Drawer")),
                                                        Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height:
                                                                topAppBarHeightCompact,
                                                            child: const Text(
                                                                "Home")),
                                                        Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height:
                                                                topAppBarHeightCompact,
                                                            child: const Text(
                                                                "Library")),
                                                        Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height:
                                                                topAppBarHeightCompact,
                                                            child: const Text(
                                                                "Browse")),
                                                        Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height:
                                                                topAppBarHeightCompact,
                                                            child: const Text(
                                                                "Radio")),
                                                      ],
                                                      controller:
                                                          model.tabController),
                                                )),
                                  ])))
                    ]),
                backgroundColor: Colors.transparent,
                toolbarHeight: topAppBarHeightCompact,
                foregroundColor: Colors.black,
                elevation: 0,
              )));
    });
  }
}
