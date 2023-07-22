
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

class ReportChart extends StatelessWidget {
  const ReportChart({super.key, required this.data});
  final List data;
  @override
  Widget build(BuildContext context) {
    List data2 = data;
    if (data.length == 1) {
      data2 = [...data, ...data, ...data];
    } else if (data.length == 2) {
      data2 = [...data, ...data];
    }
    List<RadarEntry> failsList = [];
    List<RadarEntry> passList = [];
    List<String> titles = [];
    List<RadarDataSet> dataSets = [];
    for (var e in data2) {
      failsList.add(RadarEntry(value: e[1].toDouble()));
      passList.add(RadarEntry(value: (e[1] + e[2]).toDouble()));
      titles.add(e[0]);
    }
    HSLuvColor green = const HSLuvColor.fromHSL(120, 100, 65);
    HSLuvColor red = const HSLuvColor.fromHSL(0, 100, 65);
    dataSets.add(RadarDataSet(
        dataEntries: passList,
        fillColor: green.toColor().withAlpha(200),
        borderColor: green.addLightness(10).toColor()));
    dataSets.add(RadarDataSet(
        dataEntries: failsList,
        fillColor: red.toColor().withAlpha(250),
        borderColor: red.addLightness(10).toColor()));
    return RadarChart(RadarChartData(
        tickBorderData: const BorderSide(color: Colors.white, width: 2.0),
        ticksTextStyle: const TextStyle(color: Colors.transparent),
        radarShape: RadarShape.circle,
        dataSets: dataSets,
        titleTextStyle: const TextStyle(fontSize: 8.0),
        getTitle: (index, angle) {
          return RadarChartTitle(
            text: titles[index],
            angle: angle,
          );
        }));
  }
}
