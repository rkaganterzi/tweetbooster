import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    final success =
        await ref.read(authControllerProvider.notifier).signInWithGoogle();

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        context.go(AppRoutes.home);
      } else {
        context.showSnackBar('Giriş yapılamadı. Lütfen tekrar deneyin.',
            isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo and branding
              _buildLogo(),

              const Spacer(),

              // Login button
              _buildLoginSection(l10n),

              const Spacer(flex: 2),

              // Terms and privacy
              _buildTermsSection(l10n),

              AppSpacing.verticalGapMd,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
        AppSpacing.verticalGapLg,
        Text(
          'TweetBoost',
          style: AppTypography.h1.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.verticalGapSm,
        Text(
          context.l10n.welcomeSubtitle,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginSection(l10n) {
    return Column(
      children: [
        // Features list
        _buildFeaturesList(),

        AppSpacing.verticalGapXl,

        // Google Sign In button
        _GoogleSignInButton(
          onPressed: _isLoading ? null : _signInWithGoogle,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Algoritmaya göre post analizi',
      'AI destekli içerik önerileri',
      'En iyi paylaşım zamanları',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 20,
                color: AppColors.success,
              ),
              AppSpacing.horizontalGapSm,
              Text(
                feature,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTermsSection(l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        l10n.termsAndPrivacy,
        style: AppTypography.caption.copyWith(
          color: AppColors.textMuted,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GoogleSignInButton({
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Google logo placeholder
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.g_mobiledata,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.loginWithGoogle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
