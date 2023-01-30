import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:musicnya/assets/constants.dart';
import 'subheader_xs.dart';

class RectangleTile extends StatelessWidget {
  RectangleTile(
      {super.key,
      required this.title,
      required this.image,
      this.padding = const EdgeInsets.all(defaultPadding / 4),
      this.width = 198,
      this.height = 75});

  final String title;
  final CachedNetworkImage image;
  final tmpImage =
      Image.network("https://pbs.twimg.com/media/Ejqik1oU4AE4-S8.jpg:large")
          .image;
  final EdgeInsets padding;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height + (title.isNotEmpty ? 40 : 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: width,
                  height: height,
                  child: Card(
                      clipBehavior: Clip.hardEdge,
                      margin: padding,
                      borderOnForeground: true,
                      color: Colors.transparent,
                      child: image)),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: defaultPadding / 4),
                      child: SizedBox(
                        width: width,
                        child: SubheaderXS(title: title),
                      )))
            ]));
  }
}
