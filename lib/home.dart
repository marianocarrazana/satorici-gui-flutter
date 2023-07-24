import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'states.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  void _setToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', newToken);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<String> token = ref.watch(tokenProvider);
    return token.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (_token) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    onFieldSubmitted: (e) {
                      _setToken(e);
                      ref.refresh(tokenProvider);
                    },
                    initialValue: _token,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  )),
            ],
          );
        });
  }
}
