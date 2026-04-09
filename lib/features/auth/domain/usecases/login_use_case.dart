import 'package:rebuild/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Map<String, dynamic>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
