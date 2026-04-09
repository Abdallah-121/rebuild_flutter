// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth State Dart.dart';
import '../../Api/AuthServiceDart.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/load_current_user_use_case.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/domain/usecases/refresh_token_if_needed_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final RefreshTokenIfNeededUseCase _refreshTokenIfNeededUseCase;
  final LoadCurrentUserUseCase _loadCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit(AuthService service)
    : _loginUseCase = LoginUseCase(AuthRepositoryImpl(service)),
      _signUpUseCase = SignUpUseCase(AuthRepositoryImpl(service)),
      _refreshTokenIfNeededUseCase = RefreshTokenIfNeededUseCase(
        AuthRepositoryImpl(service),
      ),
      _loadCurrentUserUseCase = LoadCurrentUserUseCase(
        AuthRepositoryImpl(service),
      ),
      _logoutUseCase = LogoutUseCase(AuthRepositoryImpl(service)),
      super(const AuthState());

  /// تسجيل الدخول
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final data = await _loginUseCase(email: email, password: password);

      final user = data['user'];
      final userData = {
        'userId': user['userId'],
        'fullName': user['fullName'],
        'email': user['email'],
        'phone': user['phoneNumber'],
        'role': user['role'],
        'cityId': user['cityId'] ?? 0,
      };

      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          token: data['token'],
          refreshToken: data['refreshToken'],
          expiresOn: data['expiresOn'],
          user: userData,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// تحديث التوكن قبل انتهاء الصلاحية
  Future<bool> refreshTokenIfNeeded() async {
    final session = await _refreshTokenIfNeededUseCase();
    if (session == null) return false;

    emit(
      state.copyWith(
        token: session.token,
        refreshToken: session.refreshToken,
        expiresOn: session.expiresOn,
      ),
    );
    return true;
  }

  /// تسجيل حساب جديد + تسجيل دخول تلقائي
  Future<void> signUp({
    required String first,
    required String last,
    required String email,
    required String password,
    required String phone,
    required int cityId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null, signUpSuccess: false));

    try {
      final success = await _signUpUseCase(
        firstName: first,
        lastName: last,
        email: email,
        password: password,
        phone: phone,
        cityId: cityId,
      );

      if (!success) {
        emit(state.copyWith(isLoading: false, error: "فشل إنشاء الحساب"));
        return;
      }

      emit(state.copyWith(isLoading: false, signUpSuccess: true));

      // تسجيل الدخول تلقائي
      final data = await _loginUseCase(email: email, password: password);

      final user = data['user'];
      final userData = {
        'userId': user['userId'],
        'fullName': user['fullName'],
        'email': user['email'],
        'phone': user['phoneNumber'],
        'role': user['role'],
        'cityId': user['cityId'] ?? cityId,
      };

      emit(
        state.copyWith(
          isAuthenticated: true,
          token: data['token'],
          refreshToken: data['refreshToken'],
          expiresOn: data['expiresOn'],
          user: userData,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// تحميل بيانات المستخدم عند فتح التطبيق
  Future<void> loadCurrentUser() async {
    try {
      final user = await _loadCurrentUserUseCase();
      if (user != null) {
        emit(
          state.copyWith(
            isAuthenticated: true,
            user: {
              'userId': user.userId,
              'fullName': user.fullName,
              'email': user.email,
              'phone': user.phoneNumber,
              'role': user.role,
            },
          ),
        );
      }
    } catch (_) {}
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    await _logoutUseCase();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');
    await prefs.remove('user_role');

    emit(
      state.copyWith(
        isAuthenticated: false,
        clearToken: true,
        clearRefresh: true,
        clearUser: true,
      ),
    );
  }
}
