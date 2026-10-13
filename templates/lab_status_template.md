# LAB_STATUS — {project}

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理、`scripts/check_consistency.sh` が照合）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: {title}
**Target**: {journal}
**Manuscript**: `paper/{file}.tex`
**Question / Aims**: A1 {この論文が**提示する**もの — 目的。「〜を示す」「〜を評価する」(方法) ではなく「〜を提示する」}（1–2 文 — RESEARCH_FRAMEWORK S22。Tak 2026-10-12: Aim は目的であって方法ではない。Study 名・推定量・データ名が Aim に出てきたらそれは Result）
**Results that answer A1**: R1 {…}; R2 {…}（Aim を支える結果。Results の小節と CLAIMS の行はこの番号を持つ。どれにも答えないものは `IDEAS_BACKLOG.md` か `exploratory/`）
**Phase**: 0 — Question
**Phase entered**: YYYY-MM-DD
**Updated**: YYYY-MM-DD

## Lifecycle artifacts

| artifact | path | status |
|---|---|---|
| Question / novelty | `EXISTING_METHODS_AND_NOVELTY.md` | — |
| Ideas backlog（cross-project） | `../../IDEAS_BACKLOG.md` | — |
| Claims registry | `CLAIMS.md` | — |
| Decision log | `DECISIONS.md` | — |
| Literature search log | `LITERATURE_SEARCH_LOG.md` | — |
| Protocols | `PROTOCOL_*.md` | — |
| Findings | `SIMULATION_FINDINGS_*.md` | — |
| Numbers ledger | `results/NUMBERS_LEDGER.csv` | — |
| Citation audit | `review_response/CITATION_AUDIT_*.md` | — |
| Reproduction report | `results/REPRODUCTION_*.md` | — |

## Phase history

| Phase | Name | Entered | Gate evidence（on disk） |
|---|---|---|---|
| 0 | Question | YYYY-MM-DD | |

## Open gates（現 Phase を抜ける条件 — `RESEARCH_FRAMEWORK.md` §1 から転記）

- [ ] …

## Next

- …
