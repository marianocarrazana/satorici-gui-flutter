import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'frosted_container.dart';
import 'report.dart';
import 'responsive_grid.dart';
import 'splitview.dart';
import 'text_status.dart';

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
      var report = mon["Report"];
      var testCases = <Widget>[];
      log(jsonEncode(mon));
      if (report["Testcases"] is List) {
        for (var test in report["Testcases"]) {
          testCases.add(TextStatus(test));
        }
      }
      listings.add(FrostedContainer(
          hoverEffect: true,
          onTap: () => Get.to(() => SplitView(
              content: Report(uuid: report["UUID"]),
              hue: 240,
              command: "satori-cli report ${report["UUID"]}")),
          cursor: SystemMouseCursors.click,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Expanded(
                    child: Text(
                  report["UUID"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                )),
                TextStatus(report["Result"] ?? "Unknown")
              ]),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    ...testCases,
                    if (report['Errors'] != null)
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
                                      "Errors: ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Expanded(
                                        child: Text(report['Errors'],
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                color: Colors.white))),
                                  ])))
                  ])),
              Row(children: [
                Expanded(child: Text(report["Time required"] ?? "-")),
                Expanded(
                    child: Text(
                  report["User"],
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  mon['Date'],
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
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
    getFromApi('report/info?repo=all', m);
    return Obx(() => ResponsiveGrid(
          elements: _getListings(),
        ));
  }
}
