import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isFirebaseAvailable = false;

  AuthService() {
    _initFirebase();
  }

  void _initFirebase() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _firebaseAuth = FirebaseAuth.instance;
        _isFirebaseAvailable = true;
      }
    } catch (e) {
      _isFirebaseAvailable = false;
    }
  }

  // Current user stream
  Stream<User?> get authStateChanges {
    if (!_isFirebaseAvailable || _firebaseAuth == null) {
      // Return a stream that emits null (not authenticated)
      return Stream.value(null);
    }
    return _firebaseAuth!.authStateChanges();
  }

  // Current user
  User? get currentUser => _isFirebaseAvailable ? _firebaseAuth?.currentUser : null;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Check if Firebase is available
  bool get isFirebaseAvailable => _isFirebaseAvailable;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    if (!_isFirebaseAvailable || _firebaseAuth == null) {
      throw AuthException('Firebase is not configured. Please add google-services.json.');
    }

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth!.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Giriş yapılırken bir hata oluştu: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final futures = <Future>[];
      if (_isFirebaseAvailable && _firebaseAuth != null) {
        futures.add(_firebaseAuth!.signOut());
      }
      futures.add(_googleSignIn.signOut());
      await Future.wait(futures);
    } catch (e) {
      throw AuthException('Çıkış yapılırken bir hata oluştu.');
    }
  }

  // Get ID token for API authentication
  Future<String?> getIdToken() async {
    try {
      return await currentUser?.getIdToken();
    } catch (e) {
      return null;
    }
  }

  // Refresh token
  Future<String?> refreshToken() async {
    try {
      return await currentUser?.getIdToken(true);
    } catch (e) {
      return null;
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'Bu e-posta adresi başka bir hesapla ilişkili.';
      case 'invalid-credential':
        return 'Geçersiz kimlik bilgileri.';
      case 'operation-not-allowed':
        return 'Bu giriş yöntemi etkin değil.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış şifre.';
      case 'network-request-failed':
        return 'İnternet bağlantısı bulunamadı.';
      default:
        return 'Giriş yapılırken bir hata oluştu.';
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
