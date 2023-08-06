import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:satori_app/widgets/satori_card.dart';

import '../api_handler.dart';
import '../states.dart';
import '../report.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/text_utils.dart';

final reportsProvider = FutureProvider<Map>((_) async {
  Response res = await apiGet("reports");
  return jsonDecode(res.body);
});

class Reports extends ConsumerWidget {
  const Reports({super.key});

  List<Widget> _getListings(List reports, BuildContext context, WidgetRef ref) {
    var listings = <Widget>[];
    const footerStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 10);
    for (var report in reports) {
      log(report.toString());
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
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Icon(
                      Icons.error_outline_outlined,
                      color: Colors.redAccent,
                      size: 15,
                    ),
                    const Text(
                      "Errors: ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                        child: Text(report['errors'],
                            overflow: TextOverflow.fade,
                            style: const TextStyle(color: Colors.white))),
                  ]))
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
            Text(report['date'], style: footerStyle)
          ]));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map> reportsList = ref.watch(reportsProvider);
    return reportsList.when(
        loading: () => const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
        error: (err, stack) => Text('Error: $err'),
        data: (reports) {
          return ResponsiveGrid(
            children: _getListings(reports["list"], context, ref),
          );
        });
  }
}
