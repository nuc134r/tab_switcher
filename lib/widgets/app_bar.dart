import 'package:flutter/material.dart';

import '../utils/controller.dart';
import '../utils/responsive_page_view_scroll_physics.dart';
import '../utils/tab.dart';
import '../utils/theme.dart';
import 'tab_count_icon.dart';

/// Wraps supplied app bar builder to add gesture support, animations and transitions
class TabSwitcherAppBar extends StatelessWidget implements PreferredSizeWidget {
  TabSwitcherAppBar(
    this.controller,
    this.pageController,
    this.mediaQuery,
    this.theme,
  );

  final PageController pageController;
  final MediaQueryData mediaQuery;
  final TabSwitcherController controller;
  final TabSwitcherThemeData theme;

  @override
  Widget build(BuildContext context) {
    final tab = controller.currentTab;
    final bgColor = theme.backgroundColor ?? Colors.transparent;
    final appBarHeight = mediaQuery.padding.top + theme.appBarHeight;
    return GestureDetector(
      onVerticalDragStart: (d) {
        if (!controller.switcherActive) {
          controller.switcherActive = true;
        }
      },
      child: Container(
        height: appBarHeight,
        color: theme.appBarBackgroundColor,
        child: Stack(
          children: [
            buildAppBar(context, null),
            IgnorePointer(
              ignoring: controller.switcherActive,
              child: AnimatedOpacity(
                child: controller.switcherActive
                    ? buildAppBar(
                        context,
                        tab != null ? controller.tabs[tab.index] : null,
                      )
                    : Container(
                        color: bgColor,
                        child: PageView.builder(
                          controller: pageController,
                          physics: ResponsiveBouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: controller.tabCount,
                          itemBuilder: (c, i) {
                            return buildAppBar(context, controller.tabs[i]);
                          },
                        ),
                      ),
                duration: Duration(milliseconds: 125),
                opacity: controller.switcherActive ? 0 : 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context, TabSwitcherTab? tab) {
    if (theme.appBarBuilder != null) {
      return theme.appBarBuilder!(context, tab);
    }
    return AppBar(
      backgroundColor: theme.appBarBackgroundColor,
      foregroundColor: theme.appBarForegroundColor,
      actions: [
        TabCountIcon(controller: controller),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, mediaQuery.padding.top + theme.appBarHeight);
}
