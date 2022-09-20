import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef ImageCaptureCallback = void Function(ui.Image image);

/// Generates image from child widget right before detaching from the widget tree
/// and calls callback with the captured image
/// TODO Customizable image quality (pixelRatio)
class PreviewCapturerWidget extends StatefulWidget {
  PreviewCapturerWidget({required this.child, required this.callback, required this.tag});

  final Widget child;
  final ImageCaptureCallback callback;
  final String tag;

  @override
  State<PreviewCapturerWidget> createState() => _PreviewCapturerWidgetState();
}

class _PreviewCapturerWidgetState extends State<PreviewCapturerWidget> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: widget.child, key: _key);

  @override
  void deactivate() {
    super.deactivate();
    _captureImage();
  }

  void _captureImage() async {
    //Logger.measure("TabPreview", "Capture", () async {
    var ro = _key.currentContext?.findRenderObject();
    if (ro is RenderRepaintBoundary) {
      RenderRepaintBoundary boundary = ro;
      var retries = 3;
      do {
        try {
          ui.Image image = await boundary.toImage(pixelRatio: 1.5);
          widget.callback(image);
          return;
        } catch (e) {
          if (true) {}
        }
        await Future.delayed(Duration(milliseconds: 20));
      } while (--retries != 0);
    }
    //});
  }
}
