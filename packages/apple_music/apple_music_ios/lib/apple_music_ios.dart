import 'package:apple_music_platform_interface/apple_music_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const MethodChannel _channel =
    MethodChannel('nyan.inc.plugins/apple_music_ios');

/// The iOS implementation of [AppleMusicPlatform].
class AppleMusiciOS extends AppleMusicPlatform {
  /// The MethodChannel that is being used by this implementation of the plguin.
  MethodChannel get channel => _channel;
  FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Registers this class as the default instance of [AppleMusicPlatform].
  static void registerWith() {
    AppleMusicPlatform.instance = AppleMusiciOS();
  }
}
