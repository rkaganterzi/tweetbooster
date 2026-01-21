import 'package:flutter/material.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/extensions.dart';

class PostInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onAnalyze;
  final bool isAnalyzing;

  const PostInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onAnalyze,
    this.isAnalyzing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PostTextField(
          controller: controller,
          hintText: context.l10n.postPlaceholder,
          onChanged: onChanged,
          showCharacterCount: true,
        ),
      ],
    );
  }
}
