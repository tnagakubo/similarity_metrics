---
paths:
  - "projects/**/PROTOCOL_*.md"
  - "projects/**/SIMULATION_FINDINGS*.md"
  - "projects/**/CLAIMS.md"
  - "projects/**/DECISIONS.md"
  - "projects/**/results/**"
  - "projects/**/LITERATURE_SEARCH_LOG.md"
---

# Protocol / results / registry rules（研究記録ファイルを触るときだけ読み込まれる）

Source of truth: `RESEARCH_FRAMEWORK.md` §6（Scientific integrity principles）、`templates/protocol_template.md`、`templates/claims_template.md`。

## Protocol（`PROTOCOL_*.md`）
- 結果を見る前に書き、commit する（hash を冒頭に）。§0 honesty clause は省略不可（「なし」でも書く）
- ADEMP の 5 節が揃っていない protocol は protocol ではない。性能指標には Monte Carlo SE の式と $n_{\mathrm{sim}}$ の根拠
- §2 licenses / does not license を先に固定。§9 逸脱は append-only、削除しない
- θ を特定する効果追跡 sim は設計しない（`memory/project_no_effect_tracking_sim.md`）

## Results（`results/**`）
- 論文に使う CSV は single writer（1 スクリプトが書く）。手で編集しない
- 性能指標の CSV は estimate と MCSE の列を持つ。proportion か percent か列名で分かるように
- 出力の隣に `sessionInfo` または `renv.lock`、`*_PROVENANCE.md`（`templates/provenance_template.md`）
- 旧 run は削除せず「canonical でない」と provenance に書く。`NUMBERS_LEDGER.csv` は append、verifier ≠ producer

## Claims（`CLAIMS.md`）
- 1 行 1 主張。Evidence はディスク上のパス（file:line / Prop. / CSV 列）。動詞は許容表のとおり
- narrowed / retracted は log に旧文言と理由。原稿側は C1 cascade（grep 残存 0）

## Decisions（`DECISIONS.md`）
- append-only、`D-YYYYMMDD-n`。Reasons に「なぜ他を捨てたか」。覆すときは新 entry + 旧 entry を superseded
- Tak の指示は verbatim で引く
