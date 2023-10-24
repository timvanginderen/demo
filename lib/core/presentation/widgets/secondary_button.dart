import 'package:demo/core/presentation/theme/theme_build_context_extension.dart';
import 'package:demo/core/presentation/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.primaryIcon,
    required this.secondaryIcon,
  });

  final String text;
  final VoidCallback onPressed;
  final IconData primaryIcon;
  final IconData secondaryIcon;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: context.colors.secondary,
      foregroundColor: Colors.white,
      primaryIcon: primaryIcon,
      secondaryIcon: secondaryIcon,
    );
  }
}
