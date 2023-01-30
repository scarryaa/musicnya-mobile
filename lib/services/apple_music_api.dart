import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:musicnya/models/playlist.dart';
import 'package:musicnya/services/authentication_service.dart';
import 'package:musicnya/services/jwt_gen.dart';

import '../models/album.dart';
import '../models/song.dart';
import '../models/station.dart';

class AppleMusicApi {
  static final AppleMusicApi _instance = AppleMusicApi._internal();
  final http.Client client = http.Client();
  List tmpRecentlyPlayed = List.generate(3, (i) => i);

  factory AppleMusicApi() {
    return _instance;
  }

  AppleMusicApi._internal();

  Future<List<Station>> getStations() async {
    try {
      final response = await client.get(
          Uri.https('api.music.apple.com', 'v1/catalog/us/stations'),
          headers: {
            "Authorization": 'Bearer ${JwtGen.generate256SignedJWT()}'
          });

      if (response.statusCode == 200) {
        List<Station> stations = [];
        for (Object o in jsonDecode(response.body)['data']) {
          stations.add(Station.from(o));
        }
        return stations;
      } else {
        throw Exception(
            'Failed to load stations ${response.statusCode}, ${response.body})');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<dynamic>> getRecentlyPlayedContent() async {
    try {
      final response = await client.get(
          Uri.https(
            'api.music.apple.com',
            'v1/me/recent/played',
          ),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${JwtGen.generate256SignedJWT()}',
            'Music-User-Token': '${GetIt.I<AuthenticationService>().userToken}',
          });

      if (response.statusCode == 200) {
        List<dynamic> results = [];
        List<dynamic> searchResults = json.decode(response.body)['data'];

        for (var element in searchResults) {
          if (kDebugMode) {
            print(element);
          }
          switch (element['type']) {
            case 'albums':
            case 'library-albums':
              results.add(Album.from(element));
              break;
            case 'songs':
            case 'library-songs':
              results.add(Song.from(element));
              break;
            case 'stations':
            case 'library-stations':
              results.add(Station.from(element));
              break;
          }
        }

        return results;
      } else {
        throw Exception(
            'Failed to load search results ${response.statusCode}, ${json.decode(response.body)}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Playlist> getPlaylist(String id) async {
    try {
      final response = await client.get(
          Uri.https('api.music.apple.com', 'v1/catalog/us/playlists/$id'),
          headers: {
            "Authorization": 'Bearer ${JwtGen.generate256SignedJWT()}'
          });

      if (response.statusCode == 200) {
        return Playlist.from(jsonDecode(response.body)['data'][0]);
      } else {
        throw Exception(
            'Failed to load playlist ${response.statusCode}, ${response.body}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Station> getStation(String id) async {
    try {
      final response = await client.get(
          Uri.https('api.music.apple.com', 'v1/catalog/us/stations/$id'),
          headers: {
            "Authorization": 'Bearer ${JwtGen.generate256SignedJWT()}'
          });

      if (response.statusCode == 200) {
        return Station.from(jsonDecode(response.body)['data'][0]);
      } else {
        throw Exception(
            'Failed to load station ${response.statusCode}, ${response.body}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Album> getAlbum(String id) async {
    try {
      final response = await client.get(
          Uri.https('api.music.apple.com', 'v1/catalog/us/albums/$id'),
          headers: {
            "Authorization": 'Bearer ${JwtGen.generate256SignedJWT()}'
          });

      if (response.statusCode == 200) {
        return Album.from(jsonDecode(response.body)['data'][0]);
      } else {
        throw Exception(
            'Failed to load album ${response.statusCode}, ${response.body}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<Song> getSong() async {
    try {
      final response = await client.get(
          Uri.https('api.music.apple.com', 'v1/catalog/us/songs/1207120448'),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${JwtGen.generate256SignedJWT()}'
          });

      if (response.statusCode == 200) {
        return Song.from(jsonDecode(response.body)['data'][0]);
      } else {
        throw Exception(
            'Failed to load song ${response.statusCode}, ${response.body}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<dynamic>> getUserRecentPlaylists() async {
    try {
      final response = await client.get(
          Uri.https(
            'api.music.apple.com',
            'v1/me/recent/played',
          ),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${JwtGen.generate256SignedJWT()}',
            'Music-User-Token': '${GetIt.I<AuthenticationService>().userToken}',
          });

      if (response.statusCode == 200) {
        List<Playlist> results = [];
        List<dynamic> searchResults = json.decode(response.body)['data'];

        for (var element in searchResults) {
          if (element['type'] == 'playlists') {
            results.add(Playlist.from(element));
          }
        }

        return results;
      } else {
        throw Exception(
            'Failed to load search results ${response.statusCode}, ${json.decode(response.body)}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<dynamic>> getUserHeavyRotation() async {
    try {
      final response = await client.get(
          Uri.https(
            'api.music.apple.com',
            'v1/me/history/heavy-rotation',
          ),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${JwtGen.generate256SignedJWT()}',
            'Music-User-Token': '${GetIt.I<AuthenticationService>().userToken}',
          });

      if (response.statusCode == 200) {
        List<dynamic> results = [];
        List<dynamic> searchResults = json.decode(response.body)['data'];

        for (var element in searchResults) {
          if (kDebugMode) {
            print(element);
          }
          switch (element['type']) {
            case 'albums':
              results.add(Album.from(element));
              break;
            case 'songs':
              results.add(Song.from(element));
              break;
          }
        }

        return results;
      } else {
        throw Exception(
            'Failed to load search results ${response.statusCode}, ${json.decode(response.body)}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<dynamic>> search(
      String searchTerms, String params, int local) async {
    try {
      //TODO implement local searching
      if (local == 1) {
        return ['local', 'searching', 'is', 'not', 'implemented'];
      }

      final response = await client.get(
          Uri.https('api.music.apple.com', 'v1/catalog/us/search',
              {'types': params, "term": searchTerms.split(' ').join('+')}),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ${JwtGen.generate256SignedJWT()}'
          });

      if (response.statusCode == 200) {
        List results = [];
        LinkedHashMap<String, dynamic> searchResults =
            json.decode(response.body)['results'];

        if (searchResults.containsKey("songs")) {
          for (var element in searchResults['songs']['data']) {
            results.add(Song.from(element));
          }
        }

        if (searchResults.containsKey('albums')) {
          for (var element in searchResults['albums']['data']) {
            results.add(Album.from(element));
          }
        }

        return results;
      } else {
        throw Exception(
            'Failed to load search results ${response.statusCode}, ${json.decode(response.body)}');
      }
    } catch (_) {
      return Future.error(_);
    }
  }
}
