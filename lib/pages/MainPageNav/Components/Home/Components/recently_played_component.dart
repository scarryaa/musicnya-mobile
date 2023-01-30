import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/abstracts/on_tap/on_tap_router.dart';
import 'package:musicnya/assets/ui_components/rectangle_tile.dart';
import 'package:musicnya/assets/ui_components/square_tile.dart';
import 'package:musicnya/assets/ui_components/subheader.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/song.dart';
import 'package:musicnya/assets/constants.dart';

import 'package:musicnya/services/music_player.dart';
import 'package:musicnya/services/navigation_service.dart';
import 'package:musicnya/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

class RecentlyPlayedComponent extends StatefulWidget {
  const RecentlyPlayedComponent({super.key});

  @override
  State<StatefulWidget> createState() => RecentlyPlayedComponentState();
}

class RecentlyPlayedComponentState extends State<RecentlyPlayedComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
        builder: (context, model, child) => FutureBuilder(
            future: Future.wait([
              model.futureUserRecentlyPlayedContent,
              model.futureRecentlyPlayedContentImages
              // model.futureUserHeavyRotation,
              // model.futureUserHeavyRotationImages
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        defaultPadding / 2,
                        defaultPadding / 1.5,
                        defaultPadding / 1.5,
                        defaultPadding / 2),
                    child: Row(children: const [
                      Subheader(
                        title: "Recently Played",
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
                        child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: defaultPadding / 1.5),
                            child: SizedBox(
                                height: screenWidth / 1.125,
                                child: snapshot.hasError
                                    ? SizedBox(
                                        child: Card(
                                            color: Colors.grey.shade400,
                                            child: const Center(
                                                child: Text(
                                                    "Could not get recently played media at this time.",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400)))),
                                      )
                                    : snapshot.hasData
                                        ? recentlyPlayedList(
                                            context,
                                            snapshot.data![0],
                                            snapshot.data![1])
                                        : Container())))
                  ]),
                  // Row(children: [
                  //   Flexible(
                  //       fit: FlexFit.tight,
                  //       child: SizedBox(
                  //           height: 76,
                  //           child: snapshot.hasError
                  //               ? SizedBox(
                  //                   height: screenWidth / 8,
                  //                   child: Card(
                  //                       color: Colors.grey.shade400,
                  //                       child: const Center(
                  //                           child: Text(
                  //                               "Could not get recently played songs at this time.",
                  //                               style: TextStyle(
                  //                                   fontSize: 18,
                  //                                   fontWeight:
                  //                                       FontWeight.w400)))),
                  //                 )
                  //               : snapshot.hasData
                  //                   ? recentlyPlayedSongList(context,
                  //                       snapshot.data![1], snapshot.data![3])
                  //                   : const Center(
                  //                       child: CircularProgressIndicator())))
                  // ])
                ]);
              }
              return Container();
            }));
  }

  Widget recentlyPlayedList(BuildContext context, List<dynamic> data,
      List<CachedNetworkImage> images) {
    var values =
        data.isNotEmpty ? (data).map((e) => IMediaType.from(e)).toList() : [];
    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 0,
            childAspectRatio: 3,
            mainAxisExtent: screenWidth / 3.1,
            maxCrossAxisExtent: screenHeight / 3),
        itemCount: 6,
        padding: const EdgeInsets.fromLTRB(
            defaultPadding / 2, 0, defaultPadding / 2, 0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                OnTapRouter.handleTap(context, values[index]);
              },
              child: SquareTile(
                  title: values[index].title,
                  size: screenWidth / 3.2,
                  padding: const EdgeInsets.all(0),
                  image: images[index]));
        });
  }

  Widget recentlyPlayedSongList(BuildContext context, List<Song<dynamic>> data,
      List<CachedNetworkImage> images) {
    var values = data.isNotEmpty ? data.map((e) => Song.from(e)).toList() : [];
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
          //TODO add animation when clicking on child
          return GestureDetector(
              onTap: () async {
                GetIt.I<NavigationService>().toggleAlbumView(context,
                    arguments: {
                      (await MusicPlayer()
                          .getAlbum(values[index].albumId as String))
                    });
              },
              child: RectangleTile(
                  title: values[index].title,
                  width: screenWidth / 3.2,
                  height: screenHeight / 15,
                  padding: const EdgeInsets.all(0),
                  image: images[index]));
        });
  }
}
