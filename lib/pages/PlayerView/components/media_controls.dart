import 'package:flutter/material.dart';

import '../../../assets/custom_track_shape.dart';
import 'package:musicnya/assets/constants.dart';
import '../../../helpers/milliseconds_to_datetime.dart';

class MediaControls extends StatefulWidget {
  const MediaControls({super.key});

  @override
  State<StatefulWidget> createState() => MediaControlsState();
}

class MediaControlsState extends State<MediaControls> {
  double _currentSliderValue = 0;
  final double _maxSliderValue = 221000; //TODO get this from current track
  final double _defaultSliderRadius = 5;
  double _sliderRadius = 5;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: forceLightTheme,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          child: Text(
                        MillisecondsToDateTime.millisecondsToClockFormat(
                            _currentSliderValue.toInt()),
                        style:
                            const TextStyle(color: secondaryAccentColorMuted),
                      )),
                      Expanded(
                          flex: 9,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding,
                                  horizontal: defaultPadding / 4),
                              child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 3,
                                    overlayColor: Colors.white.withAlpha(0),
                                    overlappingShapeStrokeColor: secondaryColor,
                                    overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 10),
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: _sliderRadius,
                                        elevation: 0,
                                        pressedElevation: 0),
                                    trackShape: CustomTrackShape(),
                                  ),
                                  child: Slider(
                                    onChangeStart: (value) =>
                                        onSliderChangeStart(),
                                    onChangeEnd: (value) => onSliderChangeEnd(),
                                    onChanged: (value) => onSliderChange(value),
                                    activeColor: secondaryColor,
                                    inactiveColor:
                                        secondaryColor.withOpacity(0.2),
                                    min: 0,
                                    max: _maxSliderValue,
                                    value: _currentSliderValue,
                                  )))),
                      Flexible(
                          child: Text(
                        MillisecondsToDateTime.millisecondsToClockFormat(
                            _maxSliderValue.toInt()),
                        style:
                            const TextStyle(color: secondaryAccentColorMuted),
                      )),
                    ],
                  )),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Text(String.fromCharCode(Icons.shuffle.codePoint),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 32,
                            fontWeight: FontWeight.w100,
                            fontFamily: Icons.skip_next.fontFamily,
                            package: Icons.skip_next.fontPackage,
                            color: secondaryAccentColorMuted,
                          )),
                      onPressed: () => playNext(),
                      iconSize: 46,
                    ),
                    IconButton(
                      icon: Text(
                          String.fromCharCode(Icons.skip_previous.codePoint),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 56,
                            fontWeight: FontWeight.w100,
                            fontFamily: Icons.skip_previous.fontFamily,
                            package: Icons.skip_previous.fontPackage,
                          )),
                      iconSize: 56,
                      onPressed: () => playPrevious(),
                    ),
                    IconButton(
                      onPressed: () => playPause(),
                      icon: Text(
                          String.fromCharCode(
                              Icons.play_circle_outline.codePoint),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 102,
                            fontWeight: FontWeight.w100,
                            fontFamily: Icons.play_circle_outline.fontFamily,
                            package: Icons.play_circle_outline.fontPackage,
                          )),
                      iconSize: 102,
                    ),
                    IconButton(
                      icon: Text(String.fromCharCode(Icons.skip_next.codePoint),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 56,
                            fontWeight: FontWeight.w100,
                            fontFamily: Icons.skip_next.fontFamily,
                            package: Icons.skip_next.fontPackage,
                          )),
                      onPressed: () => playNext(),
                      iconSize: 56,
                    ),
                    IconButton(
                      icon: Text(String.fromCharCode(Icons.repeat.codePoint),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 32,
                            fontWeight: FontWeight.w100,
                            fontFamily: Icons.skip_next.fontFamily,
                            package: Icons.skip_next.fontPackage,
                            color: secondaryAccentColorMuted,
                          )),
                      onPressed: () => playNext(),
                      iconSize: 46,
                    ),
                  ],
                ),
              )
            ]));
  }

  playPause() async {}

  playPrevious() {}
  playNext() {}

  onSliderChange(value) {
    setState(() {
      _currentSliderValue = value;
    });
  }

  onSliderChangeStart() {
    setState(() {
      _sliderRadius = 10;
    });
  }

  onSliderChangeEnd() {
    setState(() {
      _sliderRadius = _defaultSliderRadius;
    });
  }
}
