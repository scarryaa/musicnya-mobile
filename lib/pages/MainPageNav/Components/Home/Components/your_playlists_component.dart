import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/assets/ui_components/square_tile.dart';
import 'package:musicnya/assets/ui_components/subheader.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/assets/constants.dart';

import 'package:musicnya/services/navigation_service.dart';
import 'package:musicnya/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class YourPlaylistsComponent extends StatefulWidget {
  const YourPlaylistsComponent({super.key, required this.onFutureComplete});

  final void Function() onFutureComplete;

  @override
  State<StatefulWidget> createState() => YourPlaylistsComponentState();
}

class YourPlaylistsComponentState extends State<YourPlaylistsComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
        builder: (context, model, child) => FutureBuilder(
            future: Future.wait(
                [model.futurePlaylists, model.futurePlaylistsImages]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        defaultPadding / 2,
                        defaultPadding / 1.5,
                        defaultPadding / 2,
                        defaultPadding / 2),
                    child: Row(children: const [
                      Subheader(
                        title: "Your Playlists",
                        padding: EdgeInsets.only(bottom: defaultPadding / 4),
                        actions: [
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.arrow_forward_ios_rounded))
                        ],
                      ),
                    ]),
                  ),
                  Row(children: [
                    Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(
                            height: screenHeight / 5,
                            child: snapshot.hasError
                                ? SizedBox(
                                    child: Card(
                                        color: Colors.grey.shade400,
                                        child: const Center(
                                            child: Text(
                                                "Could not get playlists at this time.",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)))),
                                  )
                                : snapshot.hasData
                                    ? playlistList(context, snapshot.data![0],
                                        snapshot.data![1])
                                    : Container())),
                  ])
                ]);
              }
              return Container();
            }));
  }
}

Widget playlistList(BuildContext context, List<Playlist<dynamic>> data,
    List<CachedNetworkImage> images) {
  var values =
      data.isNotEmpty ? (data).map((e) => Playlist.from(e)).toList() : [];
  return ListView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      itemExtent: (screenWidth / 3) - (defaultPadding / 4.5),
      padding: const EdgeInsets.fromLTRB(
          defaultPadding / 2, 0, defaultPadding / 2, 0),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              GetIt.I<NavigationService>()
                  .togglePlaylistView(context, arguments: {values[index]});
            },
            child: SquareTile(
                title: values[index].title,
                size: screenWidth / 3.2,
                padding: const EdgeInsets.all(0),
                image: images[index]));
      });
}
