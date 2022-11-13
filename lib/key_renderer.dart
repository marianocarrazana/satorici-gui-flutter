import 'package:flutter/material.dart';

class KeyRenderer extends StatelessWidget {
  const KeyRenderer({super.key, required this.objList});
  final Map<String, dynamic> objList;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (var key in objList.keys)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$key: '),
            Expanded(
                child: Text(
              objList[key] ?? 'None',
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ))
          ],
        )
    ]);
  }
}
