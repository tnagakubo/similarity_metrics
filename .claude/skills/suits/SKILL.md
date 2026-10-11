---
description: Display current SUITS.md script status
model: haiku
---

# Research Lab: SUITS Status

Display current drama script and status.

## Execution

1. **Donna**: Read SUITS.md
2. Show latest scene and current tasks
3. **Donna**: `bash scripts/check_consistency.sh --quiet` の findings があれば一緒に示す（Phase 不一致・stale な LAB_STATUS・欠けた artifacts）
4. Add brief status comment in character

## Output Format

```
**Donna**: （画面を確認しながら）
「現在の状況よ」

[Latest scene from SUITS.md]

「Active Tasks:
- Harvey: {task}
- Mike: {task}
...」
```
