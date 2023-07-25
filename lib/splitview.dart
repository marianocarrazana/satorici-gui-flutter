import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsluv/hsluvcolor.dart';
import 'package:satori_app/states.dart';

import 'menu.dart';

class SplitView extends StatelessWidget {
  const SplitView(
      {Key? key,
      required this.content,
      // these values are now configurable with sensible default values
      this.breakpoint = 600,
      this.menuWidth = 240,
      this.hue,
      required this.command})
      : super(key: key);
  final Widget content;
  final double breakpoint;
  final double menuWidth;
  final double? hue;
  final String command;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      // desktop
      return Scaffold(
          body: GradientContainer(
              hue: hue ?? 47,
              child: Row(
                children: [
                  SizedBox(
                    width: menuWidth,
                    child: AppMenu(),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  onTap: () {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Command copied to clipboard'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Clipboard.setData(
                                        ClipboardData(text: command));
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Row(children: [
                                        Expanded(
                                            child: Text(
                                          command,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                        const Icon(
                                          Icons.content_copy,
                                          color: Colors.white,
                                        )
                                      ])))),
                          Expanded(child: content)
                        ]),
                  ),
                ],
              )));
    } else {
      // mobile
      return Scaffold(
        body: GradientContainer(hue: hue ?? 47, child: content),
        appBar: AppBar(
          title: const Text('Satori CI'),
          backgroundColor: HSLuvColor.fromHSL(hue ?? 0, 100, 70).toColor(),
        ),
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            backgroundColor: HSLuvColor.fromHSL(hue ?? 0, 100, 70).toColor(),
            child: AppMenu(
              hue: hue,
            ),
          ),
        ),
      );
    }
  }
}

class GradientContainer extends ConsumerWidget {
  final double hue;
  final Widget child;

  const GradientContainer({super.key, required this.hue, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    double colorSpread = 24;
    double saturation = 55;
    double lightness = 16;
    double hue1 = ref.read(pageHue);
    double hue2 = (ref.read(pageHue) + colorSpread) % 360;
    double hue3 = (ref.read(pageHue) - colorSpread) % 360;
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              transform: const GradientRotation(0.78),
              colors: <Color>[
                HSLuvColor.fromHSL(hue1, saturation, lightness).toColor(),
                HSLuvColor.fromHSL(hue2, saturation, lightness).toColor(),
                HSLuvColor.fromHSL(hue3, saturation, lightness).toColor(),
              ]),
        ),
        child: child);
  }
}
