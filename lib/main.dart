import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'commits.dart';
import 'home.dart';
import 'monitor.dart';
import 'repos.dart';
import 'reports.dart';
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
            case "/commits":
              return _page(
                  settings,
                  const SplitView(
                      content: Commits(), command: "satori-cli repo commits"));
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
            default: //home
              return _page(settings,
                  const SplitView(content: Home(), command: "satori-cli"));
          }
        });
  }
}
