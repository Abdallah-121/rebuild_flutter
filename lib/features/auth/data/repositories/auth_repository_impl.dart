import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Model/UserModel.dart';
import 'package:rebuild/features/auth/domain/entities/auth_session.dart';
import 'package:rebuild/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  AuthRepositoryImpl(this._service);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _service.login(email: email, password: password);
  }

  @override
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int cityId,
    required String phone,
  }) {
    return _service.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      cityId: cityId,
      phone: phone,
    );
  }

  @override
  Future<bool> refreshAuthToken() {
    return _service.refreshAuthToken();
  }

  @override
  Future<AuthSession> getStoredSession() async {
    final authData = await _service.getStoredAuthData();
    return AuthSession(
      token: authData['token'],
      refreshToken: authData['refreshToken'],
      expiresOn: authData['expiresOn'],
    );
  }

  @override
  Future<UserModel?> getCurrentUserFull() {
    return _service.getCurrentUserFull();
  }

  @override
  Future<void> logout() {
    return _service.clearAuthData();
  }
}
