import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabSwitcherController {
  int get tabCount => _tabs.length;
  UnmodifiableListView<TabSwitcherTab> get tabs => UnmodifiableListView(_tabs);
  TabSwitcherTab get currentTab => _currentTab;

  Stream<TabSwitcherTab> get onNewTab => _newTabSubject.stream;
  Stream<TabSwitcherTab> get onTabClosed => _tabClosedSubject.stream;
  Stream<TabSwitcherTab> get onCurrentTabChanged => _currentTabChangedSubject.stream;
  Stream<bool> get onSwitchModeChanged => _switchModeSubject.stream;

  T getTab<T>() {
    for (var tab in _tabs) {
      if (tab is T) {
        return tab as T;
      }
    }

    return null;
  }

  void toggleTabSwitcher() => switcherActive = !switcherActive;

  bool get switcherActive => _switcherActive;
  set switcherActive(bool value) {
    if (value == false && tabCount == 0) return; // switcher cannot be exited when there are no tabs
    if (_switcherActive != value) {
      _switcherActive = value;
      _switchModeSubject.add(value);
    }
  }

  void pushTab(TabSwitcherTab tab, {int index = 0, bool foreground = true}) {
    if (_tabs.isEmpty) {
      foreground = true;
    }

    _tabs.add(tab);
    tab._index = _tabs.length - 1;

    if (foreground) {
      _currentTab?.onSave(_currentTab._state);
      _currentTab = tab;
      if (_switcherActive) {
        _switcherActive = false;
        _switchModeSubject.add(_switcherActive);
      }
      _currentTabChangedSubject.sink.add(_currentTab);
    }

    _newTabSubject.sink.add(tab);
  }

  void closeTab(TabSwitcherTab tab) {
    _tabs.remove(tab);

    var i = 0;
    _tabs.forEach((t) => t._index = i++);

    if (_currentTab == tab) {
      if (_tabs.isNotEmpty) {
        _currentTab = _tabs.last;
      } else {
        _currentTab = null;
        if (!_switcherActive) {
          _switcherActive = true;
          _switchModeSubject.add(_switcherActive);
        }
      }
      _currentTabChangedSubject.sink.add(_currentTab);
    }

    _tabClosedSubject.sink.add(tab);
  }

  void switchToTab(int index) {
    if (index >= 0 && index < _tabs.length) {
      _currentTab?.onSave(_currentTab._state);
      _currentTab = _tabs[index];
      _currentTabChangedSubject.sink.add(_currentTab);
    }

    if (switcherActive) {
      switcherActive = false;
    }
  }

  TabSwitcherTab _currentTab;
  List<TabSwitcherTab> _tabs = [];

  bool _switcherActive = false;

  final StreamController<TabSwitcherTab> _newTabSubject = StreamController<TabSwitcherTab>.broadcast();
  final StreamController<TabSwitcherTab> _tabClosedSubject = StreamController<TabSwitcherTab>.broadcast();
  final StreamController<TabSwitcherTab> _currentTabChangedSubject = StreamController<TabSwitcherTab>.broadcast();
  final StreamController<bool> _switchModeSubject = StreamController<bool>.broadcast();
}

abstract class TabSwitcherTab {
  int get index => _index;
  Key get key => _key;

  String getTitle();
  String getSubtitle() => null;

  Widget build(TabState state);
  void onSave(TabState state);

  Widget getContent() => _content ??= build(_state);

  ui.Image previewImage; // TODO Move out of here

  Widget _content;
  int _index;
  UniqueKey _key = UniqueKey();
  TabState _state = TabState();
}

class TabState {
  void set(String id, dynamic content) => _items[id] = content;
  T get<T>(String id) => _items[id] as T;

  Map<String, dynamic> _items = Map<String, dynamic>();
}
