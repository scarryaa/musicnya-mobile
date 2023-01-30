import 'package:flutter/material.dart';

class RectTile extends StatelessWidget {
  const RectTile(
      {super.key, required this.title, this.subtitle = const Text('')});

  final Text title;
  final Text subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 198,
        height: 75,
        child: Card(
            borderOnForeground: true,
            color: Colors.red,
            child: ListTile(
                title: title,
                subtitle: subtitle,
                isThreeLine: subtitle.data!.isNotEmpty ? true : false)));
  }
}
