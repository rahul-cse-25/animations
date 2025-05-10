import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            MyContainer(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(20),
              width: 200,
              height: 100,
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: const Text(
                "Custom Container",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyContainer extends SingleChildRenderObjectWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final BoxDecoration? decoration;

  const MyContainer({
    super.key,
    super.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.alignment,
    this.decoration,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMyContainer(
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      color: color,
      width: width,
      height: height,
      alignment: alignment ?? Alignment.topLeft,
      decoration: decoration,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderMyContainer renderObject) {
    renderObject
      ..padding = padding ?? EdgeInsets.zero
      ..margin = margin ?? EdgeInsets.zero
      ..color = color
      ..width = width
      ..height = height
      ..alignment = alignment ?? Alignment.topLeft
      ..decoration = decoration;
  }
}

class RenderMyContainer extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  EdgeInsets _padding;
  EdgeInsets _margin;
  Color? _color;
  double? _width;
  double? _height;
  Alignment _alignment;
  BoxDecoration? _decoration;

  RenderMyContainer({
    required EdgeInsets padding,
    required EdgeInsets margin,
    required Alignment alignment,
    Color? color,
    double? width,
    double? height,
    BoxDecoration? decoration,
  })  : _padding = padding,
        _margin = margin,
        _alignment = alignment,
        _color = color,
        _width = width,
        _height = height,
        _decoration = decoration;

  set padding(EdgeInsets value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  set margin(EdgeInsets value) {
    if (_margin == value) return;
    _margin = value;
    markNeedsLayout();
  }

  set color(Color? value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  set width(double? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  set height(double? value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  set alignment(Alignment value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  set decoration(BoxDecoration? value) {
    if (_decoration == value) return;
    _decoration = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    final BoxConstraints innerConstraints = constraints.deflate(_margin);

    Size childSize = Size.zero;
    if (child != null) {
      final BoxConstraints paddedConstraints =
          innerConstraints.deflate(_padding);
      child!.layout(paddedConstraints, parentUsesSize: true);
      childSize = child!.size;
    }

    final double containerWidth =
        _width ?? (_padding.horizontal + childSize.width);
    final double containerHeight =
        _height ?? (_padding.vertical + childSize.height);

    size = constraints.constrain(Size(containerWidth, containerHeight) +
        Offset(_margin.horizontal, _margin.vertical));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final Rect innerRect = Rect.fromLTWH(
      offset.dx + _margin.left,
      offset.dy + _margin.top,
      size.width - _margin.horizontal,
      size.height - _margin.vertical,
    );

    if (_decoration != null) {
      _decoration!.createBoxPainter().paint(
          canvas, innerRect.topLeft, ImageConfiguration(size: innerRect.size));
    } else if (_color != null) {
      final Paint paint = Paint()..color = _color!;
      canvas.drawRect(innerRect, paint);
    }

    if (child != null) {
      final double x = _alignment
          .alongOffset(Offset(
            innerRect.width - child!.size.width,
            innerRect.height - child!.size.height,
          ))
          .dx;

      final double y = _alignment
          .alongOffset(Offset(
            innerRect.width - child!.size.width,
            innerRect.height - child!.size.height,
          ))
          .dy;

      final Offset childOffset = Offset(
        innerRect.left + _padding.left + x,
        innerRect.top + _padding.top + y,
      );

      context.paintChild(child!, childOffset);
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;
}
