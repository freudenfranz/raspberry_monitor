import 'package:flutter/material.dart';
import 'package:raspberry_monitor/core/util/logger.dart';

/// BLoC observer that logs state changes and transitions for debugging.
///
/// This observer helps with:
/// - Debugging state management issues
/// - Monitoring BLoC performance
/// - Tracking state transitions in development
class AppNavigatorObserver extends NavigatorObserver {
  /// Creates an instance of [AppNavigatorObserver].
  AppNavigatorObserver();
  final _logger = logger(AppNavigatorObserver);

  // Helper to safely get the route name or a default value
  String _getRouteName(Route<dynamic>? route) =>
      route?.settings.name ?? 'unknown_route';

  /// The [Navigator] pushed `route`.
  ///
  /// The route immediately below that one, and thus the previously active
  /// route, is `previousRoute`.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logger.info('didPush: ${_getRouteName(route)}');
  }

  /// The [Navigator] popped `route`.
  ///
  /// The route immediately below that one, and thus the newly active
  /// route, is `previousRoute`.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logger.info(
      'didPop: ${_getRouteName(route)}, now top is ${_getRouteName(previousRoute)}',
    );
  }

  /// The [Navigator] removed `route`.
  ///
  /// If only one route is being removed, then the route immediately below
  /// that one, if any, is `previousRoute`.
  ///
  /// If multiple routes are being removed, then the route below the
  /// bottommost route being removed, if any, is `previousRoute`, and this
  /// method will be called once for each removed route, from the topmost route
  /// to the bottommost route.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logger.info('didRemove: ${_getRouteName(route)}');
  }

  /// The [Navigator] replaced `oldRoute` with `newRoute`.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logger.info(
      'didReplace: new=${_getRouteName(newRoute)}, old=${_getRouteName(oldRoute)}',
    );
  }

  /// The top most route has changed.
  ///
  /// The `topRoute` is the new top most route. This can be a new route pushed
  /// on top of the screen, or an existing route that becomes the new top-most
  /// route because the previous top-most route has been popped.
  ///
  /// The `previousTopRoute` was the top most route before the change. This can
  /// be a route that was popped off the screen, or a route that will be covered
  /// by the `topRoute`. This can also be null if this is the first build.
  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    super.didChangeTop(topRoute, previousTopRoute);
    _logger.debug('didChangeTop: ${_getRouteName(topRoute)}');
  }

  /// The [Navigator]'s routes are being moved by a user gesture.
  ///
  /// For example, this is called when an iOS back gesture starts, and is used
  /// to disable hero animations during such interactions.
  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);
    _logger.debug('didStartUserGesture: ${_getRouteName(route)}');
  }

  /// User gesture is no longer controlling the [Navigator].
  ///
  /// Paired with an earlier call to [didStartUserGesture].
  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    _logger.debug('didStopUserGesture');
  }
}
