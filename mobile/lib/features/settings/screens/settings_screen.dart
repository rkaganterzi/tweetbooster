import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/utils/extensions.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final appVersion = ref.watch(appVersionProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language
            Text(
              l10n.language,
              style: AppTypography.label,
            ),
            AppSpacing.verticalGapSm,
            _LanguageSelector(
              currentLocale: locale,
              onLocaleChanged: (newLocale) {
                ref.read(localeProvider.notifier).setLocale(newLocale);
              },
            ),

            AppSpacing.verticalGapLg,

            // Notifications
            _SettingsToggle(
              title: l10n.notifications,
              subtitle: 'Bildirimler al',
              value: notificationsEnabled,
              onChanged: (value) {
                ref.read(notificationsEnabledProvider.notifier).state = value;
              },
            ),

            AppSpacing.verticalGapLg,

            // About section
            Text(
              l10n.about,
              style: AppTypography.label,
            ),
            AppSpacing.verticalGapSm,
            AppCard(
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.info_outline,
                    title: l10n.version,
                    trailing: Text(
                      appVersion,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.border),
                  _SettingsRow(
                    icon: Icons.description_outlined,
                    title: 'Kullanım Koşulları',
                    onTap: () {
                      // Open terms
                    },
                  ),
                  const Divider(color: AppColors.border),
                  _SettingsRow(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Gizlilik Politikası',
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                ],
              ),
            ),

            AppSpacing.verticalGapXl,
          ],
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'locale': const Locale('tr'), 'name': 'Türkçe', 'flag': '🇹🇷'},
      {'locale': const Locale('en'), 'name': 'English', 'flag': '🇬🇧'},
    ];

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: languages.asMap().entries.map((entry) {
          final index = entry.key;
          final lang = entry.value;
          final locale = lang['locale'] as Locale;
          final isSelected = currentLocale.languageCode == locale.languageCode;

          return Column(
            children: [
              InkWell(
                onTap: () => onLocaleChanged(locale),
                child: Padding(
                  padding: AppSpacing.paddingMd,
                  child: Row(
                    children: [
                      Text(
                        lang['flag'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                      AppSpacing.horizontalGapMd,
                      Text(
                        lang['name'] as String,
                        style: AppTypography.body,
                      ),
                      const Spacer(),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
              if (index < languages.length - 1)
                const Divider(height: 1, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body),
                if (subtitle != null) ...[
                  AppSpacing.verticalGapXs,
                  Text(
                    subtitle!,
                    style: AppTypography.caption,
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.textSecondary,
            ),
            AppSpacing.horizontalGapMd,
            Expanded(
              child: Text(title, style: AppTypography.body),
            ),
            if (trailing != null) trailing!,
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
