import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicnya/pages/PlayerView/components/album_component.dart';
import 'package:musicnya/pages/PlayerView/components/media_controls.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:provider/provider.dart';

import 'package:musicnya/assets/constants.dart';
import '../../models/song.dart';
import '../../models/album.dart';
import 'components/queue_details_component.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<StatefulWidget> createState() => PlayerViewState();
}

class PlayerViewState extends State<PlayerView> {
  bool settingsViewActive = false;
  late List<Widget> stackChildren;
  PageController pageController = PageController(keepPage: false);
  late Future<Album> futureCurrentAlbum;
  late Future<List<Song>> futureSongQueue;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));

    futureCurrentAlbum = MusicPlayer().getAlbum('0');
    futureSongQueue = MusicPlayer().getSongQueue();

    //TODO probably have to listen to the media player to figure out what song is playing/when it changes
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
        ),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                centerTitle: true,
                leadingWidth: 25,
                toolbarHeight: settingsViewActive ? 84 : 56,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                leading: Align(
                    alignment: Alignment.topCenter,
                    child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        onPressed: () => Navigator.maybePop(context))),
                title: settingsViewActive
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            FutureBuilder(
                                future: futureCurrentAlbum,
                                //TODO replace with local placeholder asset?
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Flexible(
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                          Flexible(
                                              child: Image(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          (snapshot.data!
                                                              .getArtworkUrl())),
                                                  fit: BoxFit.contain))
                                        ]));
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                            FutureBuilder(
                              future: futureSongQueue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Flexible(
                                      fit: FlexFit.loose,
                                      flex: 4,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: defaultPadding),
                                          child: Consumer<MusicPlayer>(
                                              builder:
                                                  (context, musicPlayer,
                                                          child) =>
                                                      Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                snapshot
                                                                    .data![musicPlayer
                                                                        .currentSongIndex]
                                                                    .title,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        color:
                                                                            secondaryColor,
                                                                        fontWeight:
                                                                            FontWeight.w400)),
                                                            Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top:
                                                                        defaultPadding /
                                                                            4),
                                                                child: Text(
                                                                    snapshot
                                                                        .data![musicPlayer
                                                                            .currentSongIndex]
                                                                        .artist,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleSmall!
                                                                        .copyWith(
                                                                            color:
                                                                                secondaryAccentColorMuted,
                                                                            fontWeight:
                                                                                FontWeight.w400)))
                                                          ]))));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            )
                          ])
                    : FutureBuilder(
                        future: futureCurrentAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(children: [
                              Text("Playing from Album".toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: secondaryAccentColor,
                                          fontWeight: FontWeight.w400)),
                              Text(snapshot.data!.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: secondaryAccentColor,
                                          fontWeight: FontWeight.w400))
                            ]);
                          } else {
                            return Column(children: const [
                              Center(child: CircularProgressIndicator())
                            ]);
                          }
                        }),
                actions: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.menu_rounded),
                          onPressed: () => openSettings()))
                ]),
            body: FutureBuilder(
                future: futureSongQueue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(fit: StackFit.expand, children: [
                      Consumer<MusicPlayer>(
                          builder: (context, musicPlayer, child) =>
                              AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 300),
                                  crossFadeState: musicPlayer
                                              .currentSongIndex ==
                                          0
                                      ? CrossFadeState.showFirst
                                      : musicPlayer.currentSongIndex % 2 == 0
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                  firstChild: SizedBox(
                                      height: maxScreenSize,
                                      child: Image(
                                          alignment: Alignment.bottomCenter,
                                          image: CachedNetworkImageProvider(
                                              snapshot.data![musicPlayer
                                                      .currentSongIndex]
                                                  .getArtworkUrl()),
                                          fit: BoxFit.cover)),
                                  secondChild: SizedBox(
                                    height: maxScreenSize,
                                    child: Image(
                                        image: (CachedNetworkImageProvider(
                                            snapshot.data![musicPlayer.songQueue
                                                                .length -
                                                            1 >=
                                                        musicPlayer
                                                                .currentSongIndex +
                                                            1
                                                    ? musicPlayer
                                                            .currentSongIndex +
                                                        1
                                                    : musicPlayer
                                                        .currentSongIndex]
                                                .getArtworkUrl())),
                                        fit: BoxFit.cover),
                                  ))),
                      ClipRect(
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                            child: Container(
                              color: Colors.black.withOpacity(0.4),
                              child: SafeArea(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                      fit: FlexFit.loose,
                                      flex: 2,
                                      child: PageView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          allowImplicitScrolling: true,
                                          controller: pageController,
                                          children: [
                                            AlbumComponent(snapshot.data!),
                                            QueueDetailsComponent(
                                                pageActive: settingsViewActive),
                                          ])),
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: settingsViewActive
                                                  ? 0
                                                  : defaultPadding / 1.7),
                                          child: const MediaControls()))
                                ],
                              )),
                            )),
                      )
                    ]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }

  openSettings() {
    setState(() {
      pageController.jumpToPage(settingsViewActive ? 0 : 1);
      settingsViewActive = !settingsViewActive;
    });
  }
}
