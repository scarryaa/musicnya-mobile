import 'package:flutter/material.dart' hide AppBar;
import 'package:musicnya/assets/ui_components/chip_row.dart';
import 'package:musicnya/enums/category_filter.dart';
import 'package:musicnya/enums/local_filter.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/pages/LibraryView/components/all_view.dart';
import 'package:musicnya/pages/LibraryView/components/artist_view.dart';
import 'package:musicnya/pages/LibraryView/components/song_view.dart';
import 'package:musicnya/viewmodels/chip_library_view_model.dart';
import 'package:musicnya/viewmodels/library_page_view_model.dart';
import 'package:musicnya/viewmodels/page_body_view_model.dart';
import 'package:provider/provider.dart';
import 'components/album_view.dart';
import 'components/playlist_view.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<StatefulWidget> createState() {
    return LibraryViewState();
  }
}

class LibraryViewState extends State<LibraryView> {
  bool showLocal = true;
  int? categorySelection = 1;
  int? localSelection = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ChangeNotifierProvider<ChipLibraryViewModel>.value(
                value: Provider.of<PageBodyViewModel>(context, listen: false)
                    .chipLibraryViewModel!,
                child: SizedBox(
                    height: 50,
                    child: ChipRow<ChipLibraryViewModel>(
                        chips: CategoryLibraryFilter.values
                            .map((e) => e.name)
                            .toList(),
                        secondaryChips:
                            LocalFilter.values.map((e) => e.name).toList()))),
            Consumer<LibraryPageViewModel>(
                builder: (context, model, child) => Expanded(
                    child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverFillRemaining(
                              hasScrollBody: true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: bottomAppBarHeight),
                                  child: showCategoryChipContent(
                                      model.categorySelection,
                                      model.localSelection)))
                        ],
                        primary: true)))
          ],
        ));
  }
}

Widget showCategoryChipContent(int? categorySelection, int localSelection) {
  if (categorySelection == null) return allView(localSelection);

  switch (CategoryLibraryFilter.values[categorySelection]) {
    case CategoryLibraryFilter.playlists:
      return playlistView(localSelection);
    case CategoryLibraryFilter.albums:
      return albumView(localSelection);
    case CategoryLibraryFilter.artists:
      return artistView(localSelection);
    case CategoryLibraryFilter.songs:
      return songView(localSelection);
  }
}
