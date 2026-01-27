import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { randomUUID } from 'node:crypto';
import { eq, desc } from 'drizzle-orm';
import { db, schema, isDbAvailable } from '../db/index.js';
import { analyzeScreenshot, ExtractedMetrics } from '../services/vision/screenshot-analyzer.js';

const router = Router();

// Request schemas
const extractMetricsSchema = z.object({
  imageBase64: z.string().min(1, 'Image data is required').max(10 * 1024 * 1024, 'Image too large (max 10MB)'),
  mediaType: z.enum(['image/png', 'image/jpeg', 'image/webp']).default('image/png'),
  originalAnalysisId: z.string().optional(),
  predictedScore: z.number().min(0).max(100).optional(),
  postContent: z.string().optional(),
});

const updateMetricsSchema = z.object({
  actualLikes: z.number().int().min(0).optional(),
  actualRetweets: z.number().int().min(0).optional(),
  actualReplies: z.number().int().min(0).optional(),
  actualQuotes: z.number().int().min(0).optional(),
  actualImpressions: z.number().int().min(0).optional(),
  actualBookmarks: z.number().int().min(0).optional(),
});

// POST /api/performance/extract - Extract metrics from screenshot
router.post('/extract', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { imageBase64, mediaType, originalAnalysisId, predictedScore, postContent } =
      extractMetricsSchema.parse(req.body);

    // Extract metrics using Claude Vision
    const metrics = await analyzeScreenshot(imageBase64, mediaType);

    // Calculate accuracy score if predicted score is provided
    let accuracyScore: number | null = null;
    if (predictedScore && metrics.totalEngagement) {
      // Simple accuracy calculation based on engagement relative to predicted score
      const actualEngagementScore = Math.min(100, (metrics.totalEngagement / 1000) * 100);
      accuracyScore = 100 - Math.abs(predictedScore - actualEngagementScore);
    }

    // Save to database if available
    let savedId: string | null = null;
    if (isDbAvailable && db) {
      try {
        savedId = randomUUID();
        await db.insert(schema.performanceTracking).values({
          id: savedId,
          originalAnalysisId: originalAnalysisId || null,
          predictedScore: predictedScore || 0,
          actualLikes: metrics.likes,
          actualRetweets: metrics.retweets,
          actualReplies: metrics.replies,
          actualQuotes: metrics.quotes,
          actualImpressions: metrics.impressions,
          actualBookmarks: metrics.bookmarks,
          postContent: postContent || null,
          accuracyScore,
        });
      } catch {
        savedId = null;
      }
    }

    res.json({
      success: true,
      data: {
        id: savedId,
        metrics,
        accuracyScore,
        createdAt: new Date().toISOString(),
      },
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/performance/history - Get performance tracking history
router.get('/history', async (_req: Request, res: Response, next: NextFunction) => {
  try {
    if (!isDbAvailable || !db) {
      return res.json({
        success: true,
        data: [],
        message: 'History not available - database not configured',
      });
    }

    const history = await db.query.performanceTracking.findMany({
      orderBy: (records, { desc }) => [desc(records.createdAt)],
      limit: 50,
    });

    res.json({
      success: true,
      data: history,
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/performance/trends - Get performance trends
router.get('/trends', async (_req: Request, res: Response, next: NextFunction) => {
  try {
    if (!isDbAvailable || !db) {
      return res.json({
        success: true,
        data: {
          averageAccuracy: null,
          totalAnalyses: 0,
          averageEngagement: null,
          trend: [],
        },
      });
    }

    const history = await db.query.performanceTracking.findMany({
      orderBy: (records, { desc }) => [desc(records.createdAt)],
      limit: 30,
    });

    // Calculate trends
    const accuracies = history.filter(h => h.accuracyScore !== null).map(h => h.accuracyScore!);
    const engagements = history.map(h =>
      (h.actualLikes || 0) + (h.actualRetweets || 0) + (h.actualReplies || 0)
    );

    const averageAccuracy = accuracies.length > 0
      ? accuracies.reduce((a, b) => a + b, 0) / accuracies.length
      : null;

    const averageEngagement = engagements.length > 0
      ? engagements.reduce((a, b) => a + b, 0) / engagements.length
      : null;

    // Prepare trend data (last 7 records)
    const trend = history.slice(0, 7).reverse().map(h => ({
      date: h.createdAt,
      likes: h.actualLikes || 0,
      retweets: h.actualRetweets || 0,
      replies: h.actualReplies || 0,
      accuracy: h.accuracyScore,
    }));

    res.json({
      success: true,
      data: {
        averageAccuracy,
        totalAnalyses: history.length,
        averageEngagement,
        trend,
      },
    });
  } catch (error) {
    next(error);
  }
});

// PUT /api/performance/:id - Update metrics manually
router.put('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id as string;
    const updates = updateMetricsSchema.parse(req.body);

    if (!isDbAvailable || !db) {
      return res.status(404).json({
        success: false,
        error: 'Database not configured',
      });
    }

    await db.update(schema.performanceTracking)
      .set(updates)
      .where(eq(schema.performanceTracking.id, id));

    const updated = await db.query.performanceTracking.findFirst({
      where: eq(schema.performanceTracking.id, id),
    });

    res.json({
      success: true,
      data: updated,
    });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/performance/:id - Delete performance record
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id as string;

    if (!isDbAvailable || !db) {
      return res.status(404).json({
        success: false,
        error: 'Database not configured',
      });
    }

    await db.delete(schema.performanceTracking).where(eq(schema.performanceTracking.id, id));

    res.json({
      success: true,
      message: 'Performance record deleted',
    });
  } catch (error) {
    next(error);
  }
});

export default router;
