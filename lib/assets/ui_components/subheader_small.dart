import 'package:flutter/material.dart';

import 'header.dart';

class SubheaderSmall extends Header {
  const SubheaderSmall(
      {super.key,
      required super.title,
      super.padding = const EdgeInsets.fromLTRB(8, 0, 10, 0),
      super.actions = const [],
      super.textStyle = const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      super.maxLines});
}
