import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(
      {super.key,
      required this.title,
      this.padding = const EdgeInsets.only(top: 10),
      this.actions = const [],
      this.textStyle =
          const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      this.maxLines = 2});

  final String title;
  final EdgeInsets padding;
  final List<IconButton> actions;
  final TextStyle textStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Text(title,
                  textAlign: TextAlign.left,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle)),
          actions.isNotEmpty
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 6, top: 1),
                    itemCount: actions.length,
                    itemBuilder: (context, index) {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 22,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: actions[index].icon,
                            onPressed: actions[index].onPressed,
                          ));
                    },
                  ))
              : const SizedBox()
        ]);
  }
}
