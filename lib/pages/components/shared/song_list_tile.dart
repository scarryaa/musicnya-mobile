import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/helpers/color_helper.dart';

class SongListTile extends StatefulWidget {
  const SongListTile(
      {super.key,
      this.swipeRightAction,
      this.swipeLeftAction,
      this.swipeLeftBackgroundColor,
      this.swipeRightBackgroundColor,
      this.swipeLeftIcon,
      this.swipeRightIcon,
      this.swipeIconSize = 24,
      this.swipeIconColor = secondaryColor,
      this.onTap,
      this.tileSplashColor,
      this.tileVerticalPadding,
      this.showSongNumber = true,
      required this.tileText,
      this.trailing,
      this.showDivider = true,
      required this.index});

  final void Function()? onTap;
  final void Function()? swipeRightAction;
  final void Function()? swipeLeftAction;
  final Color? swipeLeftBackgroundColor;
  final Color? swipeRightBackgroundColor;
  final Widget? swipeLeftIcon;
  final Widget? swipeRightIcon;
  final double swipeIconSize;
  final Color? swipeIconColor;
  final Color? tileSplashColor;
  final double? tileVerticalPadding;
  final bool showSongNumber;
  final Text tileText;
  final Widget? trailing;
  final bool showDivider;
  final int index;

  @override
  State<StatefulWidget> createState() => SongListTileState();
}

class SongListTileState extends State<SongListTile> {
  final Color _defaultSwipeLeftBackgroundColor =
      Colors.blue.shade400.withAlpha(180);
  final Color _defaultSwipeRightBackgroundColor =
      Colors.red.shade400.withAlpha(180);
  final Color _defaultTileSplashColor =
      lighten(primaryColor, 0.2).withOpacity(0.2);
  final double _defaulTtileVerticalPadding = 19;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            //TODO implement play next
            widget.swipeRightAction;
          } else if (direction == DismissDirection.endToStart) {
            //TODO implement play last
            widget.swipeLeftAction;
          }
          return Future.value(false);
        },
        direction: DismissDirection.horizontal,
        background: Container(
            color: widget.swipeLeftBackgroundColor ??
                _defaultSwipeRightBackgroundColor,
            child: Padding(
                padding: const EdgeInsets.all(0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  IconButton(
                    icon: widget.swipeLeftIcon ?? const SizedBox.shrink(),
                    iconSize: widget.swipeIconSize,
                    color: widget.swipeIconColor,
                    onPressed: () {},
                  )
                ]))),
        secondaryBackground: Container(
            color: widget.swipeLeftBackgroundColor ??
                _defaultSwipeLeftBackgroundColor,
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 8),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    icon: widget.swipeRightIcon ?? const SizedBox.shrink(),
                    iconSize: widget.swipeIconSize,
                    color: widget.swipeIconColor,
                    onPressed: () {},
                  )
                ]))),
        key: UniqueKey(),
        child: Column(children: [
          Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.onTap,
                splashColor: widget.tileSplashColor ?? _defaultTileSplashColor,
                child: ListTile(
                    minVerticalPadding: widget.tileVerticalPadding ??
                        _defaulTtileVerticalPadding,
                    leading: widget.showSongNumber
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                    padding: widget.index < 10
                                        ? const EdgeInsets.only(
                                            left: defaultPadding)
                                        : const EdgeInsets.only(
                                            left: defaultPadding - 7),
                                    child: Text('${widget.index}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: secondaryAccentColorMuted)))
                              ])
                        : null,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    minLeadingWidth: 12,
                    contentPadding: EdgeInsets.zero,
                    title: widget.tileText,
                    trailing: widget.trailing),
              )),
          if (widget.showDivider)
            Divider(
              color: Colors.grey.withOpacity(0.15),
              thickness: 1,
              height: 1,
            ),
        ]));
  }
}
