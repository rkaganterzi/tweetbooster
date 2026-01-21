import '../../../core/services/auth_service.dart';
import '../../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Stream<AppUser?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      if (user == null) return null;
      return _mapFirebaseUser(user);
    });
  }

  AppUser? get currentUser {
    final user = _authService.currentUser;
    if (user == null) return null;
    return _mapFirebaseUser(user);
  }

  bool get isLoggedIn => _authService.isLoggedIn;

  Future<AppUser?> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    if (credential?.user == null) return null;
    return _mapFirebaseUser(credential!.user!);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<String?> getIdToken() async {
    return _authService.getIdToken();
  }

  AppUser _mapFirebaseUser(fb.User user) {
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }
}
