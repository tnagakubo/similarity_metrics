# CLAIMS — similarity-metric 主張↔証拠台帳

**Owner**: Harvey（主張の文言）/ Mike（証拠の所在と検証）/ Louis（攻撃）/ Donna（原稿との整合）
**Rule**: 原稿のあらゆる主張（abstract を含む）はこの台帳の 1 行に対応する。台帳に無い主張は書かない。証拠を削ったら主張を narrow し、C1 cascade（`templates/review_checklist.md`）で原稿の全出現箇所を直す。
**状態（2026-10-10）**: 雛形。`/claims init` で `paper/per_em_W1_wiley.tex`（v6 後、20 pp）の abstract → Discussion ¶1 → 各節 topic sentence から起票する。下の 3 行は `PAPER_LOGIC.md`（09-06、v6 前）の台帳からの **候補**であり、文言は原稿から取り直すまで `pending`。

## 動詞の許容（P5: 主張と証拠の比例）

| 証拠の型 | 許される動詞 | 禁止 |
|---|---|---|
| theory（命題・証明） | shows, establishes, implies | — |
| simulation | demonstrates, illustrates, indicates（設計した範囲内で） | proves, guarantees |
| application（実データ、ground truth なし） | illustrates, is consistent with | shows that W₁ is correct, outperforms |
| literature / guideline | describes, notes, permits（E17） | recommends, requires, mandates |

## 台帳

| ID | Claim（原稿の文言、1 文） | Type | Evidence（file:line / Prop. / CSV 列 / protocol） | Verb used | Carried by（§/¶; abstract に載るか） | Status | Last verified（who, date） |
|---|---|---|---|---|---|---|---|
| C-01 | （候補・v6 前の文言）要約量ベースの競合指標は少なくとも 1 つの臨床的に妥当な世界で構造的に盲目（任意の n）であり、W₁ は盲目でない | simulation | §3 Study 1（identification）、gate `R/verify_study2_figures.R`、`results/selection_sim_summary*.csv` / `clustering_sim_summary*.csv` | demonstrates? | §3.1、Discussion ¶1 (i)、abstract | pending | — |
| C-02 | （候補）Δ_max = L_clinical · W₁ が分布距離を臨床スケールへ翻訳する（KR 双対性、n 非依存） | theory | §2.4 Prop. 1（`eq:heterogeneity_bound`） | shows | §2.4、Discussion ¶1 (ii)、abstract | pending | — |
| C-03 | （候補）percentile bootstrap は n ≥ 100 で良好な coverage を持ち、null 近傍では正の bias と null floor がある | simulation | §3.2 Study 2（estimation）、`results/w1_raw_summary.csv`（`results/STUDY1_PROVENANCE.md`）、§2.3 | demonstrates? | §3.2、§2.3、Discussion ¶1 (iii)、abstract | pending | — |

**Status の意味**: pending = 証拠未確認 / supported = 証拠がディスク上にあり verifier が確認 / narrowed = 証拠に合わせて文言を狭めた（旧文言を下に記録）/ retracted = 原稿から削除（残存 0 を grep で確認）

## Narrowed / retracted log（append-only）

| date | ID | 旧文言 | 新文言 or 削除 | 理由 | cascade 確認（grep 結果） |
|---|---|---|---|---|---|
| 2026-09-26 | （v6 以前、ID 未付与） | τ_clin による screening rule、§2.5 operability、AND 規則・6 eligible partners、anchor vs clustering、L_UB 感度分析 | 削除（v6） | Tak 09-25「判定方法は規定できない」→ `memory/feedback_quantify_not_decide.md`、`DECISIONS.md` D-20260925-1 | `RESTRUCTURE_v6_no_decision.md` §7（53 箇所、compile error 0） |
| 2026-09-26 | （同上） | harm 2.14×（KS の高コスト誤り） | 削除 | KR 双対の循環（`DECISIONS.md` D-20260926-3） | — |

## 使い方

- `/claims init` で原稿から主張を抽出して起票、`/claims check` で各行の Evidence がディスクに在るか・動詞が許容表に収まるかを検証
- `/protocol` の §2（licenses / does not license）は、この台帳の候補行
- `/pre-review` `/review` `/submission-check` は台帳の Status が全行 supported であることを要求する（abstract の主張は特に）
