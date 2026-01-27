import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/user.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Current user provider - always null (no auth)
final currentUserProvider = Provider<AppUser?>((ref) {
  return null;
});
