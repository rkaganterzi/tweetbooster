import { Router } from 'express';
import { z } from 'zod';
import { randomUUID } from 'node:crypto';
import { db, schema, isDbAvailable } from '../db/index.js';
import { analyzePost } from '../services/analyzer/index.js';
import { generateWithClaude, isClaudeConfigured } from '../services/claude/client.js';
import { createError } from '../middleware/error.js';
import {
  STYLE_TARGETS,
  THREAD_GUIDELINES,
  type PostStyle,
  type TargetEngagement,
  type GeneratedPost,
} from '@postmaker/shared';

const router = Router();

const generateRequestSchema = z.object({
  topic: z.string().min(1, 'Topic is required').max(500, 'Topic too long'),
  style: z.enum(['informative', 'controversial', 'question', 'thread', 'story', 'hook']),
  targetEngagement: z.enum(['likes', 'replies', 'retweets', 'quotes', 'shares', 'all']),
  constraints: z
    .object({
      maxLength: z.number().optional(),
      minLength: z.number().optional(),
      includeHashtags: z.boolean().optional(),
      maxHashtags: z.number().optional(),
      includeEmojis: z.boolean().optional(),
      includeCTA: z.boolean().optional(),
      tone: z.enum(['professional', 'casual', 'humorous', 'provocative']).optional(),
    })
    .optional(),
});

function buildPrompt(
  topic: string,
  style: PostStyle,
  targetEngagement: TargetEngagement,
  constraints?: z.infer<typeof generateRequestSchema>['constraints']
): string {
  const styleConfig = STYLE_TARGETS[style];

  let prompt = `Sen bir X (Twitter) içerik stratejisti uzmanısın. Şu konu hakkında yüksek etkileşim alacak bir post oluştur: "${topic}"

Stil: ${style}
Hedef etkileşim: ${targetEngagement === 'all' ? styleConfig.primaryEngagement : targetEngagement}
İçerik kalıbı: ${styleConfig.contentPattern}

`;

  if (style === 'thread') {
    prompt += `${THREAD_GUIDELINES.optimalLength.min}-${THREAD_GUIDELINES.optimalLength.max} parçalık bir thread oluştur.
İlk tweet okuyucuyu çekmeli (max ${THREAD_GUIDELINES.firstTweetMaxChars} karakter).
Güçlü bir CTA ile bitir.

`;
  }

  if (constraints) {
    if (constraints.maxLength) {
      prompt += `Maksimum uzunluk: ${constraints.maxLength} karakter\n`;
    }
    if (constraints.minLength) {
      prompt += `Minimum uzunluk: ${constraints.minLength} karakter\n`;
    }
    if (constraints.includeHashtags === false) {
      prompt += `Hashtag KULLANMA\n`;
    } else if (constraints.maxHashtags) {
      prompt += `En fazla ${constraints.maxHashtags} hashtag kullan\n`;
    }
    if (constraints.includeEmojis === false) {
      prompt += `Emoji KULLANMA\n`;
    }
    if (constraints.includeCTA) {
      prompt += `Net bir call-to-action ekle\n`;
    }
    if (constraints.tone) {
      prompt += `Ton: ${constraints.tone}\n`;
    }
  }

  prompt += `
ÖNEMLİ:
- Yapay zeka tarafından yazılmış gibi değil, otantik hissettir
- Etkileşim ve paylaşım için optimize et
- Genel tavsiyeler verme - spesifik ve değerli ol
- ${style === 'question' ? 'Tartışmaya davet eden açık uçlu bir soru ile bitir' : ''}
- ${style === 'controversial' ? 'Güçlü bir duruş sergile ama saldırgan olma' : ''}
- ${style === 'hook' ? 'İnsanların etkileşime geçmek isteyeceği bir merak boşluğu yarat' : ''}

${style === 'thread' ? 'Format: PART 1: [içerik]\\nPART 2: [içerik]\\n...' : 'SADECE post içeriğini yaz, başka bir şey yazma.'}`;

  return prompt;
}

function parseThreadResponse(response: string): string[] {
  const parts = response.split(/PART \d+:/i).filter(Boolean);
  if (parts.length > 1) {
    return parts.map(p => p.trim());
  }
  return response.split(/\n\n+/).filter(p => p.trim().length > 0);
}

router.post('/', async (req, res, next) => {
  try {
    if (!isClaudeConfigured()) {
      throw createError('ANTHROPIC_API_KEY not configured', 500, 'CONFIG_ERROR');
    }

    const { topic, style, targetEngagement, constraints } = generateRequestSchema.parse(
      req.body
    );

    const prompt = buildPrompt(topic, style, targetEngagement, constraints);
    const generatedText = await generateWithClaude(prompt);

    let content: string;
    let threadParts: string[] | undefined;

    if (style === 'thread') {
      threadParts = parseThreadResponse(generatedText);
      content = threadParts[0] ?? generatedText;
    } else {
      content = generatedText.trim();
    }

    const analysis = analyzePost(content);

    const generatedPost: GeneratedPost = {
      content,
      threadParts,
      score: analysis.overallScore,
      suggestions: analysis.suggestions.map(s => s.message),
      engagementPrediction: {
        likes: Math.round(analysis.engagementScores.likeability * 100),
        replies: Math.round(analysis.engagementScores.replyability * 100),
        retweets: Math.round(analysis.engagementScores.retweetability * 100),
        quotes: Math.round(analysis.engagementScores.quoteability * 100),
        shares: Math.round(analysis.engagementScores.shareability * 100),
        dwellTime: Math.round(analysis.engagementScores.dwellPotential * 30),
      },
    };

    // Save to database if available
    if (isDbAvailable && db) {
      try {
        const id = randomUUID();
        await db.insert(schema.posts).values({
          id,
          content,
          threadParts: threadParts ?? null,
          score: analysis.overallScore,
        });
      } catch (dbError) {
        console.warn('[Generate] Failed to save to database:', dbError);
      }
    }

    res.json({
      success: true,
      data: generatedPost,
    });
  } catch (error) {
    next(error);
  }
});

router.get('/history', async (_req, res, next) => {
  try {
    if (!isDbAvailable || !db) {
      return res.json({
        success: true,
        data: [],
        message: 'History not available - database not configured',
      });
    }

    const posts = await db.query.posts.findMany({
      orderBy: (records, { desc }) => [desc(records.createdAt)],
      limit: 50,
    });

    res.json({
      success: true,
      data: posts,
    });
  } catch (error) {
    next(error);
  }
});

export default router;
