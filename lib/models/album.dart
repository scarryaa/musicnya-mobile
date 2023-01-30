import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/song.dart';

import '../helpers/index_walker.dart';

class Album<T> implements IMediaType<Album> {
  Album(this.id, this.type, this.tracks, this.title, this.artist, this.genres,
      this.releaseDate, this.albumCoverUrl, this.albumCover, this.copyrightInfo,
      {this.playbackLength = "0"});

  @override
  Album.fromAlbum(Album album)
      : id = album.id,
        type = album.type,
        tracks = album.tracks,
        title = album.title,
        artist = album.artist,
        genres = album.genres,
        releaseDate = album.releaseDate,
        albumCoverUrl = album.albumCoverUrl,
        albumCover = album.albumCover,
        playbackLength = album.playbackLength,
        copyrightInfo = album.copyrightInfo;

  final String id;
  final Type type;
  List<Song>? tracks;
  final String title;
  final String artist;
  final List<String> genres;
  final String releaseDate;
  final String albumCoverUrl;
  final CachedNetworkImage? albumCover;
  final String playbackLength;
  final String copyrightInfo;

  @override
  factory Album.updateValues(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Album(
          IndexWalker(type)['id'].value as String,
          Album,
          IndexWalker(type)['tracks'].value,
          IndexWalker(type)['title'].value,
          IndexWalker(type)['artist'].value,
          IndexWalker(type)['genres'].value,
          IndexWalker(type)['releaseDate'].value,
          IndexWalker(type)['albumCoverUrl'].value,
          IndexWalker(type)['albumCover'].value,
          (IndexWalker(type)['copyrightInfo'].value as String));
    } else {
      throw Exception(
          "No suitable method to convert Album from type ${type.runtimeType}");
    }
  }

  @override
  factory Album.from(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Album(
          IndexWalker(type)['id'].value as String,
          Album,
          IndexWalker(type)['relationships']['tracks']['data'].value != null
              ? IndexWalker(type)['relationships']['tracks']['data']
                  .value
                  .map<Song>((i) {
                  return Song.from(i, IndexWalker(type)['id'].value as String);
                }).toList()
              : [],
          IndexWalker(type)['attributes']['name'].value as String,
          IndexWalker(type)['attributes']['artistName'].value as String,
          (IndexWalker(type)['attributes']['genreNames'].value as List)
              .map((i) => i as String)
              .where((i) => i != "Music")
              .toList(),
          IndexWalker(type)['attributes']['releaseDate'].value as String,
          (IndexWalker(type)['attributes']['artwork']['url'].value as String),
          CachedNetworkImage(
              imageUrl: (IndexWalker(type)['attributes']['artwork']['url'].value
                  as String)),
          (IndexWalker(type)['attributes']['copyright'].value as String));
    } else if (type is LinkedHashMap) {
      return Album(
          IndexWalker(type)['id'].value as String,
          Album,
          (IndexWalker(type)['relationships']['tracks']['data'].value as List)
              .map((i) => Song.from(i))
              .toList(),
          IndexWalker(type)['attributes']['name'].value as String,
          IndexWalker(type)['attributes']['artistName'].value as String,
          (IndexWalker(type)['attributes']['genreNames'].value as List)
              .map((i) => i as String)
              .where((i) => i != "Music")
              .toList(),
          IndexWalker(type)['attributes']['releaseDate'].value as String,
          (IndexWalker(type)['attributes']['artwork']['url'].value as String),
          CachedNetworkImage(
              imageUrl: (IndexWalker(type)['attributes']['artwork']['url'].value
                  as String)),
          (IndexWalker(type)['attributes']['copyright'].value as String));
    } else if (type is LinkedHashSet) {
      var set = type;
      return Album(
          set.first.id,
          set.first.type,
          set.first.tracks,
          set.first.title,
          set.first.artist,
          set.first.genres,
          set.first.releaseDate,
          set.first.albumCoverUrl,
          set.first.albumCover,
          set.first.copyrightInfo);
    } else if (type is Album<dynamic>) {
      return Album.fromAlbum(type);
    } else {
      throw Exception(
          "No suitable method to convert Album from type ${type.runtimeType}");
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'tracks': tracks,
      'title': title,
      'artist': artist,
      'genres': genres,
      'releaseDate': releaseDate,
      'albumCoverUrl': albumCoverUrl,
      'playbackLength': playbackLength,
      'copyrightInfo': copyrightInfo,
    };
  }

  @override
  String getArtworkUrl({int size = 300}) {
    return albumCoverUrl
        .replaceFirst('{w}', size.toString())
        .replaceFirst('{h}', size.toString());
  }

  @override
  List<dynamic> checkMissingProperties(Album a) {
    a.toMap().forEach((key, value) {
      (a.toMap().update(key, (value) => value));
    });

    List refreshProps = a
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
  String calculatePlaybackLength() {
    int lengthInMiliseconds = 0;
    for (var track in tracks!) {
      lengthInMiliseconds += int.parse(track.playbackLength);
    }
    return lengthInMiliseconds.toString();
  }

  @override
  CachedNetworkImage getArtwork({int size = 300}) {
    return albumCover ??
        CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: albumCoverUrl
                .replaceFirst('{w}', size.toString())
                .replaceFirst('{h}', size.toString()));
  }
}
