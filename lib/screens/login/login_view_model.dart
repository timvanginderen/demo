import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/navigation/navigation_service.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final AutoDisposeChangeNotifierProvider<LoginViewModel> loginViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginViewModel>(
        (AutoDisposeChangeNotifierProviderRef<LoginViewModel> ref) {
  return locator<LoginViewModel>()..initState();
});

abstract class LoginViewModel extends ViewModel {
  Future<void> initState();
  Future<void> goToOrderScreen();
}

@Injectable(as: LoginViewModel)
class LoginViewModelImpl extends BaseViewModel implements LoginViewModel {
  LoginViewModelImpl(this.navigationService);

  final NavigationService navigationService;

  @override
  Future<void> initState() async {}

  @override
  Future<void> goToOrderScreen() => navigationService.goToOrderScreen();
}
