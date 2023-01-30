import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/helpers/index_walker.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/song.dart';

class Playlist<T> implements IMediaType<Playlist> {
  const Playlist(
      this.id,
      this.type,
      this.title,
      this.artwork,
      this.artworkUrl,
      this.url,
      this.curatorName,
      this.description,
      this.shortDescription,
      this.tracks);

  Playlist.fromPlaylist(Playlist playlist)
      : id = playlist.id,
        type = playlist.type,
        title = playlist.title,
        artwork = playlist.artwork,
        url = playlist.url,
        curatorName = playlist.curatorName,
        description = playlist.description,
        shortDescription = playlist.shortDescription,
        artworkUrl = playlist.artworkUrl,
        tracks = playlist.tracks;

  final String id;
  final Type type;
  final String title;
  final CachedNetworkImage? artwork;
  final String artworkUrl;
  final String url;
  final String curatorName;
  final String description;
  final String shortDescription;
  final List<Song> tracks;

  @override
  factory Playlist.updateValues(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Playlist(
          IndexWalker(type)['id'].value as String,
          Playlist,
          IndexWalker(type)['title'].value,
          IndexWalker(type)['artwork'].value,
          IndexWalker(type)['artworkUrl'].value,
          IndexWalker(type)['url'].value,
          IndexWalker(type)['curatorName'].value,
          IndexWalker(type)['description'].value,
          IndexWalker(type)['shortDescription'].value,
          IndexWalker(type)['tracks'].value);
    } else {
      throw Exception(
          "No suitable method to convert Station from type ${type.runtimeType}");
    }
  }

  factory Playlist.from(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Playlist(
          IndexWalker(type)['id'].value as String,
          Playlist,
          IndexWalker(type)['attributes']['name'].value as String,
          null,
          IndexWalker(type)['attributes']['artwork']['url'].value as String,
          IndexWalker(type)['attributes']['url'].value,
          IndexWalker(type)['attributes']['curatorName'].value,
          IndexWalker(type)['attributes']['description']['standard'].value,
          IndexWalker(type)['attributes']['description']['short'].value,
          IndexWalker(type)['relationships']['tracks']['data'].value != null
              ? IndexWalker(type)['relationships']['tracks']['data']
                  .value
                  .map<Song>((i) {
                  return Song.from(i, IndexWalker(type)['id'].value as String);
                }).toList()
              : []);
    } else if (type is LinkedHashMap) {
      return Playlist(
          IndexWalker(type)['id'].value as String,
          Playlist,
          IndexWalker(type)['attributes']['name'].value as String,
          null,
          IndexWalker(type)['attributes']['artwork']['url'].value as String,
          IndexWalker(type)['attributes']['url'].value,
          IndexWalker(type)['attributes']['curatorName'].value,
          IndexWalker(type)['attributes']['description']['standard'].value,
          IndexWalker(type)['attributes']['description']['short'].value,
          IndexWalker(type)['relationships']['tracks']['data'].value != null
              ? IndexWalker(type)['relationships']['tracks']['data']
                  .value
                  .map<Song>((i) {
                  return Song.from(i, IndexWalker(type)['id'].value as String);
                }).toList()
              : []);
    } else if (type is LinkedHashSet) {
      var set = type;
      return Playlist(
          set.first.id,
          set.first.type,
          set.first.title,
          set.first.artwork,
          set.first.url,
          set.first.curatorName,
          set.first.description,
          set.first.shortDescription,
          set.first.tracks,
          set.first.artworkUrl);
    } else if (type is Playlist<dynamic>) {
      return Playlist.fromPlaylist(type);
    } else {
      throw Exception(
          "No suitable method to convert Playlist from type ${type.runtimeType}");
    }
  }

  @override
  String getArtworkUrl({int size = 300}) {
    return artworkUrl
        .replaceFirst('{w}', size.toString())
        .replaceFirst('{h}', size.toString());
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
  String calculatePlaybackLength() {
    int lengthInMiliseconds = 0;
    for (var track in tracks) {
      lengthInMiliseconds += int.parse(track.playbackLength);
    }
    return lengthInMiliseconds.toString();
  }

  @override
  List<dynamic> checkMissingProperties(Playlist p) {
    p.toMap().forEach((key, value) {
      (p.toMap().update(key, (value) => value));
    });

    List refreshProps = p
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
      'artwork': artwork,
      'artworkUrl': artworkUrl,
      'url': url,
      'curatorName': curatorName,
      'description': description,
      'shortDescription': shortDescription,
      'tracks': tracks,
    };
  }
}
