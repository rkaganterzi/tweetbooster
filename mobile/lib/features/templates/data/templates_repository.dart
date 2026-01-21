import '../../../core/services/api_service.dart';
import '../../../core/config/api_config.dart';
import 'models/post_template.dart';

class TemplatesRepository {
  final ApiService _apiService;

  TemplatesRepository(this._apiService);

  Future<List<PostTemplate>> getTemplates({TemplateCategory? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category != TemplateCategory.all) {
      queryParams['category'] = category.value;
    }

    final response = await _apiService.get(
      ApiConfig.templatesEndpoint,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final list = response.data as List<dynamic>;
    return list
        .map((e) => PostTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PostTemplate> getTemplate(String id) async {
    final response = await _apiService.get(
      '${ApiConfig.templatesEndpoint}/$id',
    );

    return PostTemplate.fromJson(response.data as Map<String, dynamic>);
  }

  // Mock templates for offline/demo use
  static List<PostTemplate> getMockTemplates() {
    return [
      PostTemplate(
        id: '1',
        name: 'Soru Soran Hook',
        description: 'Etkileşim çeken soru formatı',
        template: '{soru}?\n\nCevabı çoğu kişiyi şaşırtacak.',
        category: TemplateCategory.question,
        placeholders: ['soru'],
        averageScore: 78,
        usageCount: 1250,
      ),
      PostTemplate(
        id: '2',
        name: 'Hot Take',
        description: 'Tartışma başlatacak görüş',
        template: 'Unpopular opinion:\n\n{gorus}\n\nKatılan var mı?',
        category: TemplateCategory.hotTake,
        placeholders: ['gorus'],
        averageScore: 82,
        usageCount: 890,
      ),
      PostTemplate(
        id: '3',
        name: 'Thread Başlangıcı',
        description: 'Thread için dikkat çekici açılış',
        template: '{konu} hakkında bilmeniz gereken 5 şey:\n\n🧵 Thread:',
        category: TemplateCategory.thread,
        placeholders: ['konu'],
        averageScore: 75,
        usageCount: 2100,
      ),
      PostTemplate(
        id: '4',
        name: 'Değer Paylaşımı',
        description: 'Faydalı bilgi formatı',
        template: 'Bunu öğrendikten sonra {konu} hakkındaki bakış açım tamamen değişti:\n\n{bilgi}',
        category: TemplateCategory.value,
        placeholders: ['konu', 'bilgi'],
        averageScore: 80,
        usageCount: 1500,
      ),
      PostTemplate(
        id: '5',
        name: 'Mini Hikaye',
        description: 'Hikaye anlatımı formatı',
        template: '{yil} yılında {olay}.\n\nBu deneyim bana {ders} öğretti.',
        category: TemplateCategory.story,
        placeholders: ['yil', 'olay', 'ders'],
        averageScore: 77,
        usageCount: 980,
      ),
      PostTemplate(
        id: '6',
        name: 'Karşılaştırma',
        description: 'İki şeyi karşılaştırma',
        template: '{a} vs {b}\n\nKazanan: {kazanan}\n\nNeden?',
        category: TemplateCategory.hotTake,
        placeholders: ['a', 'b', 'kazanan'],
        averageScore: 79,
        usageCount: 1100,
      ),
      PostTemplate(
        id: '7',
        name: 'Anket Sorusu',
        description: 'Oy toplayan soru',
        template: '{soru}?\n\n👍 {secenek1}\n👎 {secenek2}\n\nYorumda neden seçtiğini yaz!',
        category: TemplateCategory.question,
        placeholders: ['soru', 'secenek1', 'secenek2'],
        averageScore: 85,
        usageCount: 3200,
      ),
      PostTemplate(
        id: '8',
        name: 'Tek Cümle Hook',
        description: 'Dikkat çekici tek cümle',
        template: '{hook}\n\nBunu daha erken öğrenseydim keşke.',
        category: TemplateCategory.value,
        placeholders: ['hook'],
        averageScore: 76,
        usageCount: 1800,
      ),
    ];
  }
}
