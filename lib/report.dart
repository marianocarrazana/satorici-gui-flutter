import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:satori_app/report_chart.dart';

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
      var mon2 = Map<String, dynamic>.from(mon);
      String test = mon2['test'] ?? "test";
      String testStatus = (mon2['test_status'] ?? mon2['status']) +
          (mon2['total_fails'] > 0
              ? ('(' + mon2['total_fails'].toString() + ')')
              : "");
      List toRemove = ['test', 'test_status', 'status', 'total_fails'];
      mon2.removeWhere((key, value) => toRemove.contains(key));
      log(mon.toString());
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
        Container(
          height: 200,
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ReportChart(data: mon2['gfx']),
        ),
        Text("Testcases: " + mon2["testcases"].toString()),
        Container(
            child: Column(children: [
          for (var asserts in mon2["asserts"])
            AssertContainer(assertData: asserts)
        ]))
      ])));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    final ReportController m = Get.put(ReportController());
    getFromApi("report/info/$uuid", m, forceReload: true);
    return Obx(() => ListView(
          shrinkWrap: true,
          children: _getListings(),
        ));
  }
}

class AssertContainer extends StatelessWidget {
  const AssertContainer({super.key, required this.assertData});
  final Map<String, dynamic> assertData;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(assertData["assert"]),
        Text("Expected: " + assertData["expected"]),
        Text("Fails:" + assertData["count"].toString()),
        TextStatus(assertData["status"])
      ]),
      for (var data in assertData["data"]) ExpandData(data: data)
    ]);
  }
}

class ExpandData extends StatefulWidget {
  const ExpandData({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<ExpandData> createState() => _ExpandData();
}

class _ExpandData extends State<ExpandData> {
  bool expand = true;
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
        header: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Data",
            )),
        collapsed: Container(),
        expanded: KeyRenderer(
          objList: widget.data,
          softWrap: true,
          maxLines: null,
        ));
  }
}
