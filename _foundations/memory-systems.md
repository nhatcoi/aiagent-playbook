# Memory Systems

## 4 lớp memory

```
┌──────────────────────────────────────────────┐
│  Working memory   (context window — sống/chết theo turn)  │
├──────────────────────────────────────────────┤
│  Episodic memory  (lịch sử conversation)     │
├──────────────────────────────────────────────┤
│  Semantic memory  (facts, rules — vector DB) │
├──────────────────────────────────────────────┤
│  Procedural       (skill, workflow đã học)   │
└──────────────────────────────────────────────┘
```

## So sánh storage

| Loại | Tech | Ưu | Nhược |
|------|------|----|-------|
| In-context | Prompt | Ngay lập tức | Tốn token, có giới hạn |
| File-based | Markdown files | Đơn giản, git-able | Không semantic search |
| Vector DB | Pinecone, Chroma, Qdrant | Semantic search | Cần embedding, infra |
| SQL | Postgres + pgvector | Hybrid filter + semantic | Setup phức tạp |
| Knowledge graph | Neo4j, Memgraph | Quan hệ rõ | Khó maintain |

## Pattern thực tế

### Claude Code memory
File markdown, frontmatter type (user/feedback/project/reference), index trong `MEMORY.md`. Đơn giản, không cần infra.

### MemGPT / Letta
OS-style: agent tự quyết định di chuyển data giữa "RAM" (context) và "disk" (vector store).

### Mem0
Layer trung gian: tự extract fact từ conversation → lưu vector DB → recall.

## Câu hỏi khi design memory

1. Nhớ **cái gì**? (user pref, project state, error history?)
2. Nhớ **bao lâu**? (session, ngày, mãi mãi?)
3. **Ai** ghi? (user explicit / agent tự động?)
4. **Khi nào** recall? (mọi turn / chỉ khi user hỏi?)
5. Stale → xử lý ra sao?

## Repos tốt

- [letta-ai/letta](https://github.com/letta-ai/letta) — MemGPT successor
- [mem0ai/mem0](https://github.com/mem0ai/mem0)
- [getzep/zep](https://github.com/getzep/zep) — memory + temporal KG
