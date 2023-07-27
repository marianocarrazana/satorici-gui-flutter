import 'dart:convert';

import 'package:flutter/material.dart';

class KeyRenderer extends StatelessWidget {
  const KeyRenderer(this.objList,
      {super.key, this.maxLines = 1, this.softWrap = false});
  final Map<String, dynamic> objList;
  final int? maxLines;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (var key in objList.keys)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$key: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Text(
              json.encode(objList[key]),
              overflow: TextOverflow.fade,
              maxLines: maxLines,
              softWrap: softWrap,
            ))
          ],
        )
    ]);
  }
}
