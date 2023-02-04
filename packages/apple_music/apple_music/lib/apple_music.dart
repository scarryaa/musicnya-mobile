import 'package:apple_music_platform_interface/apple_music_platform_interface.dart';

/// Provides authentication and music player control for Apple Music/MusicKit.
class AppleMusic {
  static AppleMusicPlatform get platform => AppleMusicPlatform.instance;

  Future<bool?> checkUserAuthentication({required String devToken}) async {
    return await platform.checkUserAuthentication(devToken);
  }

  Future<String?> startUserAuthentication({required String devToken}) async {
    return await platform.startUserAuthentication(devToken);
  }

  Future<void> initializeMusicPlayer({String devToken = ''}) async {
    await platform.initializeMusicPlayer(devToken: devToken);
  }
}
