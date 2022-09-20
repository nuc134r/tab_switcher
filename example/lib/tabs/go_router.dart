import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tab_switcher/tab_switcher.dart';

class GoRouterTab extends TabSwitcherTab {
  GoRouterTab({
    required this.routes,
    required this.titleBuilder,
    required this.controller,
    this.initialLocation,
  }) {
    _total++;
    _current = _total;
    router.addListener(() {
      if (textController.text != router.location) {
        textController.text = router.location;
      }
    });
  }

  final String? initialLocation;
  final List<GoRoute> routes;
  final TabSwitcherController controller;
  final Widget Function(String route) titleBuilder;
  late final router = GoRouter(
    routes: routes,
    initialLocation: initialLocation,
  );
  late final textController = TextEditingController(text: initialLocation);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
    );
  }

  @override
  TabInfo getInfo(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TabInfo(
      tag: 'router_tab_$_current',
      title: titleBuilder(router.location),
      subtitle: Text(router.location),
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Go Home',
            onPressed: () {
              router.go(initialLocation ?? '/');
            },
          ),
          Expanded(
            child: TextFormField(
              controller: textController,
              onFieldSubmitted: (value) {
                router.push(value);
              },
              decoration: InputDecoration(
                fillColor: colors.inverseSurface,
                focusColor: colors.inverseSurface,
                hoverColor: colors.inverseSurface,
                border: InputBorder.none,
                filled: true,
                isDense: true,
              ),
              cursorColor: colors.onInverseSurface,
              style: TextStyle(
                color: colors.onInverseSurface,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.copy),
          tooltip: 'Copy url',
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);
            Clipboard.setData(ClipboardData(text: router.location));
            messenger.showSnackBar(
              SnackBar(content: Text('Copied ${router.location} to clipboard')),
            );
          },
        ),
      ],
    );
  }

  int _current = 0;
  static int _total = 0;
}
