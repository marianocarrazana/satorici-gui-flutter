import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'satori_container.dart';

class SatoriCard extends ConsumerWidget {
  const SatoriCard({
    super.key,
    required this.body,
    this.header,
    this.footer,
    this.onTap,
    this.cursor = MouseCursor.defer,
    this.hoverEffect = false,
  });
  final Widget body;
  final List<Widget>? header;
  final List<Widget>? footer;
  final void Function()? onTap;
  final MouseCursor cursor;
  final bool hoverEffect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SatoriContainer(
        hoverEffect: hoverEffect,
        onTap: onTap,
        cursor: cursor,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: header ?? []),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: body)),
          Row(children: footer ?? [])
        ]));
  }
}
