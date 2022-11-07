import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'config_controller.dart';

class ReportsController extends GetxController {
  final _monitors = RxList([]);
  List get monitors => _monitors.value;
  updateMonitors(newList) => _monitors.value = newList;
}

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController c = Get.find();
    final ReportsController m = Get.put(ReportsController());
    String token = c.token;
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'token $token'
    };
    var apiHost = c.api_host;
    http
        .get(Uri.parse('$apiHost/ci'), headers: requestHeaders)
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        m.updateMonitors(jsonDecode(response.body));
      } else {
        print("error");
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
      listings.add(Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(95, 0, 0, 0), width: 1),
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 32, 101, 204),
              Color.fromARGB(255, 15, 46, 101)
            ]),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(108, 11, 23, 33),
                  offset: new Offset(4, 4),
                  blurRadius: 6),
            ],
          ),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            for (var key in mon.keys)
              Row(
                children: [
                  Text('$key: '),
                  Text(
                    mon[key] != null ? mon[key] : 'None',
                    overflow: TextOverflow.ellipsis,
                  )
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
