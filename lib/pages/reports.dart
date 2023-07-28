import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satori_app/widgets/satori_card.dart';

import '../api_handler.dart';
import '../states.dart';
import '../widgets/satori_container.dart';
import '../report.dart';
import '../widgets/responsive_grid.dart';
import '../splitview.dart';
import '../widgets/text_utils.dart';

class ReportsList extends StateNotifier<List> {
  ReportsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final reportsList =
    StateNotifierProvider<ReportsList, List>((ref) => ReportsList(ref));

class Reports extends ConsumerWidget {
  const Reports({super.key});

  List<Widget> _getListings(List reports, BuildContext context, WidgetRef ref) {
    var listings = <Widget>[];
    const footerStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 10);
    for (var mon in reports) {
      var report = mon["report"];
      var testCases = <Widget>[];
      if (report["testcases"] is List) {
        for (var test in report["testcases"]) {
          testCases.add(TextStatus(test));
        }
      }
      listings.add(SatoriCard(
          hoverEffect: true,
          onTap: () => Navigator.pushNamed(context, '/report',
              arguments: ReportArguments(report["id"])),
          cursor: SystemMouseCursors.click,
          header: [
            Expanded(
                child: Text(
              report["id"],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HSLColor.fromAHSL(1, ref.read(pageHue) - 30, 1, 0.8)
                      .toColor()),
              overflow: TextOverflow.fade,
              softWrap: false,
            )),
            TextStatus(report["result"] ?? "Unknown")
          ],
          body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            ...testCases,
            if (report['errors'] != null)
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
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
                                    style:
                                        const TextStyle(color: Colors.white))),
                          ])))
          ]),
          footer: [
            Expanded(
                child: Text(
              report["time required"] ?? "-",
              style: footerStyle,
            )),
            Expanded(
                child: Text(report["user"] ?? "",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: footerStyle)),
            Text(mon['date'], style: footerStyle)
          ]));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('reports', ref.read(reportsList.notifier), ref);
    List reports = ref.watch(reportsList);
    return ResponsiveGrid(
      children: _getListings(reports, context, ref),
    );
  }
}
