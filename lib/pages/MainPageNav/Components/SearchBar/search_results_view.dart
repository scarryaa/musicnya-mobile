import 'package:flutter/material.dart' hide AppBar;
import 'package:musicnya/assets/ui_components/rect_tile.dart';
import 'package:musicnya/assets/ui_components/subheader.dart';
import 'package:musicnya/models/album.dart';
import 'package:musicnya/models/song.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/viewmodels/page_body_view_model.dart';
import 'package:musicnya/viewmodels/search_results_view_model.dart';
import 'package:provider/provider.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({super.key});

  @override
  State<StatefulWidget> createState() => SearchResultsViewState();
}

class SearchResultsViewState extends State<SearchResultsView> {
//add chip view model
//add search bar view model

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Consumer<SearchResultsViewModel>(
            builder: (context, searchResultsModel, child) => GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () => searchResultsModel.searchFocusNode.unfocus(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: SingleChildScrollView(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  scrollDirection: Axis.vertical,
                                  child: Provider.of<PageBodyViewModel>(context,
                                                  listen: true)
                                              .mainVm
                                              .searchInput !=
                                          ''
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            FutureBuilder<dynamic>(
                                                future: searchResultsModel
                                                    .futureSearchResults,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.active) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                        '${snapshot.error}');
                                                  } else if (snapshot.hasData) {
                                                    final data = snapshot.data;

                                                    return ListView.separated(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: (snapshot.data
                                                              as List)
                                                          .length,
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                                  int index) =>
                                                              const Divider(
                                                        color: Colors.grey,
                                                        thickness: 0.5,
                                                        height: 2,
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTile(
                                                            title: Text(data[
                                                                        index]
                                                                    is Song
                                                                ? Song.from(data[
                                                                        index])
                                                                    .title
                                                                : data[index]
                                                                        is Album
                                                                    ? Album.from(data[
                                                                            index])
                                                                        .title
                                                                    : data[index]
                                                                            is String
                                                                        ? data[
                                                                            index]
                                                                        : "Artist"));
                                                      },
                                                    );
                                                  }
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                              const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: defaultPadding),
                                                  child: Subheader(
                                                      title:
                                                          "Recently Searched")),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 20),
                                                  child: ListView(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                  child: Wrap(
                                                                      crossAxisAlignment:
                                                                          WrapCrossAlignment
                                                                              .start,
                                                                      alignment:
                                                                          WrapAlignment
                                                                              .spaceBetween,
                                                                      spacing:
                                                                          5,
                                                                      direction:
                                                                          Axis
                                                                              .horizontal,
                                                                      children: searchResultsModel
                                                                          .tmpRecentSearches
                                                                          .map((i) => const RectTile(
                                                                              title: Text('XYZ'),
                                                                              subtitle: Text("test test test test test")))
                                                                          .toList())),
                                                            ])
                                                      ])),
                                              const Subheader(
                                                  title: "Explore Categories"),
                                              ListView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  //70 is padding for bottom, to compensate for bottom sheet
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          bottom: 10),
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                              child: Wrap(
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .start,
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .spaceBetween,
                                                                  spacing: 5,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: searchResultsModel
                                                                      .tmpCategories
                                                                      .map((i) => const RectTile(
                                                                          title: Text(
                                                                              'XYZ'),
                                                                          subtitle:
                                                                              Text("test test test test test")))
                                                                      .toList())),
                                                        ])
                                                  ]),
                                            ])))),
                    ]))));
  }
}
