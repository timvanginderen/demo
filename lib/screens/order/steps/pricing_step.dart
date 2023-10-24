import 'package:demo/core/domain/pricing_tier.dart';
import 'package:demo/screens/order/order_screen.dart';
import 'package:demo/screens/order/order_view_model.dart';
import 'package:flutter/material.dart';

class PricingStep extends StatelessWidget {
  const PricingStep({
    super.key,
    required this.formKey,
    required this.orderViewModel,
  });

  final GlobalKey<FormState> formKey;
  final OrderViewModel orderViewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: FormField<bool>(
        builder: (FormFieldState<bool> formFieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: const Text('Basic'),
                subtitle: Text(
                    orderViewModel.getFormattedPriceString(PricingTier.basic)),
                leading: Radio<PricingTier>(
                  value: PricingTier.basic,
                  groupValue: orderViewModel.tier,
                  onChanged: (PricingTier? value) {
                    formFieldState.setValue(true);
                    orderViewModel.onPriceTierChanged(value, formKey);
                  },
                ),
                onTap: () {
                  formFieldState.setValue(true);
                  orderViewModel.onPriceTierChanged(PricingTier.basic, formKey);
                },
              ),
              ListTile(
                title: const Text('Normal'),
                subtitle: Text(
                    orderViewModel.getFormattedPriceString(PricingTier.normal)),
                leading: Radio<PricingTier>(
                  value: PricingTier.normal,
                  groupValue: orderViewModel.tier,
                  onChanged: (PricingTier? value) {
                    formFieldState.setValue(true);
                    orderViewModel.onPriceTierChanged(value, formKey);
                  },
                ),
                onTap: () {
                  formFieldState.setValue(true);
                  orderViewModel.onPriceTierChanged(
                      PricingTier.normal, formKey);
                },
              ),
              ListTile(
                title: const Text('Advanced'),
                subtitle: Text(orderViewModel
                    .getFormattedPriceString(PricingTier.advanced)),
                leading: Radio<PricingTier>(
                  value: PricingTier.advanced,
                  groupValue: orderViewModel.tier,
                  onChanged: (PricingTier? value) {
                    formFieldState.setValue(true);
                    orderViewModel.onPriceTierChanged(value, formKey);
                  },
                ),
                onTap: () {
                  formFieldState.setValue(true);
                  orderViewModel.onPriceTierChanged(
                      PricingTier.advanced, formKey);
                },
              ),
              if (formFieldState.hasError)
                Text(
                  formFieldState.errorText!,
                  style: const TextStyle(color: Colors.red),
                )
              else
                Container(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SegmentedButton<PricingPeriod>(
                  segments: pricingPeriodOptions
                      .map<ButtonSegment<PricingPeriod>>(
                          ((PricingPeriod, String) pricingPeriod) {
                    return ButtonSegment<PricingPeriod>(
                        value: pricingPeriod.$1, label: Text(pricingPeriod.$2));
                  }).toList(),
                  selected: orderViewModel.pricingPeriodSelection,
                  onSelectionChanged:
                      orderViewModel.onPricingPeriodSelectionChanged,
                ),
              ),
              if (orderViewModel.isEligibleForDiscount())
                const Text('You get 2 months free'),
            ],
          );
        },
        validator: orderViewModel.validatePricing,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
