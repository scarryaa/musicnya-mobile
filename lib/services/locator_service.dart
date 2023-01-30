import 'package:get_it/get_it.dart';
import 'package:musicnya/services/authentication_service.dart';
import 'package:musicnya/services/navigation_service.dart';

import 'music_player.dart';

final serviceLocator = GetIt.I;

void init() {
  serviceLocator.registerLazySingleton(() => NavigationService());
  serviceLocator.registerLazySingleton(() => MusicPlayer());
  serviceLocator.registerLazySingleton(() => AuthenticationService());
}
