import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_handler.dart';
import 'responsive_grid.dart';

class CommitsController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Commits extends StatelessWidget {
  const Commits({super.key});

  @override
  Widget build(BuildContext context) {
    final CommitsController m = Get.put(CommitsController());
    getFromApi('report/info?repo=all', m);
    return Obx(() => ResponsiveGrid(
          elements: m.list,
        ));
  }
}
