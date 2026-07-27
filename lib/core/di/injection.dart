import 'package:b1/core/errors/error_handler.dart';
import 'package:b1/core/network/api_client.dart';
import 'package:b1/core/network/dio_client.dart';
import 'package:b1/core/services/connectivity_service.dart';
import 'package:b1/core/services/logger_service.dart';
import 'package:b1/core/session/session_service.dart';
import 'package:b1/core/storage/secure_storage.dart';
import 'package:b1/core/storage/shared_prefs.dart';
import 'package:b1/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // <stackchain:core>
  getIt.registerLazySingleton<Logger>(Logger.new);
  getIt.registerLazySingleton<ErrorHandler>(() => ErrorHandler(logger: getIt()));
  final prefs = await SharedPrefsService.create();
  getIt.registerSingleton<SharedPrefsService>(prefs);
  getIt.registerLazySingleton<SecureStorageService>(SecureStorageService.new);
  getIt.registerLazySingleton<SessionService>(() => SessionService(secure: getIt(), prefs: getIt()));
  getIt.registerLazySingleton<DioClient>(() => DioClient(
    tokenProvider: () => getIt<SessionService>().accessToken,
    onUnauthorized: () => getIt<SessionService>().clear(),
  ));
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<DioClient>()));
  getIt.registerLazySingleton<ConnectivityService>(ConnectivityService.new);
  getIt.registerLazySingleton<LoggerService>(() => LoggerService(getIt()));
  // </stackchain:core>
  // <stackchain:features>
  getIt.registerFactory<HomeBloc>(HomeBloc.new);
  // </stackchain:features>
}
