import 'package:rebuild/features/auth/domain/entities/auth_session.dart';
import 'package:rebuild/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenIfNeededUseCase {
  final AuthRepository _repository;

  RefreshTokenIfNeededUseCase(this._repository);

  Future<AuthSession?> call() async {
    final stored = await _repository.getStoredSession();

    final expiresOn = stored.expiresOn;
    if (!stored.hasToken) {
      return null;
    }

    final expiresTime = expiresOn != null ? DateTime.tryParse(expiresOn) : null;
    final isExpired = expiresTime == null || expiresTime.isBefore(DateTime.now());

    if (!isExpired) {
      return stored;
    }

    final refreshed = await _repository.refreshAuthToken();
    if (!refreshed) {
      return null;
    }

    return _repository.getStoredSession();
  }
}
