import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../states.dart';

class SatoriContainer extends ConsumerStatefulWidget {
  const SatoriContainer({
    super.key,
    required this.child,
    this.radius = 6.0,
    this.margin = 8.0,
    this.padding = 8.0,
    this.opacity = 0.12,
    this.borderColor,
    this.borderWidth = 1.0,
    this.cursor = MouseCursor.defer,
    this.hoverEffect = false,
    this.onTap,
    this.width,
    this.height,
  });
  final Widget child;
  final double radius;
  final double margin;
  final double padding;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final MouseCursor cursor;
  final bool hoverEffect;
  final void Function()? onTap;
  final double? width;
  final double? height;
  @override
  ConsumerState<SatoriContainer> createState() => _FrostedContainer();
}

class _FrostedContainer extends ConsumerState<SatoriContainer> {
  bool _isHover = false;

  void updateIsHover(newState) {
    setState(() {
      _isHover = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    double saturation = 66;
    double lightness = 20;
    Color background =
        HSLuvColor.fromHSL(ref.read(pageHue), saturation, lightness).toColor();
    Color backgroundHover =
        HSLuvColor.fromColor(background).withLightness(25).toColor();
    return MouseRegion(
        cursor: widget.cursor,
        onEnter: widget.hoverEffect ? (event) => updateIsHover(true) : null,
        onExit: widget.hoverEffect ? (event) => updateIsHover(false) : null,
        child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: EdgeInsets.all(widget.margin),
              child: AnimatedContainer(
                padding: EdgeInsets.all(widget.padding),
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: widget.borderWidth,
                      color: widget.borderColor ??
                          const Color.fromARGB(100, 255, 255, 255)),
                  color: _isHover ? backgroundHover : background,
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.radius)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0.0, 6.0),
                        spreadRadius: -6,
                        blurRadius: 6),
                  ],
                ),
                child: widget.child,
              ),
            )));
  }
}
