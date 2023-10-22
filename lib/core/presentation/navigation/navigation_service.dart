import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class NavigationService {
  GlobalKey<NavigatorState> get navigatorKey;

  static const String routeHome = 'home_screen';

  void goBack([dynamic result]);

  Future<void> goToHomeScreen();
}

@LazySingleton(as: NavigationService)
class NavigationServiceImpl implements NavigationService {
  NavigationServiceImpl();
  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void goBack([dynamic result]) {
    navigatorKey.currentState!.pop(result);
  }

  @override
  Future<void> goToHomeScreen() {
    return navigatorKey.currentState!
        .pushReplacementNamed(NavigationService.routeHome);
  }
}
