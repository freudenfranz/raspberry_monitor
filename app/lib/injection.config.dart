// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:raspberry_monitor/core/network/network_info.dart' as _i595;
import 'package:raspberry_monitor/features/app_info/data/datasources/app_info_remote_data_source.dart'
    as _i460;
import 'package:raspberry_monitor/features/app_info/data/repositories/app_info_repository_impl.dart'
    as _i853;
import 'package:raspberry_monitor/features/app_info/domain/repositories/app_info_repository.dart'
    as _i40;
import 'package:raspberry_monitor/features/app_info/domain/usecases/get_app_info.dart'
    as _i366;
import 'package:raspberry_monitor/features/app_info/presentation/bloc/app_info_bloc.dart'
    as _i351;
import 'package:raspberry_monitor/features/design_system_showcase/data/datasources/showcase_local_datasource.dart'
    as _i501;
import 'package:raspberry_monitor/features/design_system_showcase/data/repositories/showcase_repository_impl.dart'
    as _i38;
import 'package:raspberry_monitor/features/design_system_showcase/domain/repositories/showcase_repository.dart'
    as _i237;
import 'package:raspberry_monitor/features/design_system_showcase/domain/usecases/get_items_by_category.dart'
    as _i148;
import 'package:raspberry_monitor/features/design_system_showcase/domain/usecases/get_showcase_items.dart'
    as _i665;
import 'package:raspberry_monitor/features/design_system_showcase/domain/usecases/search_items.dart'
    as _i949;
import 'package:raspberry_monitor/features/design_system_showcase/presentation/bloc/showcase_bloc.dart'
    as _i492;
import 'package:raspberry_monitor/features/i18n/data/datasources/locale_local_data_source.dart'
    as _i1033;
import 'package:raspberry_monitor/features/i18n/data/datasources/locale_remote_data_source.dart'
    as _i750;
import 'package:raspberry_monitor/features/i18n/data/repositories/locale_repository_impl.dart'
    as _i577;
import 'package:raspberry_monitor/features/i18n/domain/repositories/locale_repository.dart'
    as _i1065;
import 'package:raspberry_monitor/features/i18n/domain/usecases/get_current_locale.dart'
    as _i845;
import 'package:raspberry_monitor/features/i18n/domain/usecases/get_supported_locales.dart'
    as _i830;
import 'package:raspberry_monitor/features/i18n/domain/usecases/get_system_locale.dart'
    as _i827;
import 'package:raspberry_monitor/features/i18n/domain/usecases/set_current_locale.dart'
    as _i282;
import 'package:raspberry_monitor/features/i18n/presentation/bloc/locale_bloc.dart'
    as _i862;
import 'package:raspberry_monitor/features/mqtt/data/datasources/mqtt_config.dart'
    as _i1036;
import 'package:raspberry_monitor/features/mqtt/data/datasources/mqtt_remote_data_source.dart'
    as _i710;
import 'package:raspberry_monitor/features/mqtt/data/datasources/mqtt_remote_data_source_impl.dart'
    as _i348;
import 'package:raspberry_monitor/features/mqtt/data/repositories/raspbperry_repository_impl.dart'
    as _i1072;
import 'package:raspberry_monitor/features/mqtt/domain/repositories/raspberry_repository.dart'
    as _i735;
import 'package:raspberry_monitor/features/mqtt/domain/usecases/get_items_by_category.dart'
    as _i812;
import 'package:raspberry_monitor/features/mqtt/domain/usecases/get_showcase_items.dart'
    as _i1007;
import 'package:raspberry_monitor/features/mqtt/domain/usecases/search_items.dart'
    as _i518;
import 'package:raspberry_monitor/features/mqtt/presentation/bloc/raspberry_bloc.dart'
    as _i473;
import 'package:raspberry_monitor/injectable_module.dart' as _i265;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _dev = 'dev';
const String _stg = 'stg';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => injectionModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i1036.MQTTConfig>(() => _i1036.MQTTConfig());
    gh.lazySingleton<_i895.Connectivity>(
      () => injectionModule.connectivity,
      registerFor: {_dev, _stg, _prod},
    );
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => injectionModule.internetConnectionChecker,
      registerFor: {_dev, _stg, _prod},
    );
    gh.lazySingleton<_i501.ShowcaseLocalDataSource>(
      () => _i501.ShowcaseLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i750.LocaleRemoteDataSource>(
      () => const _i750.LocaleRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i460.AppInfoRemoteDataSource>(
      () => _i460.AppInfoRemoteDataSourceImpl(),
    );
    gh.singleton<String>(
      () => injectionModule.devApiUrl,
      instanceName: 'API_BASE_URL',
      registerFor: {_dev},
    );
    gh.lazySingleton<_i710.MQTTRemoteDataSource>(
      () => _i348.MQTTRemoteDataSourceImpl(config: gh<_i1036.MQTTConfig>()),
    );
    gh.lazySingleton<_i40.AppInfoRepository>(
      () => _i853.AppInfoRepositoryImpl(
        remoteDataSource: gh<_i460.AppInfoRemoteDataSource>(),
      ),
    );
    gh.singleton<String>(
      () => injectionModule.stagingApiUrl,
      instanceName: 'API_BASE_URL',
      registerFor: {_stg},
    );
    gh.lazySingleton<_i237.ShowcaseRepository>(
      () => _i38.ShowcaseRepositoryImpl(
        localDataSource: gh<_i501.ShowcaseLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i366.GetAppInfo>(
      () => _i366.GetAppInfo(gh<_i40.AppInfoRepository>()),
    );
    gh.lazySingleton<_i1033.LocaleLocalDataSource>(
      () => _i1033.LocaleLocalDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i595.NetworkInfo>(
      () => injectionModule.networkInfo(gh<_i973.InternetConnectionChecker>()),
      registerFor: {_dev, _stg, _prod},
    );
    gh.factory<_i351.AppInfoBloc>(
      () => _i351.AppInfoBloc(getAppInfo: gh<_i366.GetAppInfo>()),
    );
    gh.lazySingleton<_i735.RaspberryRepository>(
      () => _i1072.RaspberryRepositoryImpl(
        remoteDataSource: gh<_i710.MQTTRemoteDataSource>(),
      ),
    );
    gh.singleton<String>(
      () => injectionModule.productionApiUrl,
      instanceName: 'API_BASE_URL',
      registerFor: {_prod},
    );
    gh.lazySingleton<_i1065.LocaleRepository>(
      () => _i577.LocaleRepositoryImpl(
        localDataSource: gh<_i1033.LocaleLocalDataSource>(),
        remoteDataSource: gh<_i750.LocaleRemoteDataSource>(),
        networkInfo: gh<_i595.NetworkInfo>(),
      ),
    );
    gh.factory<_i473.RaspberryBloc>(
      () => _i473.RaspberryBloc(repository: gh<_i735.RaspberryRepository>()),
    );
    gh.lazySingleton<_i148.GetItemsByCategory>(
      () =>
          _i148.GetItemsByCategory(repository: gh<_i237.ShowcaseRepository>()),
    );
    gh.lazySingleton<_i665.GetShowcaseItems>(
      () => _i665.GetShowcaseItems(repository: gh<_i237.ShowcaseRepository>()),
    );
    gh.lazySingleton<_i949.SearchItems>(
      () => _i949.SearchItems(repository: gh<_i237.ShowcaseRepository>()),
    );
    gh.lazySingleton<_i812.GetItemsByCategory>(
      () =>
          _i812.GetItemsByCategory(repository: gh<_i237.ShowcaseRepository>()),
    );
    gh.lazySingleton<_i1007.GetShowcaseItems>(
      () => _i1007.GetShowcaseItems(repository: gh<_i237.ShowcaseRepository>()),
    );
    gh.lazySingleton<_i518.SearchItems>(
      () => _i518.SearchItems(repository: gh<_i237.ShowcaseRepository>()),
    );
    gh.factory<_i492.ShowcaseBloc>(
      () => _i492.ShowcaseBloc(
        getShowcaseItems: gh<_i665.GetShowcaseItems>(),
        getItemsByCategory: gh<_i148.GetItemsByCategory>(),
        searchItems: gh<_i949.SearchItems>(),
      ),
    );
    gh.lazySingleton<_i845.GetCurrentLocale>(
      () => _i845.GetCurrentLocale(gh<_i1065.LocaleRepository>()),
    );
    gh.lazySingleton<_i830.GetSupportedLocales>(
      () => _i830.GetSupportedLocales(gh<_i1065.LocaleRepository>()),
    );
    gh.lazySingleton<_i827.GetSystemLocale>(
      () => _i827.GetSystemLocale(gh<_i1065.LocaleRepository>()),
    );
    gh.lazySingleton<_i282.SetCurrentLocale>(
      () => _i282.SetCurrentLocale(gh<_i1065.LocaleRepository>()),
    );
    gh.factory<_i862.LocaleBloc>(
      () => _i862.LocaleBloc(
        getCurrentLocale: gh<_i845.GetCurrentLocale>(),
        setCurrentLocale: gh<_i282.SetCurrentLocale>(),
        getSupportedLocales: gh<_i830.GetSupportedLocales>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i265.InjectionModule {}
