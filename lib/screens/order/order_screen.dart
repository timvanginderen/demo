import 'package:demo/core/domain/pricing_tier.dart';
import 'package:demo/screens/order/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

enum PricingPeriod { monthly, yearly }

const List<(PricingPeriod, String)> pricingPeriodOptions =
    <(PricingPeriod, String)>[
  (PricingPeriod.monthly, 'monthly'),
  (PricingPeriod.yearly, 'yearly'),
];

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final List<GlobalKey<FormState>> _formKeys = <GlobalKey<FormState>>[
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  PricingTier? _tier;

  Set<PricingPeriod> _segmentedButtonSelection = <PricingPeriod>{
    PricingPeriod.monthly
  };

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final OrderViewModel orderViewModel = ref.watch(orderViewModelProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Order'),
            leading: InkWell(
              onTap: () {
                orderViewModel.goToLoginScreen();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: AbsorbPointer(
                    absorbing: orderViewModel.isOrderSubmitted,
                    child: Stepper(
                      type: StepperType.horizontal,
                      physics: const ScrollPhysics(),
                      currentStep: orderViewModel.currentStep,
                      onStepTapped: (int step) => orderViewModel.tapped(step),
                      onStepContinue: () {
                        GlobalKey<FormState>? formKey;
                        if (orderViewModel.currentStep < 2) {
                          formKey = _formKeys[orderViewModel.currentStep];
                        }
                        orderViewModel.onStepContinue(formKey);
                      },
                      onStepCancel: orderViewModel.onStepCancel,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return Row(
                          children: <Widget>[
                            if (orderViewModel.currentStep > 0 &&
                                !orderViewModel.isOrderSubmitted)
                              ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text('BACK'),
                              ),
                            const Spacer(),
                            if (orderViewModel.currentStep < 2)
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('NEXT'),
                              ),
                            if (orderViewModel.currentStep == 2 &&
                                orderViewModel.isFormCompleted &&
                                !orderViewModel.isOrderSubmitted)
                              ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('CONTINUE'),
                              ),
                          ],
                        );
                      },
                      steps: <Step>[
                        Step(
                          title: const Text('Details'),
                          content: Form(
                            key: _formKeys[0],
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                  validator: orderViewModel.validateName,
                                  onChanged: (String value) =>
                                      orderViewModel.setName(value),
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Email Address'),
                                  validator: orderViewModel.validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (String value) =>
                                      orderViewModel.setEmail(value),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: IntlPhoneField(
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (PhoneNumber phone) {
                                      orderViewModel
                                          .setPhoneNumber(phone.completeNumber);
                                    },
                                    initialCountryCode: 'BE',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isActive: orderViewModel.currentStep == 0,
                          state: orderViewModel.isStepOneCompleted
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text('Pricing'),
                          content: Form(
                            key: _formKeys[1],
                            child: FormField<bool>(
                              builder: (FormFieldState<bool> state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text('Basic'),
                                      subtitle: Text(_formatPriceString(
                                          PricingTier.basic,
                                          _getSelectedPricingPeriod())),
                                      leading: Radio<PricingTier>(
                                        value: PricingTier.basic,
                                        groupValue: _tier,
                                        onChanged: (PricingTier? value) {
                                          setState(() {
                                            _tier = value;
                                            state.setValue(true);
                                            _formKeys[1]
                                                .currentState!
                                                .validate();
                                          });
                                        },
                                      ),
                                      // trailing: ,
                                      // onTap: () {},
                                    ),
                                    ListTile(
                                      title: const Text('Normal'),
                                      subtitle: Text(_formatPriceString(
                                          PricingTier.normal,
                                          _getSelectedPricingPeriod())),
                                      leading: Radio<PricingTier>(
                                        value: PricingTier.normal,
                                        groupValue: _tier,
                                        onChanged: (PricingTier? value) {
                                          setState(() {
                                            _tier = value;
                                            state.setValue(true);
                                            _formKeys[1]
                                                .currentState!
                                                .validate();
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Advanced'),
                                      subtitle: Text(_formatPriceString(
                                          PricingTier.advanced,
                                          _getSelectedPricingPeriod())),
                                      leading: Radio<PricingTier>(
                                        value: PricingTier.advanced,
                                        groupValue: _tier,
                                        onChanged: (PricingTier? value) {
                                          setState(() {
                                            _tier = value;
                                            state.setValue(true);
                                            _formKeys[1]
                                                .currentState!
                                                .validate();
                                          });
                                        },
                                      ),
                                    ),
                                    if (state.hasError)
                                      Text(
                                        state.errorText!,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    else
                                      Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SegmentedButton<PricingPeriod>(
                                        segments: pricingPeriodOptions
                                            .map<ButtonSegment<PricingPeriod>>(
                                                ((
                                                      PricingPeriod,
                                                      String
                                                    ) pricingPeriod) {
                                          return ButtonSegment<PricingPeriod>(
                                              value: pricingPeriod.$1,
                                              label: Text(pricingPeriod.$2));
                                        }).toList(),
                                        selected: _segmentedButtonSelection,
                                        onSelectionChanged:
                                            (Set<PricingPeriod> newSelection) {
                                          setState(() {
                                            _segmentedButtonSelection =
                                                newSelection;
                                          });
                                        },
                                      ),
                                    ),
                                    if (_getSelectedPricingPeriod() ==
                                        PricingPeriod.yearly)
                                      const Text('You get 2 months free'),
                                  ],
                                );
                              },
                              validator: (bool? value) {
                                if (value == null) {
                                  return 'Please choose a pricing plan.';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          isActive: orderViewModel.currentStep == 1,
                          state: orderViewModel.isStepTwoCompleted
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text('Summary'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (!orderViewModel.isOrderSubmitted)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Text('Name:'),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          orderViewModel.name ?? 'no name',
                                          style: TextStyle(
                                              color: orderViewModel.name == null
                                                  ? Colors.red
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Text('Email address:'),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          orderViewModel.email ?? 'no email',
                                          style: TextStyle(
                                              color:
                                                  orderViewModel.email == null
                                                      ? Colors.red
                                                      : Colors.black),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Text('Yearly cost:'),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          _tier != null
                                              ? _formatYearlyPriceForTier(
                                                  _tier!,
                                                  discount:
                                                      _isEligibleForDiscount())
                                              : 'no tier selected',
                                          style: TextStyle(
                                              color: _tier == null
                                                  ? Colors.red
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                    if (_tier != null)
                                      Row(
                                        children: <Widget>[
                                          const Text('Discount:'),
                                          const SizedBox(width: 4.0),
                                          Text(_formatDiscountString(_tier!,
                                              _getSelectedPricingPeriod()))
                                        ],
                                      ),
                                  ],
                                ),
                              if (orderViewModel.isOrderSubmitted)
                                const Column(
                                  children: <Widget>[
                                    Text('Thank you for your order.'),
                                  ],
                                ),
                            ],
                          ),
                          isActive: orderViewModel.currentStep == 2,
                          state: orderViewModel.isOrderSubmitted
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                      ],
                    ),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: orderViewModel.goToLoginScreen,
                //     child: const Text('Back to login'))
              ],
            ),
          ),
        );
      },
    );
  }

  PricingPeriod _getSelectedPricingPeriod() {
    if (_segmentedButtonSelection.contains(PricingPeriod.yearly)) {
      return PricingPeriod.yearly;
    } else {
      return PricingPeriod.monthly;
    }
  }

  String _formatPriceString(PricingTier tier, PricingPeriod period) {
    switch (period) {
      case PricingPeriod.monthly:
        return _formatMonthlyPriceForTier(tier);
      case PricingPeriod.yearly:
        return _formatYearlyPriceForTier(tier);
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

  String _formatDiscountString(PricingTier pricingTier, PricingPeriod period) {
    switch (period) {
      case PricingPeriod.monthly:
        return 'no discount';
      case PricingPeriod.yearly:
        return '${_calculateDiscount(pricingTier)} euro';
    }
  }

  int _calculateDiscount(PricingTier pricingTier) {
    final int price = monthlyPrices[pricingTier] ?? 0;
    return price * 2;
  }

  bool _isEligibleForDiscount() =>
      _getSelectedPricingPeriod() == PricingPeriod.yearly;
}
