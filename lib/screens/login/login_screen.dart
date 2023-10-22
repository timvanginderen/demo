import 'package:demo/core/presentation/theme/theme_build_context_extension.dart';
import 'package:demo/core/presentation/widgets/primary_button.dart';
import 'package:demo/core/presentation/widgets/secondary_button.dart';
import 'package:demo/core/utils/logger.dart';
import 'package:demo/screens/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final LoginViewModel loginViewModel = ref.watch(loginViewModelProvider);
        return Scaffold(
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
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Image.asset('assets/images/proceedix_logo.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 48.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: <Widget>[
                              SecondaryButton(
                                onPressed: () {
                                  logger.i('enterprise button pressed');
                                },
                                text: 'Proceedix Enterprise',
                                primaryIcon: Icons.cloud,
                                secondaryIcon: Icons.play_arrow_rounded,
                              ),
                              const SizedBox(height: 18.0),
                              PrimaryButton(
                                  text: 'Log in',
                                  onPressed: () {
                                    logger.i('log in button pressed');
                                  },
                                  primaryIcon: Icons.person_2_rounded),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
