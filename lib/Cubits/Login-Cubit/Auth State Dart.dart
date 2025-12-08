class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? token;
  final String? refreshToken;
  final String? expiresOn;
  final Map<String, dynamic>? user;
  final String? error;
  final bool signUpSuccess;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.token,
    this.refreshToken,
    this.expiresOn,
    this.user,
    this.error,
    this.signUpSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? token,
    String? refreshToken,
    String? expiresOn,
    Map<String, dynamic>? user,
    String? error,
    bool? signUpSuccess,

    // These allow us to explicitly set fields to null
    bool clearToken = false,
    bool clearRefresh = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,

      token: clearToken ? null : (token ?? this.token),
      refreshToken: clearRefresh ? null : (refreshToken ?? this.refreshToken),
      expiresOn: expiresOn ?? this.expiresOn,

      user: clearUser ? null : (user ?? this.user),

      error: error ?? this.error,
      signUpSuccess: signUpSuccess ?? this.signUpSuccess,
    );
  }

  bool get hasError => error != null && error!.isNotEmpty;
}
