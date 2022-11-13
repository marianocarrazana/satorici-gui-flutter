import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:satori_app/responsive_grid.dart';

import 'config_controller.dart';

class CIController extends GetxController {
  final _monitors = RxList([]);
  List get monitors => _monitors.value;
  updateMonitors(newList) => _monitors.value = newList;
}

class CI extends StatelessWidget {
  const CI({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController c = Get.find();
    final CIController m = Get.put(CIController());
    String token = c.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'token $token'
    };
    var apiHost = c.api_host;
    http
        .get(Uri.parse('$apiHost/ci'), headers: requestHeaders)
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        m.updateMonitors(jsonDecode(response.body));
      } else {
        log("error");
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Obx(() => ResponsiveGrid(
                  elements: m.monitors,
                )))
      ],
    );
  }
}
