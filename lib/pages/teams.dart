import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:satori_app/widgets/text_utils.dart';

import '../api_handler.dart';
import '../widgets/dynamic_table.dart';

class TeamsList extends StateNotifier<List> {
  TeamsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final teamsList =
    StateNotifierProvider<TeamsList, List>((ref) => TeamsList(ref));

class Teams extends ConsumerWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('teams', ref.read(teamsList.notifier), ref);
    List teams = ref.watch(teamsList);
    return teams.isEmpty
        ? Text("Loading")
        : DynamicTable(teams);
  }
}
