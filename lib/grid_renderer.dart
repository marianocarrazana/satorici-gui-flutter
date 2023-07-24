import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states.dart';
import 'widgets/satori_container.dart';
import 'key_renderer.dart';

class GridRenderer extends ConsumerWidget {
  const GridRenderer({super.key, required this.elements});
  final List elements;

  List<Widget> _getListings() {
    var listings = <Widget>[];
    for (var mon in elements) {
      listings.add(SatoriContainer(
          child: KeyRenderer(
        objList: mon,
      )));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //0=loading, 1=loaded, 2=cached, 3=error
    final int _status = ref.watch(status);
    switch (_status) {
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
