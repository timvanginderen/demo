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
                        color: orderViewModel.email == null
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
                        ? orderViewModel.getFormattedSummaryPriceString()
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
                    Text(orderViewModel.getFormattedDiscountString())
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
    );
  }
}
