import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicnya/env/env.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/navigation_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:apple_music/apple_music.dart';

///Handles Apple Music authentication & user sign-in
class AuthenticationService {
  bool userRefused = false;
  final storage = const FlutterSecureStorage();
  AppleMusic appleMusic = AppleMusic();

  /// Checks if the user token exists, returns true if so and false if not.
  Future<bool> checkUserAuthentication() async {
    bool? userAuthenticated =
        await appleMusic.checkUserAuthentication(devToken: Env.devToken);
    return userAuthenticated ?? false;
  }

  /// Starts the user authentication process.
  Future<void> startUserAuthentication() async {
    String? userToken = '';

    userToken =
        await appleMusic.startUserAuthentication(devToken: Env.devToken);

    if (userToken == null) {
      userRefused = true;
      Navigator.of(
              serviceLocator<NavigationService>().navigatorKey.currentContext!)
          .pushReplacementNamed("/");
    } else if (userToken == '') {
      //TODO show "error occured" popup, retry? add navigation options
    } else {
      // User token was written to storage, so we can continue
      Navigator.of(
              serviceLocator<NavigationService>().navigatorKey.currentContext!)
          .pushReplacementNamed("/");
    }
  }

  Future<String?> readUserToken() async {
    String? userToken;

    try {
      userToken = await storage.read(key: "userToken");
    } catch (e) {
      if (kDebugMode) log("User token was unable to be read. Error: $e");
    }

    if (userToken == null) {
      if (kDebugMode) log("User token not found in local storage.");
    }
    return userToken;
  }
}
