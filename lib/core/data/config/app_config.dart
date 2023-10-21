import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

enum Flavor { dev, qa, prod }

abstract class AppConfig {
  Flavor get flavor;

  bool get showFlavorBanner;

  bool get enableLogging;
}

abstract class _BaseAppConfig implements AppConfig {}

@LazySingleton(as: AppConfig, env: <String>['dev'])
class DevAppConfig extends _BaseAppConfig {
  @override
  Flavor get flavor => Flavor.dev;

  @override
  bool get showFlavorBanner => true;

  @override
  bool get enableLogging => true;
}

@LazySingleton(as: AppConfig, env: <String>['qa'])
class QaAppConfig extends _BaseAppConfig {
  @override
  Flavor get flavor => Flavor.qa;

  @override
  bool get showFlavorBanner => true;

  @override
  bool get enableLogging => true;
}

@LazySingleton(as: AppConfig, env: <String>['prod'])
class ProdAppConfig extends _BaseAppConfig {
  @override
  Flavor get flavor => Flavor.prod;

  @override
  bool get showFlavorBanner => false;

  @override
  bool get enableLogging => kDebugMode;
}
