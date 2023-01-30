import 'dart:async';

import 'package:flutter/material.dart' hide PageScrollPhysics;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:musicnya/assets/constants.dart';
import 'queue_details_list.dart';

class QueueDetailsComponent extends StatefulWidget {
  const QueueDetailsComponent({super.key, this.pageActive = false});
  final bool pageActive;
  final int listItems = 3;
  static final GlobalKey stickyKey = GlobalKey();

  @override
  State<StatefulWidget> createState() => QueueDetailsComponentState();
}

class QueueDetailsComponentState extends State<QueueDetailsComponent> {
  bool pageActive = false;
  int listItems = 0;
  bool userIsHoldingScroll = false;
  double playingHeaderOffset = 0;
  late AutoScrollController controller;
  double pointerUpPosition = 0;
  final List<QueueDetailsList> queueDetailsList =
      List.generate(3, (index) => QueueDetailsList(currentSection: index));

  double getPlayerHeaderOffset() {
    if (controller.hasClients) {
      return controller.offset;
    } else {
      Timer(const Duration(milliseconds: 500), () => getPlayerHeaderOffset());
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    bool abovePlayingHeader = false;
    bool needsToScroll = false;

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    listItems = widget.listItems;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        if (controller.offset == playingHeaderOffset) {
          needsToScroll = false;
        } else if (controller.offset < playingHeaderOffset &&
            controller.offset != playingHeaderOffset &&
            !needsToScroll) {
          abovePlayingHeader = true;
          needsToScroll = true;
        } else if (controller.offset > playingHeaderOffset &&
            controller.offset != playingHeaderOffset &&
            !needsToScroll) {
          abovePlayingHeader = false;
          needsToScroll = true;
        }

        if (needsToScroll &&
            !userIsHoldingScroll &&
            abovePlayingHeader &&
            controller.offset > playingHeaderOffset - 1 &&
            controller.position.userScrollDirection ==
                ScrollDirection.reverse) {
          needsToScroll = false;
          if (pointerUpPosition < playingHeaderOffset) {
            controller.jumpTo(playingHeaderOffset);
          }
        } else if (needsToScroll &&
            !userIsHoldingScroll &&
            !abovePlayingHeader &&
            controller.offset < playingHeaderOffset + 1 &&
            controller.position.userScrollDirection ==
                ScrollDirection.forward) {
          needsToScroll = false;
          if (pointerUpPosition > playingHeaderOffset) {
            controller.jumpTo(playingHeaderOffset);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pageActive = widget.pageActive;

    //TODO figure out way to eliminate this dependency
    //(e.g. get playingHeaderOffset without use of .scrollToIndex, using RenderBox & controller.offset?)
    if (!pageActive) {
      controller.scrollToIndex(1,
          duration: const Duration(milliseconds: 1),
          preferPosition: AutoScrollPosition.begin);
    }

    if (playingHeaderOffset == 0) {
      playingHeaderOffset = getPlayerHeaderOffset();
    }

    return DefaultTextStyle(
        style: forceLightTheme,
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 0, vertical: defaultPadding),
            child: Listener(
                onPointerDown: (event) => setState(() {
                      userIsHoldingScroll = true;
                    }),
                onPointerUp: (event) => setState(() {
                      pointerUpPosition = controller.offset;
                      userIsHoldingScroll = false;
                    }),
                child: ListView.builder(
                    controller: controller,
                    itemCount: 3,
                    primary: false,
                    itemBuilder: (context, index) {
                      return AutoScrollTag(
                          controller: controller,
                          index: index,
                          key: ValueKey(index),
                          child: queueDetailsList[index]);
                    }))));
  }
}
