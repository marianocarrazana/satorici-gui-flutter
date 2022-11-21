import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config_controller.dart';
import 'frosted_container.dart';
import 'key_renderer.dart';

class GridRenderer extends StatelessWidget {
  const GridRenderer({super.key, required this.elements});
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
    final ConfigController c = Get.find();
    //0=loading, 1=loaded, 2=cached, 3=error
    switch (c.status) {
      case 0:
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      default:
        var columns =
            max((MediaQuery.of(context).size.width ~/ 480).toInt(), 1);
        var widthColumns = MediaQuery.of(context).size.width / columns;
        var aspectRatio = widthColumns / 220;
        return GridView.count(
            crossAxisCount: columns,
            childAspectRatio: aspectRatio,
            padding: const EdgeInsets.all(2),
            children: _getListings());
    }
  }
}
