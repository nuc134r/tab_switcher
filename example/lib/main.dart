import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_count_icon.dart';
import 'package:tab_switcher/tab_switcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    controller = TabSwitcherController();
    controller.pushTab(CounterTab());
    controller.pushTab(CounterTab());
    controller.pushTab(ColorsTab());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabSwitcherWidget(
        controller: controller,
        appBarBuilder: (context, tab) => tab != null
            ? AppBar(
                elevation: 0,
                title: Text(tab.getTitle()),
                actions: [
                  TabCountIcon(controller: controller),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'demotab',
                        child: Text('New demo tab'),
                      )
                    ],
                    onSelected: (v) => controller.pushTab(CounterTab()),
                  ),
                ],
              )
            : AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
                actions: [
                  TabCountIcon(controller: controller),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'demotab',
                        child: Text('New demo tab'),
                      )
                    ],
                    onSelected: (v) => controller.pushTab(CounterTab()),
                  ),
                ],
              ),
      ),
    );
  }

  late TabSwitcherController controller;
}

class CounterTab extends TabSwitcherTab {
  @override
  Widget build(TabState state) => Builder(
        builder: (context) => Container(
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
                    _counter++;
                  },
                  child: const Text('+'),
                )
              ],
            ),
          ),
        ),
      );

  @override
  String getTitle() => 'Title';

  @override
  String? getSubtitle() => 'Subtitle';

  @override
  void onSave(TabState state) {}

  int _counter = 0;
}

class ColorsTab extends TabSwitcherTab {
  @override
  Widget build(TabState state) => Builder(
        builder: (context) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Colorrr("primary", Theme.of(context).colorScheme.primary),
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Container(height: 48, width: 48, color: e.color),
                          const SizedBox(width: 8),
                          Text(e.name),
                        ]),
                      ))
                  .cast<Widget>()
                  .toList(),
            ),
          ),
        ),
      );

  @override
  String getTitle() => 'Title';

  @override
  String? getSubtitle() => 'Subtitle';

  @override
  void onSave(TabState state) {}
}

class Colorrr {
  Colorrr(this.name, this.color);

  final String name;
  final Color color;
}
