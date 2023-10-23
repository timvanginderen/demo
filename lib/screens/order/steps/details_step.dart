import 'package:demo/screens/order/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class DetailsStep extends StatelessWidget {
  const DetailsStep({
    super.key,
    required this.formKey,
    required this.orderViewModel,
    this.onSubmitted,
  });

  final GlobalKey<FormState> formKey;
  final OrderViewModel orderViewModel;
  final void Function()? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: orderViewModel.validateName,
            onChanged: (String value) => orderViewModel.setName(value),
            onTapOutside: (PointerDownEvent event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email Address'),
            validator: orderViewModel.validateEmail,
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value) => orderViewModel.setEmail(value),
            onTapOutside: (PointerDownEvent event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            textInputAction: TextInputAction.next,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (PhoneNumber phone) {
                orderViewModel.setPhoneNumber(phone.completeNumber);
              },
              initialCountryCode: 'BE',
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (onSubmitted != null) {
                  onSubmitted!();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
