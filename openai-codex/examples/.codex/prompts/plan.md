# /plan — Tạo implementation plan

Đọc spec / task user mô tả → tạo plan trước khi code.

## Quy trình
1. Search codebase tìm pattern tương tự (`grep`, `find`)
2. Đọc file liên quan đầy đủ
3. List unknown — chỗ nào cần hỏi user
4. Output plan theo format dưới
5. **DỪNG** — đợi user OK trước khi code

## Output
```
## Plan: <task name>

### Files sẽ chạm
- path/to/a.go — thêm function X
- path/to/b.go — refactor Y

### Files mới
- path/to/c.go — Z handler

### Steps
1. [ ] thêm migration tables
2. [ ] thêm repository
3. [ ] thêm service
4. [ ] thêm handler
5. [ ] viết test
6. [ ] update docs

### Unknown / cần user xác nhận
- [ ] auth bằng JWT hay session?
- [ ] cache TTL bao lâu?

### Risk
- migration lock bảng X (hiện 50M rows) — đề xuất CONCURRENTLY
```

## Rules
- Không code khi chưa có "OK go"
- Plan đủ chi tiết để dev khác đọc làm được
- Liệt kê risk thẳng, không che giấu
