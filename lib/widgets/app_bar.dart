import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../controller.dart';
import '../impl.dart';
import '../utils/responsive_page_view_scroll_physics.dart';

/// Wraps supplied app bar builder to add gesture support, animations and transitions
class TabSwitcherAppBar extends StatelessWidget implements PreferredSizeWidget {
  TabSwitcherAppBar(
    this.builder,
    this.controller,
    this.pageController,
    this.mediaQuery,
    this.appBarHeight,
    this.backgroundColor,
  );

  final PageController pageController;
  final TabWidgetBuilder? builder;
  final MediaQueryData mediaQuery;
  final int appBarHeight;
  final TabSwitcherController controller;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onVerticalDragStart: (d) {
          if (!controller.switcherActive) {
            controller.switcherActive = true;
          }
        },
        child: Container(
          height: mediaQuery.padding.top + appBarHeight,
          child: Stack(
            children: [
              builder!(context, null),
              IgnorePointer(
                ignoring: controller.switcherActive,
                child: AnimatedOpacity(
                  child: controller.switcherActive
                      ? builder!(
                          context,
                          controller.currentTab != null ? controller.tabs[controller.currentTab!.index] : null,
                        )
                      : Container(
                          color: backgroundColor,
                          child: PageView.builder(
                            controller: pageController,
                            physics: ResponsiveBouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            itemCount: controller.tabCount,
                            itemBuilder: (c, i) => builder!(context, controller.tabs[i]),
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

  @override
  Size get preferredSize => Size(double.infinity, mediaQuery.padding.top + appBarHeight);
}
