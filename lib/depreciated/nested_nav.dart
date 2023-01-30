// import 'package:flutter/material.dart';
// import 'package:musicnya/pages/LibraryView/library_view.dart';
// import 'package:musicnya/pages/SettingsView/settings_page.dart';
// import '../pages/album_view.dart';
// import '../pages/MainPageNav/main_page_nav.dart';

// @immutable
// class NestedNav extends StatefulWidget {
//   static NestedNavState of(BuildContext context) {
//     return context.findAncestorStateOfType<NestedNavState>()!;
//   }

//   const NestedNav({
//     super.key,
//     required this.setupPageRoute,
//   });

//   final String setupPageRoute;

//   @override
//   NestedNavState createState() => NestedNavState();
// }

// class NestedNavState extends State<NestedNav> {
//   late FocusNode searchFocusNode;
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   String? currentPageName;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     searchFocusNode = FocusNode();

//     return WillPopScope(
//         onWillPop: () async {
//           if (Navigator.of(_navigatorKey.currentContext!).canPop()) {
//             if (currentPageName == '/search') {
//               searchFocusNode.dispose();
//             }
//             Navigator.of(_navigatorKey.currentContext!).pop();
//             _navigatorKey.currentState?.popUntil((route) {
//               currentPageName = route.settings.name;
//               return true;
//             });
//           }
//           return false;
//         },
//         child: Navigator(
//             key: _navigatorKey,
//             onGenerateRoute: (settings) {
//               late Widget page;

//               if (settings.name == '/') {
//                 page = const MainPageNav();
//               } else if (settings.name == '/settings') {
//                 page = const SettingsPage();
//               } else if (settings.name == '/library') {
//                 page = const LibraryView();
//               } else if (settings.name == '/album_view') {
//                 page = const AlbumView();
//               } else {
//                 throw Exception('Unknown route: ${settings.name}');
//               }

//               return PageRouteBuilder(
//                 settings: settings,
//                 pageBuilder: (context, animation, secondaryAnimation) =>
//                     SafeArea(child: page),
//                 transitionDuration: const Duration(milliseconds: 1),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) =>
//                         FadeTransition(opacity: animation, child: child),
//                 reverseTransitionDuration: const Duration(milliseconds: 1),
//               );
//             }));
//   }
// }
