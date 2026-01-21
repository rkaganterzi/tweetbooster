# TweetBoost API

X (Twitter) post analiz ve optimizasyon API'si.

## Özellikler

- **Post Analizi**: X algoritmasına göre post skorlama
- **Post Üretimi**: Gemini AI ile post oluşturma
- **Şablonlar**: Hazır post şablonları
- **Zamanlama**: En iyi paylaşım zamanları

## Hızlı Başlangıç

```bash
# Bağımlılıkları yükle
npm install

# Geliştirme sunucusunu başlat
npm run dev
```

API http://localhost:3001 adresinde çalışacak.

## Environment Variables

`.env.example` dosyasını `.env` olarak kopyalayın:

```bash
cp .env.example .env
```

| Variable | Required | Description |
|----------|----------|-------------|
| `PORT` | No | Server port (default: 3001) |
| `DATABASE_URL` | No | PostgreSQL connection string (history için) |
| `ANTHROPIC_API_KEY` | Yes* | Claude API key (AI üretimi için) |

> *Post üretimi için gerekli, analiz için gerekli değil.

> **Not**: DATABASE_URL olmadan da API çalışır, sadece history kaydedilmez.

## API Endpoints

### Health Check
```
GET /health
```

### Post Analizi
```
POST /api/analyze
Content-Type: application/json

{
  "content": "Post içeriği",
  "hasMedia": false,
  "saveHistory": false
}
```

### Post Üretimi
```
POST /api/generate
Content-Type: application/json

{
  "topic": "Konu",
  "style": "informative",
  "targetEngagement": "likes"
}
```

### Şablonlar
```
GET /api/templates
GET /api/templates/:id
```

### Zamanlama
```
GET /api/timing
GET /api/timing/now
```

## Render'a Deploy

### Yöntem 1: Manuel Deploy

1. [Render Dashboard](https://dashboard.render.com)'a gidin
2. **New > Web Service** seçin
3. GitHub repo'nuzu bağlayın
4. Ayarlar:
   - **Root Directory**: `backend`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm start`
5. Environment variables ekleyin (opsiyonel):
   - `DATABASE_URL`: PostgreSQL connection string
   - `GEMINI_API_KEY`: Gemini API key

### Yöntem 2: Blueprint ile Deploy

1. `render.yaml` dosyası zaten hazır
2. Render Dashboard > **Blueprints** > **New Blueprint Instance**
3. Repo'yu seçin ve deploy edin

## Geliştirme

```bash
# TypeScript kontrolü
npm run typecheck

# Build
npm run build

# Production
npm start
```

## Lisans

MIT
