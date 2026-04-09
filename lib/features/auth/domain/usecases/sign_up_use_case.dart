import 'package:rebuild/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<bool> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int cityId,
    required String phone,
  }) {
    return _repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      cityId: cityId,
      phone: phone,
    );
  }
}
