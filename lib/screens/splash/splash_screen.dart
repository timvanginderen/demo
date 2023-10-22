import 'package:demo/core/presentation/theme/theme_build_context_extension.dart';
import 'package:demo/screens/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(splashViewModelProvider);

    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SizedBox.expand(
            child: ColoredBox(
              color: context.colors.onSurface,
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}
