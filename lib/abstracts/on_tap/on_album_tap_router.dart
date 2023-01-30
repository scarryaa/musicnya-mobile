import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/abstracts/on_tap/on_tap_router.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/album.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:musicnya/services/navigation_service.dart';

/// Handles tap action on album tiles
class OnAbumTapRouter implements OnTapRouter {
  static void handleTap(BuildContext? context, IMediaType album) async {
    List refreshProps = album.checkMissingProperties(album);
    if (refreshProps.isNotEmpty) {
      Album results;
      try {
        results = await MusicPlayer().getAlbum((album as Album).id);
      } catch (_) {
        return (Future.error(_));
      }

      var contentMap = album.toMap();

      contentMap.forEach((key, value) {
        contentMap.update(key, (value) => results.toMap()[key]);
      });

      album = Album.updateValues(contentMap);
      album.calculatePlaybackLength();
    }

    GetIt.I<NavigationService>().toggleAlbumView(context!, arguments: {album});
  }
}
