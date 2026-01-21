import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../../../core/providers/ad_provider.dart';
import '../../../core/utils/extensions.dart';
import '../providers/performance_provider.dart';
import '../widgets/screenshot_upload.dart';
import '../widgets/metrics_display.dart';

class PerformanceScreen extends ConsumerStatefulWidget {
  const PerformanceScreen({super.key});

  @override
  ConsumerState<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends ConsumerState<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(performanceControllerProvider);
    final l10n = context.l10n;

    // Listen for errors
    ref.listen<PerformanceState>(performanceControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        context.showSnackBar(next.error!, isError: true);
        ref.read(performanceControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Performans Takibi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoutes.performanceHistory),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isExtracting,
        message: 'Metrikler çıkarılıyor...',
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Screenshot upload
                    ScreenshotUpload(
                      selectedImage: state.selectedImage,
                      onImageSelected: (bytes) {
                        ref
                            .read(performanceControllerProvider.notifier)
                            .setSelectedImage(bytes);
                      },
                      onClear: state.selectedImage != null
                          ? () => ref
                              .read(performanceControllerProvider.notifier)
                              .clearCurrentMetrics()
                          : null,
                    ),

                    AppSpacing.verticalGapMd,

                    // Extract button
                    if (state.selectedImage != null && state.currentMetrics == null)
                      AppButton(
                        text: 'Metrikleri Çıkar',
                        onPressed: _onExtract,
                        isLoading: state.isExtracting,
                        icon: Icons.auto_fix_high,
                      ),

                    // Results
                    if (state.currentMetrics != null) ...[
                      AppSpacing.verticalGapLg,

                      MetricsDisplay(
                        metrics: state.currentMetrics!,
                        accuracyScore: state.accuracyScore,
                        isEditable: true,
                        onMetricsChanged: (metrics) {
                          if (state.currentId != null) {
                            ref
                                .read(performanceControllerProvider.notifier)
                                .updateMetrics(state.currentId!, metrics);
                          }
                        },
                      ),

                      AppSpacing.verticalGapMd,

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Yeni Analiz',
                              variant: AppButtonVariant.secondary,
                              onPressed: () {
                                ref
                                    .read(performanceControllerProvider.notifier)
                                    .clearCurrentMetrics();
                              },
                              icon: Icons.add,
                            ),
                          ),
                          AppSpacing.horizontalGapSm,
                          Expanded(
                            child: AppButton(
                              text: 'Trendleri Gör',
                              onPressed: () => context.push(AppRoutes.performanceHistory),
                              icon: Icons.trending_up,
                            ),
                          ),
                        ],
                      ),

                      AppSpacing.verticalGapXl,
                    ],
                  ],
                ),
              ),
            ),
            const BottomBannerAd(),
          ],
        ),
      ),
    );
  }

  void _onExtract() async {
    final state = ref.read(performanceControllerProvider);

    if (state.selectedImage == null) {
      context.showSnackBar('Lütfen bir screenshot seçin', isError: true);
      return;
    }

    await ref.read(performanceControllerProvider.notifier).extractMetrics(
          imageBytes: state.selectedImage!,
          mediaType: 'image/png',
        );

    // Record action for interstitial ad
    ref.read(adControllerProvider.notifier).recordAction();
  }
}
