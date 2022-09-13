import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_switcher.dart';

class CounterTab extends TabSwitcherTab {
  CounterTab() {
    _totalCounterTabs++;
    _tabInstanceNumber = _totalCounterTabs;
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        key: key,
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
                  style: Theme.of(context).textTheme.headlineMedium,
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
  TabInfo getInfo(BuildContext context) {
    return TabInfo(
      tag: 'counter_tab_$_tabInstanceNumber',
      title: const Text('Counter'),
      subtitle: Text('Counter tab ' + _tabInstanceNumber.toString()),
    );
  }

  int _counter = 0;

  int _tabInstanceNumber = 0;
  static int _totalCounterTabs = 0;
}
