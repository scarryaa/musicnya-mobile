import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'package:musicnya/assets/constants.dart';

class QueueDetailsList extends StatefulWidget {
  const QueueDetailsList({super.key, required this.currentSection});
  final int currentSection;

  @override
  State<StatefulWidget> createState() => QueueDetailsListState();
}

class QueueDetailsListState extends State<QueueDetailsList> {
  final GlobalKey eventListHeaderKey = GlobalKey();
  final GlobalKey playingHeaderKey = GlobalKey();
  final GlobalKey shaderMaskKey = GlobalKey();
  final double _stickyHeaderHeight = 45;

  @override
  Widget build(BuildContext context) {
    final List sectionHeaders = [
      [
        Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding / 3, horizontal: defaultPadding * 2),
            child: Text("History",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryColor, fontWeight: FontWeight.w400)))
      ],
      [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Text("Playing Next",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryColor, fontWeight: FontWeight.w400))),
        Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding / 8, horizontal: defaultPadding * 2),
            child: Text("Hot Fuss",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: secondaryAccentColor, fontWeight: FontWeight.w400)))
      ],
      [
        Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding / 2.5, horizontal: defaultPadding * 2),
            child: Text("Autoplay",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryColor, fontWeight: FontWeight.w400)))
      ],
    ];

    final List sectionActions = [
      //clear history
      [
        Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding / 2.5, horizontal: defaultPadding * 2),
            child: Text("Clear",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: secondaryAccentColorMuted,
                    fontWeight: FontWeight.w400)))
      ],
      //toggle shuffle, repeat, autoplay
      [
        IconButton(
            constraints: const BoxConstraints(),
            onPressed: () => toggleShuffle(),
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding / 3),
            icon:
                const Icon(Icons.shuffle_rounded, color: secondaryAccentColor)),
        IconButton(
            constraints: const BoxConstraints(),
            onPressed: () => toggleRepeat(),
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding / 3),
            icon:
                const Icon(Icons.repeat_rounded, color: secondaryAccentColor)),
        IconButton(
          constraints: const BoxConstraints(),
          onPressed: () => toggleAutoplay(),
          padding: const EdgeInsets.only(
              left: defaultPadding / 2,
              right: defaultPadding * 2,
              top: defaultPadding / 3,
              bottom: defaultPadding / 3),
          icon: const Icon(Icons.all_inclusive_rounded,
              color: secondaryAccentColor),
        )
      ],
      //toggle autoplay
      [
        IconButton(
            constraints: const BoxConstraints(),
            onPressed: () => toggleAutoplay(),
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 2, vertical: defaultPadding / 3),
            icon: const Icon(Icons.all_inclusive_rounded,
                color: secondaryAccentColor)),
      ]
    ];

    return StickyHeader(
        header: SizedBox(
            key: eventListHeaderKey,
            height: _stickyHeaderHeight,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    sectionHeaders[widget.currentSection]),
                            Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children:
                                          sectionActions[widget.currentSection])
                                ]),
                          ]))
                ])),
        content: ShaderMask(
            key: shaderMaskKey,
            shaderCallback: (bounds) =>
                _listShader(eventListHeaderKey, shaderMaskKey, bounds),
            blendMode: BlendMode.dstOut,
            child: Padding(
                padding: widget.currentSection == 1
                    ? const EdgeInsets.only(bottom: defaultPadding / 2)
                    : const EdgeInsets.only(bottom: defaultPadding),
                child: Container(
                    color: widget.currentSection == 1
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.15),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.currentSection == 0 ? 50 : 20,
                        primary: false,
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(
                                left: defaultPadding * 2,
                                right: defaultPadding + defaultPadding / 4.5),
                            child: ListTile(
                              textColor: secondaryColor,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: defaultPadding / 2.5),
                              leading: const Image(
                                  image: CachedNetworkImageProvider(
                                      "https://upload.wikimedia.org/wikipedia/en/1/17/The_Killers_-_Hot_Fuss.png"),
                                  fit: BoxFit.contain),
                              title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Somebody Told Me",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w400)),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: defaultPadding / 4),
                                        child: Text("The Killers",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color:
                                                        secondaryAccentColorMuted,
                                                    fontWeight:
                                                        FontWeight.w400)))
                                  ]),
                              trailing: widget.currentSection == 0
                                  ? null
                                  //reorder function
                                  : IconButton(
                                      onPressed: () => reorderList(),
                                      icon: const Icon(Icons.menu_rounded),
                                      color: secondaryAccentColorDark),
                            )))))));
  }

  Shader _listShader(
      GlobalKey listHeaderKey, GlobalKey shaderMaskKey, Rect rect) {
    final RenderBox listHeaderRenderBox =
        listHeaderKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = listHeaderRenderBox.localToGlobal(Offset.zero);

    final RenderBox shaderMaskRenderBox =
        shaderMaskKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset2 = shaderMaskRenderBox.globalToLocal(offset);

    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: <double>[
          0,
          (rect.top + offset2.dy + _stickyHeaderHeight - 5) / (rect.height),
          (rect.top + offset2.dy + _stickyHeaderHeight - 5) / (rect.height),
          1
        ],
        colors: const <Color>[
          Colors.white,
          Colors.white,
          Colors.transparent,
          Colors.transparent
        ]).createShader(Rect.fromLTWH(0, 0, rect.width, rect.height));
  }

  void reorderList() {
    //TODO implement this
  }

  void toggleShuffle() {
    //TODO implement this
  }

  void toggleRepeat() {
    //TODO implement this
  }

  void toggleAutoplay() {
    //TODO implement this
  }
}
