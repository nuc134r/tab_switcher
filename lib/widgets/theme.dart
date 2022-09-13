import 'package:flutter/material.dart';

import '../impl.dart';

class TabSwitcherThemeData {
  const TabSwitcherThemeData({
    this.backgroundColor,
    this.foregroundColor,
    this.selectedColor,
    this.appBarHeight = 56,
    this.tabGridHeight = 256,
    this.tabListHeight = 148,
    this.appBarBuilder,
    this.bodyBuilder,
    this.emptyScreenBuilder,
    this.switcherFooterBuilder,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? selectedColor;
  final int appBarHeight;
  final double tabGridHeight;
  final double tabListHeight;
  final TabWidgetBuilder? appBarBuilder;
  final TabWidgetBuilder? bodyBuilder;
  final WidgetBuilder? emptyScreenBuilder;
  final WidgetBuilder? switcherFooterBuilder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TabSwitcherThemeData &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.selectedColor == selectedColor &&
        other.appBarHeight == appBarHeight &&
        other.tabGridHeight == tabGridHeight &&
        other.tabListHeight == tabListHeight;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode ^
        foregroundColor.hashCode ^
        selectedColor.hashCode ^
        appBarHeight.hashCode ^
        tabGridHeight.hashCode ^
        tabListHeight.hashCode;
  }
}

class TabSwitcherTheme extends InheritedWidget {
  TabSwitcherTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final TabSwitcherThemeData data;

  static TabSwitcherThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabSwitcherTheme>()!.data;
  }

  @override
  bool updateShouldNotify(TabSwitcherTheme oldWidget) {
    return data != oldWidget.data;
  }
}
