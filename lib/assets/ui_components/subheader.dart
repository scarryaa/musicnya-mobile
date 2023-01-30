import 'package:flutter/material.dart';

import 'header.dart';

class Subheader extends Header {
  const Subheader(
      {super.key,
      required super.title,
      super.padding = const EdgeInsets.fromLTRB(8, 0, 10, 2),
      super.actions = const [],
      super.textStyle =
          const TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
      super.maxLines});
}
