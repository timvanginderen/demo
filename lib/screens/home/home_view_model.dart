import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/navigation/navigation_service.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final AutoDisposeChangeNotifierProvider<HomeViewModel> homeViewModelProvider =
    ChangeNotifierProvider.autoDispose<HomeViewModel>(
        (AutoDisposeChangeNotifierProviderRef<HomeViewModel> ref) {
  return locator<HomeViewModel>()..initState();
});

abstract class HomeViewModel extends ViewModel {
  Future<void> initState();
}

@Injectable(as: HomeViewModel)
class HomeViewModelImpl extends BaseViewModel implements HomeViewModel {
  HomeViewModelImpl(this.navigationService);

  final NavigationService navigationService;

  @override
  Future<void> initState() async {}
}
