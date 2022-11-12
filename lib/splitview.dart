import 'package:flutter/material.dart';

import 'menu.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.content,
    // these values are now configurable with sensible default values
    this.breakpoint = 600,
    this.menuWidth = 240,
    this.hue
  }) : super(key: key);
  final Widget content;
  final double breakpoint;
  final double menuWidth;
  final double? hue;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      // widescreen: menu on the left, content on the right
      return Scaffold(
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  transform: GradientRotation(0.78),
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    tileMode: TileMode.repeated,
                    colors: <Color>[
                      HSLColor.fromAHSL(1, hue??0, 1, 0.55).toColor(),
                      HSLColor.fromAHSL(1, hue??0, 0.9, 0.48).toColor()
                    ]),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: menuWidth,
                    child: AppMenu(),
                  ),
                  Expanded(
                      child: Scaffold(
                          backgroundColor: Color.fromARGB(0, 0, 0, 0),
                          body: content,
                          appBar: AppBar(title: Text('Satori CI')))),
                ],
              )));
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
