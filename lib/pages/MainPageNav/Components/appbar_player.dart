import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/assets/styles.dart';
import 'package:musicnya/helpers/color_helper.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:musicnya/models/song.dart';
import 'package:musicnya/services/music_player.dart';

class AppbarPlayer extends StatefulWidget {
  const AppbarPlayer({super.key});

  @override
  State<StatefulWidget> createState() => AppbarPlayerState();
}

class AppbarPlayerState extends State<AppbarPlayer> {
  var _isPaused = true;
  Future<PaletteGenerator> getImagePalette(
      CachedNetworkImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator;
  }

  late Future<Song> testSongFuture;

  @override
  void initState() {
    testSongFuture = MusicPlayer().getSong();
    super.initState();
  }

  void playPause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    GetIt.I<MusicPlayer>().playSong();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => BottomAppBar(
            clipBehavior: Clip.none,
            child: SizedBox(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  FutureBuilder(
                      future: testSongFuture,
                      builder: (context, AsyncSnapshot<Song> snapshot) {
                        if (snapshot.hasData) {
                          return FutureBuilder(
                              future: getImagePalette(
                                  CachedNetworkImageProvider(
                                      snapshot.data!.getArtworkUrl())),
                              builder: (context, imgSnapshot) {
                                if (imgSnapshot.hasData) {
                                  return Column(children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              width: screenWidth,
                                              height: 5,
                                              child: LinearProgressIndicator(
                                                value: 0.5,
                                                color: lighten(
                                                    imgSnapshot.data!
                                                        .vibrantColor!.color,
                                                    0.3),
                                                backgroundColor: lighten(
                                                    imgSnapshot.data!
                                                        .vibrantColor!.color,
                                                    0.4),
                                              ))
                                        ]),
                                    Stack(children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: imgSnapshot
                                                  .data!.vibrantColor!.color),
                                          height: ((bottomAppBarHeight -
                                                  (kBottomNavigationBarHeight /
                                                      2)) +
                                              kBottomNavigationBarHeight),
                                          width: screenWidth,
                                          child: Container(
                                              color: lighten(
                                                  imgSnapshot.data!.colors
                                                      .elementAt(1),
                                                  0.05),
                                              child: Column(children: [
                                                Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          height:
                                                              kBottomNavigationBarHeight *
                                                                  1.25,
                                                          width:
                                                              kBottomNavigationBarHeight *
                                                                  1.25,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  image: CachedNetworkImageProvider(
                                                                      snapshot
                                                                          .data!
                                                                          .getArtworkUrl())))),
                                                      Expanded(
                                                          child: SizedBox(
                                                              height:
                                                                  bottomAppBarHeight,
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                          children: [
                                                                            Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                                                                child: Text(snapshot.data!.title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: secondaryColor, fontWeight: FontWeight.w500)))
                                                                          ]),
                                                                      Row(
                                                                          children: [
                                                                            Text(snapshot.data!.artist,
                                                                                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: lighten(imgSnapshot.data!.colors.elementAt(1), 0.4), fontWeight: FontWeight.w400)),
                                                                          ])
                                                                    ],
                                                                  )))),
                                                      ButtonBar(
                                                          alignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            IconButton(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              style:
                                                                  baseButtonStyle,
                                                              iconSize: 48,
                                                              color: lighten(
                                                                  imgSnapshot
                                                                      .data!
                                                                      .colors
                                                                      .elementAt(
                                                                          1),
                                                                  0.4),
                                                              splashRadius: 0.1,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              onPressed:
                                                                  playPause,
                                                              icon: _isPaused
                                                                  ? const Icon(Icons
                                                                      .play_arrow_rounded)
                                                                  : const Icon(Icons
                                                                      .pause_rounded),
                                                            ),
                                                          ]),
                                                    ]),
                                                Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Divider(
                                                        height: 1,
                                                        thickness: 0.5,
                                                        color: darken(
                                                            imgSnapshot
                                                                .data!
                                                                .vibrantColor!
                                                                .color,
                                                            0.3)))
                                              ])))
                                    ])
                                  ]);
                                }
                                return const CircularProgressIndicator();
                              });
                        } else if (snapshot.hasError) {
                          return Column(children: [
                            SizedBox(
                                height: (bottomAppBarHeight -
                                        (kBottomNavigationBarHeight / 2)) +
                                    kBottomNavigationBarHeight,
                                child: Center(
                                    child: Text(
                                        "Something went wrong: ${snapshot.error}")))
                          ]);
                        }
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  height: (bottomAppBarHeight -
                                          (kBottomNavigationBarHeight / 2)) +
                                      kBottomNavigationBarHeight,
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                            ]);
                      })
                ]))));
  }
}
