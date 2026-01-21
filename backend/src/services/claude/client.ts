import Anthropic from '@anthropic-ai/sdk';

const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

let client: Anthropic | null = null;

export function isClaudeConfigured(): boolean {
  return Boolean(ANTHROPIC_API_KEY && ANTHROPIC_API_KEY !== 'your_anthropic_api_key_here');
}

export function getClaudeClient(): Anthropic {
  if (!isClaudeConfigured()) {
    throw new Error('ANTHROPIC_API_KEY not configured');
  }

  if (!client) {
    client = new Anthropic({
      apiKey: ANTHROPIC_API_KEY,
    });
  }

  return client;
}

export async function generateWithClaude(prompt: string): Promise<string> {
  const claude = getClaudeClient();

  const message = await claude.messages.create({
    model: 'claude-3-haiku-20240307',
    max_tokens: 1024,
    messages: [
      {
        role: 'user',
        content: prompt,
      },
    ],
  });

  // Extract text from the response
  const content = message.content[0];
  if (content.type === 'text') {
    return content.text;
  }

  throw new Error('Unexpected response format from Claude');
}
