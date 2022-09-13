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
    this.onRestore,
    this.onSave,
  });

  final TabSwitcherThemeData theme;
  final TabSwitcherController controller;
  final TabSwitcherController Function()? onRestore;
  final void Function(TabSwitcherController)? onSave;

  @override
  State<TabSwitcherWidget> createState() => _TabSwitcherWidgetState();
}

class _TabSwitcherWidgetState extends State<TabSwitcherWidget>
    with WidgetsBindingObserver {
  bool _isNavigatingToPage = false;
  late TabSwitcherController controller = widget.controller;
  late PageController _appBarPageController;
  late PageController _bodyPageController;
  StreamSubscription<TabSwitcherTab>? _onTabClose;
  StreamSubscription<TabSwitcherTab>? _onNewTab;
  StreamSubscription<bool>? _onTabSwitch;
  StreamSubscription<TabSwitcherTab?>? _onTabChanged;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        debugPrint('tabs: save');
        widget.onSave?.call(controller);
        break;
      case AppLifecycleState.resumed:
        debugPrint('tabs: restore');
        if (widget.onRestore != null) {
          controller = widget.onRestore!();
          init();
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    cancelSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    var displaySwitcher = controller.switcherActive;
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
            controller,
            _appBarPageController,
            MediaQuery.of(context),
            wTheme,
          ),
          body: displaySwitcher ? buildSwitcher(context) : buildBody(context),
        ),
      ),
    );
  }

  Widget buildSwitcher(BuildContext context) {
    var noTabs = controller.tabCount == 0;
    var theme = Theme.of(context);
    final wTheme = widget.theme;
    return Container(
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
                : TabSwitcherTabGrid(controller),
          ),
          ...wTheme.switcherFooterBuilder != null
              ? [wTheme.switcherFooterBuilder!.call(context)]
              : [],
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final wTheme = widget.theme;
    return PageView.builder(
      controller: _bodyPageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.tabCount,
      itemBuilder: (c, i) {
        var tab = controller.tabs[i];
        return PreviewCapturerWidget(
          tag: tab.getInfo(context).tag,
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
    );
  }

  void init() {
    initPageControllers();
    cancelSubscriptions();
    _onTabClose = controller.onTabClosed.listen((e) => setState(() {}));
    _onNewTab = controller.onNewTab.listen((e) => setState(() {}));
    _onTabSwitch = controller.onSwitchModeChanged
        .listen((e) => setState(() => initPageControllers()));
    _onTabChanged = controller.onCurrentTabChanged.listen((e) => setState(() {
          if (controller.switcherActive) {
            initPageControllers();
          } else if (controller.currentTab != null &&
              _appBarPageController.positions.isNotEmpty) {
            _isNavigatingToPage = true;
            _appBarPageController.jumpToPage(controller.currentTab!.index);
            _isNavigatingToPage = false;
          }
        }));
  }

  void cancelSubscriptions() {
    _onTabClose?.cancel();
    _onNewTab?.cancel();
    _onTabSwitch?.cancel();
    _onTabChanged?.cancel();
  }

  void initPageControllers() {
    final idx = controller.currentTab?.index ?? 0;
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
        if (controller.currentTab != null &&
            controller.currentTab!.index != index) {
          controller.switchToTab(index);
        }
      }
    });
  }
}
