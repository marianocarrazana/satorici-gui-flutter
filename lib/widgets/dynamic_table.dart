import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DynamicTable extends StatelessWidget {
  const DynamicTable(this.objList, {super.key});
  final List objList;

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
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
            cells: {for (var key in obj.keys) key: PlutoCell(value: obj[key])},
          ),
      ],
    );
  }
}
