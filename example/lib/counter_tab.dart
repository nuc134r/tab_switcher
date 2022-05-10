import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_switcher.dart';

class CounterTab extends TabSwitcherTab {
  CounterTab() {
    _totalCounterTabs++;
    _tabInstanceNumber = _totalCounterTabs;
  }

  @override
  Widget build(TabState state) => StatefulBuilder(
        builder: (context, setState) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  child: const Text('+'),
                )
              ],
            ),
          ),
        ),
      );

  @override
  String getTitle() => 'Counter';

  @override
  String? getSubtitle() => 'Counter tab ' + _tabInstanceNumber.toString();

  @override
  void onSave(TabState state) {}

  int _counter = 0;

  int _tabInstanceNumber = 0;
  static int _totalCounterTabs = 0;
}
