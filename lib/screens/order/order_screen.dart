import 'package:demo/screens/order/order_view_model.dart';
import 'package:demo/screens/order/steps/details_step.dart';
import 'package:demo/screens/order/steps/pricing_step.dart';
import 'package:demo/screens/order/steps/summary_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          body: Column(
            children: <Widget>[
              Expanded(
                child: AbsorbPointer(
                  absorbing: orderViewModel.isOrderSubmitted,
                  child: Stepper(
                    type: StepperType.horizontal,
                    physics: const ScrollPhysics(),
                    currentStep: orderViewModel.currentStep,
                    onStepTapped: (int step) => orderViewModel.onStepTapped(
                        step,
                        formKey: _getCurrentFormKey(orderViewModel)),
                    onStepContinue: () => _goToNextStep(orderViewModel),
                    onStepCancel: orderViewModel.onStepCancel,
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Container();
                    },
                    steps: <Step>[
                      Step(
                        title: const Text('Details'),
                        content: DetailsStep(
                          formKey: _formKeys[0],
                          orderViewModel: orderViewModel,
                          onSubmitted: () => _goToNextStep(orderViewModel),
                        ),
                        isActive: orderViewModel.currentStep == 0,
                        state: orderViewModel.isStepOneCompleted
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Pricing'),
                        content: PricingStep(
                          formKey: _formKeys[1],
                          orderViewModel: orderViewModel,
                        ),
                        isActive: orderViewModel.currentStep == 1,
                        state: orderViewModel.isStepTwoCompleted
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Summary'),
                        content: SummaryStep(orderViewModel: orderViewModel),
                        isActive: orderViewModel.currentStep == 2,
                        state: orderViewModel.isOrderSubmitted
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                  ),
                ),
              ),
              if (orderViewModel.isOrderSubmitted)
                ElevatedButton(
                    onPressed: orderViewModel.goToLoginScreen,
                    child: const Text('Back to login'))
            ],
          ),
          // TODO(BottomNavigation): extract buttons
          bottomNavigationBar: orderViewModel.isOrderSubmitted
              ? null
              : Container(
                  height: 60,
                  color: Colors.black12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (orderViewModel.currentStep > 0 &&
                          !orderViewModel.isOrderSubmitted)
                        Expanded(
                          child: Material(
                            color: Colors.blue,
                            child: InkWell(
                              onTap: () => orderViewModel.onStepCancel(),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.navigate_before,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'BACK',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (orderViewModel.currentStep < 2)
                        Expanded(
                          child: Material(
                            color: Colors.blue,
                            child: InkWell(
                              onTap: () => _goToNextStep(orderViewModel),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'NEXT',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (orderViewModel.currentStep == 2 &&
                          orderViewModel.isFormCompleted &&
                          !orderViewModel.isOrderSubmitted)
                        Expanded(
                          child: Material(
                            color: Colors.green,
                            child: InkWell(
                              onTap: () => _goToNextStep(orderViewModel),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'CONTINUE',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
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

  void _goToNextStep(OrderViewModel orderViewModel) {
    final GlobalKey<FormState>? currentFormKey =
        _getCurrentFormKey(orderViewModel);
    orderViewModel.onStepContinue(currentFormKey);
  }

  GlobalKey<FormState>? _getCurrentFormKey(OrderViewModel orderViewModel) {
    GlobalKey<FormState>? formKey;
    if (orderViewModel.currentStep < 2) {
      formKey = _formKeys[orderViewModel.currentStep];
    }
    return formKey;
  }
}
