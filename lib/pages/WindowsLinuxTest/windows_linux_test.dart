// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:desktop_webview_window/desktop_webview_window.dart';
// import 'package:flutter/services.dart';
// import 'package:musicnya/env/env.dart';
// import 'package:flutter_js/flutter_js.dart';

// class WindowsLinuxTest extends StatefulWidget {
//   const WindowsLinuxTest({super.key});

//   @override
//   State<WindowsLinuxTest> createState() => WindowsLinuxTestState();
// }

// class WindowsLinuxTestState extends State<WindowsLinuxTest> {
//   late JavascriptRuntime flutterJs;
//   Object _jsResult = {};

//   @override
//   void initState() {
//     flutterJs = getJavascriptRuntime();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('FlutterJS Example'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('JS Evaluate Result: $_jsResult\n'),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(10),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//               )
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.transparent,
//           onPressed: () async {
//             try {
//               String musicKit =
//                   await rootBundle.loadString('lib/assets/js/musickit.js');
//               flutterJs.evaluate('var window = global = globalThis;');
//               flutterJs.evaluate(musicKit + "");
//               JsEvalResult jsResult = flutterJs.evaluate('''
//                   const musicKitInstance = window.MusicKit.configure({
//                       developerToken: "e",
//                       app: {
//                           name: "musicnya",
//                           build: "1.0.0",
//                           },
//                       });
  
//                   try {
//                       await musicKitInstance.authorize().then(async function() {
//                         const { data: result } = await musicKitInstance.api.library.playlists(null);
//                         console.log(result.data);
//                       })
//                   } catch (error) {
//                       console.log(error);
//                   };
//       ''');
//               setState(() {
//                 _jsResult = jsResult.stringResult;
//               });
//             } on Exception catch (e) {
//               print('Failed to init js engine');
//             } finally {
//               print(_jsResult);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
