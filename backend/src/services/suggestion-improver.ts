import { generateWithClaude, isClaudeConfigured } from './claude/client.js';
import type { Suggestion } from '@postmaker/shared';

export interface ImprovedSuggestion extends Suggestion {
  improvedContent?: string;
}

/**
 * Generate improved content for each suggestion using Claude
 */
export async function generateImprovedSuggestions(
  originalContent: string,
  suggestions: Suggestion[]
): Promise<ImprovedSuggestion[]> {
  if (!isClaudeConfigured() || suggestions.length === 0) {
    return suggestions;
  }

  // Take top 3 suggestions to limit API calls
  const topSuggestions = suggestions.slice(0, 3);

  const prompt = `Sen bir X (Twitter) içerik uzmanısın. Aşağıdaki tweet'i verilen önerilere göre düzenle.

Orijinal Tweet:
"${originalContent}"

Her öneri için tweet'in düzenlenmiş halini yaz. Sadece düzenlenmiş tweet'leri JSON formatında döndür.

Öneriler:
${topSuggestions.map((s, i) => `${i + 1}. ${s.type}: ${s.message}`).join('\n')}

SADECE şu JSON formatında yanıt ver, başka bir şey yazma:
{
  "improvements": [
    {"type": "öneri_tipi", "content": "düzenlenmiş tweet"},
    ...
  ]
}

Kurallar:
- Her düzenlenmiş tweet maksimum 280 karakter olmalı
- Orijinal mesajın özünü koru
- Sadece ilgili öneriyi uygula
- Doğal ve akıcı olsun`;

  try {
    const response = await generateWithClaude(prompt);

    // Parse JSON response
    const jsonMatch = response.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      return suggestions;
    }

    const parsed = JSON.parse(jsonMatch[0]) as {
      improvements: Array<{ type: string; content: string }>;
    };

    // Map improvements back to suggestions
    const improvedSuggestions: ImprovedSuggestion[] = suggestions.map((suggestion) => {
      const improvement = parsed.improvements.find(
        (imp) => imp.type.toLowerCase().includes(suggestion.type.toLowerCase()) ||
                 suggestion.type.toLowerCase().includes(imp.type.toLowerCase())
      );

      return {
        ...suggestion,
        improvedContent: improvement?.content,
      };
    });

    return improvedSuggestions;
  } catch (error) {
    console.error('Failed to generate improved suggestions:', error);
    return suggestions;
  }
}
