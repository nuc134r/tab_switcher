import 'package:go_router/go_router.dart';

import 'screens/counter.dart';

final routes = <GoRoute>[
  GoRoute(
    path: '/counter',
    builder: (context, state) => const Counter(),
    routes: [
      GoRoute(
        path: ':value',
        builder: (context, state) {
          final stringVal = state.params['value']!;
          final value = int.tryParse(stringVal) ?? 0;
          return Counter(value: value);
        },
      ),
    ],
  ),
];

final router = GoRouter(
  routes: routes,
);
