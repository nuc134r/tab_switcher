import 'package:flutter/material.dart';
import 'dart:ui' as ui;

abstract class TabSwitcherTab {
  Widget getTitle();
  String getTag();
  Widget? getSubtitle() => null;

  Widget build(TabState state);
  void onSave(TabState state);
  TabState onLoad() => TabState();

  Widget getContent() => _content ??= build(state);

  ui.Image? previewImage; // TODO Move out of here

  Widget? _content;
  late int index;
  final UniqueKey key = UniqueKey();
  final TabState state = TabState();
}

class TabState {
  void set(String id, dynamic content) => _items[id] = content;
  T get<T>(String id) => _items[id] as T;

  final Map<String, dynamic> _items = <String, dynamic>{};
}
