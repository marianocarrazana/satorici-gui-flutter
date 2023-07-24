import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_handler.dart';
import 'grid_renderer.dart';

class MonitorsList extends StateNotifier<List> {
  MonitorsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final monitorsList =
    StateNotifierProvider<MonitorsList, List>((ref) => MonitorsList(ref));


class Monitor extends ConsumerWidget {
  const Monitor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('monitors', ref.read(monitorsList.notifier), ref);
    List todos = ref.watch(monitorsList);
    return GridRenderer(
          elements: todos,
        );
  }
}
