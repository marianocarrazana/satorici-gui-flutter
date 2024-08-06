import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_handler.dart';
import '../widgets/dynamic_table.dart';

class ReportsList extends StateNotifier<List> {
  ReportsList(this.ref) : super([]);
  final Ref ref;
  void updateList(newList) {
    state = newList;
  }
}

final reportsList =
    StateNotifierProvider<ReportsList, List>((ref) => ReportsList(ref));

class Reports extends ConsumerWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getFromApi('reports', ref.read(reportsList.notifier), ref);
    List reports = ref.watch(reportsList);
    log(reports.toString());
    return reports.isEmpty ? const Text("Loading...") : DynamicTable(reports);
  }
}
