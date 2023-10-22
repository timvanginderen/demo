import 'package:demo/core/data/config/app_config.dart';
import 'package:demo/core/data/config/log_config.dart';
import 'package:demo/core/di/di.dart';
import 'package:demo/core/presentation/navigation/navigation_service.dart';
import 'package:demo/core/presentation/theme/theme_build_context_extension.dart';
import 'package:demo/core/presentation/widgets/flavor_banner_widget.dart';
import 'package:demo/core/utils/logger.dart';
import 'package:demo/screens/app/app_view_model.dart';
import 'package:demo/screens/home/home_screen.dart';
import 'package:demo/screens/login/login_screen.dart';
import 'package:demo/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> runAppCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies(flavor);
  final AppConfig appConfig = locator();
  if (appConfig.enableLogging) {
    setupLogging();
  }
  logger.i('Finished initialization');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(builder: (BuildContext context, WidgetRef ref, _) {
        final AppViewModel viewModel = ref.watch(appViewModelProvider);
        final AppConfig config = viewModel.appConfig;
        return MaterialApp(
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: (RouteSettings settings) {
            final WidgetBuilder? builder = getRoutes(settings)[settings.name!];
            return PageRouteBuilder<dynamic>(
              pageBuilder: (BuildContext ctx, _, __) => builder!(ctx),
            );
          },
          title: 'Proceedix Demo',
          theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch: Colors.blue,
          ),
          home: FlavorBanner(
            bannerColor: context.colors.flavorBanner,
            child: const SplashScreen(),
          ),
        );
      }),
    );
  }

  Map<String, WidgetBuilder> getRoutes(RouteSettings settings) {
    return <String, WidgetBuilder>{
      NavigationService.routeHome: (_) => const HomeScreen(),
      NavigationService.routeLogin: (_) => const LoginScreen(),
    };
  }
}
