import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';

class OutlinedIconButton extends StatefulWidget {
  const OutlinedIconButton(
      {super.key,
      this.onTap,
      this.iconColor,
      this.icon,
      this.iconSize = 30,
      this.padding,
      this.iconPadding});

  final void Function()? onTap;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;

  @override
  State<StatefulWidget> createState() => OutlinedIconButtonState();
}

class OutlinedIconButtonState extends State<OutlinedIconButton> {
  final _defaultIconPadding = const EdgeInsets.all(defaultPadding / 2.5);
  final _defaultPadding =
      const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5);
  final _defaultIconColor = secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ?? _defaultPadding,
        child: ClipOval(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                        padding: widget.iconPadding ?? _defaultIconPadding,
                        child: Icon(widget.icon,
                            size: widget.iconSize,
                            color: widget.iconColor ?? _defaultIconColor))))));
  }
}
