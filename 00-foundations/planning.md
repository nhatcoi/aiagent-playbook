# Planning

## Tại sao cần plan

Single LLM call = "phản xạ". Agent phức tạp cần "tư duy chiến lược": chia mục tiêu lớn → nhánh con → bước thực thi.

## Kỹ thuật

### 1. Task Decomposition
```
Goal: tạo REST API user
├─ design schema
├─ tạo migration
├─ implement handler
├─ viết test
└─ update docs
```

### 2. Plan-and-Execute (LangChain)
- Planner LLM: tạo plan
- Executor LLM: chạy từng bước
- Re-planner: cập nhật khi gặp surprise

### 3. Tree Search (LATS, ToT)
Mở rộng nhiều plan, đánh giá, prune.

### 4. Hierarchical
Plan ở 2-3 mức độ trừu tượng: chiến lược → chiến thuật → action.

## Plan file thực tế

Claude Code dùng `TodoWrite` để track plan trong session:
```json
[
  {"id": "1", "content": "đọc spec", "status": "completed"},
  {"id": "2", "content": "viết handler", "status": "in_progress"},
  {"id": "3", "content": "viết test", "status": "pending"}
]
```

Cursor + ChatGPT thường để LLM tự generate plan markdown rồi check off.

## Anti-patterns

- Plan quá chi tiết → realityđổi → plan vô dụng
- Không cập nhật plan khi gặp lỗi → agent đi sai hướng
- Plan = output cuối → quên execute
