import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:satori_app/widgets/satori_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../states.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  void _setConfig(String key, String newValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, newValue);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<String, String>> globalConfig =
        ref.watch(globalConfigProvider);
    return globalConfig.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (_config) {
          return SatoriCard(
            hoverEffect: false,
            body: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    obscureText: false,
                    onChanged: (e) {
                      _setConfig("host", e);
                      ref.refresh(globalConfigProvider);
                    },
                    initialValue: _config["host"],
                    decoration: const InputDecoration(
                      labelText: "Host",
                      hintText: "Satori api host url",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    obscureText: false,
                    onChanged: (e) {
                      _setConfig("token", e);
                      ref.refresh(globalConfigProvider);
                    },
                    initialValue: _config["token"],
                    decoration: const InputDecoration(
                      labelText: "Token",
                      hintText: "Team or personal token from satori.ci",
                      border: UnderlineInputBorder(),
                    ),
                  )
                ]),
          );
        });
  }
}
