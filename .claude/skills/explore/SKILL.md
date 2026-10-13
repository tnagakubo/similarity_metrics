---
description: Exploratory sandbox — scaffold a labelled side study (question, minimal simulation, real-data illustration, Quarto report) that can never leak into the manuscript without passing through /protocol
model: opus
argument-hint: "<slug> <one-line question>"
---

# Research Lab: Explore（探索的 side study の sandbox — RESEARCH_FRAMEWORK S20）

Claude Science は referee のついでに Neyman smooth test の 2 標本版を一本作った（simulation + GUSTO 例示 + Quarto）。研究環境は「問いが立ったら 1 時間で手を動かせる場所」を持つべきだが、その結果が protocol なしに原稿へ流れ込んではいけない。この skill は両方を満たす: scaffold は速く、出口は `/protocol` だけ。
Arguments: $ARGUMENTS（`<slug>` と問い）。Output: `projects/{project}/exploratory/{slug}/`

## Execution
1. **Harvey**: 問いを 1 文に固める（「何が分かれば何を変えるか」）。`IDEAS_BACKLOG.md` に無ければ Donna が `/idea` で登録
2. **Donna**: scaffold を作る
   ```
   projects/{p}/exploratory/{slug}/
   ├── README.md        # EXPLORATORY banner、問い、date、owner、「protocol に昇格する条件」、「原稿に引用しない」
   ├── R/{slug}.R       # seed 宣言、相対パス、sessionInfo を results/ に保存（r-code.md の規則はここでも適用）
   ├── results/         # CSV + sessionInfo.txt
   ├── figures/
   └── report.qmd       # templates/paper_template.qmd の型、数値は num() で CSV から
   ```
   README の 1 行目は `> **EXPLORATORY — not pre-registered, not citable from the manuscript.** Promote via /protocol.`
3. **Mike**: 最小の simulation（1 DGM × 1 推定量 × 小 n_sim）と、可能なら real-data の 1 例示。MCSE を付ける。結論は「次に何を protocol に書くか」で終える
4. **Louis**: 1 件以上の攻撃 — 循環（KR 双対で W₁ が定義上最適、θ の特定で一般性を失う — `memory/project_no_effect_tracking_sim.md`）、事後選択、「本論文の scope（Q_metric）の外」
5. **Jessica**: 昇格の Go / No-Go。Go なら `/protocol {slug}`（ADEMP・MCSE・licenses を書いてから本番）。No-Go なら README に理由、`/idea` で `IDEAS_BACKLOG.md` に戻す（status 💡 に、理由を note）
6. **Donna**: SUITS.md に scene（TOP）。`evidence_coverage.py` が原稿・supplement・registry・ledger から `exploratory/` への参照を検出したら Donna が差し戻す（CI の coverage step は advisory — unbilled 件数は ratchet で止まるが、leak を CI で止めるには `--strict` を step に足す。それまでは hook と `/handoff` の目で見る）

## Rules
- `exploratory/` の数値・図を原稿に書かない。registry の `source_file` にも使わない（`evidence_coverage.py` の leak 検出は原稿・supplement・`numbers_registry.csv`・`NUMBERS_LEDGER.csv` を見る）
- 昇格は `/protocol` 経由のみ。protocol §0 に「exploratory で結果を一度見た」を prior-look として開示する（S8）
- sandbox でも seed・相対パス・sessionInfo は必須（`check_r_reproducibility.sh` の既定範囲は `projects/*/R/*.R` と `projects/*/exploratory/*/R/*.R` — hook・ratchet・CI の全部で見る）
- 一本の問いにつき一つの slug。問いが変わったら新しい slug

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Explore — {slug}

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Mike のモニタに新しいフォルダ。README の先頭に赤い一行。*

**Harvey**: 「問いは一つ — {question}。分かったら {何を変えるか}。分からなければ捨てる。」

**Mike**: 「{最小設計}。n_sim {n}、MCSE {se}。I got it!」

**Louis**: 「{攻撃}」

**Jessica**: 「Let me be clear. {Go / No-Go}。{理由}」

---
```
