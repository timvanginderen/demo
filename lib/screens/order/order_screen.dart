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
                              builder: (FormFieldState<bool> formFieldState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text('Basic'),
                                      subtitle: Text(orderViewModel
                                          .getFormattedPriceString(
                                              PricingTier.basic)),
                                      leading: Radio<PricingTier>(
                                        value: PricingTier.basic,
                                        groupValue: orderViewModel.tier,
                                        onChanged: (PricingTier? value) {
                                          formFieldState.setValue(true);
                                          orderViewModel.onPriceTierChanged(
                                              value, _formKeys[1]);
                                        },
                                      ),
                                      // trailing: ,
                                      // onTap: () {},
                                    ),
                                    ListTile(
                                      title: const Text('Normal'),
                                      subtitle: Text(orderViewModel
                                          .getFormattedPriceString(
                                              PricingTier.normal)),
                                      leading: Radio<PricingTier>(
                                        value: PricingTier.normal,
                                        groupValue: orderViewModel.tier,
                                        onChanged: (PricingTier? value) {
                                          formFieldState.setValue(true);
                                          orderViewModel.onPriceTierChanged(
                                              value, _formKeys[1]);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Advanced'),
                                      subtitle: Text(orderViewModel
                                          .getFormattedPriceString(
                                              PricingTier.advanced)),
                                      leading: Radio<PricingTier>(
                                        value: PricingTier.advanced,
                                        groupValue: orderViewModel.tier,
                                        onChanged: (PricingTier? value) {
                                          formFieldState.setValue(true);
                                          orderViewModel.onPriceTierChanged(
                                              value, _formKeys[1]);
                                        },
                                      ),
                                    ),
                                    if (formFieldState.hasError)
                                      Text(
                                        formFieldState.errorText!,
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
                                        selected: orderViewModel
                                            .pricingPeriodSelection,
                                        onSelectionChanged: orderViewModel
                                            .onPricingPeriodSelectionChanged,
                                      ),
                                    ),
                                    if (orderViewModel.isEligibleForDiscount())
                                      const Text('You get 2 months free'),
                                  ],
                                );
                              },
                              validator: orderViewModel.validatePricing,
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
                                          orderViewModel.tier != null
                                              ? orderViewModel
                                                  .getFormattedSummaryPriceString()
                                              : 'no tier selected',
                                          style: TextStyle(
                                              color: orderViewModel.tier == null
                                                  ? Colors.red
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                    if (orderViewModel.tier != null)
                                      Row(
                                        children: <Widget>[
                                          const Text('Discount:'),
                                          const SizedBox(width: 4.0),
                                          Text(orderViewModel
                                              .getFormattedDiscountString())
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
}
