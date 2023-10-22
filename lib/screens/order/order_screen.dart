import 'package:demo/screens/order/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

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
          appBar: AppBar(title: const Text('Order')),
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
                            child: const Column(),
                          ),
                          isActive: orderViewModel.currentStep == 1,
                          state: orderViewModel.isStepTwoCompleted
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text('Summary'),
                          content: Column(
                            children: <Widget>[
                              if (!orderViewModel.isOrderSubmitted)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Name: ${orderViewModel.name}' ?? ''),
                                    Text(
                                        'Email address: ${orderViewModel.email}' ??
                                            ''),
                                  ],
                                ),
                              if (orderViewModel.isOrderSubmitted)
                                const Text('Thank you for your order.'),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
