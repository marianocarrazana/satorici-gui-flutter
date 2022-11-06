import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:satori_app/config_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController c = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(25.0),
            child: TextFormField(
              onFieldSubmitted: c.setToken,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your user token here',
              ),
            )),
      ],
    );
  }
}
