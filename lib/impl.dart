import 'dart:async';

import 'package:flutter/material.dart';
import 'widgets/preview_capturer_widget.dart';
import 'widgets/app_bar.dart';
import 'controller.dart';
import 'widgets/tab_grid.dart';
import 'widgets/theme.dart';

typedef TabWidgetBuilder = Widget Function(
    BuildContext context, TabSwitcherTab? tab);

/// Root widget for building apps with full screen tabs
class TabSwitcherWidget extends StatefulWidget {
  TabSwitcherWidget({
    required this.controller,
    required this.appBarBuilder,
    this.theme = const TabSwitcherThemeData(),
    this.bodyBuilder,
    this.emptyScreenBuilder,
    this.switcherFooterBuilder,
  });

  final TabSwitcherThemeData theme;
  final TabSwitcherController controller;

  final TabWidgetBuilder? appBarBuilder;
  final TabWidgetBuilder? bodyBuilder;
  final WidgetBuilder? emptyScreenBuilder;
  final WidgetBuilder? switcherFooterBuilder;

  @override
  State<TabSwitcherWidget> createState() => _TabSwitcherWidgetState();
}

class _TabSwitcherWidgetState extends State<TabSwitcherWidget> {
  bool _isNavigatingToPage = false;
  late PageController _appBarPageController;
  late PageController _bodyPageController;

  void initPageControllers() {
    _appBarPageController =
        PageController(initialPage: widget.controller.currentTab?.index ?? 0);
    _bodyPageController =
        PageController(initialPage: widget.controller.currentTab?.index ?? 0);

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
            widget.appBarBuilder,
            widget.controller,
            _appBarPageController,
            MediaQuery.of(context),
            wTheme.appBarHeight,
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
                                    style: TextStyle(
                                        color: theme.colorScheme.onSurface),
                                  ),
                                )
                            : TabSwitcherTabGrid(widget.controller),
                      ),
                      ...widget.switcherFooterBuilder != null
                          ? [widget.switcherFooterBuilder!.call(context)]
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
      ),
    );
  }

  late StreamSubscription<TabSwitcherTab> _sub1;
  late StreamSubscription<TabSwitcherTab> _sub2;
  late StreamSubscription<bool> _sub3;
  late StreamSubscription<TabSwitcherTab?> _sub4;
}
