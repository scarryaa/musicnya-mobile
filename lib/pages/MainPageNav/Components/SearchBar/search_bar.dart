import 'package:flutter/material.dart' hide AppBar;
import 'package:musicnya/assets/constants.dart';
import 'package:musicnya/viewmodels/search_bar_view_model.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Consumer<SearchBarViewModel>(
          builder: (context, searchModel, child) => Column(children: [
            SizedBox(
                width: screenWidth - 95,
                height: topAppBarHeightCompact,
                child: TextField(
                  focusNode: searchModel.searchBarFocusNode,
                  onChanged: (value) {
                    setState(() => searchModel.updateSearchInput(value));
                    searchModel.search();
                  },
                  autofocus: false,
                  obscureText: false,
                  cursorHeight: 22,
                  controller: searchModel.textEditingController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 0, vertical: defaultPadding / 1.3),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: Padding(
                        padding: EdgeInsets.only(top: defaultPadding / 8),
                        child: Text('Search for music')),
                    labelStyle:
                        TextStyle(fontSize: 16.5, color: Colors.black38),
                    fillColor: Colors.transparent,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                )),
          ]),
        ));
  }
}
