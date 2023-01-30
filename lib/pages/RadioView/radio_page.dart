import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/assets/ui_components/square_tile.dart';
import '../../models/station.dart';
import '../../services/music_player.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<StatefulWidget> createState() => RadioPageState();
}

class RadioPageState extends State<RadioPage> {
  late Future<List<Station>> futureStations;

  @override
  void initState() {
    super.initState();
    futureStations = MusicPlayer().getStations();
  }

  @override
  Widget build(Object context) {
    return FutureBuilder<List<Station>>(
        future: futureStations,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              child: Card(
                  color: Colors.grey.shade400,
                  child: Center(
                      child: Text(
                          "Could not get stations at this time. ${snapshot.error}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)))),
            );
          } else if (snapshot.hasData) {
            var values = snapshot.hasData
                ? (snapshot.data as List).isNotEmpty
                    ? (snapshot.data as List)
                        .map((e) => Station.from(e))
                        .toList()
                    : []
                : null;
            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: values?.length ?? 0,
                itemExtent: screenWidth / 3.15,
                padding: const EdgeInsets.fromLTRB(
                    defaultPadding / 1.5, 0, defaultPadding / 1.5, 0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      child: SquareTile(
                          title: values?[index].title,
                          size: screenWidth / 3.15,
                          padding: index == 0
                              ? const EdgeInsets.fromLTRB(0, defaultPadding / 4,
                                  defaultPadding / 4, defaultPadding / 4)
                              : index == 1
                                  ? const EdgeInsets.fromLTRB(
                                      defaultPadding / 8,
                                      defaultPadding / 4,
                                      defaultPadding / 4,
                                      defaultPadding / 4)
                                  : const EdgeInsets.all(defaultPadding / 4),
                          image: CachedNetworkImage(
                              fadeInDuration: const Duration(microseconds: 1),
                              imageUrl: values?[index].getArtworkUrl())));
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
