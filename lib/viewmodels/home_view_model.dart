import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'dart:math' as math;

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.mainVm) {
    // futureUserHeavyRotationImages =
    //     Future.wait([futureUserHeavyRotation]).then((value) {
    //   List<CachedNetworkImage> images = [];
    //   value[0].forEach((element) {
    //     images.add(CachedNetworkImage(
    //         imageUrl: element.getAlbumCover(size: 300),
    //         fadeInDuration: const Duration(microseconds: 1)));
    //   });
    //   return images;
    // });

    futureRecentlyPlayedContentImages =
        Future.wait([futureUserRecentlyPlayedContent]).then((value) {
      List<CachedNetworkImage> images = [];
      for (var element in value[0]) {
        images.add(CachedNetworkImage(
            imageUrl: element.getArtworkUrl(),
            fadeInDuration: const Duration(microseconds: 1)));
      }
      return images;
    });

    // futureRecentlyPlayedAlbumsImages =
    //     Future.wait([futureRecentlyPlayedAlbums]).then((value) {
    //   List<CachedNetworkImage> images = [];
    //   value[0].forEach((element) {
    //     images.add(CachedNetworkImage(
    //         imageUrl: element.getAlbumCover(size: 300),
    //         fadeInDuration: const Duration(microseconds: 1)));
    //   });
    //   return images;
    // });
    // futureRecentlyPlayedSongsImages =
    //     Future.wait([futureRecentlyPlayedSongs]).then((value) {
    //   List<CachedNetworkImage> images = [];
    //   value[0].forEach((element) {
    //     images.add(CachedNetworkImage(
    //       imageUrl: element.getAlbumCover(300),
    //       fit: BoxFit.cover,
    //       fadeInDuration: const Duration(microseconds: 1),
    //     ));
    //   });
    //   return images;
    // });
    // futurePlaylistsImages = Future.wait([futurePlaylists]).then((value) {
    //   List<CachedNetworkImage> images = [];
    //   value[0].forEach((element) {
    //     images.add(CachedNetworkImage(
    //         imageUrl: element.getArtwork(size: 300),
    //         fadeInDuration: const Duration(microseconds: 1)));
    //   });
    //   return images;
    // });
    futureRecentlyPlayedContentImages =
        Future.wait([futureUserRecentlyPlayedContent]).then((value) {
      List<CachedNetworkImage> images = [];
      for (var element in value[0]) {
        images.add(CachedNetworkImage(
            imageUrl: element.getArtworkUrl(size: 300),
            fadeInDuration: const Duration(microseconds: 1)));
      }
      return images;
    });
  }

  MainPageNavigationViewModel mainVm;
  Future<List<dynamic>> futureUserRecentlyPlayedContent =
      MusicPlayer().getRecentlyPlayedContent();
  // Future<List<dynamic>> futureUserHeavyRotation =
  //     MusicPlayer().getUserHeavyRotation();
  // Future<List<Album>> futureRecentlyPlayedAlbums =
  //     MusicPlayer().getRecentlyPlayedAlbums();
  // Future<List<Song>> futureRecentlyPlayedSongs =
  //     MusicPlayer().getRecentlyPlayedSongs();
  // Future<List<Playlist>> futurePlaylists =
  //     MusicPlayer().getUserRecentPlaylists();

  late Future<List<CachedNetworkImage>> futureRecentlyPlayedContentImages;
  // late Future<List<CachedNetworkImage>> futureUserHeavyRotationImages;
  // late Future<List<CachedNetworkImage>> futureRecentlyPlayedAlbumsImages;
  // late Future<List<CachedNetworkImage>> futureRecentlyPlayedSongsImages;
  late Future<List<CachedNetworkImage>> futurePlaylistsImages;

  Object? albumInfo;
  Object? playlistInfo;

  double downloadProgress = 0;

  void setPlaylist({Object? arguments}) {
    playlistInfo = arguments;
  }

  void setAlbum({Object? arguments}) {
    albumInfo = arguments;
  }

  void setDownloadProgress(double value) {
    downloadProgress = value;
  }

  double totalDownloadProgress(List<double> params) {
    double min = 0;
    for (var element in params) {
      min = math.min(min, element);
    }
    return min;
  }
}
