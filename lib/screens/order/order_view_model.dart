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

  void onStepContinue();

  void onStepCancel();

  void tapped(int step);

  String? validateName(String? name);

  String? validateEmail(String? email);

  String? validatePhoneNumber(String? phoneNumber);

  void setName(String name);

  void setEmail(String email);

  void setPhoneNumber(String phoneNumber);

  String? get name;

  String? get email;

  String? get phoneNumber;

  bool get isFormCompleted;
}

@Injectable(as: OrderViewModel)
class OrderViewModelImpl extends BaseViewModel implements OrderViewModel {
  OrderViewModelImpl(this.navigationService);

  final NavigationService navigationService;
  int _currentStep = 0;
  bool _isFormCompleted = false;

  @override
  Future<void> initState() async {}

  @override
  String? email;

  @override
  String? name;

  @override
  String? phoneNumber;

  @override
  int get currentStep => _currentStep;

  @override
  bool get isFormCompleted => _isFormCompleted;

  @override
  void onStepContinue() {
    _currentStep < 2 ? _currentStep += 1 : finishForm();
    notifyListeners();
  }

  @override
  void onStepCancel() {
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

  void finishForm() {
    _isFormCompleted = true;
  }

  @override
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  @override
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email address cannot be empty';
    }

    // TODO(validation): consider using email_validator package
    const String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    if (!RegExp(pattern).hasMatch(email)) {
      return 'Email address not valid';
    }

    return null;
  }

  @override
  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number cannot be empty';
    }
    return null;
  }

  @override
  void setName(String name) {
    this.name = name;
  }

  @override
  void setEmail(String email) {
    this.email = email;
  }

  @override
  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }
}
