import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/helpers/index_walker.dart';
import 'dart:collection';

import 'package:musicnya/interfaces/i_media_type.dart';

class Song<T> implements IMediaType<Song> {
  const Song(this.id, this.type, this.title, this.albumCoverUrl, this.artist,
      this.albumCover, this.albumId, this.playbackLength);

  Song.fromSong(Song song)
      : id = song.id,
        type = song.type,
        title = song.title,
        albumCoverUrl = song.albumCoverUrl,
        artist = song.artist,
        albumCover = song.albumCover,
        albumId = song.albumId,
        playbackLength = song.playbackLength;

  final String id;
  final Type type;
  final String title;
  final String albumCoverUrl;
  final CachedNetworkImage? albumCover;
  final String artist;
  final String? albumId;
  final String playbackLength;

  @override
  factory Song.updateValues(dynamic type) {
    if (type is Map<dynamic, Object?>) {
      return Song(
          IndexWalker(type)['id'].value as String,
          Song,
          IndexWalker(type)['title'].value,
          IndexWalker(type)['albumCoverUrl'].value,
          IndexWalker(type)['artist'].value,
          IndexWalker(type)['albumCover'].value,
          IndexWalker(type)['albumId'].value,
          IndexWalker(type)['playbackLength'].value);
    } else {
      throw Exception(
          "No suitable method to convert Song from type ${type.runtimeType}");
    }
  }

  factory Song.from(dynamic type, [String? id]) {
    if (id != null) {
      return Song(
          IndexWalker(type)['id'].value as String,
          Song,
          IndexWalker(type)['attributes']['name'].value as String,
          (IndexWalker(type)['attributes']['artwork']['url'].value as String),
          IndexWalker(type)['attributes']['artistName'].value as String,
          null,
          id,
          IndexWalker(type)['attributes']['durationInMillis'].value.toString());
    } else {
      if (type is Map<dynamic, Object?>) {
        return Song(
            IndexWalker(type)['id'].value as String,
            Song,
            IndexWalker(type)['attributes']['name'].value as String,
            (IndexWalker(type)['attributes']['artwork']['url'].value as String),
            IndexWalker(type)['attributes']['artistName'].value as String,
            null,
            IndexWalker(type)['relationships']['albums']['data'][0]['id']
                    .value ??
                '',
            IndexWalker(type)['attributes']['durationInMillis']
                .value
                .toString());
      } else if (type is LinkedHashMap) {
        return Song(
            IndexWalker(type)['id'].value as String,
            Song,
            IndexWalker(type)['attributes']['name'].value as String,
            (IndexWalker(type)['attributes']['artwork']['url'].value as String),
            IndexWalker(type)['attributes']['artistName'].value as String,
            null,
            IndexWalker(type)['relationships']['albums']['data'][0]['id'].value
                as String,
            IndexWalker(type)['attributes']['durationInMillis']
                .value
                .toString());
      } else if (type is LinkedHashSet) {
        var set = type;
        return Song(
            set.first.id,
            set.first.type,
            set.first.title,
            set.first.albumCoverUrl,
            set.first.albumCover,
            set.first.artist,
            set.first.albumId,
            set.first.playbackLength);
      } else if (type is Song<dynamic>) {
        return Song.fromSong(type);
      } else {
        throw Exception(
            "No suitable method to convert song from type ${type.runtimeType}");
      }
    }
  }

  @override
  String calculatePlaybackLength() {
    return playbackLength;
  }

  @override
  List<dynamic> checkMissingProperties(Song s) {
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
  String getArtworkUrl({int size = 300}) {
    return albumCoverUrl
        .replaceFirst('{w}', size.toString())
        .replaceFirst('{h}', size.toString());
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'albumCoverUrl': albumCoverUrl,
      'artist': artist,
      'albumCover': albumCover,
      'albumId': albumId,
      'playbackLength': playbackLength,
    };
  }
}
