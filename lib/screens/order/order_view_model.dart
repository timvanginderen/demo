import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/navigation/navigation_service.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final AutoDisposeChangeNotifierProvider<OrderViewModel> orderViewModelProvider =
    ChangeNotifierProvider.autoDispose<OrderViewModel>(
        (AutoDisposeChangeNotifierProviderRef<OrderViewModel> ref) {
  return locator<OrderViewModel>()..initState();
});

abstract class OrderViewModel extends ViewModel {
  Future<void> initState();
  int get currentStep;
  void continued();
  void cancelled();
  void tapped(int step);
}

@Injectable(as: OrderViewModel)
class OrderViewModelImpl extends BaseViewModel implements OrderViewModel {
  OrderViewModelImpl(this.navigationService);

  final NavigationService navigationService;
  int _currentStep = 0;

  @override
  Future<void> initState() async {}

  @override
  int get currentStep => _currentStep;

  @override
  void continued() {
    _currentStep < 2 ? _currentStep += 1 : finishForm();
    notifyListeners();
  }

  @override
  void cancelled() {
    if (_currentStep > 0) {
      _currentStep -= 1;
    }
    notifyListeners();
  }

  @override
  void tapped(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void finishForm() {}
}
