import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedContainer extends StatelessWidget {
  const FrostedContainer(
      {super.key,
      required this.child,
      this.blur = 8.0,
      this.radius = 5.0,
      this.margin = 8.0,
      this.padding = 8.0,
      this.opacity = 0.37,
      this.borderColor,
      this.borderWidth = 2.0});
  final Widget child;
  final double blur;
  final double radius;
  final double margin;
  final double padding;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
        child: Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(margin),
              decoration: BoxDecoration(
                  border:
                      Border.all(width: borderWidth, color: Colors.transparent),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(100, 11, 23, 33),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 5),
                  ]),
            )),
        Container(
            margin: EdgeInsets.all(margin),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: borderWidth,
                        color:
                            borderColor ?? Color.fromARGB(100, 255, 255, 255)),
                    color: Colors.white.withOpacity(opacity),
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                  ),
                  child: child,
                ),
              ),
            ))
      ],
    ));
  }
}
