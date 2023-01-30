import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:musicnya/pages/AuthenticationPromptView/authentication_prompt_view.dart';
import 'package:musicnya/pages/LibraryView/library_view.dart';
import 'package:musicnya/pages/MainPageNav/main_page_nav.dart';
import 'package:musicnya/pages/SettingsView/settings_page.dart';
import 'package:musicnya/services/authentication_service.dart';
import 'package:musicnya/services/locator_service.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:musicnya/services/navigation_service.dart';
import 'package:musicnya/viewmodels/main_page_navigation_view_model.dart';
import 'package:provider/provider.dart';
import 'package:musicnya/assets/constants.dart';
import 'behaviors/scroll_behavior_by_platform.dart';

late bool userNeedsAuth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  init();
  userNeedsAuth = await serviceLocator<AuthenticationService>()
      .checkIfUserNeedsAuthentication();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // dark text for status bar
      statusBarColor: Colors.transparent));

  GetIt.I<MusicPlayer>().initPlayer();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MusicPlayer()),
    ChangeNotifierProvider(create: (context) => MainPageNavigationViewModel())
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        child: MaterialApp(
            scrollBehavior: ScrolBehaviorByPlatform(),
            debugShowCheckedModeBanner: false,
            title: 'musicnya',
            themeMode: ThemeMode.light,
            initialRoute: userNeedsAuth ? '/authentication_prompt' : '/',
            navigatorKey: serviceLocator<NavigationService>().navigatorKey,
            theme: ThemeData.light().copyWith(
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle.dark),
                useMaterial3: false,
                textTheme: Typography().black,
                buttonTheme: const ButtonThemeData(buttonColor: secondaryColor),
                scaffoldBackgroundColor: bgColor,
                canvasColor: secondaryColor),
            darkTheme: ThemeData.dark().copyWith(
                textTheme: Typography().white,
                buttonTheme:
                    const ButtonThemeData(buttonColor: secondaryColorDark),
                scaffoldBackgroundColor: bgColorDark,
                canvasColor: secondaryColorDark),
            builder: (context, child) => ScrollConfiguration(
                behavior: ScrolBehaviorByPlatform(), child: child!),
            onGenerateInitialRoutes: (initialRoute) {
              if (initialRoute == '/') {
                return [MaterialPageRoute(builder: (_) => const MainPageNav())];
              } else if (initialRoute == '/authentication_prompt') {
                return [
                  MaterialPageRoute(
                      builder: (_) => const AuthenticationPromptView())
                ];
              }
              return [MaterialPageRoute(builder: (_) => const MainPageNav())];
            },
            onGenerateRoute: (settings) {
              late Widget page;

              if (settings.name == '/') {
                page = const MainPageNav();
              } else if (settings.name == '/settings') {
                page = const SettingsPage();
              } else if (settings.name == '/library') {
                page = const LibraryView();
              } else if (settings.name == '/authentication_prompt') {
                page = const AuthenticationPromptView();
              } else {
                throw Exception('Unknown route: ${settings.name}');
              }

              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionDuration: const Duration(milliseconds: 1),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
                reverseTransitionDuration: const Duration(milliseconds: 1),
              );
            }));
  }

  void checkForAuth() async {
    await serviceLocator<AuthenticationService>()
        .checkIfUserNeedsAuthentication();
  }
}
