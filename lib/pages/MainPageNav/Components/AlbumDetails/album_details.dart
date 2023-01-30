import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/assets/ui_components/buttons/outlined_icon_button.dart';
import 'package:musicnya/pages/MainPageNav/Components/AlbumDetails/Components/album_media_controls.dart';
import 'package:musicnya/helpers/color_helper.dart';
import 'package:musicnya/pages/MainPageNav/Components/AlbumDetails/Components/custom_flex.dart';
import 'package:musicnya/models/album.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:musicnya/pages/MainPageNav/Components/AlbumDetails/Components/sliver_app_bar_border.dart';
import 'package:musicnya/pages/components/shared/song_list_tile.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/navigation_service.dart';

class AlbumDetails extends StatefulWidget {
  const AlbumDetails({super.key, required this.arguments});

  final Object? arguments;

  @override
  State<StatefulWidget> createState() => AlbumDetailsState();
}

class AlbumDetailsState extends State<AlbumDetails> {
  late Album currentAlbum;
  final _controller = ScrollController();

  final LayerLink layerLink = LayerLink();
  late CachedNetworkImageProvider albumCover;
  bool showDivider = true;
  bool shouldAbsorb = false;

  @override
  void initState() {
    currentAlbum = Album.from(widget.arguments);
    albumCover = CachedNetworkImageProvider(currentAlbum.getArtworkUrl());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaContainer(
        child: Theme(
            data: ThemeData.light()
                .copyWith(textTheme: Typography.whiteCupertino),
            child: Stack(children: [
              SizedBox(
                  height: maxScreenSize,
                  child: Image(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      image: (albumCover))),
              ClipRect(
                  child: BackdropFilter(
                      blendMode: BlendMode.srcATop,
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ))),
              CustomScrollView(controller: _controller, slivers: [
                SliverAppBar(
                    automaticallyImplyLeading: false,
                    floating: false,
                    elevation: 0,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 80,
                    expandedHeight: 400,
                    collapsedHeight: 80,
                    shape: SliverAppBarBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                        borderWidth: 0,
                        statusBarHeight: MediaQuery.of(context).padding.top),
                    stretch: false,
                    title: SizedBox(
                        height: 65,
                        child: Stack(children: [
                          Positioned(
                              top: 0,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: ClipOval(
                                      child: Material(
                                          elevation: 50,
                                          color: Colors.black.withOpacity(0.6),
                                          child: InkWell(
                                            onTap: () {
                                              serviceLocator<
                                                      NavigationService>()
                                                  .toggleAlbumView(context);
                                            },
                                            child: const Padding(
                                                padding: EdgeInsets.all(
                                                    defaultPadding / 2.5),
                                                child: Icon(
                                                    Icons.arrow_back_rounded,
                                                    size: 25,
                                                    color: secondaryColor)),
                                          )))))
                        ])),
                    flexibleSpace: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomFlex(
                          currentAlbum: currentAlbum,
                          expandedWidget: CachedNetworkImage(
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(microseconds: 1),
                              imageUrl: albumCover.url),
                          image: albumCover,
                        ),
                        Positioned(
                            height: screenHeight,
                            top: 0,
                            child: SizedBox(
                                width: screenWidth,
                                height: screenHeight,
                                child: const AlbumMediaControls()))
                      ],
                    )),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Stack(children: [
                    ClipRect(
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                                bottom: kBottomNavigationBarHeight +
                                    bottomAppBarHeight),
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentAlbum.tracks!.length + 2,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0 && showDivider) {
                                return Divider(
                                  color: Colors.grey.withOpacity(0.15),
                                  thickness: 1,
                                  height: 1,
                                );
                              } else if (index ==
                                  currentAlbum.tracks!.length + 1) {
                                return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: screenWidth,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(
                                              defaultPadding / 2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: defaultPadding / 2),
                                              child: Text(
                                                "${currentAlbum.releaseDate}\n${currentAlbum.copyrightInfo}",
                                                style: const TextStyle(
                                                    color: secondaryColor,
                                                    fontSize: 14),
                                              )))
                                    ]);
                              }
                              return SongListTile(
                                index: index,
                                swipeIconColor: secondaryColor,
                                swipeLeftAction: () {}, //TODO implement this
                                swipeRightAction: () {}, //TODO implement this
                                swipeLeftIcon: SvgPicture.asset(
                                    'lib/assets/icons/play_last.svg',
                                    width: 20,
                                    height: 20,
                                    color: secondaryColor),
                                swipeRightIcon: SvgPicture.asset(
                                    'lib/assets/icons/play_next.svg',
                                    width: 20,
                                    height: 20,
                                    color: secondaryColor),
                                tileText:
                                    Text(currentAlbum.tracks![index - 1].title),
                                tileVerticalPadding: 10,
                                trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            OutlinedIconButton(
                                              icon: Icons.more_vert_rounded,
                                              iconColor:
                                                  lighten(primaryColor, 0.15),
                                              iconPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          defaultPadding / 2,
                                                      vertical:
                                                          defaultPadding / 2),
                                              onTap: () {},
                                              iconSize: 24,
                                            )
                                          ])
                                    ]),
                              );
                            })),
                    // prevent drag of dismissables (e.g. tracks) when user wants to use an edge gesture
                    Positioned(
                        left: 0,
                        width: MediaQuery.systemGestureInsetsOf(context).left,
                        //TODO eventually get this value instead of hardcoding it, since it isnt guaranteed
                        height: currentAlbum.tracks!.length * 57,
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onHorizontalDragStart: (details) => {})),
                    Positioned(
                        right: 0,
                        width: MediaQuery.systemGestureInsetsOf(context).right,
                        height: currentAlbum.tracks!.length * 57,
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onHorizontalDragStart: (details) => {}))
                  ]),
                ])),
              ])
            ])));
  }
}
