import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'config_controller.dart';
import 'frosted_container.dart';

class MonitorController extends GetxController {
  final _monitors = RxList([]);
  List get monitors => _monitors.value;
  updateMonitors(newList) => _monitors.value = newList;
}

class Monitor extends StatelessWidget {
  const Monitor({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController c = Get.find();
    final MonitorController m = Get.put(MonitorController());
    String token = c.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'token $token'
    };
    var apiHost = c.api_host;
    http
        .get(Uri.parse('$apiHost/monitor'), headers: requestHeaders)
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
            child: Obx(() => MonitorList(
                  monitors: m.monitors,
                )))
      ],
    );
  }
}

class MonitorList extends StatelessWidget {
  final monitors;

  const MonitorList({super.key, required this.monitors});
  List<Widget> _getListings() {
    var listings = <Widget>[];
    for (var mon in monitors) {
      listings.add(FrostedContainer(
          padding:10,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var key in mon.keys)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$key: '),
                      Expanded(
                          child: Text(
                        mon[key] ?? 'None',
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ))
                    ],
                  )
              ])));
    }
    return listings;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(2), children: _getListings());
  }
}
