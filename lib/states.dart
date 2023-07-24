import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currentPage = StateProvider<String>((ref) => "home");
final status =
    StateProvider<int>((ref) => 0); //0=loading, 1=loaded, 2=cached, 3=error

final tokenProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? "";
});
