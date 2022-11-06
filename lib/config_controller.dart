import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfigController extends GetxController {
  final box = GetStorage();
  String api_host = 'https://nuvyp2kffa.execute-api.us-east-2.amazonaws.com';
  String get token => box.read('token') ?? '';
  void setToken(String newToken) => box.write('token', newToken);
}
