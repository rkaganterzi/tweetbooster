import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/user.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth state stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((user) {
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }).value;
});

// Auth controller for actions
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  final Ref _ref;

  AuthController(this._authService, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final result = await _authService.signInWithGoogle();
      state = const AsyncValue.data(null);
      return result != null;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService, ref);
});
