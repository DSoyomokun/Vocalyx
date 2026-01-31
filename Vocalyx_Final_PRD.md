# Vocalyx — Product Requirements Document (Final)

**Tagline:** Train how you speak, not just what you say.

---

## 1. Problem Statement

Many capable professionals struggle to communicate confidence, clarity, and competence in high-stakes conversations such as interviews, networking, and leadership discussions.

Existing solutions fall short because:
- Interview prep focuses on *what* to say, not *how* to say it
- Public speaking tools optimize for presentations, not conversational speech
- AI tools rewrite text but do not train spoken delivery
- There is no tight feedback loop that converts practice into improvement

**Result:** People often sound less capable than they actually are.

---

## 2. Product Vision

Vocalyx is an **AI-powered speaking coach** that helps users improve how they speak by:
- Analyzing real spoken responses
- Providing structured, actionable feedback
- Rewriting responses in confident, professional styles
- Reinforcing delivery through repetition and constraints

The focus is **applied communication skill**, not theory or impersonation.

---

## 3. Target Users

### Primary Users
- Job seekers and early-career professionals
- Software engineers (backend / full-stack / AI)
- Candidates preparing for interviews

### Secondary Users
- Sales professionals
- Startup founders
- Content creators / podcasters
- Professionals seeking confidence in conversation

---

## 4. Core Use Case

> “I want to answer interview questions in a way that makes me sound confident, capable, and professional — not nervous or junior.”

---

## 5. MVP Scope

### 5.1 Modes

**Interview Mode (MVP)**  
Trains behavioral and technical storytelling using the  
**T.A.R framework (Tension → Action → Result)**.

---

### 5.2 Style Packs (Speaking Archetypes)

Users select **archetypes**, not impersonations.  
Style packs are implemented as configurable rules.

| Style Pack | Characteristics |
|-----------|-----------------|
| Executive Calm | Concise, decisive, minimal filler |
| Comedian Witty | Light situational humor, warm but professional |
| Charismatic Witty | Confident, engaging, subtle charm |

---

## 6. Core User Flow

```
1. SELECT
   - Mode: Interview
   - Style Pack
   - Prompt

2. RECORD
   - Real-time coaching visuals
   - Target duration (45–60s)
   - Pace and energy guidance

3. SUBMIT
   - Audio stored
   - Async backend pipeline triggered

4. ANALYZE
   - Transcription
   - Heuristic metrics
   - Structured AI evaluation
   - Rewrite + drill generation

5. REVIEW
   - Scores and critique
   - Rewritten response
   - Follow-up drill

6. REPEAT
   - Constrained re-attempt
   - Improvement loop
```

---

## 7. Key Features

### 7.1 Audio Recording & Playback
- Mobile recording (Expo)
- Playback for self-review
- Secure per-user storage

---

### 7.2 Real-Time Coaching (On-Device, MVP)
- Elapsed / remaining time
- Speaking pace indicator
- Voice energy visualization
- Visual coaching cues

*Streaming transcription deferred to Phase 2.*

---

### 7.3 Post-Speech Analysis (Core Value)

#### Deterministic Metrics (Non-LLM)
- Duration
- Words per minute
- Filler word count
- Hedge phrase density
- Ownership verb usage
- Repetition detection

#### Structured AI Evaluation (LLM)
- T.A.R completeness
- Clarity and conciseness
- Confidence and decisiveness
- Delivery quality

All LLM outputs are validated against **strict Pydantic schemas**.

---

### 7.4 Rewrite Engine
- Rewrites user responses in selected style pack
- Preserves factual accuracy
- Improves structure, tone, cadence

---

### 7.5 Drill Generator
- Shortened, constrained re-attempts
- Time, structure, and clarity constraints
- Reinforces improvement through repetition

---

## 8. Technical Architecture

### 8.1 Stack Overview

| Layer | Technology |
|-----|------------|
| Client | Expo (React Native) |
| Backend | FastAPI (Python 3.12+) |
| Database | Supabase (PostgreSQL + pgvector) |
| Task Queue | Redis + Celery |
| Auth | Supabase Auth |
| Storage | Supabase Storage / S3 |
| Transcription | Whisper v3-large |
| Orchestration | LangGraph |
| LLM Providers | GPT-4o / Claude 3.5 Sonnet |
| Observability | LangSmith |
| Deployment | Fly.io / Render |

---

### 8.2 Backend Repository Structure

```
vocalyx-backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       └── endpoints/
│   │           ├── audio.py
│   │           ├── analysis.py
│   │           └── users.py
│   ├── core/
│   ├── models/
│   ├── schemas/
│   ├── services/
│   │   ├── transcription.py
│   │   ├── heuristics.py
│   │   └── orchestration.py
│   ├── main.py
│   └── worker.py
├── tests/
├── alembic/
└── requirements.txt
```

---

## 16. Open Questions

- Best onboarding experience?
- Optimal default style pack?
- Ideal balance of real-time vs post-speech coaching?
- Which sharing mechanics improve retention?
- Which user segments convert fastest to Pro?
