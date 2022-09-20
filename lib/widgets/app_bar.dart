import 'package:flutter/material.dart';

import '../utils/controller.dart';
import '../utils/responsive_page_view_scroll_physics.dart';
import '../utils/tab.dart';
import '../utils/theme.dart';
import 'tab_count_icon.dart';

/// Wraps supplied app bar builder to add gesture support, animations and transitions
class TabSwitcherAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TabSwitcherAppBar({
    required this.controller,
    required this.pageController,
    required this.mediaQuery,
    required this.theme,
  });

  final PageController pageController;
  final MediaQueryData mediaQuery;
  final TabSwitcherController controller;
  final TabSwitcherThemeData theme;

  @override
  Size get preferredSize => Size(
        double.infinity,
        mediaQuery.padding.top + theme.appBarHeight,
      );

  @override
  State<TabSwitcherAppBar> createState() => _TabSwitcherAppBarState();
}

class _TabSwitcherAppBarState extends State<TabSwitcherAppBar> {
  @override
  Widget build(BuildContext context) {
    final tab = widget.controller.currentTab;
    final bgColor = widget.theme.backgroundColor ?? Colors.transparent;
    final appBarHeight =
        widget.mediaQuery.padding.top + widget.theme.appBarHeight;
    return GestureDetector(
      onVerticalDragStart: (d) {
        if (!widget.controller.switcherActive) {
          widget.controller.switcherActive = true;
        }
      },
      child: Container(
        height: appBarHeight,
        color: widget.theme.appBarBackgroundColor,
        child: Stack(
          children: [
            buildAppBar(context, null),
            IgnorePointer(
              ignoring: widget.controller.switcherActive,
              child: AnimatedOpacity(
                child: widget.controller.switcherActive
                    ? buildAppBar(
                        context,
                        tab != null ? widget.controller.tabs[tab.index] : null,
                      )
                    : Container(
                        color: bgColor,
                        child: PageView.builder(
                          controller: widget.pageController,
                          physics: ResponsiveBouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: widget.controller.tabCount,
                          itemBuilder: (c, i) {
                            return buildAppBar(
                              context,
                              widget.controller.tabs[i],
                            );
                          },
                        ),
                      ),
                duration: Duration(milliseconds: 125),
                opacity: widget.controller.switcherActive ? 0 : 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context, TabSwitcherTab? tab) {
    if (widget.theme.appBarBuilder != null) {
      return widget.theme.appBarBuilder!(context, tab);
    }
    return AppBar(
      backgroundColor: widget.theme.appBarBackgroundColor,
      foregroundColor: widget.theme.appBarForegroundColor,
      actions: [
        TabCountIcon(controller: widget.controller),
      ],
    );
  }
}
