## 🗄️ Database Schema (PostgreSQL)

To prove you're a **Backend Engineer**, your schema needs to be relational and optimized for history tracking.

```sql
-- Core User Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Store metadata about the audio files
CREATE TABLE recordings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    s3_url TEXT NOT NULL,
    duration_seconds INT,
    style_pack_id VARCHAR(50), -- e.g., 'executive_calm'tailed AI Analysis
CREATE TABLE analyses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recording_id UUID REFERENCES recordings(id),
    transcript TEXT NOT NULL,
    wpm INT,
    filler_word_count INT,
    confidence_score FLOAT, -- 0.0 to 1.0
    ai_feedback_json JSONB, -- The structured rubric output
    suggested_rewrite TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```