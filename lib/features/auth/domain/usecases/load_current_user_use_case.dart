import 'package:rebuild/Model/UserModel.dart';
import 'package:rebuild/features/auth/domain/repositories/auth_repository.dart';

class LoadCurrentUserUseCase {
  final AuthRepository _repository;

  LoadCurrentUserUseCase(this._repository);

  Future<UserModel?> call() {
    return _repository.getCurrentUserFull();
  }
}
