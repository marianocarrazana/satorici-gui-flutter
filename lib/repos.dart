import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:satori_app/grid_renderer.dart';
import 'package:satori_app/text_widgets.dart';

import 'api_handler.dart';
import 'frosted_container.dart';
import 'key_renderer.dart';
import 'responsive_grid.dart';

class ReposController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Repos extends StatelessWidget {
  const Repos({super.key});

  List<Widget> _getListings(m) {
    var listings = <Widget>[];
    for (var mon in m.list) {
      var mon2 = Map<String, dynamic>.from(mon);
      List toRemove = ['Repo', 'Result'];
      mon2.removeWhere((key, value) => toRemove.contains(key));
      listings.add(FrostedContainer(
          child: Column(children: [
        Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
            child: Row(children: [
              Expanded(
                  child: Text(
                mon["Repo"],
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              TextStatus(mon["Result"])
            ])),
        Expanded(
            child: KeyRenderer(
          objList: mon2,
        ))
      ])));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    final ReposController m = Get.put(ReposController());
    getFromApi('repo', m);
    return Obx(() => ResponsiveGrid(
          elements: _getListings(m),
        ));
  }
}
