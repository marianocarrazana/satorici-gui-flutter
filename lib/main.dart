import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config_controller.dart';
import 'home.dart';
import 'monitor.dart';
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
        defaultTransition: Transition.noTransition,
        initialRoute: '/home',
        theme: ThemeData.dark(),
        getPages: [
          GetPage(name: '/home', page: () => SplitView(content: Home())),
          GetPage(
              name: '/reports',
              page: () => const SplitView(content: Reports())),
          GetPage(
              name: '/monitor', page: () => const SplitView(content: Monitor()))
        ]);
  }
}
