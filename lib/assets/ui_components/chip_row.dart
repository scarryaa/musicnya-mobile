import 'package:flutter/material.dart';
import 'package:musicnya/helpers/color_helper.dart';
import 'package:musicnya/models/abstract_chip_model.dart';
import 'package:musicnya/assets/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:musicnya/extensions/string_extensions.dart';

class ChipRow<T extends AbstractChipModel> extends StatelessWidget {
  const ChipRow({super.key, required this.chips, this.secondaryChips});

  final List chips;
  final List? secondaryChips;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<T>(context, listen: true);

    return Container(
        color: Colors.grey.shade100,
        height: 50,
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 50,
                    width: (constraints.maxWidth < 380)
                        ? constraints.maxWidth - 101
                        : null,
                    child: Stack(children: [
                      Container(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth < 385
                                  ? (constraints.maxWidth - 105)
                                  : double.infinity),
                          child: Consumer<T>(
                              builder: (context, value, child) =>
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: chips.length,
                                      padding: const EdgeInsets.only(
                                          left: defaultPadding / 4,
                                          right: defaultPadding / 2),
                                      itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: defaultPadding / 8,
                                              vertical: defaultPadding / 3),
                                          child: FilterChip(
                                              clipBehavior: Clip.antiAlias,
                                              elevation: 0,
                                              pressElevation: 0,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.black12,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      )),
                                              selectedColor: lighten(
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  0.2),
                                              backgroundColor: Colors.white10,
                                              padding: index == 0
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal:
                                                          defaultPadding / 8)
                                                  : const EdgeInsets.all(0),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              showCheckmark: false,
                                              label: Text(chips[index]
                                                  .toString()
                                                  .toCapitalized()),
                                              selected:
                                                  model.categorySelection ==
                                                      index,
                                              onSelected: (value) => {
                                                    model.setCategorySelection(
                                                        model.categorySelection ==
                                                                index
                                                            ? null
                                                            : index)
                                                  }))))),
                      if (constraints.maxWidth < 379)
                        SizedBox(
                            height: 50,
                            width: constraints.maxWidth - 105,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  VerticalDivider(
                                    indent: 5,
                                    endIndent: 5,
                                    color: Colors.grey.withOpacity(0.4),
                                    thickness: 1,
                                    width: 1,
                                  )
                                ])),
                    ])),
                if (secondaryChips != null)
                  Consumer<T>(
                      builder: (context, value, child) => ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: secondaryChips!.length,
                          clipBehavior: Clip.none,
                          padding:
                              const EdgeInsets.only(right: defaultPadding / 4),
                          itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 8,
                                  vertical: defaultPadding / 3),
                              child: FilterChip(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  pressElevation: 0,
                                  shape: const RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black12, width: 1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )),
                                  selectedColor: lighten(
                                      Theme.of(context).primaryColor, 0.2),
                                  backgroundColor: Colors.white10,
                                  padding: const EdgeInsets.all(0),
                                  visualDensity: VisualDensity.compact,
                                  showCheckmark: false,
                                  label: secondaryChips![index].toLowerCase() ==
                                          "applemusic"
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: defaultPadding / 8),
                                          child: CachedNetworkImage(
                                              color: Colors.black54,
                                              fadeInDuration: const Duration(
                                                  microseconds: 1),
                                              height: 20,
                                              fit: BoxFit.scaleDown,
                                              imageUrl:
                                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Apple-logo.png/640px-Apple-logo.png'))
                                      : Text(secondaryChips![index]
                                          .toString()
                                          .toCapitalized()),
                                  selected: model.localSelection == index,
                                  onSelected: (value) {
                                    model.setLocalSelection(index);
                                  }))))
              ]);
        }));
  }
}
