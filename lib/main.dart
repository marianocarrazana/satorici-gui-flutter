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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'SAPP',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.getFont('PT Mono').fontFamily,
        ),
        initialRoute: "/home",
        routes: {
          '/home': (context) => const SplitView(
                content: Home(),
                hue: 138,
                command: "satori-cli",
              ),
          '/reports': (context) => const SplitView(
              content: Reports(), hue: 238, command: "satori-cli report"),
          '/commits': (context) => const SplitView(
              content: Commits(), hue: 298, command: "satori-cli repo commits"),
          '/repos': (context) => const SplitView(
              content: Repos(), hue: 38, command: "satori-cli repo"),
          '/monitor': (context) => const SplitView(
              content: Monitor(), hue: 98, command: "satori-cli monitor"),
        });
  }
}
