import 'package:demo/core/data/config/app_config.dart';
import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final AutoDisposeChangeNotifierProvider<AppViewModel> appViewModelProvider =
    ChangeNotifierProvider.autoDispose<AppViewModel>(
        (AutoDisposeChangeNotifierProviderRef<AppViewModel> ref) {
  return locator<AppViewModel>()..initState();
});

abstract class AppViewModel extends ViewModel {
  Future<void> initState();

  AppConfig get appConfig;
}

@Injectable(as: AppViewModel)
class AppViewModelImpl extends BaseViewModel implements AppViewModel {
  AppViewModelImpl(this._appConfig);

  final AppConfig _appConfig;

  @override
  Future<void> initState() async {}

  @override
  AppConfig get appConfig => _appConfig;
}
