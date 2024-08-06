import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_handler.dart';
import '../widgets/dynamic_table.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('repos', ref.read(reposList.notifier), ref);
    List repos = ref.watch(reposList);
    return repos.isEmpty ? const Text("Loading...") : DynamicTable(repos);
  }
}
