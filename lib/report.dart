import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:satori_app/report_chart.dart';

import 'responsive_grid.dart';
import 'frosted_container.dart';
import 'api_handler.dart';
import 'key_renderer.dart';
import 'text_status.dart';

class ReportController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Report extends StatelessWidget {
  const Report({super.key, required this.uuid});
  final String uuid;
  List<Widget> _getListings() {
    final ReportController m = Get.put(ReportController());
    var listings = <Widget>[];
    for (var mon in m.list) {
      log(mon.toString());
      var mon2 = Map<String, dynamic>.from(mon);
      String test = mon2['test'] ?? "test";
      String testStatus = (mon2['test_status'] ?? mon2['status']) +
          (mon2['total_fails'] > 0
              ? ('(' + mon2['total_fails'].toString() + ')')
              : "");
      List toRemove = ['test', 'test_status', 'status', 'total_fails'];
      mon2.removeWhere((key, value) => toRemove.contains(key));
      listings.add(FrostedContainer(child: ReportChart(data: mon2['gfx'])));
      listings.add(FrostedContainer(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
              child: Text(
            test,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            overflow: TextOverflow.fade,
            softWrap: false,
          )),
          TextStatus(testStatus)
        ]),
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
    final ReportController m = Get.put(ReportController());
    getFromApi("report/info/$uuid", m, forceReload: true);
    return Obx(() => ResponsiveGrid(elements: _getListings()));
  }
}
