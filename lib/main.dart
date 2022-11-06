import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home.dart';
import 'monitor.dart';
import 'splitview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'SAPP',
        defaultTransition: Transition.noTransition,
        initialRoute: '/home',
        theme: ThemeData.dark(),
        getPages: [
          GetPage(name: '/home', page: () => SplitView(content: Home())),
          GetPage(
              name: '/reports', page: () => const SplitView(content: Home())),
          GetPage(
              name: '/monitor', page: () => const SplitView(content: Monitor()))
        ]);
  }
}
