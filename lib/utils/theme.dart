import 'package:flutter/material.dart';

import 'impl.dart';

class TabSwitcherThemeData {
  const TabSwitcherThemeData({
    this.backgroundColor,
    this.foregroundColor,
    this.selectedTabColor,
    this.unselectedTabColor,
    this.tabShadowColor,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.appBarHeight = 56,
    this.tabGridHeight = 256,
    this.tabListHeight = 148,
    this.appBarBuilder,
    this.bodyBuilder,
    this.tabBuilder,
    this.emptyScreenBuilder,
    this.switcherFooterBuilder,
    this.tabRadius,
    this.emptyTabsText = 'No open tabs',
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? selectedTabColor;
  final Color? unselectedTabColor;
  final Color? tabShadowColor;
  final Color? appBarBackgroundColor;
  final Color? appBarForegroundColor;
  final double appBarHeight;
  final double tabGridHeight;
  final double tabListHeight;
  final TabWidgetBuilder? appBarBuilder;
  final TabWidgetBuilder? bodyBuilder;
  final TabWidgetBuilder? tabBuilder;
  final WidgetBuilder? emptyScreenBuilder;
  final WidgetBuilder? switcherFooterBuilder;
  final BorderRadiusGeometry? tabRadius;
  final String emptyTabsText;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TabSwitcherThemeData &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.selectedTabColor == selectedTabColor &&
        other.unselectedTabColor == unselectedTabColor &&
        other.tabShadowColor == tabShadowColor &&
        other.appBarBackgroundColor == appBarBackgroundColor &&
        other.appBarForegroundColor == appBarForegroundColor &&
        other.appBarHeight == appBarHeight &&
        other.tabGridHeight == tabGridHeight &&
        other.tabListHeight == tabListHeight &&
        other.appBarBuilder == appBarBuilder &&
        other.bodyBuilder == bodyBuilder &&
        other.tabBuilder == tabBuilder &&
        other.emptyScreenBuilder == emptyScreenBuilder &&
        other.switcherFooterBuilder == switcherFooterBuilder &&
        other.tabRadius == tabRadius &&
        other.emptyTabsText == emptyTabsText;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode ^
        foregroundColor.hashCode ^
        selectedTabColor.hashCode ^
        unselectedTabColor.hashCode ^
        tabShadowColor.hashCode ^
        appBarBackgroundColor.hashCode ^
        appBarForegroundColor.hashCode ^
        appBarHeight.hashCode ^
        tabGridHeight.hashCode ^
        tabListHeight.hashCode ^
        appBarBuilder.hashCode ^
        bodyBuilder.hashCode ^
        tabBuilder.hashCode ^
        emptyScreenBuilder.hashCode ^
        switcherFooterBuilder.hashCode ^
        tabRadius.hashCode ^
        emptyTabsText.hashCode;
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
