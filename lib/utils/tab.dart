import 'dart:ui' as ui;

import 'package:flutter/material.dart';

abstract class TabSwitcherTab {
  Widget getTitle();
  String getTag();
  Widget? getSubtitle() => null;

  Widget build(BuildContext context);

  Widget getContent(BuildContext context) => _content ??= build(context);

  ui.Image? previewImage; // TODO Move out of here

  Widget? _content;
  late int index;
  final UniqueKey key = UniqueKey();
}
