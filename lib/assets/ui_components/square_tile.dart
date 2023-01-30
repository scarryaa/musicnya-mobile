import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:musicnya/assets/constants.dart';
import 'subheader_xs.dart';

class SquareTile extends StatelessWidget {
  SquareTile(
      {super.key,
      this.title = "",
      this.subtitle = "",
      required this.image,
      this.padding = const EdgeInsets.all(defaultPadding / 4),
      this.size = 158,
      this.rounded = true,
      this.textAlign = Alignment.topLeft});

  final String title;
  final String subtitle;
  final CachedNetworkImage image;
  final tmpImage =
      Image.network("https://pbs.twimg.com/media/Ejqik1oU4AE4-S8.jpg:large")
          .image;
  final EdgeInsets padding;
  final double size;
  final bool rounded;
  final Alignment textAlign;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size + (title.isNotEmpty ? 40 : 0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: size,
                  height: size,
                  child: rounded
                      ? Card(
                          clipBehavior: Clip.hardEdge,
                          borderOnForeground: true,
                          margin: EdgeInsets.fromLTRB(padding.left, padding.top,
                              padding.right, padding.bottom),
                          child: image)
                      : Container(
                          clipBehavior: Clip.none,
                          padding: padding,
                          child: image)),
              title.isNotEmpty
                  ? Expanded(
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: defaultPadding / 4),
                          child: SizedBox(
                              width: size,
                              child: SubheaderXS(
                                title: title,
                              ))))
                  : const SizedBox.shrink()
            ]));
  }
}
