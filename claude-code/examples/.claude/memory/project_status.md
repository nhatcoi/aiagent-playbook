---
name: project-status
description: Current sprint goals, active work, and merge freeze date
metadata:
  type: project
---

Sprint goal: ship user onboarding flow (email verification + profile setup) by 2026-05-30.

Active branches:
- `feat/email-verification` — in review
- `feat/profile-setup` — in progress

**Merge freeze:** 2026-05-28 — mobile team cuts release branch.
**Why:** Any non-critical merge after that date risks destabilizing the mobile release.
**How to apply:** Flag PRs that are not part of onboarding flow as "post-freeze" and do not push to merge them before 2026-05-28.
