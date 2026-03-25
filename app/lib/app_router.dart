import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raspberry_monitor/core/observers/app_navigation_observer.dart';
import 'package:raspberry_monitor/features/app_info/presentation/pages/app_info_page.dart';
import 'package:raspberry_monitor/features/design_system_showcase/presentation/pages/showcase_page.dart';
import 'package:raspberry_monitor/features/mqtt/presentation/pages/raspberry_page.dart';

import 'home_page.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
      routes: <RouteBase>[
        // Nested route for App Information
        GoRoute(
          path: 'app-info',
          name: 'app-info',
          builder: (BuildContext context, GoRouterState state) =>
              const AppInfoPage(),
        ),
        // Nested route for Design System Showcase
        GoRoute(
          path: 'showcase',
          name: 'showcase',
          builder: (BuildContext context, GoRouterState state) =>
              const ShowcasePage(),
        ),
        GoRoute(
          path: 'raspberry',
          name: 'raspberry',
          builder: (BuildContext context, GoRouterState state) =>
              const RaspberryPage(),
        ),
      ],
    ),
  ],
  observers: [AppNavigatorObserver()],
);
