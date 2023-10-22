import 'package:demo/screens/order/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final List<GlobalKey<FormState>> _formKeys = <GlobalKey<FormState>>[
    GlobalKey<FormState>(),
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
                  child: Stepper(
                    type: StepperType.horizontal,
                    physics: const ScrollPhysics(),
                    currentStep: orderViewModel.currentStep,
                    onStepTapped: (int step) => orderViewModel.tapped(step),
                    onStepContinue: () {
                      setState(() {
                        if (_formKeys[orderViewModel.currentStep]
                            .currentState!
                            .validate()) {
                          orderViewModel.onStepContinue();
                        }
                      });
                    },
                    onStepCancel: orderViewModel.onStepCancel,
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          if (orderViewModel.currentStep > 0)
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('BACK'),
                            ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('NEXT'),
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
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Email Address'),
                                validator: orderViewModel.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Phone number'),
                                validator: orderViewModel.validatePhoneNumber,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                        isActive: orderViewModel.currentStep >= 0,
                        state: orderViewModel.currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('Pricing'),
                        content: const Column(),
                        isActive: orderViewModel.currentStep >= 0,
                        state: orderViewModel.currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('Summary'),
                        content: const Column(),
                        isActive: orderViewModel.currentStep >= 0,
                        state: orderViewModel.currentStep >= 2
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                    ],
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
