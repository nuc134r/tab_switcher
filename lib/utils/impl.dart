import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/preview_capturer_widget.dart';
import '../widgets/tab_grid.dart';
import 'controller.dart';
import 'tab.dart';
import 'theme.dart';

typedef TabWidgetBuilder = Widget Function(
    BuildContext context, TabSwitcherTab? tab);

/// Root widget for building apps with full screen tabs
class TabSwitcherWidget extends StatefulWidget {
  TabSwitcherWidget({
    required this.controller,
    this.theme = const TabSwitcherThemeData(),
  });

  final TabSwitcherThemeData theme;
  final TabSwitcherController controller;

  @override
  State<TabSwitcherWidget> createState() => _TabSwitcherWidgetState();
}

class _TabSwitcherWidgetState extends State<TabSwitcherWidget> {
  bool _isNavigatingToPage = false;
  late PageController _appBarPageController;
  late PageController _bodyPageController;

  void initPageControllers() {
    final idx = widget.controller.currentTab?.index ?? 0;
    _appBarPageController = PageController(initialPage: idx);
    _bodyPageController = PageController(initialPage: idx);

    _appBarPageController.addListener(() {
      // syncing body PageView with header PageView
      if (_bodyPageController.hasClients) {
        _bodyPageController.position
            .correctPixels(_appBarPageController.offset);
        _bodyPageController.position.notifyListeners();
      }

      // syncing controller's current page after header swipe gesture
      if (_appBarPageController.hasClients &&
          _appBarPageController.page ==
              _appBarPageController.page!.floorToDouble() &&
          !_isNavigatingToPage) {
        var index = _appBarPageController.page!.floor();
        if (widget.controller.currentTab != null &&
            widget.controller.currentTab!.index != index) {
          widget.controller.switchToTab(index);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPageControllers();
    _sub1 = widget.controller.onTabClosed.listen((e) => setState(() {}));
    _sub2 = widget.controller.onNewTab.listen((e) => setState(() {}));
    _sub3 = widget.controller.onSwitchModeChanged
        .listen((e) => setState(() => initPageControllers()));
    _sub4 = widget.controller.onCurrentTabChanged.listen((e) => setState(() {
          if (widget.controller.switcherActive) {
            initPageControllers();
          } else if (widget.controller.currentTab != null &&
              _appBarPageController.positions.isNotEmpty) {
            _isNavigatingToPage = true;
            _appBarPageController
                .jumpToPage(widget.controller.currentTab!.index);
            _isNavigatingToPage = false;
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
    var theme = Theme.of(context);
    final wTheme = widget.theme;
    final backgroundColor =
        wTheme.backgroundColor ?? theme.scaffoldBackgroundColor;
    return TabSwitcherTheme(
      data: widget.theme,
      child: Container(
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: TabSwitcherAppBar(
            widget.controller,
            _appBarPageController,
            MediaQuery.of(context),
            wTheme,
          ),
          body: displaySwitcher
              ? Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: noTabs
                            ? wTheme.emptyScreenBuilder?.call(context) ??
                                Center(
                                  child: Text(
                                    wTheme.emptyTabsText,
                                    style: TextStyle(
                                      color: wTheme.foregroundColor ??
                                          theme.colorScheme.onSurface,
                                    ),
                                  ),
                                )
                            : TabSwitcherTabGrid(widget.controller),
                      ),
                      ...wTheme.switcherFooterBuilder != null
                          ? [wTheme.switcherFooterBuilder!.call(context)]
                          : [],
                    ],
                  ),
                )
              : PageView.builder(
                  controller: _bodyPageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.controller.tabCount,
                  itemBuilder: (c, i) {
                    var tab = widget.controller.tabs[i];
                    return PreviewCapturerWidget(
                      tag: tab.getTag(),
                      child: wTheme.bodyBuilder?.call(c, tab) ??
                          Column(
                            children: [
                              Expanded(
                                child: tab.getContent(context),
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
      ),
    );
  }

  late StreamSubscription<TabSwitcherTab> _sub1;
  late StreamSubscription<TabSwitcherTab> _sub2;
  late StreamSubscription<bool> _sub3;
  late StreamSubscription<TabSwitcherTab?> _sub4;
}
