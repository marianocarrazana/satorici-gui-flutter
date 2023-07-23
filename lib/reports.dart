import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'frosted_container.dart';
import 'report.dart';
import 'responsive_grid.dart';
import 'splitview.dart';
import 'text_widgets.dart';

class ReportsController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Reports extends StatelessWidget {
  const Reports({super.key});

  List<Widget> _getListings() {
    final ReportsController m = Get.put(ReportsController());
    var listings = <Widget>[];
    for (var mon in m.list) {
      var report = mon["report"];
      var testCases = <Widget>[];
      log(jsonEncode(mon));
      if (report["testcases"] is List) {
        for (var test in report["testcases"]) {
          testCases.add(TextStatus(test));
        }
      }
      listings.add(FrostedContainer(
          hoverEffect: true,
          onTap: () => Get.to(() => SplitView(
              content: Report(uuid: report["id"]),
              hue: 240,
              command: "satori-cli report ${report["id"]}")),
          cursor: SystemMouseCursors.click,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(
                    child: Text(
                  report["id"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                )),
                TextStatus(report["result"] ?? "Unknown")
              ]),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    ...testCases,
                    if (report['errors'] != null)
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "errors: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Expanded(
                                        child: Text(report['errors'],
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                color: Colors.white))),
                                  ])))
                  ])),
              Row(children: [
                Expanded(child: Text(report["time required"] ?? "-")),
                Expanded(
                    child: Text(
                  report["user"]??"",
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  mon['date'],
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
                )
              ])
            ],
          )));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    final ReportsController m = Get.put(ReportsController());
    getFromApi('reports', m);
    return Obx(() => ResponsiveGrid(
          elements: _getListings(),
        ));
  }
}
