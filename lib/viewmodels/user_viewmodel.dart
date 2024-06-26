import 'package:feedback_fusion/models/user.dart';
import 'package:feedback_fusion/services/repositories/auth/auth_repository.dart';
import 'package:feedback_fusion/services/repositories/storage/local_storage_repository.dart';
import 'package:feedback_fusion/utils/enums.dart';
import 'package:feedback_fusion/utils/exceptions/api_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LocalStorageRepository _localStorageRepository;
  bool _rememberMe = false;
  bool _isSignedIn = false;

  LoadingStatus _status = LoadingStatus.idle;
  User? _user;
  String? _errorMessage;

  UserViewModel({
    required AuthRepository authRepository,
    required LocalStorageRepository localStorageRepository,
  })  : _authRepository = authRepository,
        _localStorageRepository = localStorageRepository {
    getRememberMeValue();
  }

  Future<void> handleLogin({required String email, required String password}) async {
    _status = LoadingStatus.busy;

    try {
      _user = await _authRepository.login(email, password);
      saveToken(_user!.token);
      _errorMessage = null;
      _isSignedIn = true;
      _status = LoadingStatus.completed;

      notifyListeners();
    } catch (e) {
      _user = null;
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'An unknown error occurred';
      }
      _status = LoadingStatus.idle;
      notifyListeners();
    }
  }

  Future<void> handleRegistration(Map<String, dynamic> userData) async {
    _status = LoadingStatus.busy;
    try {
      _user = await _authRepository.register(userData);
      saveToken(_user!.token);
      _errorMessage = null;
      _isSignedIn = true;
      _status = LoadingStatus.completed;
      notifyListeners();
    } catch (e) {
      _user = null;
      if (e is ApiException) {
        _errorMessage = e.message;
      } else {
        _errorMessage = 'An unknown error occurred';
      }
      _status = LoadingStatus.idle;
      notifyListeners();
    }
  }

  Future<void> handleLogout() async {
    _status = LoadingStatus.busy;
    notifyListeners();

    await _localStorageRepository.clearToken();
    _status = LoadingStatus.completed;
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    await _localStorageRepository.saveToken(token);
    notifyListeners();
  }

  Future<String?> retrieveToken() {
    return _localStorageRepository.retrieveToken();
  }

  Future<bool> isTokenValid() async {
    String? authToken = await retrieveToken();
    if (authToken == null) {
      return false;
    }

    Map<String, dynamic> payload = Jwt.parseJwt(authToken);

    if (!payload.containsKey('exp')) {
      return false;
    }

    int expiryTimeInSeconds = payload['exp'];
    DateTime expiryDateTime = DateTime.fromMillisecondsSinceEpoch(expiryTimeInSeconds * 1000);

    if (expiryDateTime.isBefore(DateTime.now())) {
      return false;
    }

    return true; // Token is valid
  }

  void getRememberMeValue() async {
    _rememberMe = await _localStorageRepository.getRememberMeValue() ?? false;
    notifyListeners();
  }

  Future<void> saveRememberMeValue(bool rememberMeValue) async {
    _localStorageRepository.saveRememberMeValue(rememberMeValue).then((_) {
      getRememberMeValue();
      notifyListeners();
    });
  }

  void reset() {
    _rememberMe = false;
    _isSignedIn = false;
    _status = LoadingStatus.idle;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  LoadingStatus get status => _status;
  bool get rememberMe => _rememberMe;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isSignedIn => _isSignedIn;
}
