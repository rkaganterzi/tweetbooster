import Anthropic from '@anthropic-ai/sdk';
import { getClaudeClient, isClaudeConfigured } from '../claude/client.js';

export interface ExtractedMetrics {
  likes: number | null;
  retweets: number | null;
  replies: number | null;
  quotes: number | null;
  impressions: number | null;
  bookmarks: number | null;
  totalEngagement: number | null;
  confidence: number;
  rawText?: string;
}

const EXTRACTION_PROMPT = `You are analyzing a screenshot of an X/Twitter post to extract engagement metrics.

Look for the following metrics in the image:
- Likes (heart icon count)
- Retweets/Reposts (repost icon count)
- Replies (speech bubble icon count)
- Quotes (if visible)
- Impressions/Views (eye icon or view count)
- Bookmarks (bookmark icon count)

Return ONLY a JSON object with the following structure, no other text:
{
  "likes": <number or null if not found>,
  "retweets": <number or null if not found>,
  "replies": <number or null if not found>,
  "quotes": <number or null if not found>,
  "impressions": <number or null if not found>,
  "bookmarks": <number or null if not found>,
  "confidence": <0-100 indicating how confident you are in these numbers>,
  "rawText": "<any relevant text you extracted>"
}

Notes:
- If a number shows "K" (like 1.5K), convert it to the full number (1500)
- If a number shows "M" (like 1.2M), convert it to the full number (1200000)
- Set confidence lower if the image is blurry or metrics are partially visible
- Set values to null if you cannot find them in the image`;

export async function analyzeScreenshot(
  imageBase64: string,
  mediaType: 'image/png' | 'image/jpeg' | 'image/webp'
): Promise<ExtractedMetrics> {
  // Return mock data if Claude is not configured
  if (!isClaudeConfigured()) {
    console.warn('[ScreenshotAnalyzer] Claude not configured, returning mock data');
    return {
      likes: Math.floor(Math.random() * 100) + 10,
      retweets: Math.floor(Math.random() * 30) + 5,
      replies: Math.floor(Math.random() * 20) + 2,
      quotes: Math.floor(Math.random() * 10),
      impressions: Math.floor(Math.random() * 5000) + 500,
      bookmarks: Math.floor(Math.random() * 15),
      totalEngagement: 0,
      confidence: 50,
      rawText: 'Mock data - Claude API not configured',
    };
  }

  try {
    const client = getClaudeClient();

    const message = await client.messages.create({
      model: 'claude-3-haiku-20240307',
      max_tokens: 1024,
      messages: [
        {
          role: 'user',
          content: [
            {
              type: 'image',
              source: {
                type: 'base64',
                media_type: mediaType,
                data: imageBase64,
              },
            },
            {
              type: 'text',
              text: EXTRACTION_PROMPT,
            },
          ],
        },
      ],
    });

    // Extract text from response
    const responseText = message.content[0];
    if (responseText.type !== 'text') {
      throw new Error('Unexpected response format from Claude');
    }

    // Parse JSON from response
    const jsonMatch = responseText.text.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error('No JSON found in response');
    }

    const parsed = JSON.parse(jsonMatch[0]) as ExtractedMetrics;

    // Calculate total engagement
    const totalEngagement =
      (parsed.likes || 0) +
      (parsed.retweets || 0) +
      (parsed.replies || 0) +
      (parsed.quotes || 0) +
      (parsed.bookmarks || 0);

    return {
      ...parsed,
      totalEngagement,
    };
  } catch (error) {
    console.error('[ScreenshotAnalyzer] Failed to analyze screenshot:', error);

    // Return empty metrics on error
    return {
      likes: null,
      retweets: null,
      replies: null,
      quotes: null,
      impressions: null,
      bookmarks: null,
      totalEngagement: null,
      confidence: 0,
      rawText: `Error: ${error instanceof Error ? error.message : 'Unknown error'}`,
    };
  }
}
