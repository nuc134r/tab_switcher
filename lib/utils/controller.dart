import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'tab.dart';

/// Main controller of the tab switcher.
/// Opens new tabs, closes tabs, switches tabs programmatically.
/// Provides streams for common events.
class TabSwitcherController extends ChangeNotifier {
  int get tabCount => _tabs.length;
  UnmodifiableListView<TabSwitcherTab> get tabs => UnmodifiableListView(_tabs);
  TabSwitcherTab? get currentTab => _currentTab;

  Stream<TabSwitcherTab> get onNewTab => _newTabSubject.stream;
  Stream<TabSwitcherTab> get onTabClosed => _tabClosedSubject.stream;
  Stream<TabSwitcherTab?> get onCurrentTabChanged =>
      _currentTabChangedSubject.stream;
  Stream<bool> get onSwitchModeChanged => _switchModeSubject.stream;

  T? getTab<T>() {
    for (var tab in _tabs) {
      if (tab is T) {
        return tab as T;
      }
    }

    return null;
  }

  void toggleTabSwitcher() => switcherActive = !switcherActive;

  bool get switcherActive =>
      _switcherActive ?? (_switcherActive = _tabs.isEmpty);
  set switcherActive(bool value) {
    if (value == false && tabCount == 0) {
      // switcher cannot be exited when there are no tabs
      return;
    }
    if (_switcherActive != value) {
      _switcherActive = value;
      _switchModeSubject.add(value);
    }
  }

  void pushTab(TabSwitcherTab tab, {int index = 0, bool foreground = true}) {
    //if (_tabs.isEmpty) {
    //  foreground = true;
    //}

    _tabs.add(tab);
    tab.index = _tabs.length - 1;

    if (foreground) {
      _currentTab = tab;
      if (_switcherActive == true) {
        _switcherActive = false;
        _switchModeSubject.add(_switcherActive!);
      }
      _currentTabChangedSubject.sink.add(_currentTab);
    }

    _newTabSubject.sink.add(tab);
    notifyListeners();
  }

  void closeTab(TabSwitcherTab tab) {
    _tabs.remove(tab);

    var i = 0;
    for (var t in _tabs) {
      t.index = i++;
    }

    if (_currentTab == tab) {
      if (_tabs.isNotEmpty) {
        _currentTab = _tabs.last;
      } else {
        _currentTab = null;
        if (_switcherActive == false) {
          _switcherActive = true;
          _switchModeSubject.add(_switcherActive!);
        }
      }
      _currentTabChangedSubject.sink.add(_currentTab);
    }

    _tabClosedSubject.sink.add(tab);
    notifyListeners();
  }

  void switchToTab(int index) {
    if (index >= 0 && index < _tabs.length) {
      _currentTab = _tabs[index];
      _currentTabChangedSubject.sink.add(_currentTab);
    }

    if (switcherActive) {
      switcherActive = false;
    }
    notifyListeners();
  }

  TabSwitcherTab? _currentTab;
  final List<TabSwitcherTab> _tabs = [];

  bool? _switcherActive;

  final _newTabSubject = StreamController<TabSwitcherTab>.broadcast();
  final _tabClosedSubject = StreamController<TabSwitcherTab>.broadcast();
  final _currentTabChangedSubject =
      StreamController<TabSwitcherTab?>.broadcast();
  final _switchModeSubject = StreamController<bool>.broadcast();
}
