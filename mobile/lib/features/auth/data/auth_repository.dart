import '../../../core/services/auth_service.dart';
import '../../../models/user.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  // No auth - always return null user
  Stream<AppUser?> get authStateChanges => Stream.value(null);

  AppUser? get currentUser => null;

  bool get isLoggedIn => _authService.isLoggedIn;
}
