// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:musicnya/controllers/bottom_navigation_controller.dart';

// class CustomBottomNav extends StatefulWidget {
//   final GlobalKey<NavigatorState> nestedNav;
//   final FocusNode searchFocusNode;
//   final BottomNavigationController controller;

//   const CustomBottomNav(
//       {super.key,
//       required this.controller,
//       required this.nestedNav,
//       required this.searchFocusNode});

//   @override
//   CustomBottomNavState createState() => CustomBottomNavState();
// }

// class CustomBottomNavState extends State<CustomBottomNav> {
//   int _selectedIndex = 0;

//   List<String> _widgetOptions() {
//     return [
//       '/',
//       '/search',
//       '/library',
//       '/settings',
//     ];
//   }

//   void changeIndex(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.exitApp = exitApp;
//     widget.controller.updateIndex = updateIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           return false;
//         },
//         child: BottomNavigationBar(
//             elevation: 0,
//             enableFeedback: false,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.search),
//                 label: 'Search',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.library_add),
//                 label: 'Library',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             onTap: (value) {
//               Navigator.of(
//                 widget.nestedNav.currentContext!,
//               ).popUntil((route) {
//                 //prevent reload of a page we are already on
//                 if (route.settings.name != _widgetOptions().elementAt(value)) {
//                   Navigator.of(widget.nestedNav.currentContext!,
//                           rootNavigator: false)
//                       .pushNamed(_widgetOptions().elementAt(value));
//                   changeIndex(value);
//                 } else if (route.settings.name == "/search") {
//                   widget.searchFocusNode.requestFocus();
//                 }
//                 return true;
//               });
//             }));
//   }

//   exitApp() {
//     SystemNavigator.pop();
//   }

//   updateIndex(String pageName) {
//     print(pageName);
//     changeIndex(_widgetOptions().indexOf(pageName));
//   }
// }
