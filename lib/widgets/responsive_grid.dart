import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../states.dart';

class ResponsiveGrid extends ConsumerWidget {
  const ResponsiveGrid(
      {super.key,
      required this.children,
      this.widthExpected = 480,
      this.heightExpected = 220});
  final List<Widget> children;
  final int widthExpected;
  final int heightExpected;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //0=loading, 1=loaded, 2=cached, 3=error
    final int statusRef = ref.watch(status);
    switch (statusRef) {
      case 0:
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      default:
        var columns = math.max(
            (MediaQuery.of(context).size.width ~/ widthExpected).toInt(), 1);
        var widthColumns = MediaQuery.of(context).size.width / columns;
        var aspectRatio = widthColumns / heightExpected;
        return GridView.count(
            crossAxisCount: columns,
            childAspectRatio: aspectRatio,
            padding: const EdgeInsets.all(2),
            children: children);
    }
  }
}
