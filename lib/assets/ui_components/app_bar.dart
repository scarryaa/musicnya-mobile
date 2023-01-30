import 'package:flutter/material.dart' as material;
import 'package:musicnya/assets/constants.dart';

import 'header.dart';
import 'subheader_small.dart';

class AppBar extends material.StatefulWidget {
  const AppBar(
      {super.key,
      required this.title,
      required this.child,
      this.actions = const [],
      this.leading = const [],
      this.compact = false,
      this.bottomBorder = true});

  final String title;
  final material.Widget child;
  final List<material.Widget> actions;
  final List<material.Widget> leading;
  final bool compact;
  final bool bottomBorder;

  @override
  material.State<material.StatefulWidget> createState() => AppBarState();
}

class AppBarState extends material.State<AppBar> {
  late bool compact;

  @override
  void initState() {
    compact = widget.compact;
    super.initState();
  }

  @override
  material.Widget build(material.BuildContext context) {
    material.ScrollController controller = material.ScrollController();
    controller.addListener(() {
      if (controller.position.atEdge && controller.position.pixels == 0) {
        setState(() => compact = false);
      } else {
        setState(() => compact = true);
      }
    });

    material.Widget leading = const material.SizedBox.shrink();
    if (widget.leading.isNotEmpty) {
      leading = material.Row(
        mainAxisSize: material.MainAxisSize.min,
        crossAxisAlignment: material.CrossAxisAlignment.end,
        children: widget.actions,
      );
    }

    material.Widget actions = const material.SizedBox();
    if (widget.actions.isNotEmpty) {
      actions = material.Padding(
          padding: compact
              ? const material.EdgeInsets.fromLTRB(
                  defaultPadding / 8, 0, defaultPadding / 8, 0)
              : const material.EdgeInsets.symmetric(
                  horizontal: defaultPadding / 16,
                  vertical: defaultPadding / 4),
          child: material.Theme(
              data: material.ThemeData(
                  iconTheme: material.IconThemeData(size: compact ? 30 : 35)),
              child: material.ConstrainedBox(
                  constraints: const material.BoxConstraints(),
                  child: material.Row(
                    mainAxisSize: material.MainAxisSize.min,
                    mainAxisAlignment: material.MainAxisAlignment.start,
                    crossAxisAlignment: material.CrossAxisAlignment.center,
                    children: widget.actions,
                  ))));
    }

    return material.Column(
        mainAxisSize: material.MainAxisSize.max,
        crossAxisAlignment: material.CrossAxisAlignment.start,
        children: [
          material.SizedBox(
              height: compact ? topAppBarHeightCompact : topAppBarHeight,
              child: material.NavigationToolbar(
                  middleSpacing: widget.leading.isEmpty ? 11 : 20,
                  leading: leading,
                  middle: compact
                      ? SubheaderSmall(
                          title: widget.title,
                          textStyle:
                              material.Theme.of(context).textTheme.titleLarge ??
                                  const material.TextStyle(),
                          //TODO figure out way to make IconButton closer to the top?
                          padding: const material.EdgeInsets.only(top: 4))
                      : Header(title: widget.title),
                  centerMiddle: false,
                  trailing: actions)),
          material.Padding(
              padding: (compact
                  ? widget.bottomBorder
                      ? const material.EdgeInsets.all(0)
                      : const material.EdgeInsets.symmetric(
                          horizontal: defaultPadding / 1.5)
                  : widget.bottomBorder
                      ? const material.EdgeInsets.symmetric(
                          horizontal: defaultPadding / 1.25)
                      : const material.EdgeInsets.all(0)),
              child: widget.bottomBorder
                  ? (const material.Divider(
                      thickness: 0.5,
                      color: material.Colors.grey,
                      height: 1,
                    ))
                  : null),
          material.Expanded(
              child: material.SingleChildScrollView(
            controller: controller,
            padding: material.EdgeInsets.only(bottom: bottomAppBarHeight),
            physics: const material.AlwaysScrollableScrollPhysics(),
            child: widget.child,
          ))
        ]);
  }
}
