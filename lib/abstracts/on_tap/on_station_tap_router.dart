import 'package:flutter/material.dart';
import 'package:musicnya/abstracts/on_tap/on_tap_router.dart';
import 'package:musicnya/interfaces/i_media_type.dart';
import 'package:musicnya/models/station.dart';
import 'package:musicnya/services/music_player.dart';

/// Handles tap action on station tiles
class OnStationTapRouter implements OnTapRouter {
  static void handleTap(BuildContext? context, IMediaType station) async {
    List refreshProps = station.checkMissingProperties(station);
    if (refreshProps.isNotEmpty) {
      Station result;
      try {
        result = await MusicPlayer().getStation((station as Station).id);
      } catch (_) {
        return (Future.error(_));
      }

      var contentMap = station.toMap();

      contentMap.forEach((key, value) {
        contentMap.update(key, (value) => result.toMap()[key]);
      });

      station = Station.updateValues(contentMap);
    }

    //Start playing the station
    //station.play();
  }
}
