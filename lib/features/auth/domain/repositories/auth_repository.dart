import 'package:rebuild/Model/UserModel.dart';
import 'package:rebuild/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int cityId,
    required String phone,
  });

  Future<bool> refreshAuthToken();

  Future<AuthSession> getStoredSession();

  Future<UserModel?> getCurrentUserFull();

  Future<void> logout();
}
