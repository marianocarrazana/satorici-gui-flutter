import 'dart:convert';
import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:satori_app/report_chart.dart';

import 'widgets/satori_container.dart';
import 'api_handler.dart';
import 'widgets/key_renderer.dart';
import 'widgets/text_utils.dart';

final reportProvider = FutureProvider.family<Map, String>((_, url) async {
  Response res = await apiGet(url);
  return jsonDecode(res.body);
});

class ReportArguments {
  final String id;

  ReportArguments(this.id);
}

class Report extends ConsumerWidget {
  const Report(this.uuid, {super.key});
  final String uuid;

  List<Widget> _getListings(Map reportData) {
    var listings = <Widget>[];
    if (reportData.isEmpty) return listings;
    List jsonData = reportData["json"];
    for (var mon in jsonData) {
      log(mon.toString());
      var mon2 = Map<String, dynamic>.from(mon);
      String test = mon2['test'] ?? "test";
      String testStatus = (mon2['test_status'] ?? mon2['status']) +
          (mon2['total_fails'] > 0 ? ('(${mon2['total_fails']})') : "");
      List toRemove = ['test', 'test_status', 'status', 'total_fails'];
      mon2.removeWhere((key, value) => toRemove.contains(key));
      List gfx = [];
      for (var x in mon["asserts"]) {
        gfx.add([x["assert"], x["count"], mon["testcases"] - x["count"]]);
      }
      listings.add(SatoriContainer(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Stack(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [TextLabel("Testcases", mon2["testcases"].toString())]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              test,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            TextStatus(testStatus)
          ])
        ]),
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ReportChart(data: gfx),
        ),
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
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map> reportAsserts = ref.watch(reportProvider("reports/$uuid"));
    return reportAsserts.when(
        loading: () => const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
        error: (err, stack) => Text('Error: $err'),
        data: (config) {
          return ListView(
            shrinkWrap: true,
            children: _getListings(config),
          );
        });
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
        TextLabel("Expected", assertData["expected"].toString()),
        TextLabel("Fails", assertData["count"].toString()),
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
        header: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Data",
            )),
        collapsed: Container(),
        expanded: KeyRenderer(widget.data, softWrap: true, maxLines: null));
  }
}
