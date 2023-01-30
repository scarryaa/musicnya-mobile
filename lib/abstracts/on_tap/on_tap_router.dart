import 'package:flutter/material.dart';
import 'package:musicnya/abstracts/on_tap/on_album_tap_router.dart';
import 'package:musicnya/abstracts/on_tap/on_playlist_tap_router.dart';
import 'package:musicnya/abstracts/on_tap/on_station_tap_router.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/album.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/models/song.dart';
import 'package:musicnya/models/station.dart';

abstract class OnTapRouter<T> {
  static void handleTap(BuildContext? context, IMediaType type) {
    switch (type.runtimeType) {
      case Album:
        OnAbumTapRouter.handleTap(context, type);
        break;
      case Song:
        //TODO implement this
        break;
      case Station:
        OnStationTapRouter.handleTap(context, type);
        break;
      case Playlist:
        OnPlaylistTapRouter.handleTap(context, type);
        break;
      default:
        throw Exception("No valid tap handler found for ${type.runtimeType}.");
    }
  }
}
