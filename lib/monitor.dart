import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'responsive_grid.dart';

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
    getFromApi('monitor', m);
    return Obx(() => ResponsiveGrid(
          elements: m.list,
        ));
  }
}
