import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/abstracts/on_tap/on_tap_router.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:musicnya/services/navigation_service.dart';

/// Handles tap action on playlist tiles
class OnPlaylistTapRouter implements OnTapRouter {
  static void handleTap(BuildContext? context, IMediaType playlist) async {
    List refreshProps = playlist.checkMissingProperties(playlist);
    if (refreshProps.isNotEmpty) {
      Playlist results;
      try {
        results = await MusicPlayer().getPlaylist((playlist as Playlist).id);
      } catch (_) {
        return (Future.error(_));
      }

      var contentMap = playlist.toMap();

      contentMap.forEach((key, value) {
        contentMap.update(key, (value) => results.toMap()[key]);
      });

      playlist = Playlist.updateValues(contentMap);
      playlist.calculatePlaybackLength();
    }

    GetIt.I<NavigationService>()
        .togglePlaylistView(context!, arguments: {playlist});
  }
}
