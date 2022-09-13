import 'package:flutter/material.dart';
import 'package:scroll_shadow_container/scroll_shadow_container.dart';

import '../utils/controller.dart';
import '../utils/tab.dart';
import '../utils/theme.dart';
import 'animated_grid.dart';
import 'minimized_tab.dart';

/// Displays grid of minimized tabs
class TabSwitcherTabGrid extends StatefulWidget {
  TabSwitcherTabGrid(this.controller);

  final TabSwitcherController controller;

  @override
  State<TabSwitcherTabGrid> createState() => _TabSwitcherTabGridState();
}

class _TabSwitcherTabGridState extends State<TabSwitcherTabGrid> {
  @override
  Widget build(BuildContext context) {
    final wTheme = TabSwitcherTheme.of(context);
    return ScrollShadowContainer(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: AnimatedGrid<TabSwitcherTab>(
                items: widget.controller.tabs.toList(),
                itemHeight: wTheme.tabGridHeight,
                keyBuilder: (t) => t.key,
                builder: (context, tab, details) => TabSwitcherMinimizedTab(
                  tab,
                  () => widget.controller.switchToTab(details.index),
                  () => widget.controller
                      .closeTab(widget.controller.tabs[details.index]),
                  tab == widget.controller.currentTab,
                ),
                columns: 2,
                curve: Curves.ease,
                duration: Duration(milliseconds: 175),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
