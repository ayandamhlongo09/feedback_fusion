import 'package:feedback_fusion/models/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(Map<String, dynamic> user);
}
