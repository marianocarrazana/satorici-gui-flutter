import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'grid_renderer.dart';

class MonitorController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Monitor extends StatelessWidget {
  const Monitor({super.key});

  @override
  Widget build(BuildContext context) {
    final MonitorController m = Get.put(MonitorController());
    getFromApi('monitors', m);
    return Obx(() => GridRenderer(
          elements: m.list,
        ));
  }
}
