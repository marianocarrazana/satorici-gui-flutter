import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satori_app/widgets/text_utils.dart';

import 'api_handler.dart';
import 'widgets/satori_container.dart';
import 'key_renderer.dart';
import 'widgets/responsive_grid.dart';

class ReposList extends StateNotifier<List> {
  ReposList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final reposList =
    StateNotifierProvider<ReposList, List>((ref) => ReposList(ref));

class Repos extends ConsumerWidget {
  const Repos({super.key});

  List<Widget> _getListings(List repos) {
    var listings = <Widget>[];
    for (var mon in repos) {
      var mon2 = Map<String, dynamic>.from(mon);
      List toRemove = ['Repo', 'Result'];
      mon2.removeWhere((key, value) => toRemove.contains(key));
      listings.add(SatoriContainer(
          child: Column(children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
            child: Row(children: [
              Expanded(
                  child: Text(
                mon["repo"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              TextStatus(mon["result"])
            ])),
        Expanded(
            child: KeyRenderer(
          objList: mon2,
        ))
      ])));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('repos', ref.read(reposList.notifier), ref);
    List todos = ref.watch(reposList);
    return ResponsiveGrid(
      children: _getListings(todos),
    );
  }
}
