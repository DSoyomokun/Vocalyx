Updating the PRD to include those "Senior AI Engineer" technical requirements—specifically around **orchestration** and **observability**—is exactly what will turn this from a "school project" into a "hiring signal."

---

## 📄 Vocalyx: Updated PRD (v1.1)

*Key updates: Transitioned from simple LLM calls to a Multi-Agent Orchestration framework and added observability guardrails.*

### Added: 16. Technical Implementation Standards (2026)

*   **Orchestration:** Use **LangGraph** to manage stateful, multi-turn feedback loops. The system must distinguish between "Technical Correctness" and "Delivery Style" as separate concurrent processes.
*   **Latency Target:** Sub-2-second turnaround for post-speech analysis using **asynchronous task queues** (Celery/Redis).
*   **Observability:** Integration with **LangSmith** for trace analysis. Every "Rewrite" must be evaluatable for hallucinations or "style drift."
*   **Database:** **PostgreSQL + pgvector** for future RAG capabilities (e.g., retrieving specific jcription contexts).
