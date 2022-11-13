import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config_controller.dart';
import 'home.dart';
import 'monitor.dart';
import 'ci.dart';
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
                    hue: 197,
                  )),
          GetPage(
              name: '/ci',
              page: () => const SplitView(
                    content: CI(),
                    hue: 149,
                  )),
          GetPage(
              name: '/monitor',
              page: () => const SplitView(content: Monitor(), hue: 97)),
          GetPage(
              name: '/reports',
              page: () => const SplitView(content: Home(), hue: 49))
        ]);
  }
}
