import { pgTable, text, real, integer, timestamp, jsonb } from 'drizzle-orm/pg-core';

export const posts = pgTable('posts', {
  id: text('id').primaryKey(),
  content: text('content').notNull(),
  threadParts: jsonb('thread_parts').$type<string[]>(),
  score: real('score').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const analysisHistory = pgTable('analysis_history', {
  id: text('id').primaryKey(),
  postContent: text('post_content').notNull(),
  analysis: jsonb('analysis').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export const templates = pgTable('templates', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
  description: text('description').notNull(),
  category: text('category').notNull(),
  template: text('template').notNull(),
  placeholders: jsonb('placeholders').$type<
    Array<{
      key: string;
      label: string;
      description: string;
      type: 'text' | 'number' | 'select';
      options?: string[];
      required: boolean;
    }>
  >(),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

// Competitor Analysis table
export const competitorAnalysis = pgTable('competitor_analysis', {
  id: text('id').primaryKey(),
  competitorContent: text('competitor_content').notNull(),
  sourceUrl: text('source_url'),
  notes: text('notes'),
  analysis: jsonb('analysis').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

// Performance Tracking table
export const performanceTracking = pgTable('performance_tracking', {
  id: text('id').primaryKey(),
  originalAnalysisId: text('original_analysis_id'),
  predictedScore: real('predicted_score').notNull(),
  actualLikes: integer('actual_likes'),
  actualRetweets: integer('actual_retweets'),
  actualReplies: integer('actual_replies'),
  actualQuotes: integer('actual_quotes'),
  actualImpressions: integer('actual_impressions'),
  actualBookmarks: integer('actual_bookmarks'),
  postContent: text('post_content'),
  accuracyScore: real('accuracy_score'),
  createdAt: timestamp('created_at', { withTimezone: true })
    .notNull()
    .defaultNow(),
});

export type Post = typeof posts.$inferSelect;
export type NewPost = typeof posts.$inferInsert;
export type AnalysisHistoryRecord = typeof analysisHistory.$inferSelect;
export type NewAnalysisHistory = typeof analysisHistory.$inferInsert;
export type Template = typeof templates.$inferSelect;
export type NewTemplate = typeof templates.$inferInsert;
export type CompetitorAnalysisRecord = typeof competitorAnalysis.$inferSelect;
export type NewCompetitorAnalysis = typeof competitorAnalysis.$inferInsert;
export type PerformanceTrackingRecord = typeof performanceTracking.$inferSelect;
export type NewPerformanceTracking = typeof performanceTracking.$inferInsert;
