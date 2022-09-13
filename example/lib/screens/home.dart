import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tab_switcher/tab_switcher.dart';
import 'package:tab_switcher/widgets/tab_count_icon.dart';

import '../go_router_tab.dart';
import '../router.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          appBarBuilder: (context, tab) {
            if (tab != null) {
              final info = tab.getInfo(context);
              return AppBar(
                elevation: 0,
                leading: info.leading,
                title: info.title,
                actions: [
                  ...info.actions ?? [],
                  TabCountIcon(controller: controller),
                ],
              );
            }
            return AppBar(
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              foregroundColor: theme.textTheme.bodyLarge!.color,
              titleSpacing: 8,
              leading: NewTabButton(controller: controller),
              leadingWidth: 120,
              centerTitle: false,
              actions: [
                TabCountIcon(controller: controller),
              ],
            );
          },
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
        onPressed: addTab,
      ),
    );
  }

  void addTab() {
    controller.counterTab(controller.tabCount);
  }
}

extension ControllerUtils on TabSwitcherController {
  void counterTab(int value) {
    final tab = GoRouterTab(
      controller: this,
      routes: routes,
      initialLocation: '/counter/value',
      titleBuilder: (route) {
        if (route.startsWith('/counter')) {
          return const Text('Counter');
        }
        return const Text('Home');
      },
    );
    pushTab(tab, foreground: true);
  }
}
