import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tab_switcher/tab_switcher_controller.dart';

typedef TabWidgetBuilder = Widget Function(BuildContext context, TabSwitcherTab tab, int index);
typedef ImageCaptureCallback = void Function(ui.Image image);

class PreviewCapturerWidget extends StatefulWidget {
  PreviewCapturerWidget({@required this.child, @required this.callback, this.tag});

  final Widget child;
  final ImageCaptureCallback callback;
  final String tag;

  @override
  State<PreviewCapturerWidget> createState() => _PreviewCapturerWidgetState();
}

class _PreviewCapturerWidgetState extends State<PreviewCapturerWidget> {
  GlobalKey _key = new GlobalKey();

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: widget.child, key: _key);

  @override
  void deactivate() {
    super.deactivate();
    _captureImage();
  }

  void _captureImage() async {
    //Logger.measure("TabPreview", "Capture", () async {
    RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
    var retries = 3;
    do {
      try {
        ui.Image image = await boundary.toImage(pixelRatio: 1);
        if (image != null) {
          widget.callback(image);
          return;
        }
      } catch (e) {}
      await Future.delayed(Duration(milliseconds: 20));
    } while (--retries != 0);
    //});
  }
}
