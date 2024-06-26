
import 'package:feedback_fusion/models/user.dart';
import 'package:feedback_fusion/services/datasources/auth/auth_data_source.dart';
import 'package:feedback_fusion/services/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({
    required this.authDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      return await authDataSource.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> register(Map<String, dynamic> user) async {
    try {
      return await authDataSource.register(user);
    } catch (e) {
      rethrow;
    }
  }
}
