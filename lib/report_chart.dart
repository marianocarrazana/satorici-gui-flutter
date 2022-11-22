import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class ReportChart extends StatelessWidget {
  const ReportChart({super.key, required this.data});
  final List data;
  @override
  Widget build(BuildContext context) {
    List<Map> dataMap = [];
    for (var v in data) {
      dataMap.add({'assert': v[0], 'fails': v[1], 'pass': v[2]});
    }
    return Chart(
      data: dataMap,
      variables: {
        'assert': Variable(
          accessor: (Map map) => map["assert"] as String,
        ),
        'fails': Variable(
          accessor: (Map map) => map["fails"] as num,
        ),
        'pass': Variable(
          accessor: (Map map) => map["pass"] as num,
        ),
      },
      elements: [IntervalElement()],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
    );
  }
}
