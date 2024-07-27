import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satori_app/widgets/text_utils.dart';

import '../api_handler.dart';
class TeamsList extends StateNotifier<List> {
  TeamsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final teamsList =
    StateNotifierProvider<TeamsList, List>((ref) => TeamsList(ref));

class _TeamsDataSource extends DataTableSource {
  _TeamsDataSource(this.teams, this.ref);
  final List teams;
  final WidgetRef ref;

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => teams.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    final team = teams[index];
    return DataRow(
      cells: [
        DataCell(Text(team['id'])),
        DataCell(Text(team['name'])),
        DataCell(Text(team['permissions'])),
        DataCell(Text(team['owner'])),
      ],
    );
  }
}

class Teams extends ConsumerWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('teams', ref.read(teamsList.notifier), ref);
    List teams = ref.watch(teamsList);

    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Permissions")),
        DataColumn(label: Text("Owner")),
      ],
      source: _TeamsDataSource(teams, ref),
      rowsPerPage: 15,
    );
  }
}
