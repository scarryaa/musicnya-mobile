import 'package:flutter/material.dart';
import 'package:musicnya/assets/ui_components/chip_row.dart';
import 'package:musicnya/enums/category_filter.dart';
import 'package:musicnya/enums/local_filter.dart';
import 'package:musicnya/viewmodels/chip_search_view_model.dart';
import 'package:musicnya/viewmodels/page_body_view_model.dart';
import 'package:provider/provider.dart';

import '../../../services/responsive_layout.dart';
import '../../RadioView/radio_page.dart';
import '../../LibraryView/library_view.dart';
import 'Home/home_view.dart';
import 'SearchBar/search_results_view.dart';
import 'Settings/settings_view.dart';

class PageBody extends StatefulWidget {
  const PageBody({super.key});

  @override
  State<StatefulWidget> createState() => PageBodyState();
}

class PageBodyState extends State<PageBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageBodyViewModel>(builder: (context, model, child) {
      return Column(mainAxisSize: MainAxisSize.max, children: [
        if (model.searchOpen && (model.searchInput != ''))
          ChangeNotifierProvider<ChipSearchViewModel>.value(
              value: model.chipSearchViewModel!,
              child: SizedBox(
                  height: 50,
                  child: ChipRow<ChipSearchViewModel>(
                      chips: CategorySearchFilter.values
                          .map((e) => e.name)
                          .toList(),
                      secondaryChips:
                          LocalFilter.values.map((e) => e.name).toList()))),
        Expanded(
            child: AnimatedSwitcher(
                transitionBuilder: (child, animation) => FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                            parent: animation, curve: Curves.easeIn)),
                    child: child),
                duration: const Duration(milliseconds: 200),
                child: ChangeNotifierProvider(
                    create: (context) => model.searchResultsViewModel,
                    child: model.searchOpen
                        ? const SearchResultsView()
                        : AnimatedSwitcher(
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                    opacity: Tween<double>(begin: 0, end: 1)
                                        .animate(CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeIn)),
                                    child: child),
                            duration: const Duration(milliseconds: 200),
                            child: model.settingsOpen
                                ? const SettingsView()
                                : MultiProvider(
                                    providers: [
                                        ChangeNotifierProvider.value(
                                            value: model.homeViewModel),
                                        ChangeNotifierProvider.value(
                                            value: model.libraryPageViewModel)
                                      ],
                                    builder: (context, child) => TabBarView(
                                            controller: model.tabController,
                                            children: [
                                              // if (!ResponsiveLayout.isMobile(
                                              //     context))
                                              //   ConstrainedBox(
                                              //       constraints:
                                              //           const BoxConstraints(
                                              //               minWidth: 150,
                                              //               maxWidth: 250),
                                              //       child: const Drawer()),
                                              const HomeView(),
                                              const LibraryView(),
                                              const Text("hi :)"),
                                              const RadioPage()
                                            ]))))))
      ]);
    });
  }
}
