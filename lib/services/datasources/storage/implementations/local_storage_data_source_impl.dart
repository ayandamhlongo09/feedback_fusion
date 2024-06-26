import 'package:feedback_fusion/services/core/storage/local_storage.dart';
import 'package:feedback_fusion/services/core/storage/secure_storage.dart';
import 'package:feedback_fusion/services/datasources/storage/local_storage_data_source.dart';

class LocalStorageDataSourceImpl extends LocalStorageDataSource {
  static const String _rememberMeKey = "REMEMBER_ME";
  static const String _tokenKey = "AUTH_TOKEN";

  final LocalStorage localStorage;
  final SecureStorage secureStorage;
  LocalStorageDataSourceImpl({
    required this.localStorage,
    required this.secureStorage,
  });

  @override
  Future<bool?> getRememberMeValue() async {
    return await localStorage.get<bool?>(_rememberMeKey);
  }

  @override
  Future<void> saveRememberMeValue(bool rememberMeValue) async {
    return await localStorage.put<bool?>(_rememberMeKey, rememberMeValue);
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.remove(_tokenKey);
  }

  @override
  Future<String?> retrieveToken() {
    return secureStorage.get(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.put(_tokenKey, token);
  }
}
