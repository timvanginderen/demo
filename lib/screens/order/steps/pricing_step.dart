import 'package:demo/core/domain/pricing_tier.dart';
import 'package:demo/core/utils/extensions.dart';
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
              Column(
                children: PricingTier.values
                    .map((PricingTier tier) => ListTile(
                          title: Text(tier.name.capitalize()),
                          subtitle: Text(
                              orderViewModel.getFormattedPriceString(tier)),
                          leading: Radio<PricingTier>(
                            value: tier,
                            groupValue: orderViewModel.tier,
                            onChanged: (PricingTier? value) {
                              formFieldState.setValue(true);
                              orderViewModel.onPriceTierChanged(value, formKey);
                            },
                          ),
                          onTap: () {
                            formFieldState.setValue(true);
                            orderViewModel.onPriceTierChanged(tier, formKey);
                          },
                        ))
                    .toList(),
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
                child: Row(
                  children: <Widget>[
                    const Text('Select period: '),
                    const SizedBox(width: 8.0),
                    SegmentedButton<PricingPeriod>(
                      segments: pricingPeriodOptions
                          .map<ButtonSegment<PricingPeriod>>(
                              ((PricingPeriod, String) pricingPeriod) {
                        return ButtonSegment<PricingPeriod>(
                            value: pricingPeriod.$1,
                            label: Text(pricingPeriod.$2));
                      }).toList(),
                      selected: orderViewModel.pricingPeriodSelection,
                      onSelectionChanged:
                          orderViewModel.onPricingPeriodSelectionChanged,
                    ),
                  ],
                ),
              ),
              if (orderViewModel.isEligibleForDiscount())
                Text(
                  'You get 2 months free!',
                  style: TextStyle(color: Colors.green.shade900),
                ),
            ],
          );
        },
        validator: orderViewModel.validatePricing,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
