import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfigController extends GetxController {
  final box = GetStorage();
  String get token => box.read('token') ?? '';
  void setToken(String newToken) => box.write('token', newToken);
  final _status = RxInt(0);//0=loading, 1=loaded, 2=cached, 3=error
  int get status => _status.value;
  updateStatus(newList) => _status.value = newList;
}
