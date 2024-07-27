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
    this.borderWidth = 2.0,
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
  ConsumerState<SatoriContainer> createState() => _SatoriContainer();
}

class _SatoriContainer extends ConsumerState<SatoriContainer> {
  bool _isHover = false;

  void updateIsHover(newState) {
    setState(() {
      _isHover = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    double saturation = 0.33;
    double lightness = 0.03;
    double hue = ref.read(pageHue);
    Color background =
        HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
    Color borderColor1 = HSLColor.fromAHSL(1, hue, 1, 0.5).toColor();
    Color borderColor2 = HSLColor.fromAHSL(1, hue + 180, 1, 0.5).toColor();
    Color backgroundHover =
        HSLuvColor.fromColor(background).withLightness(25).toColor();
    const BoxShadow shadow = BoxShadow(
        color: Colors.black,
        offset: Offset(0.0, 6.0),
        spreadRadius: -6,
        blurRadius: 6);
    BoxShadow shadowHover = BoxShadow(
        color: HSLColor.fromAHSL(1, hue, 0.85, 0.65).toColor(), blurRadius: 6);
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
                  padding: const EdgeInsets.all(1.5),
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      transform: const GradientRotation(60),
                      colors: [borderColor1, borderColor2],
                    ),
                    borderRadius: BorderRadius.circular(widget.radius),
                    boxShadow: [_isHover ? shadowHover : shadow],
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: _isHover ? backgroundHover : background,
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: widget.child,
                      ))),
            )));
  }
}
