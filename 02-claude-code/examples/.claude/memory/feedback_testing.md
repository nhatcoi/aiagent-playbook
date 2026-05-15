---
name: feedback-testing
description: Integration test phải hit DB thật, không mock
metadata:
  type: feedback
---

Integration test phải hit Postgres thật (testcontainers), không mock.

**Why:** Q3/2025 incident — mock test pass nhưng migration prod fail vì mock không phản ánh constraint thật.

**How to apply:** Khi viết hoặc review test trong `*.integration.test.ts`, từ chối mọi PR mock DB client. Unit test thì OK mock.
