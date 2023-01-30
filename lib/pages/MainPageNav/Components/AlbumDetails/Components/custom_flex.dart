import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/assets/ui_components/buttons/outlined_icon_button.dart';
import 'dart:math' as math;

import 'package:musicnya/helpers/color_helper.dart';
import 'package:musicnya/helpers/milliseconds_to_datetime.dart';
import 'package:musicnya/models/album.dart';
import 'package:palette_generator/palette_generator.dart';

class CustomFlex extends StatefulWidget {
  const CustomFlex(
      {Key? key,
      required this.expandedWidget,
      required this.image,
      required this.currentAlbum})
      : super(key: key);

  final Widget expandedWidget;
  final CachedNetworkImageProvider image;
  final Album currentAlbum;

  @override
  State<StatefulWidget> createState() => CustomFlexState();
}

class CustomFlexState extends State<CustomFlex> {
  late Future imagePaletteFuture;

  @override
  void initState() {
    imagePaletteFuture = getImagePalette(widget.image);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final fadeAmount = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        //faster for text fade
        final tT = (1.0 -
                ((settings.currentExtent / 2) - settings.minExtent) /
                    deltaExtent)
            .clamp(0.0, 1.0);
        final fadeStartT = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEndT = 1.0;
        final fadeAmountT = 1.0 - Interval(fadeStartT, fadeEndT).transform(tT);

        return SizedBox(
            child: Stack(clipBehavior: Clip.none, children: [
          FutureBuilder(
              future: imagePaletteFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(fit: StackFit.expand, children: [
                    ShaderMask(
                        blendMode: BlendMode.dstOut,
                        shaderCallback: (bounds) {
                          return LinearGradient(
                                  colors: const [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.white,
                                Colors.white
                              ],
                                  //TODO fix this to make it linear/consistent
                                  stops: [
                                0,
                                (0.3 * (bounds.height / screenWidth))
                                    .clamp(0.5, 0.8),
                                (0.85 * (bounds.height / screenWidth))
                                    .clamp(0.8, 0.85),
                                1
                              ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)
                              .createShader(bounds);
                        },
                        child: Opacity(
                            opacity: fadeAmount, child: widget.expandedWidget)),
                    Positioned(
                        top: 0,
                        height: MediaQuery.of(context).viewPadding.top + 55,
                        child: IgnorePointer(
                            child: Opacity(
                                opacity: 1 - fadeAmount,
                                child: Material(
                                    elevation: 2,
                                    color: Colors.transparent,
                                    child: Container(
                                      width: screenWidth,
                                      color: (snapshot.data as PaletteGenerator)
                                          .lightMutedColor!
                                          .color
                                          .withOpacity(0.15),
                                    ))))),
                    Opacity(
                        opacity: fadeAmountT,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: defaultPadding / 2),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: screenWidth),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        bottom:
                                                            defaultPadding / 4,
                                                        left: defaultPadding /
                                                            1.5,
                                                        right: defaultPadding /
                                                            1.5),
                                                    child: Text(widget.currentAlbum.title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontSize: Theme.of(context)
                                                                        .textTheme
                                                                        .titleLarge!
                                                                        .fontSize! *
                                                                    1.5,
                                                                color:
                                                                    secondaryColor,
                                                                fontWeight: FontWeight
                                                                    .w500))))),

                                        Flexible(
                                            child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: screenWidth),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        bottom:
                                                            defaultPadding / 4,
                                                        right: defaultPadding /
                                                            1.5,
                                                        left: defaultPadding /
                                                            1.5),
                                                    child: GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        onTap:
                                                            () {}, //TODO implement this
                                                        child: Text(
                                                            widget
                                                                .currentAlbum.artist,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    fontSize: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge!
                                                                            .fontSize! *
                                                                        2,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)))))),
                                        Flexible(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: defaultPadding / 1.5,
                                                    left: defaultPadding / 1.5),
                                                child: Text(
                                                    MillisecondsToDateTime.millisecondsToFormattedString(
                                                        int.parse(widget
                                                            .currentAlbum
                                                            .calculatePlaybackLength())),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                            fontSize: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .fontSize! *
                                                                1.1,
                                                            color: Colors.grey.withOpacity(0.5),
                                                            fontWeight: FontWeight.w500)))),

                                        // Text(
                                        //     '${currentAlbum.genres.join(', ')} | ${currentAlbum.releaseDate.substring(0, 4)}')
                                      ])),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: defaultPadding / 3),
                                  child: Row(children: [
                                    OutlinedIconButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: defaultPadding / 2.5),
                                        icon: Icons.favorite_border,
                                        onTap: favoriteAlbum),
                                    OutlinedIconButton(
                                      padding: const EdgeInsets.all(0),
                                      icon: Icons.more_vert,
                                      onTap: moreAlbumOptions,
                                    )
                                  ]))
                            ])),
                  ]);
                }
                return const CircularProgressIndicator.adaptive();
              }),
        ]));
      },
    );
  }

  favoriteAlbum() {
    //TODO implement this
  }

  moreAlbumOptions() {} //TODO imeplement this
}
