# Vocalyx — Product Requirements Document

**Tagline:** Train how you speak, not just what you say.

---

## 1. Problem Statement

Many capable professionals struggle to communicate confidence, clarity, and competence in high-stakes conversations—interviews, networking, leadership discussions.

Existing solutions fall short:
- Interview prep focuses on *what* to say, not *how* to say it
- Public speaking tools target presentations, not conversational speaking
- AI tools rewrite text but don't train spoken delivery
- There's no tight feedback loop that turns practice into improvement

**Result:** People often sound less capable than they actually are.

---

## 2. Product Vision

Vocalyx is an **AI-powered speaking coach** that helps users practice and improve how they speak by:
- Analyzing real spoken responses
- Providing structured, actionable feedback
- Rewriting answers in confident, professional styles
- Training delivery through repetition and constraints

The focus is **applied communication skill**, not theory.

---

## 3. Target Users

### Primary
- Job seekers and early-career professionals
- Software engineers (backend / full-stack / AI)
- Candidates preparing for interviews

### Secondary
- Sales professionals
- Startup founders
- Content creators / podcasters
- Professionals seeking confidence in conversation

---

## 4. Core Use Case

> "I want to answer interview questions in a way that makes me sound confident, capable, and professional—not nervous or junior."

---

## 5. MVP Scope

### 5.1 Modes

**Interview Mode** (MVP)
- Uses **T.A.R (Tension → Action → Result)** framework to train behavioral and technical storytelling

### 5.2 Style Packs

Users select speaking **archetypes**, not impersonations. Style packs are implemented as configurable rules.

| Style Pack | Characteristics |
|------------|-----------------|
| **Executive Calm** | Concise, decisive, minimal filler |
| **Comedian Witty** | Light situational humor, warmth without losing professionalism |
| **Charismatic Witty** | Confident, engaging, subtle charm |

---

## 6. Core User Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  1. SELECT                                                      │
│     • Mode: Interview                                           │
│     • Style Pack                                                │
│     • Prompt (e.g., "Tell me about yourself")                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  2. RECORD with real-time coaching visuals                      │
│     • Timer (target 45–60s)                                     │
│     • Pace indicator (slow / good / fast)                       │
│     • Voice energy meter                                        │
│     • Filler/hedge alerts                                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  3. SUBMIT → Backend Pipeline                                   │
│     • Store audio                                               │
│     • Transcribe (Whisper)                                      │
│     • Compute metrics (non-LLM)                                 │
│     • Run structured AI evaluation                              │
│     • Generate rewrite + drill                                  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  4. RECEIVE                                                     │
│     • Scores and critique                                       │
│     • Rewritten answer in chosen style                          │
│     • Follow-up drill ("Say it again with constraints")         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    5. REPEAT → Improvement loop
```

---

## 7. Key Features

### 7.1 Audio Recording & Playback
- Mobile recording (Expo)
- Playback for self-review
- Secure storage per user

### 7.2 Real-Time Coaching (On-Device)
- Elapsed / remaining time
- Speaking pace guidance
- Amplitude / energy visualization
- Visual coaching cues

*Note: Streaming transcription is Phase 2*

### 7.3 Post-Speech Analysis

**Metrics (Computed Without LLM)**
- Duration
- Words per minute
- Filler word count
- Hedge phrase count
- Ownership verb usage
- Repetition detection

**AI Evaluation (LLM, Structured JSON)**
- T.A.R completeness
- Clarity and conciseness
- Confidence and decisiveness
- Delivery quality

All outputs validated against strict schema.

### 7.4 Rewrite Engine
- Rewrites user's answer in selected style pack
- Preserves factual accuracy
- Improves structure, tone, cadence

### 7.5 Drill Generator
- Shorter, constrained version of same answer
- Time, clarity, and structure constraints
- Reinforces improvement through repetition

---

## 8. Technical Architecture

### 8.1 Stack Overview

| Layer | Technology |
|-------|------------|
| **Client** | Expo (React Native) |
| **Backend** | FastAPI (Python 3.12+) |
| **Database** | Supabase (PostgreSQL + pgvector) |
| **Task Queue** | Redis + Celery |
| **Auth** | Supabase Auth |
| **Storage** | Supabase Storage / S3 |
| **Transcription** | Whisper v3-large |
| **Orchestration** | LangGraph |
| **Intelligence** | GPT-4o / Claude 3.5 Sonnet |
| **Observability** | LangSmith |
| **Deployment** | Fly.io / Render |

### 8.2 Backend Structure

```
vocalyx-backend/
├── app/
│   ├── api/
│   │   └── v1/
│   │       └── endpoints/
│   │           ├── audio.py        # Upload/stream audio
│   │           ├── analysis.py     # Fetch AI results
│   │           └── users.py        # Profile/history
│   ├── core/
│   │   ├── config.py
│   │   └── security.py
│   ├── models/
│   │   ├── user.py
│   │   ├── recording.py
│   │   └── analysis.py
│   ├── schemas/                    # Pydantic request/response validation
│   │   ├── audio.py
│   │   └── analysis.py
│   ├── services/                   # Business logic / AI orchestration
│   │   ├── transcription.py        # Whisper wrapper
│   │   ├── heuristics.py           # WPM, filler detection
│   │   └── orchestration.py        # LangGraph agents
│   ├── main.py                     # App entry point
│   └── worker.py                   # Celery worker for async jobs
├── tests/
├── alembic/                        # DB migrations
├── .env
└── requirements.txt
```

### 8.3 Service Modules

| Service | Responsibility |
|---------|----------------|
| **Audio Service** | Ingestion, format conversion, storage |
| **Transcription Service** | Speech-to-text via Whisper |
| **Heuristic Engine** | WPM, filler density, hedge detection (non-LLM) |
| **Orchestration Service** | LangGraph multi-agent pipeline |

### 8.4 LangGraph Orchestration

```
┌──────────────────┐    ┌──────────────────┐
│  Node A:         │    │  Node B:         │
│  Content         │    │  Style           │
│  Evaluator       │    │  Evaluator       │
│  (T.A.R check)   │    │  (Tone/Charisma) │
└────────┬─────────┘    └────────┬─────────┘
         │                       │
         └───────────┬───────────┘
                     ↓
         ┌──────────────────────┐
         │  Node C:             │
         │  Synthesis Agent     │
         │  (Feedback + Drill)  │
         └──────────────────────┘
```

Content and Style evaluation run as **separate concurrent processes**, then synthesize into final feedback.

### 8.5 Technical Standards

- **Latency Target:** Sub-2-second turnaround for post-speech analysis using async task queues
- **Observability:** LangSmith integration for trace analysis; every rewrite must be evaluatable for hallucinations or style drift
- **Database:** PostgreSQL + pgvector for future RAG capabilities (e.g., retrieving job description context)
- **Validation:** All LLM outputs validated against strict Pydantic schemas

---

## 9. Data Model

### Core Entities
- `User`
- `Session`
- `Recording`
- `Transcript`
- `Analysis`
- `StylePack`
- `Prompt`
- `Subscription`

### Design Principles
- Extensibility for new modes/features
- Auditability for debugging and improvement
- Cost tracking per user/request

---

## 10. Monetization

### Free Tier
- Limited recordings per day
- Basic analysis
- Single rewrite

### Pro Subscription
- Unlimited recordings
- Deep critique
- Multiple rewrites
- Advanced drills
- Future RAG features

*Stripe integration: Phase 2*

---

## 11. Differentiation

| Vocalyx | Competitors |
|---------|-------------|
| Spoken-first | Text-focused |
| Trains delivery | Rewrites content |
| Structured evaluation | Vague feedback |
| Repetition-based improvement | One-shot suggestions |
| Real backend + AI system | Simple API wrappers |

---

## 12. Explicit Non-Goals (MVP)

- Voice cloning or impersonation
- Actor likeness marketing
- Training ML models from scratch
- Academic ML explanations
- Slide-based public speaking tools

---

## 13. Phase 2 / Future

### AI & Systems
- Streaming partial transcription (live coaching)
- Company-fit RAG (job descriptions, values)
- User story library retrieval
- Role-specific scoring

### Product
- IRL Charisma Mode
- Pitch Mode
- Shareable before/after clips
- Progress analytics & streaks

---

## 14. Success Metrics

- Users complete multiple recordings per session
- Users repeat drills
- Positive qualitative feedback ("I sound better")
- Retention across days
- Conversion to Pro

---

## 15. Open Questions

- Best onboarding experience?
- Optimal default style pack?
- Ideal balance of real-time vs post-speech coaching?
- What sharing mechanics increase retention?
- Which user segments convert fastest to Pro?

---

## 16. Portfolio Signal

This project demonstrates:
- Backend system design (FastAPI, async pipelines)
- AI orchestration with guardrails (LangGraph, LangSmith)
- Real-time signal processing
- Production-ready architecture
- Strong product intuition
