import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'config_controller.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid(
      {super.key,
      required this.elements,
      this.widthExpected = 480,
      this.heightExpected = 220});
  final List<Widget> elements;
  final int widthExpected;
  final int heightExpected;
  @override
  Widget build(BuildContext context) {
    final ConfigController c = Get.find();
    //0=loading, 1=loaded, 2=cached, 3=error
    switch (c.status) {
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
            children: elements);
    }
  }
}
