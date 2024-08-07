import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_handler.dart';
import '../widgets/dynamic_table.dart';

class PlaybooksList extends StateNotifier<List> {
  PlaybooksList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final playbooksList =
    StateNotifierProvider<PlaybooksList, List>((ref) => PlaybooksList(ref));

class Playbooks extends ConsumerWidget {
  const Playbooks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('playbooks', ref.read(playbooksList.notifier), ref);
    List playbooks = ref.watch(playbooksList);
    return playbooks.isEmpty
        ? const Text("Loading...")
        : DynamicTable(playbooks);
  }
}
