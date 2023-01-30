import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/navigation_service.dart';

class PlaylistDetails extends StatefulWidget {
  const PlaylistDetails({super.key, required this.arguments});

  final Object? arguments;

  @override
  State<StatefulWidget> createState() => PlaylistDetailsState();
}

class PlaylistDetailsState extends State<PlaylistDetails> {
  late Playlist currentPlaylist;
  bool showAppBarTitle = false;
  final _controller = ScrollController();
  GlobalKey key = GlobalKey();
  GlobalKey shaderMaskKey = GlobalKey();
  GlobalKey eventListHeaderKey = GlobalKey();
  bool showBorder = false;

  callback(bool value) {
    setState(() {
      showBorder = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentPlaylist = Playlist.from(widget.arguments);

    return Theme(
        data: ThemeData.light().copyWith(textTheme: Typography.whiteCupertino),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                bottom: showBorder
                    ? PreferredSize(
                        preferredSize: Size(screenWidth, 1),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.15),
                          thickness: 1,
                          height: 1,
                        ))
                    : const PreferredSize(
                        preferredSize: Size(1, 1), child: SizedBox.shrink()),
                leadingWidth: 33,
                titleSpacing: 0,
                shadowColor: Colors.transparent,
                toolbarHeight: topAppBarHeightCompact,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                actionsIconTheme: const IconThemeData(color: primaryColor),
                actions: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 4),
                      child: RawMaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          hoverColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.white.withOpacity(0.1),
                          focusColor: Colors.white.withOpacity(0.1),
                          splashColor: Colors.black87.withOpacity(0),
                          elevation: 0,
                          fillColor: Colors.black87.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 3,
                              vertical: defaultPadding / 2),
                          constraints: const BoxConstraints(minWidth: 20),
                          shape: const CircleBorder(),
                          onPressed: () => addAlbumToPlaylist(),
                          child: const Icon(Icons.add_to_photos_rounded,
                              size: 20))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 4),
                      child: RawMaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          hoverColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.white.withOpacity(0.1),
                          focusColor: Colors.white.withOpacity(0.1),
                          splashColor: Colors.black87.withOpacity(0),
                          elevation: 0,
                          fillColor: Colors.black87.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 3,
                              vertical: defaultPadding / 2),
                          constraints: const BoxConstraints(minWidth: 20),
                          shape: const CircleBorder(),
                          onPressed: () => addAlbumToLibrary(),
                          child: const Icon(Icons.add_rounded, size: 20))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 4),
                      child: RawMaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          hoverColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.white.withOpacity(0.1),
                          focusColor: Colors.white.withOpacity(0.1),
                          splashColor: Colors.black87.withOpacity(0),
                          elevation: 0,
                          fillColor: Colors.black87.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 3,
                              vertical: defaultPadding / 2),
                          constraints: const BoxConstraints(minWidth: 20),
                          shape: const CircleBorder(),
                          onPressed: () => favoriteAlbum(),
                          child: const Icon(Icons.favorite_rounded, size: 20))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 4),
                      child: RawMaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          hoverColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.white.withOpacity(0.1),
                          focusColor: Colors.white.withOpacity(0.1),
                          splashColor: Colors.black87.withOpacity(0),
                          elevation: 0,
                          fillColor: Colors.black87.withOpacity(0.4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 3,
                              vertical: defaultPadding / 2),
                          constraints: const BoxConstraints(minWidth: 20),
                          shape: const CircleBorder(),
                          onPressed: () => moreAlbumOptions(),
                          child:
                              const Icon(Icons.more_vert_rounded, size: 20))),
                ],
                title: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 4),
                    child: RawMaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        hoverColor: Colors.white.withOpacity(0.1),
                        highlightColor: Colors.white.withOpacity(0.1),
                        focusColor: Colors.white.withOpacity(0.1),
                        splashColor: Colors.black87.withOpacity(0),
                        elevation: 0,
                        fillColor: Colors.black87.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 3,
                            vertical: defaultPadding / 2),
                        constraints: const BoxConstraints(minWidth: 20),
                        shape: const CircleBorder(),
                        onPressed: () => serviceLocator<NavigationService>()
                            .togglePlaylistView(context),
                        child:
                            const Icon(Icons.arrow_back_rounded, size: 20)))),
            body: Scaffold(
                extendBodyBehindAppBar: true,
                extendBody: true,
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                body: Stack(children: [
                  SizedBox(
                      height: maxScreenSize,
                      child: Image(
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                          image: (CachedNetworkImageProvider(
                              currentPlaylist.getArtworkUrl())))),
                  ClipRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: ShaderMask(
                                  key: shaderMaskKey,
                                  blendMode: BlendMode.dstOut,
                                  shaderCallback: (bounds) => _listShader(
                                      eventListHeaderKey,
                                      shaderMaskKey,
                                      bounds),
                                  child: Stack(
                                      key: eventListHeaderKey,
                                      children: [
                                        CustomScrollView(
                                          controller: _controller,
                                          //border for appBar
                                          slivers: [
                                            SliverAppBar(
                                              stretch: true,
                                              pinned: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              primary: false,
                                              expandedHeight:
                                                  (0.5 * screenHeight) - 30,
                                              flexibleSpace: FlexibleSpaceBar(
                                                  titlePadding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          defaultPadding,
                                                      vertical: defaultPadding),
                                                  collapseMode:
                                                      CollapseMode.parallax,
                                                  background: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        ShaderMask(
                                                            blendMode: BlendMode
                                                                .dstOut,
                                                            shaderCallback:
                                                                (Rect bounds) {
                                                              return LinearGradient(
                                                                      colors: const [
                                                                    Colors
                                                                        .transparent,
                                                                    Colors
                                                                        .transparent,
                                                                    Colors
                                                                        .white,
                                                                    Colors.white
                                                                  ],
                                                                      stops: [
                                                                    0,
                                                                    0.65 -
                                                                        ((_controller.offset /
                                                                                (screenHeight - screenWidth)) *
                                                                            0.65),
                                                                    0.95 -
                                                                        ((_controller.offset /
                                                                                (screenHeight - screenWidth)) *
                                                                            0.65),
                                                                    1.0
                                                                  ],
                                                                      begin: Alignment
                                                                          .topCenter,
                                                                      end: Alignment
                                                                          .bottomCenter)
                                                                  .createShader(
                                                                      bounds);
                                                            },
                                                            child: ShaderMask(
                                                              blendMode:
                                                                  BlendMode
                                                                      .dstOut,
                                                              shaderCallback:
                                                                  (Rect
                                                                      bounds) {
                                                                return LinearGradient(
                                                                        colors: const [
                                                                      Colors
                                                                          .transparent,
                                                                      Colors
                                                                          .transparent,
                                                                      Colors
                                                                          .white,
                                                                      Colors
                                                                          .white
                                                                    ],
                                                                        stops: [
                                                                      0,
                                                                      0.65 -
                                                                          ((_controller.offset / (screenHeight - screenWidth)) *
                                                                              0.25),
                                                                      0.95 -
                                                                          ((_controller.offset / (screenHeight - screenWidth)) *
                                                                              0.45),
                                                                      1.0
                                                                    ],
                                                                        begin: Alignment
                                                                            .bottomCenter,
                                                                        end: Alignment
                                                                            .topCenter)
                                                                    .createShader(
                                                                        bounds);
                                                              },
                                                              child: CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  fadeInDuration:
                                                                      const Duration(
                                                                          microseconds:
                                                                              1),
                                                                  imageUrl:
                                                                      currentPlaylist
                                                                          .getArtworkUrl()),
                                                            )),
                                                        Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          defaultPadding,
                                                                      horizontal:
                                                                          defaultPadding *
                                                                              1.5),
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: defaultPadding / 4),
                                                                            child: Text(currentPlaylist.title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: Theme.of(context).textTheme.titleLarge!.fontSize! * 1.5, color: secondaryColor, fontWeight: FontWeight.w400))),
                                                                        Text(
                                                                            currentPlaylist
                                                                                .curatorName,
                                                                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                                                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! * 1.5,
                                                                                color: secondaryColor.withOpacity(0.25),
                                                                                fontWeight: FontWeight.w400)),
                                                                        // Text(
                                                                        //     '${currentAlbum.genres.join(', ')} | ${currentAlbum.releaseDate.substring(0, 4)}')
                                                                      ]))
                                                            ]),
                                                      ])),
                                              leadingWidth: 25,
                                              shadowColor: Colors.transparent,
                                              toolbarHeight:
                                                  topAppBarHeightCompact,
                                              elevation: 0,
                                              automaticallyImplyLeading: false,
                                            ),
                                            SliverList(
                                                delegate:
                                                    SliverChildListDelegate([
                                              MediaQuery.removePadding(
                                                  context: context,
                                                  removeTop: true,
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          primary: false,
                                                          itemCount:
                                                              currentPlaylist
                                                                      .tracks
                                                                      .length +
                                                                  1,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            if (index == 0) {
                                                              return Divider(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.15),
                                                                thickness: 1,
                                                                height: 1,
                                                              );
                                                            }
                                                            return Dismissible(
                                                                confirmDismiss:
                                                                    (direction) {
                                                                  if (direction ==
                                                                      DismissDirection
                                                                          .startToEnd) {
                                                                    //TODO implement play next
                                                                  } else if (direction ==
                                                                      DismissDirection
                                                                          .endToStart) {
                                                                    //TODO implement play last
                                                                  }
                                                                  return Future
                                                                      .value(
                                                                          false);
                                                                },
                                                                direction:
                                                                    DismissDirection
                                                                        .horizontal,
                                                                secondaryBackground:
                                                                    Container(
                                                                        color: Colors
                                                                            .blue,
                                                                        alignment: Alignment
                                                                            .centerLeft,
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .end,
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => {},
                                                                                icon: SvgPicture.asset(width: 24, height: 24, color: Colors.white, 'lib/assets/icons/play_last.svg'),
                                                                              )
                                                                            ])),
                                                                background:
                                                                    Container(
                                                                        color: Colors
                                                                            .red,
                                                                        child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => {},
                                                                                icon: SvgPicture.asset(width: 24, height: 24, color: Colors.white, 'lib/assets/icons/play_next.svg'),
                                                                              )
                                                                            ])),
                                                                key:
                                                                    UniqueKey(),
                                                                child: Column(
                                                                    children: [
                                                                      ListTile(
                                                                        onTap:
                                                                            () {},
                                                                        minVerticalPadding:
                                                                            19,
                                                                        leading: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(padding: index < 10 ? const EdgeInsets.only(left: 21) : const EdgeInsets.only(left: 12), child: Text('$index', style: const TextStyle(fontSize: 16, color: secondaryAccentColorMuted)))
                                                                            ]),
                                                                        visualDensity:
                                                                            VisualDensity.adaptivePlatformDensity,
                                                                        minLeadingWidth:
                                                                            12,
                                                                        contentPadding:
                                                                            EdgeInsets.zero,
                                                                        title: Text(currentPlaylist
                                                                            .tracks[index -
                                                                                1]
                                                                            .title),
                                                                        trailing: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                            children: [
                                                                              Row(mainAxisSize: MainAxisSize.min, children: [
                                                                                IconButton(
                                                                                  color: primaryColor,
                                                                                  splashRadius: 20,
                                                                                  constraints: const BoxConstraints(),
                                                                                  padding: EdgeInsets.zero,
                                                                                  icon: const Icon(Icons.add_rounded),
                                                                                  onPressed: () {},
                                                                                ),
                                                                                IconButton(
                                                                                  color: primaryColor,
                                                                                  splashRadius: 20,
                                                                                  padding: EdgeInsets.zero,
                                                                                  icon: const Icon(Icons.more_vert_rounded),
                                                                                  onPressed: () {},
                                                                                )
                                                                              ])
                                                                            ]),
                                                                      ),
                                                                      Divider(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.15),
                                                                        thickness:
                                                                            1,
                                                                        height:
                                                                            1,
                                                                      ),
                                                                    ]));
                                                          },
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8, 8, 8, 8),
                                                            child: const Text(
                                                              "no",
                                                              // "${currentPlaylist.releaseDate}\n${MillisecondsToDateTime.millisecondsToFormattedString(int.parse(currentPlaylist.calculatePlaybackLength()))}\n${currentPlaylist.copyrightInfo}",
                                                              style: TextStyle(
                                                                  color:
                                                                      secondaryColor,
                                                                  fontSize: 14),
                                                            ))
                                                      ]))
                                            ]))
                                          ],
                                          scrollDirection: Axis.vertical,
                                        )
                                      ])))))
                ]))));
  }

  addAlbumToPlaylist() {} // TODO implement these

  addAlbumToLibrary() {}

  favoriteAlbum() {}

  moreAlbumOptions() {}

  Shader _listShader(
      GlobalKey listHeaderKey, GlobalKey shaderMaskKey, Rect rect) {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: <double>[
          0,
          (_controller.position.pixels > screenWidth - 100) ? 1 : 0,
          (_controller.position.pixels > screenWidth - 100) ? 1 : 0,
          1
        ],
        colors: const <Color>[
          Colors.white,
          Colors.white,
          Colors.transparent,
          Colors.transparent
        ]).createShader(
        Rect.fromLTWH(0, 0, screenWidth, topAppBarHeightCompact + 30));
  }
}
