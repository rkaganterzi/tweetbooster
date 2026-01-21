import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class ScreenshotUpload extends StatelessWidget {
  final Uint8List? selectedImage;
  final ValueChanged<Uint8List?> onImageSelected;
  final VoidCallback? onClear;

  const ScreenshotUpload({
    super.key,
    this.selectedImage,
    required this.onImageSelected,
    this.onClear,
  });

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      onImageSelected(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedImage != null) {
      return AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.memory(
                selectedImage!,
                fit: BoxFit.contain,
                height: 200,
              ),
            ),
            Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Screenshot seçildi',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (onClear != null)
                    TextButton.icon(
                      onPressed: onClear,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Temizle'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tweet Screenshot\'ı Yükle',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.verticalGapMd,
          Row(
            children: [
              Expanded(
                child: _UploadOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Galeri',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ),
              AppSpacing.horizontalGapMd,
              Expanded(
                child: _UploadOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Kamera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapMd,
          Text(
            'Tweet metriklerini içeren bir screenshot seçin.\nBeğeni, RT, yanıt, görüntülenme gibi değerler otomatik olarak çıkarılacak.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UploadOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
