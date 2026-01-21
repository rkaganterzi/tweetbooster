import { drizzle, PostgresJsDatabase } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema.js';

const DATABASE_URL = process.env.DATABASE_URL;

let db: PostgresJsDatabase<typeof schema> | null = null;
let isDbAvailable = false;

if (DATABASE_URL && DATABASE_URL !== 'postgresql://user:password@host:5432/database') {
  try {
    const client = postgres(DATABASE_URL);
    db = drizzle(client, { schema });
    isDbAvailable = true;
    console.log('[DB] Database connection initialized');
  } catch (error) {
    console.warn('[DB] Failed to connect to database:', error);
    isDbAvailable = false;
  }
} else {
  console.warn('[DB] DATABASE_URL not configured - history features disabled');
}

export { db, schema, isDbAvailable };
