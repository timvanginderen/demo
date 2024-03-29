import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/navigation/navigation_service.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:demo/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final AutoDisposeChangeNotifierProvider<SplashViewModel>
    splashViewModelProvider =
    ChangeNotifierProvider.autoDispose<SplashViewModel>(
        (AutoDisposeChangeNotifierProviderRef<SplashViewModel> ref) {
  return locator<SplashViewModel>()..initState();
});

abstract class SplashViewModel extends ViewModel {
  Future<void> initState();
}

@Injectable(as: SplashViewModel)
class SplashViewModelImpl extends BaseViewModel implements SplashViewModel {
  SplashViewModelImpl(this._navigationService);

  final NavigationService _navigationService;
  static const int kSplashDuration = 2000;

  @override
  Future<void> initState() async {
    final int timeBeforeSetup = DateTime.now().millisecond;

    // do setup work
    const bool isLoggedIn = false;

    // delay navigation to home screen
    final int timedPassed = DateTime.now().millisecond - timeBeforeSetup;
    final int delay = kSplashDuration - timedPassed;
    if (delay > 0) {
      await Future<dynamic>.delayed(Duration(milliseconds: delay));
    }

    logger.i('setup done');
    if (isLoggedIn) {
      logger.i('user is logged in, go to home screen');
      await _navigationService.goToHomeScreen();
    } else {
      logger.i('user is not logged in, go to login screen');
      await _navigationService.goToLoginScreen();
    }
  }
}
