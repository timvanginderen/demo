import 'package:demo/core/presentation/theme/theme_build_context_extension.dart';
import 'package:demo/core/presentation/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.primaryIcon,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData primaryIcon;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: text,
      onPressed: onPressed,
      foregroundColor: context.colors.secondary,
      backgroundColor: Colors.white,
      primaryIcon: primaryIcon,
    );
  }
}
