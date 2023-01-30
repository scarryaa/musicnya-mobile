import 'package:flutter/material.dart';

import 'header.dart';

class SubheaderCustom extends Header {
  const SubheaderCustom(
      {super.key,
      required super.title,
      super.padding = const EdgeInsets.fromLTRB(8, 0, 12, 8),
      super.actions = const [],
      super.textStyle =
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      super.maxLines});
}
