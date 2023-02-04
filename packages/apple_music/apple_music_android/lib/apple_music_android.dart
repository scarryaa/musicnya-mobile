import 'dart:async';
import 'dart:developer';
import 'package:apple_music_platform_interface/apple_music_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const MethodChannel _channel = MethodChannel('nyan.inc.plugins/apple_music');

/// The android implementation of [AppleMusicPlatform].
class AppleMusicAndroid extends AppleMusicPlatform {
  /// The MethodChannel that is being used by this implementation of the plguin.
  MethodChannel get channel => _channel;
  FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Registers this class as the default instance of [AppleMusicPlatform].
  static void registerWith() {
    AppleMusicPlatform.instance = AppleMusicAndroid();
  }

  @override
  Future<bool?> checkUserAuthentication(String devToken) async {
    String? userToken;

    try {
      userToken = await _storage.read(key: 'userToken');
      if (userToken != '' && userToken != null) {
        if (kDebugMode) log("Read user token successfully.");
      } else {
        if (kDebugMode) log("User token read but value is blank or null.");
      }
    } catch (_) {
      if (kDebugMode) {
        ('Could not read user token from local storage. ${Future.error(_)}');
      }
    }

    return (userToken == null) ? false : true;
  }

  @override
  Future<String?> startUserAuthentication(String devToken) async {
    String? result;

    try {
      result = await _channel
          .invokeMethod('startUserAuthentication', {"devToken": devToken});
    } catch (e) {
      if (kDebugMode) log("User authentication was unsuccessful. Error: $e");
      return '';
    }

    if (result == 0) {
      // User declined authentication.
      if (kDebugMode) log("User authentication was declined by the user.");
      return null;
    } else {
      _storage.write(key: "userToken", value: result);
      if (kDebugMode) log("Wrote user token to storage successfully.");
      return result;
    }
  }

  @override
  Future<void> initializeMusicPlayer({String devToken = ''}) async {
    try {
      await _channel.invokeMethod('initializeMusicPlayer');
    } catch (e) {
      if (kDebugMode)
        log("Music player initialization was unsuccessful. Error: $e");
    }
  }
}
