import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:satori_app/grid_renderer.dart';

import 'api_handler.dart';

class ReposController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Repos extends StatelessWidget {
  const Repos({super.key});

  @override
  Widget build(BuildContext context) {
    final ReposController m = Get.put(ReposController());
    getFromApi('ci', m);
    return Obx(() => GridRenderer(
          elements: m.list,
        ));
  }
}
