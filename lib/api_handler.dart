import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'config_controller.dart';

getFromApi(url, m, {bool forceReload = false}) {
  final ConfigController c = Get.find();
  final getConnect = GetConnect();
  getConnect.timeout = const Duration(minutes: 1);
  String token = c.token;
  Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  String apiHost = 'https://api.satori-ci.com';
  if (m.list.isEmpty || forceReload) {
    c.updateStatus(0);
    log('$apiHost/$url');
    getConnect.get('$apiHost/$url', headers: requestHeaders).then((response) {
      log(response.statusCode.toString());
      if (response.isOk) {
        c.updateStatus(1);
        log((response.body is Map<String, dynamic>).toString());
        if (response.body is Map<String, dynamic>) {
          m.updateList(response.body["list"]);
        } else if (response.body is List) {
          m.updateList(response.body);
        } else {
          List l = [response.body];
          m.updateList(l);
        }
      } else {
        c.updateStatus(3);
        log("error");
      }
    }).catchError((e) {
      log(e.toString());
    });
  } else {
    c.updateStatus(2);
  }
}
