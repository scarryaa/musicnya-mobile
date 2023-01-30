import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/navigation_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'jwt_gen.dart';

class AuthenticationService {
  bool userAuthenticated = false;
  bool userRefused = false;
  final _channel = const MethodChannel('auth');
  final storage = const FlutterSecureStorage();
  String? userToken = '';

  /// Prompts user to login with Apple Music, if it is their first launch of the app and they are not already signed in.
  Future<bool> checkIfUserNeedsAuthentication() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      storage.write(key: "devToken", value: JwtGen.generate256SignedJWT());

      userToken = await storage.read(key: 'userToken');
      if (userToken != null || userToken != '') return true;
      if (kDebugMode) log("Read token successfully");
      return false;
    } catch (_) {
      if (kDebugMode) {
        ('Could not read token from local storage. ${Future.error(_)}');
      }
      return (firstLaunch && !userRefused) ? true : false;
    }
  }

  Future<void> startAuthentication() async {
    var token = JwtGen.generate256SignedJWT();
    final result =
        await _channel.invokeMethod('authenticate', {"token": token});
    if (result == 0) {
      //user canceled activity
      userRefused = true;
      Navigator.of(
              serviceLocator<NavigationService>().navigatorKey.currentContext!)
          .pushReplacementNamed("/");
    } else {
      storage.write(key: "userToken", value: result);
      Navigator.of(
              serviceLocator<NavigationService>().navigatorKey.currentContext!)
          .pushReplacementNamed("/");
    }
  }
}
