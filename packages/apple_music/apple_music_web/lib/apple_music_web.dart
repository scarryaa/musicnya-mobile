import 'dart:async';
import 'dart:developer';
import 'package:apple_music_web/web_js.dart' as webJs;
import 'package:apple_music_platform_interface/apple_music_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';

/// The web implementation of [AppleMusicPlatform].
///
/// This class implements the `package:url_launcher` functionality for the web.
class AppleMusicPlugin extends AppleMusicPlatform {
  FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Registers this class as the default instance of [AppleMusicPlatform].
  static void registerWith(Registrar registrar) {
    AppleMusicPlatform.instance = AppleMusicPlugin();
  }

  @override
  Future<bool> checkUserAuthentication(String devToken) async {
    bool userIsAuthorized =
        await promiseToFuture(webJs.checkIfUserIsAuthorized());
    if (kDebugMode) {
      userIsAuthorized
          ? log("User is authorized.")
          : log("User is not authorized");
    }
    return userIsAuthorized;
  }

  @override
  Future<void> initializeMusicPlayer({String devToken = ''}) async {
    dynamic instance;
    try {
      instance = await webJs.configureMusicKit(devToken);
    } catch (e) {
      if (kDebugMode)
        log("Music player initialization was unsuccessful. Error: $e");
      return;
    }

    if (instance == null) {
      if (kDebugMode) log("Music player initialization was unsuccessful.");
    } else if (kDebugMode) {
      log("Music player initialization completed successfully.");
    }
  }

  Future<String?> startUserAuthentication(String devToken) async {
    String? result;

    try {
      result = await promiseToFuture(webJs.startAuthentication());
    } catch (e) {
      if (kDebugMode) log("User authentication was unsuccessful. Error: $e");
      return '';
    }

    if (result == null) {
      // User declined authentication.
      if (kDebugMode) log("User authentication was declined by the user.");
      return null;
    } else {
      await _storage.write(key: "userToken", value: result);
      if (kDebugMode) log("Wrote user token to storage successfully.");
      return result;
    }
  }
}
