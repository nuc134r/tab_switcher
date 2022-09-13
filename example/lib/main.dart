import 'package:flutter/material.dart';
import 'package:tab_switcher/widgets/tab_count_icon.dart';
import 'package:tab_switcher/tab_switcher.dart';
import 'package:tab_switcher_example/counter_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color source = Colors.blue;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: source,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: source,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      body: TabSwitcherWidget(
        controller: controller,
        theme: TabSwitcherThemeData(
          appBarBuilder: (context, tab) => tab != null
              ? AppBar(
                  elevation: 0,
                  title: tab.getTitle(),
                  actions: [
                    TabCountIcon(controller: controller),
                  ],
                )
              : AppBar(
                  elevation: 0,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  foregroundColor: theme.textTheme.bodyLarge!.color,
                  titleSpacing: 8,
                  leading: NewTabButton(controller: controller),
                  leadingWidth: 120,
                  actions: [
                    TabCountIcon(controller: controller),
                  ],
                ),
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
          appBarBackgroundColor: colors.inverseSurface,
          appBarForegroundColor: colors.onInverseSurface,
          selectedTabColor: colors.tertiary,
        ),
      ),
    );
  }

  late TabSwitcherController controller;
}

class NewTabButton extends StatelessWidget {
  const NewTabButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TabSwitcherController controller;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: MaterialButton(
        visualDensity: VisualDensity.compact,
        child: Row(
          children: const [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('New tab'),
          ],
        ),
        onPressed: () => controller.pushTab(
          CounterTab(),
          foreground: true,
        ),
      ),
    );
  }
}
