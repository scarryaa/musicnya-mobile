import 'package:flutter/material.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/services/music_player.dart';
import 'package:provider/provider.dart';

import '../../../models/song.dart';

class AlbumComponent extends StatefulWidget {
  const AlbumComponent(this.songQueue, {super.key});
  final List<Song> songQueue;

  @override
  State<StatefulWidget> createState() => AlbumComponentState();
}

class AlbumComponentState extends State<AlbumComponent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: forceLightTheme,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: PageView.builder(
                    onPageChanged: (index) {
                      MusicPlayer().playSongAtIndex(index);
                    },
                    allowImplicitScrolling: true,
                    itemCount: widget.songQueue.length,
                    itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.fromLTRB(
                            defaultPadding * 3,
                            defaultPadding * 2,
                            defaultPadding * 3,
                            defaultPadding),
                        child: widget.songQueue[index].getArtwork()))),
            Consumer<MusicPlayer>(
                builder: (context, musicPlayer, child) => Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                        widget.songQueue[musicPlayer.currentSongIndex].title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: secondaryColor,
                            fontWeight: FontWeight.w400)))),
            Consumer<MusicPlayer>(
                builder: (context, musicPlayer, child) => Padding(
                    padding: const EdgeInsets.only(
                        top: defaultPadding / 4, bottom: defaultPadding),
                    child: Text(
                        widget.songQueue[musicPlayer.currentSongIndex].artist,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: secondaryAccentColorMuted,
                                fontWeight: FontWeight.w400))))
          ],
        ));
  }
}
