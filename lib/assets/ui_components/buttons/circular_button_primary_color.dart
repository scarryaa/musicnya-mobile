import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/helpers/color_helper.dart';

class CircularButtonPrimaryColor extends StatefulWidget {
  const CircularButtonPrimaryColor(
      {super.key,
      this.onTap,
      this.splashColor,
      this.iconColor,
      this.icon,
      this.iconSize = 50,
      this.backgroundColor,
      this.elevated = false,
      this.padding,
      this.iconPadding});

  final void Function()? onTap;
  final Color? splashColor;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final Color? backgroundColor;
  final bool elevated;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;

  @override
  State<StatefulWidget> createState() => CircularButtonPrimaryColorState();
}

class CircularButtonPrimaryColorState
    extends State<CircularButtonPrimaryColor> {
  final _defaultIconPadding = const EdgeInsets.all(defaultPadding / 2.5);
  final _defaultPadding = EdgeInsets.only(
      right: defaultPadding / 1.5, bottom: topAppBarHeightCompact / 4);
  final _defaultBackgroundColor = lighten(primaryColor, 0.1);
  final _defaultIconColor = darken(primaryColor, 0.35);
  final _defaultSplashColor = lighten(primaryColor, 0.2);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ?? _defaultPadding,
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: widget.elevated
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: ClipOval(
                child: Material(
                    color: widget.backgroundColor ?? _defaultBackgroundColor,
                    type: MaterialType.button,
                    child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => widget.onTap,
                        splashColor: widget.splashColor ?? _defaultSplashColor,
                        child: Padding(
                            padding: widget.iconPadding ?? _defaultIconPadding,
                            child: Icon(widget.icon,
                                size: widget.iconSize,
                                color: widget.iconColor ??
                                    _defaultIconColor)))))));
  }
}
