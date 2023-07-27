import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home.dart';
import 'pages/monitor.dart';
import 'pages/playbooks.dart';
import 'pages/repos.dart';
import 'pages/teams.dart';
import 'pages/reports.dart';
import 'splitview.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  _page(RouteSettings settings, Widget child) => PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, a, __, c) =>
          FadeTransition(opacity: a, child: c));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'SAPP',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark().copyWith(
              primary: const HSLColor.fromAHSL(1, 76, 0.94, 0.5).toColor(),
              secondary: const HSLColor.fromAHSL(1, 197, 0.94, 0.5).toColor()),
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.getFont('PT Mono').fontFamily,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/reports":
              return _page(
                  settings,
                  const SplitView(
                      content: Reports(), command: "satori-cli report"));
            case "/teams":
              return _page(
                  settings,
                  const SplitView(
                      content: Teams(), command: "satori-cli team"));
            case "/repos":
              return _page(
                  settings,
                  const SplitView(
                      content: Repos(), command: "satori-cli repo"));
            case "/monitors":
              return _page(
                  settings,
                  const SplitView(
                      content: Monitor(), command: "satori-cli monitor"));
            case "/playbooks":
              return _page(
                  settings,
                  const SplitView(
                      content: Playbooks(), command: "satori-cli playbook"));
            default: //home
              return _page(settings,
                  const SplitView(content: Home(), command: "satori-cli"));
          }
        });
  }
}
