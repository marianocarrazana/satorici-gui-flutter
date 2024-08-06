import 'dart:convert';
import "dart:developer";

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DynamicTable extends StatelessWidget {
  const DynamicTable(this.obj, {super.key});
  final dynamic obj;

  @override
  Widget build(BuildContext context) {
    List objList;
    log(obj.runtimeType.toString());
    if (obj is List<Map<String, dynamic>> && obj[0].containsKey("rows")) {
      //Bootstrap table list
      objList = obj[0]["rows"];
    } else if (obj is List<dynamic>) {
      objList = obj;
    } else {
      objList = [];
    }
    log(objList.toString());

    return objList.isEmpty
        ? const Text("No items")
        : PlutoGrid(
            configuration: const PlutoGridConfiguration.dark(),
            columns: [
              for (var key in objList[0].keys)
                PlutoColumn(
                  title: key.toUpperCase(),
                  field: key,
                  type: PlutoColumnType.text(),
                )
            ],
            rows: [
              for (var obj in objList)
                PlutoRow(
                  cells: {
                    for (var key in obj.keys) key: PlutoCell(value: obj[key])
                  },
                ),
            ],
          );
  }
}
