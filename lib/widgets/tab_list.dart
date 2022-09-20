import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scroll_shadow_container/scroll_shadow_container.dart';

import '../utils/controller.dart';
import '../utils/tab.dart';
import '../utils/theme.dart';
import 'minimized_tab.dart';

/// Displays list of minimized tabs
class TabSwitcherTabList extends StatefulWidget {
  TabSwitcherTabList(this.controller);

  final TabSwitcherController controller;

  @override
  State<TabSwitcherTabList> createState() => _TabSwitcherTabListState();
}

class _TabSwitcherTabListState extends State<TabSwitcherTabList> {
  final GlobalKey<AnimatedListState> animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _addSub = widget.controller.onNewTab.listen((tab) {
      animatedListKey.currentState
          ?.insertItem(tab.index, duration: Duration(milliseconds: 1));
    });
    _closeSub = widget.controller.onTabClosed.listen((tab) {
      animatedListKey.currentState?.removeItem(
          tab.index,
          (context, animation) => SizeTransition(
                axis: Axis.vertical,
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                ),
                child: SizedBox(
                  height: TabSwitcherTheme.of(context).tabListHeight,
                ),
              ),
          duration: Duration(milliseconds: 150));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _addSub.cancel();
    _closeSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final wTheme = TabSwitcherTheme.of(context);
    return ScrollShadowContainer(
      child: Scrollbar(
        child: SafeArea(
          child: AnimatedList(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            key: animatedListKey,
            itemBuilder: (context, i, animation) => SizeTransition(
              sizeFactor: animation,
              child: SlideTransition(
                position: animation.drive(Tween(
                  begin: Offset(-150, 0),
                  end: Offset(0, 0),
                )),
                child: Container(
                  height: wTheme.tabListHeight,
                  child: TabSwitcherMinimizedTab(
                    widget.controller.tabs[i],
                    () => widget.controller.switchToTab(i),
                    () => widget.controller.closeTab(widget.controller.tabs[i]),
                    widget.controller.tabs[i] == widget.controller.currentTab,
                  ),
                ),
              ),
            ),
            initialItemCount: widget.controller.tabCount,
          ),
        ),
      ),
    );
  }

  late StreamSubscription<TabSwitcherTab> _addSub;
  late StreamSubscription<TabSwitcherTab> _closeSub;
}
