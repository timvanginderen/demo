import 'package:demo/core/di/di.config.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:demo/core/data/config/app_config.dart';

T locator<T extends Object>({dynamic param1, dynamic param2}) {
  try {
    return GetIt.instance<T>(param1: param1, param2: param2);
    // ignore: avoid_catching_errors
  } on ArgumentError {
    // logger.e('$T was not registered in the locator.');
    rethrow;
  }
}

@injectableInit
void setupDependencies(Flavor flavor) {
  GetIt getIt = GetIt.instance;
  getIt.init(environment: describeEnum(flavor));
}
