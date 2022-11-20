import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'config_controller.dart';

getFromApi(url, m) {
  final ConfigController c = Get.find();
  final getConnect = GetConnect();
  getConnect.timeout = const Duration(minutes: 1);
  String token = c.token;
  Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Authorization': 'token $token'
  };
  String apiHost = 'https://nuvyp2kffa.execute-api.us-east-2.amazonaws.com';
  if (m.list.isNotEmpty) {
    c.updateStatus(2);
  } else {
    c.updateStatus(0);
    log('$apiHost/$url');
    getConnect.get('$apiHost/$url', headers: requestHeaders).then((response) {
      log(response.statusCode.toString());
      if (response.isOk) {
        c.updateStatus(1);
        m.updateList(response.body);
      } else {
        c.updateStatus(3);
        log("error");
      }
    }).catchError((e) {
      log(e.toString());
    });
  }
}
