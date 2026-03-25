import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'injection.dart';

/// The module of all the external dependencies of the app that need to be
/// injected via getIt.
@module
abstract class InjectionModule {

  //! Environment-specific configurations

  /// The development API base URL.
  @Singleton(env: [DevEnv.kName])
  @Named('API_BASE_URL')
  String get devApiUrl => 'https://api.dev.raspberry_monitor.com';

  /// The staging API base URL.
  @Singleton(env: [StageEnv.kName])
  @Named('API_BASE_URL')
  String get stagingApiUrl => 'https://api.staging.raspberry_monitor.com';

  /// The production API base URL.
  @Singleton(env: [ProdEnv.kName])
  @Named('API_BASE_URL')
  String get productionApiUrl => 'https://api.raspberry_monitor.com';

  //! External Dependencies

  /// The app's [SharedPreferences] instance.
  @singleton
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// The app's [Connectivity] instance.
  @LazySingleton(env: Env.allNames)
  Connectivity get connectivity => Connectivity();

  /// The app's [InternetConnectionChecker] instance.
  @LazySingleton(env: Env.allNames)
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  //! Core Services

  /// The app's [NetworkInfo] instance.
  @LazySingleton(env: Env.allNames)
  NetworkInfo networkInfo(InternetConnectionChecker connectionChecker) =>
      NetworkInfoImpl(connectionChecker);
}
