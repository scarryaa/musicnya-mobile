import 'package:flutter/material.dart' hide AppBar;
import 'package:musicnya/assets/ui_components/app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: "Settings",
        compact: true,
        child: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 60),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 25,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('item $index'),
                );
              },
            ))
          ],
        ));
  }
}
