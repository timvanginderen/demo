// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:demo/core/data/config/app_config.dart' as _i3;
import 'package:demo/core/presentation/navigation/navigation_service.dart'
    as _i5;
import 'package:demo/screens/app/app_view_model.dart' as _i4;
import 'package:demo/screens/home/home_view_model.dart' as _i7;
import 'package:demo/screens/splash/splash_view_model.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

const String _dev = 'dev';
const String _qa = 'qa';
const String _prod = 'prod';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AppConfig>(
      () => _i3.DevAppConfig(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i3.AppConfig>(
      () => _i3.QaAppConfig(),
      registerFor: {_qa},
    );
    gh.lazySingleton<_i3.AppConfig>(
      () => _i3.ProdAppConfig(),
      registerFor: {_prod},
    );
    gh.factory<_i4.AppViewModel>(
        () => _i4.AppViewModelImpl(gh<_i3.AppConfig>()));
    gh.lazySingleton<_i5.NavigationService>(() => _i5.NavigationServiceImpl());
    gh.factory<_i6.SplashViewModel>(
        () => _i6.SplashViewModelImpl(gh<_i5.NavigationService>()));
    gh.factory<_i7.HomeViewModel>(
        () => _i7.HomeViewModelImpl(gh<_i5.NavigationService>()));
    return this;
  }
}
