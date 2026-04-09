// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth State Dart.dart';
import '../../Api/AuthServiceDart.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService service;
  AuthCubit(this.service) : super(const AuthState());

  /// تسجيل الدخول
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final data = await service.login(email: email, password: password);

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
    final prefs = await SharedPreferences.getInstance();

    final storedToken = prefs.getString('auth_token');
    if (storedToken == null || storedToken.isEmpty) return false;

    final expires = state.expiresOn ?? prefs.getString('expires_on');
    final expiresTime = expires == null ? null : DateTime.tryParse(expires);

    // لو ما قدرنا نفهم تاريخ الانتهاء، نرجع لصلاحية الـ JWT نفسه.
    if (expiresTime == null) {
      if (!service.isTokenExpired(storedToken)) {
        _syncStateFromStorage(prefs);
        return true;
      }
      return await _refreshAndUpdateState();
    }

    if (expiresTime.isAfter(DateTime.now())) {
      _syncStateFromStorage(prefs);
      return true;
    }

    // انتهت الصلاحية → نجدد
    return await _refreshAndUpdateState();
  }


  void _syncStateFromStorage(SharedPreferences prefs) {
    emit(
      state.copyWith(
        isAuthenticated: true,
        token: prefs.getString('auth_token'),
        refreshToken: prefs.getString('refresh_token'),
        expiresOn: prefs.getString('expires_on'),
      ),
    );
  }

  Future<bool> _refreshAndUpdateState() async {
    final success = await service.refreshAuthToken();
    if (!success) return false;

    final prefs = await SharedPreferences.getInstance();

    final newToken = prefs.getString('auth_token');
    final newRefresh = prefs.getString('refresh_token');
    final newExpires = prefs.getString('expires_on');

    // تحديث الحالة
    emit(
      state.copyWith(
        token: newToken,
        refreshToken: newRefresh,
        expiresOn: newExpires,
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
      final success = await service.signUp(
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
      final data = await service.login(email: email, password: password);

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
      final user = await service.getCurrentUserFull();
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('expires_on');
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
