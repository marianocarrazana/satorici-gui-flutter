import 'package:flutter/material.dart';
import 'package:hsluv/hsluvcolor.dart';

class TextStatus extends StatelessWidget {
  const TextStatus(this.data, {super.key});
  final String data;

  @override
  Widget build(BuildContext context) {
    final isSuccess = RegExp(r'(Pass|Completed)$');
    final isFail = RegExp(r'Fail(\([\w]+\))?$');
    String data = this.data;
    Widget icon;
    var iconSize = 14.0;
    if (isSuccess.hasMatch(data)) {
      icon = Icon(
        Icons.check_circle,
        color: const HSLuvColor.fromHSL(135, 100, 63).toColor(),
        size: iconSize,
      );
    } else if (isFail.hasMatch(data)) {
      icon = Icon(Icons.cancel,
          color: const HSLuvColor.fromHSL(0, 100, 60).toColor(),
          size: iconSize);
    } else {
      icon = Icon(Icons.warning_amber_rounded,
          color: Colors.orange, size: iconSize);
    }
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [icon, Text(data)]);
  }
}

class TextLabel extends StatelessWidget {
  const TextLabel(this.label, this.data, {super.key});
  final String label;
  final String data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(data)
      ],
    );
  }
}
