import 'package:demo/core/di/di.dart';
import 'package:demo/core/domain/pricing_tier.dart';
import 'package:demo/core/presentation/navigation/navigation_service.dart';
import 'package:demo/core/presentation/view_model.dart';
import 'package:demo/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
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

  void onStepContinue(GlobalKey<FormState>? formKey);

  void onStepCancel();

  void tapped(int step);

  String? validateName(String? name);

  String? validateEmail(String? email);

  String? validatePricing(bool? pricing);

  String? get name;

  String? get email;

  String? get phoneNumber;

  PricingTier? get tier;

  Set<PricingPeriod> get pricingPeriodSelection;

  void setName(String name);

  void setEmail(String email);

  void setPhoneNumber(String phoneNumber);

  void onPriceTierChanged(PricingTier? tier, GlobalKey<FormState> formKey);

  void onPricingPeriodSelectionChanged(
      Set<PricingPeriod> pricingPeriodSelection);

  String getFormattedPriceString(PricingTier tier);

  String getFormattedSummaryPriceString();

  String getFormattedDiscountString();

  bool isEligibleForDiscount();

  bool get isStepOneCompleted;

  bool get isStepTwoCompleted;

  bool get isFormCompleted;

  bool get isOrderSubmitted;

  void goToLoginScreen();
}

@Injectable(as: OrderViewModel)
class OrderViewModelImpl extends BaseViewModel implements OrderViewModel {
  OrderViewModelImpl(this.navigationService);

  final NavigationService navigationService;
  // int _currentStep = 0;

  @override
  Future<void> initState() async {}

  @override
  String? email;

  @override
  String? name;

  @override
  String? phoneNumber;

  @override
  PricingTier? tier;

  @override
  Set<PricingPeriod> pricingPeriodSelection = <PricingPeriod>{
    PricingPeriod.monthly
  };

  @override
  int currentStep = 0;

  @override
  bool get isFormCompleted => isStepOneCompleted && isStepTwoCompleted;

  @override
  bool isStepOneCompleted = false;

  @override
  bool isStepTwoCompleted = false;

  @override
  bool isOrderSubmitted = false;

  @override
  void onStepContinue(GlobalKey<FormState>? formKey) {
    if (formKey == null && isFormCompleted) {
      submitOrder();
    } else if (formKey != null && formKey.currentState!.validate()) {
      switch (currentStep) {
        case 0:
          isStepOneCompleted = true;
        case 1:
          isStepTwoCompleted = true;
      }
      currentStep += 1;
    }
    notifyListeners();
  }

  @override
  void onStepCancel() {
    if (currentStep > 0) {
      currentStep -= 1;
    }
    notifyListeners();
  }

  @override
  void tapped(int step) {
    currentStep = step;
    notifyListeners();
  }

  void submitOrder() {
    isOrderSubmitted = true;
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
  String? validatePricing(bool? pricing) {
    if (pricing == null) {
      return 'Please choose a pricing plan.';
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

  @override
  void onPriceTierChanged(PricingTier? tier, GlobalKey<FormState> formKey) {
    this.tier = tier;
    formKey.currentState!.validate();
    notifyListeners();
  }

  @override
  void onPricingPeriodSelectionChanged(
      Set<PricingPeriod> pricingPeriodSelection) {
    this.pricingPeriodSelection = pricingPeriodSelection;
    notifyListeners();
  }

  @override
  void goToLoginScreen() => navigationService.goToLoginScreen();

  @override
  String getFormattedPriceString(PricingTier tier) {
    switch (_getSelectedPricingPeriod()) {
      case PricingPeriod.monthly:
        return _formatMonthlyPriceForTier(tier);
      case PricingPeriod.yearly:
        return _formatYearlyPriceForTier(tier);
    }
  }

  @override
  String getFormattedSummaryPriceString() => tier == null
      ? ''
      : _formatYearlyPriceForTier(tier!, discount: isEligibleForDiscount());

  @override
  String getFormattedDiscountString() {
    if (tier == null) {
      return '';
    }
    switch (_getSelectedPricingPeriod()) {
      case PricingPeriod.monthly:
        return 'no discount';
      case PricingPeriod.yearly:
        return '${_calculateDiscount(tier!)} euro';
    }
  }

  @override
  bool isEligibleForDiscount() =>
      _getSelectedPricingPeriod() == PricingPeriod.yearly;

  PricingPeriod _getSelectedPricingPeriod() {
    if (pricingPeriodSelection.contains(PricingPeriod.yearly)) {
      return PricingPeriod.yearly;
    } else {
      return PricingPeriod.monthly;
    }
  }

  String _formatMonthlyPriceForTier(PricingTier pricingTier) {
    final int price = monthlyPrices[pricingTier] ?? 0;
    return '$price euro per month';
  }

  String _formatYearlyPriceForTier(PricingTier pricingTier,
      {bool discount = true}) {
    int price = monthlyPrices[pricingTier] ?? 0;
    price = price * (discount ? 10 : 12);
    return '$price euro per year';
  }

  int _calculateDiscount(PricingTier pricingTier) {
    final int price = monthlyPrices[pricingTier] ?? 0;
    return price * 2;
  }
}
