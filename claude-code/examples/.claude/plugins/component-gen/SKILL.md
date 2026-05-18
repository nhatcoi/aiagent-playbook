---
name: component-gen
description: Generates a typed React component with Tailwind styles and Storybook story. Triggers on "generate component X", "create React component for X".
---

# Component Gen Plugin

Generates a typed, accessible React component following the project's design system.

## Input

User provides: **component name** + **variant** (server | client) + **description**

## Output Files Generated

```
packages/ui/src/components/<ComponentName>/
├── index.tsx           # component
├── <ComponentName>.stories.tsx   # Storybook story
└── <ComponentName>.test.tsx      # Vitest + Testing Library
```

## Template

### Component (client variant)
```tsx
'use client';

interface <ComponentName>Props {
  // define props
  className?: string;
}

export function <ComponentName>({ className }: <ComponentName>Props) {
  return (
    <div className={cn('', className)}>
      {/* content */}
    </div>
  );
}
```

### Story
```tsx
import type { Meta, StoryObj } from '@storybook/react';
import { <ComponentName> } from '.';

const meta: Meta<typeof <ComponentName>> = {
  component: <ComponentName>,
  tags: ['autodocs'],
};
export default meta;

export const Default: StoryObj<typeof <ComponentName>> = {};
```

## Rules

- Use `cn()` from `packages/ui/src/lib/utils` for class merging
- Server components: no `'use client'`, no hooks
- Client components: add `'use client'` as first line
- Export named (not default) for tree-shaking
- 🚫 No inline `style` props — Tailwind only
