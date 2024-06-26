import 'dart:convert';

import 'package:feedback_fusion/models/user.dart';
import 'package:feedback_fusion/services/datasources/auth/auth_data_source.dart';
import 'package:feedback_fusion/utils/exceptions/api_exceptions.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({required});

  @override
  Future<User> login(String email, String password) async {
    var baseurl = GlobalConfiguration().getValue<String>('apiBaseUrl');
    final url = '$baseurl/User/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'text/plain',
      },
      body: jsonEncode(
        {'email': email, 'password': password},
      ),
    );
    return _handleResponse(response);
  }

  @override
  Future<User> register(Map<String, dynamic> user) async {
    var baseurl = GlobalConfiguration().getValue<String>('apiBaseUrl');

    final url = '$baseurl/User/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );
    return _handleResponse(response);
  }

  User _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromRawJson(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
