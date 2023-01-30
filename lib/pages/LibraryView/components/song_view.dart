import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/assets/ui_components/square_tile.dart';

Widget songView(int localSelection) {
  return Column(children: [
    Flexible(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 20,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) => index == 0
                ? Padding(
                    padding: const EdgeInsets.only(top: defaultPadding / 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              height: 30,
                              child: Row(children: [
                                IconButton(
                                  padding: const EdgeInsets.fromLTRB(
                                      defaultPadding / 1.5,
                                      defaultPadding / 8,
                                      defaultPadding / 4,
                                      defaultPadding / 8),
                                  splashRadius: 1,
                                  alignment: Alignment.center,
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.arrow_drop_down_rounded),
                                  constraints: const BoxConstraints(),
                                ),
                                const Text("Recents")
                              ])),
                          IconButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding / 8,
                                horizontal: defaultPadding / 1.5),
                            splashRadius: 1,
                            alignment: Alignment.center,
                            onPressed: () {},
                            icon: const Icon(Icons.grid_view),
                            constraints: const BoxConstraints(),
                          ),
                        ]))
                : localSelection == 1
                    ? ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 4,
                            horizontal: defaultPadding / 1.1),
                        visualDensity: const VisualDensity(vertical: 4),
                        onTap: () {},
                        title: const Text("Test song"),
                        horizontalTitleGap: defaultPadding / 1.4,
                        leading: SizedBox(
                            width: 68,
                            height: 68,
                            child: SquareTile(
                                size: 68,
                                padding: const EdgeInsets.all(0),
                                image: CachedNetworkImage(
                                    fadeInDuration:
                                        const Duration(microseconds: 1),
                                    imageUrl:
                                        'https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/300x300bb.jpg'))),
                      )
                    : ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 4,
                            horizontal: defaultPadding / 1.1),
                        visualDensity: const VisualDensity(vertical: 4),
                        onTap: () {},
                        title: const Text("AM Test song"),
                        horizontalTitleGap: defaultPadding / 1.4,
                        leading: SizedBox(
                            width: 68,
                            height: 68,
                            child: SquareTile(
                                size: 68,
                                padding: const EdgeInsets.all(0),
                                image: CachedNetworkImage(
                                    fadeInDuration:
                                        const Duration(microseconds: 1),
                                    imageUrl:
                                        'https://is3-ssl.mzstatic.com/image/thumb/Music112/v4/03/45/19/034519dc-9ff9-7f63-3d02-23a101a0cc3a/22UMGIM01299.rgb.jpg/300x300bb.jpg'))),
                      ))),
  ]);
}
