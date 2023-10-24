import 'package:demo/core/utils/extensions.dart';
import 'package:demo/screens/order/order_view_model.dart';
import 'package:flutter/material.dart';

class SummaryStep extends StatelessWidget {
  const SummaryStep({
    super.key,
    required this.orderViewModel,
  });

  final OrderViewModel orderViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    _isInvalidName() ? 'not valid' : orderViewModel.name!,
                    style: TextStyle(
                        color: _isInvalidName() ? Colors.red : Colors.black),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('Email address:'),
                  const SizedBox(width: 4.0),
                  Text(
                    _isInvalidEmail() ? 'not valid' : orderViewModel.email!,
                    style: TextStyle(
                        color: _isInvalidEmail() ? Colors.red : Colors.black),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('Pricing package:'),
                  const SizedBox(width: 4.0),
                  Text(
                    orderViewModel.tier != null
                        ? orderViewModel.tier!.name.capitalize()
                        : 'no tier selected',
                    style: TextStyle(
                      color: orderViewModel.tier == null
                          ? Colors.red
                          : Colors.black,
                    ),
                  )
                ],
              ),
              if (orderViewModel.tier != null)
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text('Yearly cost:'),
                        const SizedBox(width: 4.0),
                        Text(
                          orderViewModel.tier != null
                              ? orderViewModel.getFormattedSummaryPriceString()
                              : 'no tier selected',
                          style: TextStyle(
                            color: orderViewModel.tier == null
                                ? Colors.red
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Discount:'),
                        const SizedBox(width: 4.0),
                        Text(
                          orderViewModel.getFormattedDiscountString(),
                          style: TextStyle(
                            color: orderViewModel.isEligibleForDiscount()
                                ? Colors.green.shade900
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
            ],
          ),
        if (orderViewModel.isOrderSubmitted)
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Thank you for your order.'),
            ],
          ),
      ],
    );
  }

  bool _isInvalidEmail() =>
      orderViewModel.validateEmail(orderViewModel.email) != null;

  bool _isInvalidName() =>
      orderViewModel.validateName(orderViewModel.name) != null;
}
