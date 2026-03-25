import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// The app's [GetIt] instance.
final getIt = GetIt.instance;

/// Configures the injection of the app depending on the given [environment].
@InjectableInit()
Future<void> configureInjection(Env environment) async =>
    getIt.init(environment: environment.name);

/// {@template env}
/// The base class for all the environments.
/// {@endtemplate}
sealed class Env {
  /// {@macro env}
  const Env();

  /// {@macro dev}
  const factory Env.dev() = DevEnv;

  /// {@macro stg}
  const factory Env.stg() = StageEnv;

  /// {@macro prod}
  const factory Env.prod() = ProdEnv;

  /// Creates an environment instance from the given [name].
  factory Env.fromName(String name) {
    switch (name.toLowerCase()) {
      case 'dev':
      case 'development':
        return const DevEnv();
      case 'stg':
      case 'staging':
        return const StageEnv();
      case 'prod':
      case 'production':
        return const ProdEnv();
      default:
        throw ArgumentError('Unknown environment: $name');
    }
  }

  /// All available environment names.
  static const List<String> allNames = [
    DevEnv.kName,
    StageEnv.kName,
    ProdEnv.kName,
  ];

  /// The name of the environment.
  String get name;
}

/// {@template dev}
/// The development environment.
/// {@endtemplate}
final class DevEnv extends Env {
  /// {@macro dev}
  const DevEnv();

  /// The name of the development environment.
  static const String kName = 'dev';

  @override
  String get name => kName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DevEnv && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// {@template stg}
/// The staging environment.
/// {@endtemplate}
final class StageEnv extends Env {
  /// {@macro stg}
  const StageEnv();

  /// The name of the staging environment.
  static const String kName = 'stg';

  @override
  String get name => kName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StageEnv && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// {@template prod}
/// The production environment.
/// {@endtemplate}
final class ProdEnv extends Env {
  /// {@macro prod}
  const ProdEnv();

  /// The name of the production environment.
  static const String kName = 'prod';

  @override
  String get name => kName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProdEnv && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
