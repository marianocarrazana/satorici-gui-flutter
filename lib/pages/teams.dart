import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satori_app/widgets/text_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../api_handler.dart';
import '../widgets/satori_container.dart';

class TeamsList extends StateNotifier<List> {
  TeamsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final teamsList =
    StateNotifierProvider<TeamsList, List>((ref) => TeamsList(ref));

class TeamDS extends DataGridSource {
  TeamDS(List teams) {
    _teams = teams
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: e["id"]),
              DataGridCell<String>(columnName: 'name', value: e["name"]),
              DataGridCell<String>(
                  columnName: 'permissions', value: e["permissions"]),
              DataGridCell<String>(columnName: 'owner', value: e["owner"]),
            ]))
        .toList();
  }

  List<DataGridRow> _teams = [];
  @override
  List<DataGridRow> get rows => _teams;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

class Teams extends ConsumerWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('teams', ref.read(teamsList.notifier), ref);
    List teams = ref.watch(teamsList);

    return SatoriContainer(
        child: SfDataGrid(
      columns: [
        GridColumn(columnName: 'id', label: Text("ID")),
        GridColumn(columnName: 'name', label: Text("Name")),
        GridColumn(columnName: 'permissions', label: Text("Permissions")),
        GridColumn(columnName: 'owner', label: Text("Owner"))
      ],
      source: TeamDS(teams),
    ));
  }
}
