
import 'package:feedback_fusion/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(Map<String, dynamic> user);
}
