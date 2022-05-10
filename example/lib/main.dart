import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_count_icon.dart';
import 'package:tab_switcher/tab_switcher.dart';
import 'package:tab_switcher_example/counter_tab.dart';

class DemoSettings {
  static bool openTabsInForeground = true;
  static Brightness brightness = Brightness.light;
  static VoidCallback rebuildRootWidget = () {};
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          DemoSettings.rebuildRootWidget = () => setState(() {});
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(primarySwatch: Colors.blue, brightness: DemoSettings.brightness),
            home: const MyHomePage(),
          );
        },
      );
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
                  DemoSettingsPopupButton(controller: controller),
                ],
              )
            : AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
                titleSpacing: 8,
                title: IntrinsicWidth(
                  child: MaterialButton(
                    visualDensity: VisualDensity.compact,
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('New tab'),
                      ],
                    ),
                    onPressed: () => controller.pushTab(CounterTab(), foreground: DemoSettings.openTabsInForeground),
                  ),
                ),
                actions: [
                  TabCountIcon(controller: controller),
                  DemoSettingsPopupButton(controller: controller),
                ],
              ),
      ),
    );
  }

  late TabSwitcherController controller;
}

class DemoSettingsPopupButton extends StatelessWidget {
  const DemoSettingsPopupButton({required this.controller, Key? key}) : super(key: key);

  final TabSwitcherController controller;

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'foreground',
            child: Text('Open tabs in background: ' + (!DemoSettings.openTabsInForeground).toString()),
          ),
          const PopupMenuItem<String>(
            value: 'theme',
            child: Text('Toggle theme'),
          ),
        ],
        onSelected: (v) {
          if (v == "theme") {
            DemoSettings.brightness = DemoSettings.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
            DemoSettings.rebuildRootWidget();
          }
          if (v == "foreground") {
            DemoSettings.openTabsInForeground = !DemoSettings.openTabsInForeground;
          }
        },
      );
}
