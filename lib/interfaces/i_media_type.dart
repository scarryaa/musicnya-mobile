import 'package:cached_network_image/cached_network_image.dart';
import 'package:musicnya/models/album.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/models/song.dart';
import 'package:musicnya/models/station.dart';

abstract class IMediaType<T> {
  CachedNetworkImage getArtwork({int size});
  String getArtworkUrl({int size});
  Map<String, dynamic> toMap();
  List<dynamic> checkMissingProperties(T t);
  String calculatePlaybackLength();

  factory IMediaType.from(dynamic type) {
    switch (type.runtimeType) {
      case Album:
        return Album.from(type) as IMediaType<T>;
      case Song:
        return Song.from(type) as IMediaType<T>;
      case Station:
        return Station.from(type) as IMediaType<T>;
      case Playlist:
        return Playlist.from(type) as IMediaType<T>;
      default:
        throw Exception("Cannot convert ${type.type} to supported content.");
    }
  }

  factory IMediaType.updateValues(dynamic type) {
    switch (type['type']) {
      case Album:
        return Album.updateValues(type) as IMediaType<T>;
      case Song:
        return Song.updateValues(type) as IMediaType<T>;
      case Station:
        return Station.updateValues(type) as IMediaType<T>;
      case Playlist:
        return Playlist.updateValues(type) as IMediaType<T>;
      default:
        throw Exception("Cannot update ${type.type} to supported content.");
    }
  }
}
