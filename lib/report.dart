import 'dart:convert';

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
    var testsList = <Widget>[];
    if (reportData.isEmpty) return testsList;
    List jsonData = reportData["report"];
    for (var singleTest in jsonData) {
      var test2 = Map<String, dynamic>.from(singleTest);
      var command = test2["data"]["original"];
      String testName = test2['test'] ?? "test";
      String testStatus = (test2['test_status'] ?? test2['status']) +
          (test2['total_fails'] > 0 ? ('(${test2['total_fails']})') : "");
      List toRemove = ['test', 'test_status', 'status', 'total_fails'];
      test2.removeWhere((key, value) => toRemove.contains(key));
      List gfx = [];
      for (var x in singleTest["asserts"]) {
        gfx.add(
            [x["assert"], x["count"], singleTest["testcases"] - x["count"]]);
      }
      testsList.add(SatoriContainer(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          children: [Text(command)],
        ),
        Stack(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextLabel("Testcases", test2["testcases"].toString())
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              testName,
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
        ExpandData(data: test2["data"]["output"] ?? {}),
        Column(children: [
          for (var asserts in test2["asserts"])
            AssertContainer(assertData: asserts)
        ])
      ])));
    }
    return testsList;
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
      ])
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
