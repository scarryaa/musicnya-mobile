import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:musicnya/assets/constants.dart';

class SliverAppBarBorder extends ShapeBorder {
  final double borderWidth;
  final BorderRadius borderRadius;
  final double statusBarHeight;

  const SliverAppBarBorder(
      {this.borderWidth = 1.0,
      this.borderRadius = BorderRadius.zero,
      required this.statusBarHeight});

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(borderWidth);
  }

  @override
  ShapeBorder scale(double t) {
    return SliverAppBarBorder(
        borderWidth: borderWidth * (t),
        borderRadius: borderRadius * (t),
        statusBarHeight: statusBarHeight);
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder? a, double t) {
    if (a is SliverAppBarBorder) {
      return SliverAppBarBorder(
          borderWidth: ui.lerpDouble(a.borderWidth, borderWidth, t)!,
          borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
          statusBarHeight: statusBarHeight);
    }
    return super.lerpFrom(a, t)!;
  }

  @override
  ShapeBorder lerpTo(ShapeBorder? b, double t) {
    if (b is SliverAppBarBorder) {
      return SliverAppBarBorder(
          borderWidth: ui.lerpDouble(borderWidth, b.borderWidth, t)!,
          borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
          statusBarHeight: statusBarHeight);
    }
    return super.lerpTo(b, t)!;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(
        0,
        0,
        screenWidth,
        rect.height - 25,
      ))
      //like button
      ..arcTo(
          rect.height > screenWidth / 2
              ? Rect.fromCircle(
                  center: Offset(27.5, rect.height - 25), radius: 22)
              : Rect.zero,
          0,
          math.pi,
          true)
      //more options button
      ..arcTo(
          rect.height > screenWidth / 2
              ? Rect.fromCircle(
                  center: Offset(77.5, rect.height - 25), radius: 22)
              : Rect.zero,
          0,
          math.pi,
          true)
      //shuffle button
      ..arcTo(
          Rect.fromCircle(
              center: Offset(screenWidth - 119, rect.height - 27), radius: 22),
          0,
          math.pi,
          true)
      //play button
      ..arcTo(
          Rect.fromCircle(
              center: Offset(screenWidth - 48, rect.height - 35), radius: 40),
          0,
          math.pi,
          true);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    rect = rect.deflate(borderWidth / 2.0);

    Paint paint;
    final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
    paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(borderRect, paint);
  }
}
