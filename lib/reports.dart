import 'dart:convert';
import 'dart:ffi';
import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'config_controller.dart';
import 'frosted_container.dart';
import 'key_renderer.dart';

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
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: Text(
              report["UUID"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              overflow: TextOverflow.fade,
              softWrap: false,
            )),
            TextStatus(report["Result"] ?? "Unknown")
          ]),
          Expanded(child: Column(children: testCases)),
          if (report['Errors'] != null)
            Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(children: [
                  Text(
                    "Errors: ",
                    style: TextStyle(color: Colors.red, fontSize: 9),
                  ),
                  Expanded(
                      child: Text(report['Errors'],
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(color: Colors.white, fontSize: 9))),
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
    return Obx(() => ResponsiveGrid2(
          elements: _getListings(),
        ));
  }
}

class ResponsiveGrid2 extends StatelessWidget {
  const ResponsiveGrid2({super.key, required this.elements});
  final List<Widget> elements;

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
            math.max((MediaQuery.of(context).size.width ~/ 480).toInt(), 1);
        var widthColumns = MediaQuery.of(context).size.width / columns;
        var aspectRatio = widthColumns / 220;
        return GridView.count(
            crossAxisCount: columns,
            childAspectRatio: aspectRatio,
            padding: const EdgeInsets.all(2),
            children: elements);
    }
  }
}

class TextStatus extends StatelessWidget {
  const TextStatus(this.data, {super.key});
  final String? data;

  @override
  Widget build(BuildContext context) {
    final isSuccess = RegExp(r'(Pass|Completed)$');
    final isFail = RegExp(r'Fail(\([\w]+\))?$');
    String data = this.data ?? '';
    Widget icon;
    var iconSize = 14.0;
    if (isSuccess.hasMatch(data)) {
      icon = Icon(
        Icons.check_circle,
        color: Color.fromARGB(255, 63, 255, 70),
        size: iconSize,
      );
    } else if (isFail.hasMatch(data)) {
      icon = Icon(Icons.cancel,
          color: Color.fromARGB(255, 255, 59, 45), size: iconSize);
    } else {
      icon = Icon(Icons.error, color: Colors.orange, size: iconSize);
    }
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [icon, Text(data)]);
  }
}
