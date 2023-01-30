import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/assets/ui_components/buttons/circular_button_primary_color.dart';
import 'package:musicnya/viewmodels/album_details_view_model.dart';
import 'package:provider/provider.dart';

class AlbumMediaControls extends StatefulWidget {
  const AlbumMediaControls({super.key});

  @override
  State<StatefulWidget> createState() => AlbumMediaControlsState();
}

class AlbumMediaControlsState extends State<AlbumMediaControls> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumDetailsViewModel>(builder: (context, model, child) {
      return Stack(children: [
        Positioned(
            height: 100,
            width: screenWidth,
            top: model.indicatorOffset.dy,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircularButtonPrimaryColor(
                    onTap: () => shufflePlay(),
                    icon: Icons.shuffle_rounded,
                    iconSize: 30,
                    elevated: true,
                  ),
                  CircularButtonPrimaryColor(
                    padding: const EdgeInsets.only(
                        right: defaultPadding / 1.75, top: defaultPadding),
                    onTap: () => playAlbum(),
                    icon: Icons.play_arrow_rounded,
                    iconSize: 65,
                    elevated: true,
                  ),
                ]))
      ]);
    });
  }
}

/// Immediately start playing the current album, appending all tracks to the beginning of the queue
playAlbum() {}

/// Immediately start shuffle playing the current album, appending all tracks to the beginning of the queue
shufflePlay() {}

class MediaContainer extends StatefulWidget {
  const MediaContainer({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => MediaContainerState();
}

class MediaContainerState extends State<MediaContainer> {
  AlbumDetailsViewModel? model;

  @override
  void initState() {
    model = Provider.of<AlbumDetailsViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        model!.updateIndicator(notification);
        return true;
      },
      child: widget.child,
    );
  }
}
