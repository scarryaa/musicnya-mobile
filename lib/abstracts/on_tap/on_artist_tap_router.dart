// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:musicnya/abstracts/on_tap/on_tap_router.dart';
// import 'package:musicnya/interfaces/i_media_type.dart';
// import 'package:musicnya/models/album.dart';
// import 'package:musicnya/services/music_player.dart';
// import 'package:musicnya/services/navigation_service.dart';

// class OnArtistTapRouter implements OnTapRouter {
//   @override
//   void handleTap(BuildContext? context, IMediaType artist) async {
//     List refreshProps = artist.checkMissingProperties(artist);
//     if (refreshProps.isNotEmpty) {
//       Album results;
//       try {
//         results = await MusicPlayer().getAlbum((artist as Artist).id);
//       } catch (_) {
//         return (Future.error(_));
//       }

//       var contentMap = artist.toMap();

//       contentMap.forEach((key, value) {
//         contentMap.update(key, (value) => results.toMap()[key]);
//       });

//       artist = Artist.updateValues(contentMap);
//       artist.calculatePlaybackLength();
//     }

//     GetIt.I<NavigationService>().toggleAlbumView(context!, arguments: {artist});
//   }
// }
