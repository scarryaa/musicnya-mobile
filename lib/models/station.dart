import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/helpers/index_walker.dart';
import 'package:musicnya/interfaces/i_media_type.dart';

class Station<T> implements IMediaType<Station> {
  const Station(this.id, this.type, this.title, this.artworkUrl, this.artwork);

  Station.fromStation(Station station)
      : id = station.id,
        type = station.type,
        title = station.title,
        artworkUrl = station.artworkUrl,
        artwork = station.artwork;

  final String id;
  final Type type;
  final String title;
  final String artworkUrl;
  final CachedNetworkImage? artwork;

  @override
  factory Station.updateValues(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Station(
          IndexWalker(type)['id'].value as String,
          Station,
          IndexWalker(type)['title'].value,
          IndexWalker(type)['artworkUrl'].value,
          IndexWalker(type)['artwork'].value);
    } else {
      throw Exception(
          "No suitable method to convert Station from type ${type.runtimeType}");
    }
  }

  factory Station.from(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Station(
          IndexWalker(type)['id'].value as String,
          Station,
          IndexWalker(type)['attributes']['name'].value as String,
          IndexWalker(type)['attributes']['artwork']['url'].value as String,
          null);
    } else if (type is LinkedHashMap) {
      return Station(
          IndexWalker(type)['id'].value as String,
          Station,
          IndexWalker(type)['attributes']['name'].value as String,
          IndexWalker(type)['attributes']['artwork']['url'].value as String,
          null);
    } else if (type is LinkedHashSet) {
      var set = type;
      return Station(set.first.id, set.first.type, set.first.title,
          set.first.artworkUrl, set.first.artwork);
    } else if (type is Station<dynamic>) {
      return Station.fromStation(type);
    } else {
      throw Exception(
          "No suitable method to convert Station from type ${type.runtimeType}");
    }
  }

  @override
  CachedNetworkImage getArtwork({int size = 300}) {
    return artwork ??
        CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: artworkUrl
                .replaceFirst('{w}', size.toString())
                .replaceFirst('{h}', size.toString()));
  }

  @override
  String getArtworkUrl({int size = 300}) {
    return artworkUrl
        .replaceFirst('{w}', size.toString())
        .replaceFirst('{h}', size.toString());
  }

  @override
  String calculatePlaybackLength() {
    throw UnsupportedError(
        "Stations do not have a tracklist, so length cannot be determined.");
  }

  @override
  List<dynamic> checkMissingProperties(Station s) {
    s.toMap().forEach((key, value) {
      (s.toMap().update(key, (value) => value));
    });

    List refreshProps = s
        .toMap()
        .values
        .where((element) => (element == null ||
            element == '' ||
            (element is List && element.isEmpty) ||
            element == '0'))
        .toList();
    return refreshProps;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'artworkUrl': artworkUrl,
      'artwork': artwork
    };
  }
}
