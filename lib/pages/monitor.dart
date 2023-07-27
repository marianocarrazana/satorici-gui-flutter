import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_handler.dart';
import '../widgets/key_renderer.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/satori_container.dart';

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
    List monitors = ref.watch(monitorsList);
    return ResponsiveGrid(children: [
      for (var monitor in monitors) SatoriContainer(child: KeyRenderer(monitor))
    ]);
  }
}
