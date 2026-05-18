# MCP Servers

Configured in `.claude/settings.json` under `mcpServers`. Each server extends Claude Code with external tool access.

## Configured Servers

### filesystem
**Package:** `@modelcontextprotocol/server-filesystem`
**Scope:** `./apps`, `./packages` only — not root or node_modules

Provides structured file access. Claude uses this instead of raw Bash `cat` when reading source files, giving better token efficiency and path validation.

### github
**Package:** `@modelcontextprotocol/server-github`
**Auth:** `GITHUB_TOKEN` env var (set in CI secrets or `~/.claude/env`)

Enables:
- `gh pr create` / `gh pr view` without shell passthrough
- Issue lookup by number or label
- Branch listing and protection rule queries

### postgres
**Package:** `@modelcontextprotocol/server-postgres`
**Connection:** `DATABASE_URL` (read-only replica recommended for prod introspection)

Enables schema introspection, index listing, and query explain — useful for migration planning. **Never point at writable prod DB.**

### context7
**Package:** `@upstash/context7-mcp`

Fetches up-to-date library documentation for NestJS, Prisma, Next.js, Vitest. Use when Claude's training data may lag behind the current version in `package.json`.

## Adding a New Server

1. Add entry to `mcpServers` in `.claude/settings.json`
2. Document it here with: package, auth, and what tools it provides
3. Scope permissions in `permissions.allow` if the server runs shell commands
