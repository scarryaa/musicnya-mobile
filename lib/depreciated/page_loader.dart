// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:musicnya/services/page_loader_service.dart';

// class PageLoader extends StatefulWidget {
//   PageLoader({super.key, required this.child, required this.pageIndex});

//   final Widget child;
//   final int pageIndex;
//   int _currentIndex = 0;

//   @override
//   State<StatefulWidget> createState() => PageLoaderState();
// }

// class PageLoaderState extends State<PageLoader> {
//   var pageLoaderService = GetIt.I<PageLoaderService>();

//   Future<dynamic> waitForPageLoad() async {
//     //assume new page has been selected if true
//     if (widget.pageIndex != widget._currentIndex) {
//       pageLoaderService.pageIsDoneLoading = false;
//     }
//     widget._currentIndex = widget.pageIndex;

//     await pageLoaderService.waitForPageLoad(widget.child.getFutures());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const CircularProgressIndicator();
//           }
//           return widget.child;
//         },
//         future: Future.wait([waitForPageLoad()]));
//   }
// }
