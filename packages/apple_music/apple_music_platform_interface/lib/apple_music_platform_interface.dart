import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/method_channel_apple_music.dart';

/// The interface that implementations of url_launcher must implement.
///
/// Platform implementations should extend this class rather than implement it as `url_launcher`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [AppleMusicPlatform] methods.
abstract class AppleMusicPlatform extends PlatformInterface {
  /// Constructs a UrlLauncherPlatform.
  AppleMusicPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppleMusicPlatform _instance = MethodChannelAppleMusic();

  /// The default instance of [AppleMusicPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppleMusic].
  static AppleMusicPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [AppleMusicPlatform] when they register themselves.
  static set instance(AppleMusicPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Attempts to read the user token from local storage. Returns true if successful, false if unsuccessful.
  Future<bool?> checkUserAuthentication(String devToken) async {
    throw UnimplementedError('checkUserAuthentication() is not implemented.');
  }

  /// Starts the user authentication process and writes the user token to storage and returns the user token if successful, returns a null if the user cancelled,
  /// and returns an empty string if an error occured.
  Future<String?> startUserAuthentication(String devToken) async {
    throw UnimplementedError('startAuthenticationError() is not implemented.');
  }

  /// Initializes the music player for the current platform.
  Future<void> initializeMusicPlayer({String devToken = ''}) async {
    throw UnimplementedError('initializeMusicPlayer() is not implemented.');
  }
}
