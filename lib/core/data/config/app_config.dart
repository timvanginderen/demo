import 'package:injectable/injectable.dart';

enum Flavor { dev, qa, prod }

abstract class AppConfig {
  Flavor get flavor;

  bool get showFlavorBanner;
}

abstract class _BaseAppConfig implements AppConfig {}

@LazySingleton(as: AppConfig, env: ["dev"])
class DevAppConfig extends _BaseAppConfig {
  @override
  Flavor get flavor => Flavor.dev;

  @override
  bool get showFlavorBanner => true;
}

@LazySingleton(as: AppConfig, env: ["qa"])
class QaAppConfig extends _BaseAppConfig {
  @override
  Flavor get flavor => Flavor.qa;

  @override
  bool get showFlavorBanner => true;
}

@LazySingleton(as: AppConfig, env: ["prod"])
class ProdAppConfig extends _BaseAppConfig {
  @override
  Flavor get flavor => Flavor.prod;

  @override
  bool get showFlavorBanner => false;
}
