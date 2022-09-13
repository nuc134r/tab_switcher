import 'dart:ui' as ui;

import 'package:flutter/material.dart';

abstract class TabSwitcherTab {
  TabInfo getInfo(BuildContext context);

  Widget build(BuildContext context);

  Widget getContent(BuildContext context) => _content ??= build(context);

  ui.Image? previewImage; // TODO Move out of here

  Widget? _content;
  late int index;
  final UniqueKey key = UniqueKey();
}

class TabInfo {
  TabInfo({
    required this.title,
    required this.tag,
    this.subtitle,
    this.actions,
    this.leading,
  });
  final Widget title;
  final Widget? subtitle;
  final String tag;
  final List<Widget>? actions;
  final Widget? leading;
}
