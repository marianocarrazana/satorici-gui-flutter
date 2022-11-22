import 'package:flutter/material.dart';

class TextStatus extends StatelessWidget {
  const TextStatus(this.data, {super.key});
  final String? data;

  @override
  Widget build(BuildContext context) {
    final isSuccess = RegExp(r'(Pass|Completed)$');
    final isFail = RegExp(r'Fail(\([\w]+\))?$');
    String data = this.data ?? '';
    Widget icon;
    var iconSize = 14.0;
    if (isSuccess.hasMatch(data)) {
      icon = Icon(
        Icons.check_circle,
        color: Color.fromARGB(255, 63, 255, 70),
        size: iconSize,
      );
    } else if (isFail.hasMatch(data)) {
      icon = Icon(Icons.cancel,
          color: Color.fromARGB(255, 255, 59, 45), size: iconSize);
    } else {
      icon = Icon(Icons.error, color: Colors.orange, size: iconSize);
    }
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [icon, Text(data)]);
  }
}
