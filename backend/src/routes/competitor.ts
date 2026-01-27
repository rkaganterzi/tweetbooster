import { Router } from 'express';
import { z } from 'zod';
import { randomUUID } from 'node:crypto';
import { eq, desc } from 'drizzle-orm';
import { db, schema, isDbAvailable } from '../db/index.js';
import { analyzePost } from '../services/analyzer/index.js';
import type { PostAnalysis } from '@postmaker/shared';

const router = Router();

// Request schemas
const analyzeCompetitorSchema = z.object({
  content: z.string().min(1, 'Content is required').max(10000, 'Content too long'),
  sourceUrl: z.string().url().optional(),
  notes: z.string().max(1000).optional(),
});

// POST /api/competitor/analyze - Analyze competitor content
router.post('/analyze', async (req, res, next) => {
  try {
    const { content, sourceUrl, notes } = analyzeCompetitorSchema.parse(req.body);

    // Analyze the competitor content using existing analyzer
    const analysis: PostAnalysis = analyzePost(content);

    // Save to database if available
    let savedId: string | null = null;
    if (isDbAvailable && db) {
      try {
        savedId = randomUUID();
        await db.insert(schema.competitorAnalysis).values({
          id: savedId,
          competitorContent: content,
          sourceUrl: sourceUrl || null,
          notes: notes || null,
          analysis: JSON.stringify(analysis),
        });
      } catch {
        savedId = null;
      }
    }

    res.json({
      success: true,
      data: {
        id: savedId,
        competitorContent: content,
        sourceUrl,
        notes,
        analysis,
        createdAt: new Date().toISOString(),
      },
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/competitor/history - Get competitor analysis history
router.get('/history', async (_req, res, next) => {
  try {
    if (!isDbAvailable || !db) {
      return res.json({
        success: true,
        data: [],
        message: 'History not available - database not configured',
      });
    }

    const history = await db.query.competitorAnalysis.findMany({
      orderBy: (records, { desc }) => [desc(records.createdAt)],
      limit: 50,
    });

    const parsed = history.map(record => ({
      id: record.id,
      competitorContent: record.competitorContent,
      sourceUrl: record.sourceUrl,
      notes: record.notes,
      analysis: typeof record.analysis === 'string'
        ? JSON.parse(record.analysis) as PostAnalysis
        : record.analysis,
      createdAt: record.createdAt,
    }));

    res.json({
      success: true,
      data: parsed,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/competitor/:id - Get single competitor analysis
router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!isDbAvailable || !db) {
      return res.status(404).json({
        success: false,
        error: 'Database not configured',
      });
    }

    const record = await db.query.competitorAnalysis.findFirst({
      where: eq(schema.competitorAnalysis.id, id),
    });

    if (!record) {
      return res.status(404).json({
        success: false,
        error: 'Analysis not found',
      });
    }

    res.json({
      success: true,
      data: {
        id: record.id,
        competitorContent: record.competitorContent,
        sourceUrl: record.sourceUrl,
        notes: record.notes,
        analysis: typeof record.analysis === 'string'
          ? JSON.parse(record.analysis) as PostAnalysis
          : record.analysis,
        createdAt: record.createdAt,
      },
    });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/competitor/:id - Delete competitor analysis
router.delete('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!isDbAvailable || !db) {
      return res.status(404).json({
        success: false,
        error: 'Database not configured',
      });
    }

    await db.delete(schema.competitorAnalysis).where(eq(schema.competitorAnalysis.id, id));

    res.json({
      success: true,
      message: 'Analysis deleted',
    });
  } catch (error) {
    next(error);
  }
});

export default router;
