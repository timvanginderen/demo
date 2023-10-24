import 'package:demo/core/presentation/theme/theme_build_context_extension.dart';
import 'package:demo/screens/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(splashViewModelProvider);

    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: context.colors.background,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/proceedix_background_mobile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SafeArea(
              child: Center(child: CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
