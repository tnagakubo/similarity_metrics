---
description: Stock a paper idea — Donna registers a research question that surfaced in discussion into the cross-project IDEAS_BACKLOG.md (I-YYYYMMDD-n: source, one line, why it is outside the current paper's Aims, evidence it would need); no evaluation on the spot, no scope creep into the manuscript
model: haiku
argument-hint: "<one-line idea> [--from <scene / D-id / review #>]"
---

# Research Lab: Idea（ネタをストックする — RESEARCH_FRAMEWORK S23）

Tak（2026-10-12）: 「議論の展開で、新たな論文のネタとなりそうなものが出てきた場合、そのネタをストックしておく。」
研究は発散してよい。論文は絞る（`memory/feedback_diverge_converge.md`）。絞るときに外した論点を捨てないための出口がこの skill。登録先は root の `IDEAS_BACKLOG.md`（cross-project）。
Idea: $ARGUMENTS

## Execution
1. **発言者**: ネタを 1 行で。どの議論から出たか（SUITS scene の時刻 / `D-…` / review の #）
2. **Harvey**（1 文）: 現論文の Aim（`projects/{project}/LAB_STATUS.md` の **Question / Aims** 行）のどれにも答えないことを確認。答えるなら「ネタ」でなく「主張」→ `/claims add` へ
3. **Donna**: `IDEAS_BACKLOG.md` の表に 1 行追記 — `I-YYYYMMDD-n`（同日は n を増やす）| date | source | 一行 | 現論文の scope 外である理由 | 必要な根拠・データ（根拠が無ければ `[推測]` と書く）| status `💡 Incubating` | by
4. **Donna**: SUITS.md に短い scene（TOP）。本題に戻る

## Rules
- **判定しない**。ネタの良し悪しをその場で議論すると本題が止まる。登録して戻る
- 登録が義務になる場面: `/meeting` Phase 4 の発散論点、`/decide` で却下した option が別論文になるとき、`/explore` の No-Go、`/review` `/referee` の「scope 外」指摘、`/victory` Phase 9
- status の lifecycle: `💡 Incubating` → `🔬 Exploring`（`/explore <slug>`、slug を source 列に）→ `📄 Promoted`（`/start` で新 project）/ `🗑 Dropped`（理由を書く）。Harvey が Phase 9（`/victory`）で見直す
- ストックは推測を含んでよい（`[推測]` 付き）。原稿は不可（`/ground`）
- 原稿・supplement・Discussion に「将来の課題」として押し込まない。ネタの置き場は backlog だけ

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Idea I-{id} — {一行}

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

**{Member}**: 「{ネタ}。この論文の Aim の外だが、捨てたくない。」

**Harvey**: 「Aim にも R1–R{k} にも答えない。ネタだ。登録して戻れ。」

**Donna**: 「I-{id} で入れたわ。{観察 — どの議論から出たか、何があれば動くか}」

---
```
