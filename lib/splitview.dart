import 'package:flutter/material.dart';

import 'menu.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.content,
    // these values are now configurable with sensible default values
    this.breakpoint = 600,
    this.menuWidth = 240,
  }) : super(key: key);
  final Widget content;
  final double breakpoint;
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      // widescreen: menu on the left, content on the right
      return Scaffold(
          body: Row(
        children: [
          SizedBox(
            width: menuWidth,
            child: AppMenu(),
          ),
          Container(width: 0.5, color: Colors.black),
          Expanded(
              child: Scaffold(
                  body: content, appBar: AppBar(title: Text('Satori CI')))),
        ],
      ));
    } else {
      // narrow screen: show content, menu inside drawer
      return Scaffold(
        body: content,
        appBar: AppBar(title: Text('Satori CI')),
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            child: AppMenu(),
          ),
        ),
      );
    }
  }
}
