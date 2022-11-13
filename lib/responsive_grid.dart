import 'dart:math';

import 'package:flutter/material.dart';

import 'frosted_container.dart';
import 'key_renderer.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.elements});
  final List elements;

  List<Widget> _getListings() {
    var listings = <Widget>[];
    for (var mon in elements) {
      listings.add(FrostedContainer(
          child: KeyRenderer(
        objList: mon,
      )));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    var columns = max((MediaQuery.of(context).size.width ~/ 480).toInt(), 1);
    var widthColumns = MediaQuery.of(context).size.width / columns;
    var aspectRatio = widthColumns / 220;
    return GridView.count(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        padding: const EdgeInsets.all(2),
        children: _getListings());
  }
}
