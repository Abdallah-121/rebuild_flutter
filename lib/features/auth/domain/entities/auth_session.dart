class AuthSession {
  final String? token;
  final String? refreshToken;
  final String? expiresOn;

  const AuthSession({
    this.token,
    this.refreshToken,
    this.expiresOn,
  });

  bool get hasToken => token != null && token!.isNotEmpty;
}
