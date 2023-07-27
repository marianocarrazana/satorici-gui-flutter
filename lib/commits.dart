import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_handler.dart';
import 'widgets/grid_renderer.dart';

class CommitsList extends StateNotifier<List> {
  List list = [];
  CommitsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    list = newList;
  }
}

final commitsList =
    StateNotifierProvider<CommitsList, List>((ref) => CommitsList(ref));

class Commits extends ConsumerWidget {
  const Commits({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('repos/commits', ref.read(commitsList.notifier), ref);
    return GridRenderer(
          elements: ref.read(commitsList.notifier).list,
        );
  }
}
