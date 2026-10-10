---
name: feedback-personality-check
description: /rule ではルール確認だけでなく、各メンバーが signature quote と personality axis を一行ずつ口に出して voice をリセットする（Tak 2026-04-25）
metadata:
  type: feedback
---
**Source**: `.claude/skills/rule/SKILL.md`「Why personality reaffirm」。

- ルールだけ確認しても character voice は薄れる。signature と axis（Harvey: Strategic / Decisive …）を口に出すことで dialogue の voice をリセットする
- 発動条件: 長いセッション、混乱時、新セッション開始、SUITS 更新の遅れ、voice drift（Harvey/Mike 偏重、Louis/Jessica 不在、ラストネーム呼び）
- `scripts/lint_suits.py` の speakers 行（silent メンバーの表示）を drift の検知に使う
