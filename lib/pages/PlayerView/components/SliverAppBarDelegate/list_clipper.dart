import 'dart:math';

import 'package:flutter/material.dart';

class ListClipper extends CustomClipper<Rect> {
  final double clipHeight;

  ListClipper({required this.clipHeight});

  @override
  Rect getClip(Size size) {
    double top = max(size.height - clipHeight, 0);
    Rect rect = Rect.fromLTRB(0, top, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
