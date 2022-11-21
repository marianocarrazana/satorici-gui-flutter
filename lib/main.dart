import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'report.dart';
import 'commits.dart';
import 'config_controller.dart';
import 'home.dart';
import 'monitor.dart';
import 'repos.dart';
import 'reports.dart';
import 'splitview.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ConfigController c = Get.put(ConfigController());

    return GetMaterialApp(
        title: 'SAPP',
        defaultTransition: Transition.fadeIn,
        initialRoute: '/home',
        theme: ThemeData.light(),
        getPages: [
          GetPage(
              name: '/home',
              page: () => const SplitView(
                    content: Home(),
                    hue: 138,
                    command: "satori-cli",
                  )),
          GetPage(
              name: '/reports',
              page: () => const SplitView(
                  content: Reports(),
                  hue: 238,
                  command: "satori-cli reports all")),
          GetPage(
              name: '/commits',
              page: () => const SplitView(
                  content: Commits(),
                  hue: 298,
                  command: "satori-cli reports all")),
          GetPage(
              name: '/repos',
              page: () => const SplitView(
                  content: Repos(), hue: 38, command: "satori-cli ci")),
          GetPage(
              name: '/monitor',
              page: () => const SplitView(
                  content: Monitor(), hue: 98, command: "satori-cli monitor")),

        ]);
  }
}
