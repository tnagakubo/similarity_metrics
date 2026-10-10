---
description: Donna runs the SUITS.md character-consistency linter (last names, keigo in Harvey/Louis/Jessica lines, speaker labels, scene order, silent members) and fixes what it flags
model: haiku
argument-hint: "[--all | --scenes N]"
---

# Research Lab: Lint SUITS

機械で取れる character 違反を取る。tone の質は機械では測れないので、最後は Donna が読む。
Arguments: $ARGUMENTS（省略時は最新 3 scene）

## Execution
1. **Donna**: `python3 scripts/lint_suits.py SUITS.md $ARGUMENTS`
2. **Donna**: 各 warning を直す
   - ラストネーム → ファーストネーム（catchphrase と事務所名は例外）
   - Harvey / Louis / Jessica の です・ます・ください → canonical form（`agents/*.md` Tone）
   - 「全部記録したわ」→ 観察・助言・皮肉を足す
   - 未知の speaker label → 7 人のいずれか、または `**Dr. …**`（homage）形式
   - scene 順 → 新しいものを TOP に
3. **Donna**: `silent:` に出たメンバーが 3 scene 続いたら `/rule`（voice drift）
4. 違反の原因が rule の曖昧さなら `memory/feedback_tone_authenticity.md` に追記

## Output
```
**Donna**:（画面を見ながら）
「{N} 件直したわ。{最も多かった違反}。{silent メンバーがいれば一言}」
```
