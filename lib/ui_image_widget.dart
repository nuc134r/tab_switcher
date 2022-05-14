import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Renders [ui.Image] data faster than encoding and displaying in [Image.memory].
class UiImageWidget extends StatelessWidget {
  final ui.Image image;
  final BoxFit fit;

  const UiImageWidget({
    Key? key,
    required this.image,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _UiImageWidgetPainter(image, fit));
  }
}

class _UiImageWidgetPainter extends CustomPainter {
  final ui.Image image;
  final BoxFit fit;

  _UiImageWidgetPainter(this.image, this.fit);

  @override
  void paint(Canvas canvas, Size size) {
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.center.inscribe(sizes.destination, Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawImageRect(
      image,
      inputSubrect,
      outputSubrect,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(_UiImageWidgetPainter oldDelegate) {
    return image != oldDelegate.image;
  }
}
