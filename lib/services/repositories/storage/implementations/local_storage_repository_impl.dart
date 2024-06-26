
import 'package:feedback_fusion/services/datasources/storage/local_storage_data_source.dart';
import 'package:feedback_fusion/services/repositories/storage/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  final LocalStorageDataSource localStorageDataSource;

  LocalStorageRepositoryImpl({required this.localStorageDataSource});

  @override
  Future<bool?> getRememberMeValue() async {
    final result = await localStorageDataSource.getRememberMeValue();
    if (result == null) {
      return false;
    }
    return result;
  }

  @override
  Future<void> saveRememberMeValue(bool rememberMeValue) async {
    return localStorageDataSource.saveRememberMeValue(rememberMeValue);
  }

  @override
  Future<void> clearToken() async {
    await localStorageDataSource.clearToken();
  }

  @override
  Future<String?> retrieveToken() {
    return localStorageDataSource.retrieveToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await localStorageDataSource.saveToken(token);
  }
}
