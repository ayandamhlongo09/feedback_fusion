abstract class LocalStorageRepository {
  Future<bool?> getRememberMeValue();
  Future<void> saveRememberMeValue(bool rememberMeValue);
   Future<void> clearToken();
  Future<String?> retrieveToken();
  Future<void> saveToken(String token);
}
