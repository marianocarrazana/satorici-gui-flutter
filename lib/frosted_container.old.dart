import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedContainer extends StatefulWidget {
  const FrostedContainer(
      {super.key,
      required this.child,
      this.blur = 8.0,
      this.radius = 5.0,
      this.margin = 8.0,
      this.padding = 8.0,
      this.opacity = 0.37,
      this.borderColor,
      this.borderWidth = 2.0,
      this.cursor = MouseCursor.defer,
      this.hoverEffect = false,
      this.onTap,
      this.width,
      this.height});
  final Widget child;
  final double blur;
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
  State<FrostedContainer> createState() => _FrostedContainer();
}

class _FrostedContainer extends State<FrostedContainer> {
  bool _isHover = false;

  void updateIsHover(newState) {
    setState(() {
      _isHover = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: widget.cursor,
        onEnter: widget.hoverEffect ? (event) => updateIsHover(true) : null,
        onExit: widget.hoverEffect ? (event) => updateIsHover(false) : null,
        child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
                width: widget.width,
                height: widget.height,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.all(widget.margin),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: widget.borderWidth,
                                  color: Colors.transparent),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(widget.radius)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(100, 11, 23, 33),
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 5),
                              ]),
                        )),
                    Container(
                        margin: EdgeInsets.all(widget.margin),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: widget.blur, sigmaY: widget.blur),
                            child: AnimatedContainer(
                              clipBehavior: Clip.hardEdge,
                              padding: EdgeInsets.all(widget.padding),
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: widget.borderWidth,
                                    color: widget.borderColor ??
                                        Color.fromARGB(100, 255, 255, 255)),
                                color: Colors.white.withOpacity(
                                    _isHover ? .75 : widget.opacity),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(widget.radius)),
                              ),
                              child: widget.child,
                            ),
                          ),
                        ))
                  ],
                ))));
  }
}
