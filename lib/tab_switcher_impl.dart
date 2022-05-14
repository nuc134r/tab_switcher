import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tab_switcher/preview_capturer_widget.dart';
import 'package:tab_switcher/tab_switcher_app_bar.dart';
import 'package:tab_switcher/tab_switcher_controller.dart';
import 'package:tab_switcher/tab_switcher_tab_grid.dart';

typedef TabWidgetBuilder = Widget Function(BuildContext context, TabSwitcherTab? tab);

/// Root widget for building apps with full screen tabs
class TabSwitcherWidget extends StatefulWidget {
  TabSwitcherWidget({
    required this.controller,
    required this.appBarBuilder,
    this.bodyBuilder,
    this.emptyScreenBuilder,
    this.switcherFooterBuilder,
    this.appBarHeight = 56,
    this.backgroundColor,
  }) {
    initPageControllers();
  }

  void initPageControllers() {
    _appBarPageController = PageController(initialPage: controller.currentTab?.index ?? 0);
    _bodyPageController = PageController(initialPage: controller.currentTab?.index ?? 0);

    _appBarPageController.addListener(() {
      // syncing body PageView with header PageView
      if (_bodyPageController.hasClients) {
        _bodyPageController.position.correctPixels(_appBarPageController.offset);
        _bodyPageController.position.notifyListeners();
      }

      // syncing controller's current page after header swipe gesture
      if (_appBarPageController.hasClients &&
          _appBarPageController.page == _appBarPageController.page!.floorToDouble() &&
          !_isNavigatingToPage) {
        var index = _appBarPageController.page!.floor();
        if (controller.currentTab != null && controller.currentTab!.index != index) {
          controller.switchToTab(index);
        }
      }
    });
  }

  late PageController _appBarPageController;
  late PageController _bodyPageController;
  bool _isNavigatingToPage = false;

  final TabSwitcherController controller;

  final TabWidgetBuilder? appBarBuilder;
  final TabWidgetBuilder? bodyBuilder;
  final WidgetBuilder? emptyScreenBuilder;
  final WidgetBuilder? switcherFooterBuilder;
  final Color? backgroundColor;

  final int appBarHeight;

  @override
  State<TabSwitcherWidget> createState() => _TabSwitcherWidgetState();
}

class _TabSwitcherWidgetState extends State<TabSwitcherWidget> {
  @override
  void initState() {
    super.initState();
    _sub1 = widget.controller.onTabClosed.listen((e) => setState(() {}));
    _sub2 = widget.controller.onNewTab.listen((e) => setState(() {}));
    _sub3 = widget.controller.onSwitchModeChanged.listen((e) => setState(() => widget.initPageControllers()));
    _sub4 = widget.controller.onCurrentTabChanged.listen((e) => setState(() {
          if (widget.controller.switcherActive) {
            widget.initPageControllers();
          } else if (widget.controller.currentTab != null && widget._appBarPageController.positions.isNotEmpty) {
            widget._isNavigatingToPage = true;
            widget._appBarPageController.jumpToPage(widget.controller.currentTab!.index);
            widget._isNavigatingToPage = false;
          }
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _sub1.cancel();
    _sub2.cancel();
    _sub3.cancel();
    _sub4.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var noTabs = widget.controller.tabCount == 0;
    var displaySwitcher = widget.controller.switcherActive;
    final backgroundColor = widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return Container(
      color: backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TabSwitcherAppBar(
          widget.appBarBuilder,
          widget.controller,
          widget._appBarPageController,
          MediaQuery.of(context),
          widget.appBarHeight,
          backgroundColor,
        ),
        body: displaySwitcher
            ? Container(
                child: Column(
                  children: [
                    Expanded(
                      child: noTabs
                          ? widget.emptyScreenBuilder?.call(context) ??
                              Center(
                                child: Text(
                                  'No open tabs',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                ),
                              )
                          : TabSwitcherTabGrid(widget.controller),
                    ),
                    ...widget.switcherFooterBuilder != null ? [widget.switcherFooterBuilder!.call(context)] : [],
                  ],
                ),
              )
            : PageView.builder(
                controller: widget._bodyPageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.controller.tabCount,
                itemBuilder: (c, i) {
                  var tab = widget.controller.tabs[i];
                  return PreviewCapturerWidget(
                    tag: tab.getTitle(),
                    child: widget.bodyBuilder?.call(c, tab) ??
                        Column(
                          children: [
                            Expanded(
                              child: tab.getContent(),
                            ),
                          ],
                        ),
                    callback: (bytes) {
                      tab.previewImage = bytes;
                      setState(() {});
                    },
                  );
                },
              ),
      ),
    );
  }

  late StreamSubscription<TabSwitcherTab> _sub1;
  late StreamSubscription<TabSwitcherTab> _sub2;
  late StreamSubscription<bool> _sub3;
  late StreamSubscription<TabSwitcherTab?> _sub4;
}
