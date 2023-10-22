import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final AutoDisposeChangeNotifierProvider<SplashViewModel>
    splashViewModelProvider =
    ChangeNotifierProvider.autoDispose<SplashViewModel>((ref) {
  return locator<SplashViewModel>()..initState();
});

abstract class SplashViewModel extends ViewModel {
  Future<void> initState();
}

@Injectable(as: SplashViewModel)
class SplashViewModelImpl extends BaseViewModel implements SplashViewModel {
  static const int kSplashDuration = 2000;

  @override
  Future<void> initState() async {
    final int timeBeforeSetup = DateTime.now().millisecond;

    // do setup work

    // delay navigation to home screen
    final int timedPassed = DateTime.now().millisecond - timeBeforeSetup;
    final int delay = kSplashDuration - timedPassed;
    if (delay > 0) {
      await Future<dynamic>.delayed(Duration(milliseconds: delay));
    }

    // go to home screen
  }
}
