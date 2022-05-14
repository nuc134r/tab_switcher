import 'package:flutter/material.dart';
import 'package:scroll_shadow_container/scroll_shadow_container.dart';
import 'package:tab_switcher/animated_grid.dart';
import 'package:tab_switcher/tab_switcher_controller.dart';
import 'package:tab_switcher/tab_switcher_minimized_tab.dart';

/// Displays grid of minimized tabs
class TabSwitcherTabGrid extends StatefulWidget {
  TabSwitcherTabGrid(this.controller);

  final TabSwitcherController controller;

  static double kTabHeight = 256;

  @override
  State<TabSwitcherTabGrid> createState() => _TabSwitcherTabGridState();
}

class _TabSwitcherTabGridState extends State<TabSwitcherTabGrid> {
  @override
  Widget build(BuildContext context) {
    return ScrollShadowContainer(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Scrollbar(
          child: AnimatedGrid<TabSwitcherTab>(
            items: widget.controller.tabs.toList(),
            itemHeight: TabSwitcherTabGrid.kTabHeight,
            keyBuilder: (t) => t.key,
            builder: (context, tab, details) => TabSwitcherMinimizedTab(
              tab,
              () => widget.controller.switchToTab(details.index),
              () => widget.controller.closeTab(widget.controller.tabs[details.index]),
              tab == widget.controller.currentTab,
            ),
            columns: 2,
            curve: Curves.ease,
            duration: Duration(milliseconds: 175),
          ),
        ),
      ),
    );
  }
}
