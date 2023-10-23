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
              // ElevatedButton(
              //     onPressed: orderViewModel.goToLoginScreen,
              //     child: const Text('Back to login'))
            ],
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
