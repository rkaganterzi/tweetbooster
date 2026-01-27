import 'dotenv/config';
import express, { Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { errorHandler, notFoundHandler } from './middleware/error.js';
import analyzeRouter from './routes/analyze.js';
import generateRouter from './routes/generate.js';
import templatesRouter from './routes/templates.js';
import timingRouter from './routes/timing.js';
import competitorRouter from './routes/competitor.js';
import performanceRouter from './routes/performance.js';

const app = express();
const PORT = process.env.PORT ?? 3001;

// Security middleware
app.use(helmet());

// CORS configuration
const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'];
app.use(cors({
  origin: (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) => {
    // Allow requests with no origin (mobile apps, curl, etc.)
    if (!origin) return callback(null, true);
    if (allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
      return callback(null, true);
    }
    return callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
}));

// Rate limiting - general
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: { error: 'Too many requests, please try again later.' },
  standardHeaders: true,
  legacyHeaders: false,
});

// Rate limiting - AI endpoints (more restrictive)
const aiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 20, // 20 requests per window
  message: { error: 'Too many AI requests, please try again later.' },
  standardHeaders: true,
  legacyHeaders: false,
});

app.use(generalLimiter);
app.use(express.json({ limit: '10mb' }));

app.get('/health', (_req: Request, res: Response) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/analyze', analyzeRouter);
app.use('/api/generate', aiLimiter, generateRouter);
app.use('/api/templates', templatesRouter);
app.use('/api/timing', timingRouter);
app.use('/api/competitor', aiLimiter, competitorRouter);
app.use('/api/performance', aiLimiter, performanceRouter);

app.use(notFoundHandler);
app.use(errorHandler);

app.listen(PORT, () => {
  if (process.env.NODE_ENV !== 'production') {
    console.log(`[API] Server running on http://localhost:${PORT}`);
  }
});

export default app;
