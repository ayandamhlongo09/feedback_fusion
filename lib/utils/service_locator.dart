import 'package:feedback_fusion/services/core/storage/local_storage.dart';
import 'package:feedback_fusion/services/core/storage/local_storage_impl.dart';
import 'package:feedback_fusion/services/core/storage/secure_storage.dart';
import 'package:feedback_fusion/services/core/storage/secure_storage_impl.dart';
import 'package:feedback_fusion/services/datasources/auth/auth_data_source.dart';
import 'package:feedback_fusion/services/datasources/auth/implementation/auth_data_source_impl.dart';
import 'package:feedback_fusion/services/datasources/storage/implementations/local_storage_data_source_impl.dart';
import 'package:feedback_fusion/services/datasources/storage/local_storage_data_source.dart';
import 'package:feedback_fusion/services/repositories/auth/auth_repository.dart';
import 'package:feedback_fusion/services/repositories/auth/implementation/auth_repository_impl.dart';
import 'package:feedback_fusion/services/repositories/storage/implementations/local_storage_repository_impl.dart';
import 'package:feedback_fusion/services/repositories/storage/local_storage_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

void registerServices() {
  //independent services
  final LocalStorage localStorage = LocalStorageImpl();

  final SecureStorage secureStorage = SecureStorageImpl();

  // datasources
  final LocalStorageDataSource localStorageDataSource = LocalStorageDataSourceImpl(localStorage: localStorage, secureStorage: secureStorage);
  final AuthDataSource authDataSource = AuthDataSourceImpl();

  //repositories
  final LocalStorageRepository localStorageRepository = LocalStorageRepositoryImpl(localStorageDataSource: localStorageDataSource);
  final AuthRepository authRepository = AuthRepositoryImpl(authDataSource: authDataSource);

  // START REGISTRATION

  // datasources
  serviceLocator.registerSingleton<LocalStorageDataSource>(localStorageDataSource);
  serviceLocator.registerSingleton<AuthDataSource>(authDataSource);

  // repositories
  serviceLocator.registerSingleton<LocalStorageRepository>(localStorageRepository);
  serviceLocator.registerSingleton<AuthRepository>(authRepository);
}
