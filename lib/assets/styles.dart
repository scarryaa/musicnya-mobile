import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';

var baseButtonStyle = ButtonStyle(
    foregroundColor: MaterialStateColor.resolveWith((states) => primaryColor),
    backgroundColor:
        MaterialStateColor.resolveWith((states) => Colors.transparent),
    shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
    overlayColor:
        MaterialStateColor.resolveWith((states) => Colors.transparent),
    surfaceTintColor:
        MaterialStateColor.resolveWith((states) => Colors.transparent),
    enableFeedback: false,
    splashFactory: NoSplash.splashFactory);
