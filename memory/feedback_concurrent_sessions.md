---
name: feedback_concurrent_sessions
description: Tak runs several Claude sessions (foreground + @bg jobs + cloud) on the SAME working tree at once; a background job must detect the others, split scope by path, never commit, and insert SUITS.md scenes atomically
metadata:
  type: feedback
---

Observed 2026-10-12 00:06: while a bg job surveyed the environment, another session (`claude-science-gap-analysis`) was applying the referee decisions to `paper/per_em_W1_wiley.tex`, CLAIMS, DECISIONS, registry — mtimes a few minutes old, none of it in the session-start `git status`.

**Why:** two writers on one working tree silently overwrite each other (read-modify-write of SUITS.md, numbers_macros.tex) and a `git commit` from either side sweeps in the other's half-finished work. The `@bg` convention ([[feedback_bg_convention]], [[feedback_bg_scope]]) assumes bg jobs are *independent*; independence has to be made, not assumed.

**How to apply:**
1. At start of a bg job: `ListAgents` + `ls -la --time-style=full-iso` on the files you intend to touch. Anything modified in the last ~30 min and not by you = another session owns it.
2. Message that session (SendMessage) with an explicit path split: "I own scripts/, .claude/, .github/, templates/, docs; you own projects/{p}/". Honour the reply (it may have touched environment files already — check before overwriting).
3. Never `git commit` / `git push` from a bg job while a peer is live on the same tree; leave commit to Tak or the foreground session and say so in the report.
4. SUITS.md: re-read immediately before inserting the scene at TOP; one atomic write; peer told to do the same.
5. Record the split and the peer's name in the SUITS scene so the next session knows who did what.
