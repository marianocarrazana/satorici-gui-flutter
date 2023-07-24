import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'states.dart';

getFromApi(url, m, WidgetRef ref, {bool forceReload = false}) {
  final getConnect = Client();
  SharedPreferences.getInstance().then((prefs) {
    String token = prefs.getString('token') ?? "";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    String apiHost = 'https://api.satori-ci.com';
    if (m.state.isEmpty || forceReload) {
      ref.read(status.notifier).state = 0;
      log('$apiHost/$url');
      getConnect
          .get(Uri.https('api.satori-ci.com', url), headers: requestHeaders)
          .then((response) {
        log(response.statusCode.toString());
        if (response.statusCode == 200) {
          ref.read(status.notifier).state = 1;
          // log("Body:");
          // log(response.body.toString());
          dynamic body = jsonDecode(response.body);
          if (body is Map<String, dynamic>) {
            if (body.containsKey("list")) {
              m.updateList(body["list"]);
            } else {
              m.updateList([body]);
            }
          } else if (body is List) {
            m.updateList(body);
          } else {
            List l = [body];
            m.updateList(l);
          }
        } else {
          ref.read(status.notifier).state = 3;
          log("error");
        }
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      ref.read(status.notifier).state = 2;
    }
  });
}
