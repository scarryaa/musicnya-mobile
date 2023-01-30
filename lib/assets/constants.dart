import 'package:flutter/material.dart';
import 'dart:math' as math;

bool firstLaunch = true;

const primaryColor = Color(0xFF2697FF);

const secondaryColor = Color(0xFFFFFFFF);
const bgColor = Color(0xFFFAFAFA);
const secondaryAccentColor = Colors.white60;
const secondaryAccentColorMuted = Colors.white54;
const secondaryAccentColorDark = Colors.white24;

const secondaryColorDark = Color(0xFF2A2D3E);
const bgColorDark = Color(0xFF212332);

const double defaultPadding = 16;
const TextStyle forceLightTheme = TextStyle(color: secondaryColor);

double topAppBarHeight = 51;
double topAppBarHeightCompact = 41;
double bottomSheetHeight = 60;
double bottomAppBarHeight = 60;

double pixelRatio =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).devicePixelRatio;
double statusBarHeight =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding.top;
double screenHeight =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
double screenWidth =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;

/// The max size of the device viewport, either width or height, whichever is larger
double maxScreenSize = math.max(screenHeight, screenWidth);
