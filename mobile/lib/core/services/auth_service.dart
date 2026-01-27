// Auth service - simplified (no Firebase)
// This file is kept for compatibility but authentication is disabled

class AuthService {
  // No authentication required
  bool get isLoggedIn => true;
  bool get isFirebaseAvailable => false;
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
