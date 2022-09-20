import 'package:flutter/material.dart';
import 'package:tab_switcher/tab_switcher.dart';
import 'package:tab_switcher/widgets/tab_count_icon.dart';

import '../tabs/go_router.dart';
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
      resizeToAvoidBottomInset: false,
      body: TabSwitcherWidget(
        media: MediaQuery.of(context),
        controller: controller,
        theme: TabSwitcherThemeData(
          appBarBuilder: (context, tab) {
            final info = tab?.getInfo(context);
            return AppBar(
              primary: false,
              elevation: 0,
              backgroundColor: colors.inverseSurface,
              foregroundColor: colors.onInverseSurface,
              titleSpacing: 8,
              title: info != null
                  ? info.leading
                  : NewTabButton(controller: controller),
              centerTitle: false,
              actions: [
                ...info?.actions ?? [],
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
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return IntrinsicWidth(
      child: MaterialButton(
        visualDensity: VisualDensity.compact,
        child: Row(
          children: [
            Icon(Icons.add, color: color),
            const SizedBox(width: 8),
            Text('New tab', style: TextStyle(color: color)),
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
      initialLocation: '/counter/$value',
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
