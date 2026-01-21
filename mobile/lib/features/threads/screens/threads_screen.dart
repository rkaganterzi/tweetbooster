import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/utils/extensions.dart';
import '../providers/threads_provider.dart';
import '../widgets/thread_composer.dart';
import '../widgets/thread_preview.dart';

class ThreadsScreen extends ConsumerStatefulWidget {
  const ThreadsScreen({super.key});

  @override
  ConsumerState<ThreadsScreen> createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends ConsumerState<ThreadsScreen> {
  final _contentController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCreateThread() {
    ref.read(threadsControllerProvider.notifier).createThread();
  }

  void _onEditPart(int index) {
    final state = ref.read(threadsControllerProvider);
    if (state.thread == null) return;

    final part = state.thread!.parts[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditPartSheet(
        content: part.content,
        partNumber: part.partNumber,
        totalParts: state.thread!.totalParts,
        onSave: (newContent) {
          ref.read(threadsControllerProvider.notifier).updatePart(
                index,
                newContent,
              );
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onClear() {
    _contentController.clear();
    ref.read(threadsControllerProvider.notifier).clearThread();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(threadsControllerProvider);
    final l10n = context.l10n;

    // Listen for errors
    ref.listen<ThreadsState>(threadsControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        context.showSnackBar(next.error!, isError: true);
        ref.read(threadsControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.threadsTab),
        actions: [
          if (state.thread != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _onClear,
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isProcessing,
        message: 'Thread oluşturuluyor...',
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.thread == null) ...[
                // Composer
                ThreadComposer(
                  controller: _contentController,
                  onChanged: (value) {
                    ref.read(threadsControllerProvider.notifier).setContent(value);
                  },
                  hintText: 'Uzun içeriğinizi buraya yazın. Otomatik olarak thread parçalarına bölünecek...',
                ),

                AppSpacing.verticalGapMd,

                // Info card
                Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20,
                      ),
                      AppSpacing.horizontalGapSm,
                      Expanded(
                        child: Text(
                          'İçerik 280 karakterlik parçalara otomatik olarak bölünecektir.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.verticalGapLg,

                // Create button
                AppButton(
                  text: l10n.createThread,
                  onPressed: _contentController.text.trim().isNotEmpty
                      ? _onCreateThread
                      : null,
                  icon: Icons.list_alt,
                ),
              ] else ...[
                // Thread preview
                ThreadPreview(
                  thread: state.thread!,
                  onEditPart: _onEditPart,
                  onCopyAll: () {},
                ),
              ],

              AppSpacing.verticalGapXl,
            ],
          ),
        ),
      ),
    );
  }
}

class _EditPartSheet extends StatefulWidget {
  final String content;
  final int partNumber;
  final int totalParts;
  final Function(String) onSave;

  const _EditPartSheet({
    required this.content,
    required this.partNumber,
    required this.totalParts,
    required this.onSave,
  });

  @override
  State<_EditPartSheet> createState() => _EditPartSheetState();
}

class _EditPartSheetState extends State<_EditPartSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          AppSpacing.verticalGapMd,

          // Title
          Text(
            'Parça ${widget.partNumber}/${widget.totalParts} Düzenle',
            style: AppTypography.h3,
          ),

          AppSpacing.verticalGapMd,

          // Content editor
          AppTextField(
            controller: _controller,
            maxLines: 6,
            maxLength: 280,
          ),

          AppSpacing.verticalGapMd,

          // Character count
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              final count = value.text.length;
              final isOver = count > 280;

              return Text(
                '$count/280',
                style: AppTypography.caption.copyWith(
                  color: isOver ? AppColors.error : AppColors.textSecondary,
                ),
                textAlign: TextAlign.right,
              );
            },
          ),

          AppSpacing.verticalGapLg,

          // Actions
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'İptal',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              AppSpacing.horizontalGapSm,
              Expanded(
                child: AppButton(
                  text: 'Kaydet',
                  onPressed: () => widget.onSave(_controller.text),
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
