import 'package:flutter/material.dart';
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
  }

  final String? initialLocation;
  final List<GoRoute> routes;
  final TabSwitcherController controller;
  final Widget Function(String route) titleBuilder;
  late final router = GoRouter(
    routes: routes,
    initialLocation: initialLocation,
  );

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
    return TabInfo(
      tag: 'router_tab_$_current',
      title: titleBuilder(router.location),
      subtitle: Text(router.location),
    );
  }

  int _current = 0;
  static int _total = 0;
}
