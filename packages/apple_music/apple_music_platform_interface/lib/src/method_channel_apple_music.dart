import 'dart:async';

import 'package:flutter/services.dart';

import '../apple_music_platform_interface.dart';

const MethodChannel _channel = MethodChannel('nyan.inc.plugins/apple_music');

/// An implementation of [AppleMusicPlatform] that uses method channels.
class MethodChannelAppleMusic extends AppleMusicPlatform {
  MethodChannel get channel => _channel;

  @override
  Future<bool?> checkUserAuthentication(String devToken) {
    return channel
        .invokeMethod<bool>('checkUserAuthentication', {"token": devToken});
  }

  @override
  Future<String?> startUserAuthentication(String devToken) async {
    return channel
        .invokeMethod<String?>('startUserAuthentication', {"token": devToken});
  }

  @override
  Future<void> initializeMusicPlayer({String devToken = ''}) async {
    return channel.invokeMethod<void>('initializeMusicPlayer');
  }
}
