import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'responsive_grid.dart';
import 'frosted_container.dart';
import 'api_handler.dart';
import 'key_renderer.dart';

class ReportController extends GetxController {
  final _list = RxList([]);
  List get list => _list.value;
  updateList(newList) => _list.value = newList;
}

class Report extends StatelessWidget {
  const Report({super.key, required this.uuid});
  final String uuid;
  List<Widget> _getListings() {
    final ReportController m = Get.put(ReportController());
    var listings = <Widget>[];
    for (var mon in m.list) {
      listings.add(FrostedContainer(
          child: KeyRenderer(
        objList: mon,
      )));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    final ReportController m = Get.put(ReportController());
    getFromApi("report/info/$uuid", m, forceReload: true);
    return Obx(() => ResponsiveGrid(elements: _getListings()));
  }
}
