enum TemplateCategory {
  all,
  question,
  thread,
  hotTake,
  value,
  story,
}

extension TemplateCategoryExtension on TemplateCategory {
  String get label {
    switch (this) {
      case TemplateCategory.all:
        return 'Tümü';
      case TemplateCategory.question:
        return 'Soru';
      case TemplateCategory.thread:
        return 'Thread';
      case TemplateCategory.hotTake:
        return 'Hot Take';
      case TemplateCategory.value:
        return 'Değer';
      case TemplateCategory.story:
        return 'Hikaye';
    }
  }

  String get value => name;
}

class PostTemplate {
  final String id;
  final String name;
  final String description;
  final String template;
  final TemplateCategory category;
  final List<String> placeholders;
  final double? averageScore;
  final int usageCount;

  PostTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.template,
    required this.category,
    this.placeholders = const [],
    this.averageScore,
    this.usageCount = 0,
  });

  factory PostTemplate.fromJson(Map<String, dynamic> json) {
    return PostTemplate(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      template: json['template'] as String? ?? '',
      category: _parseCategory(json['category'] as String?),
      placeholders: (json['placeholders'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'template': template,
      'category': category.value,
      'placeholders': placeholders,
      'averageScore': averageScore,
      'usageCount': usageCount,
    };
  }

  static TemplateCategory _parseCategory(String? category) {
    switch (category) {
      case 'question':
        return TemplateCategory.question;
      case 'thread':
        return TemplateCategory.thread;
      case 'hotTake':
        return TemplateCategory.hotTake;
      case 'value':
        return TemplateCategory.value;
      case 'story':
        return TemplateCategory.story;
      default:
        return TemplateCategory.all;
    }
  }

  String applyPlaceholders(Map<String, String> values) {
    String result = template;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  bool get hasPlaceholders => placeholders.isNotEmpty;
}
