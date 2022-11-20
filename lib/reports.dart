import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'config_controller.dart';
import 'responsive_grid.dart';

class ReportsController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportsController m = Get.put(ReportsController());
    getFromApi('report/info?repo=all', m);
    return Obx(() => ResponsiveGrid(
          elements: m.list,
        ));
  }
}
