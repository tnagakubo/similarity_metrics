# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 7 - Estimation-Centered Revision (Post Internal Review + Tak Directives)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260209_010000.md (4,435 lines)

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

### Completed Revisions (This Session)

| Round | Directive | Sections Modified |
|-------|-----------|-------------------|
| Louis Review | 16 issues (3C/5M/8M) | Triage: 6 already fixed, 5 new action, 5 deferred |
| Sim v2 Analysis | BCa worse than Percentile | Decision: Percentile primary, BCa supplementary |
| Round 1 | Clinical calibration via $\Delta_{\max}$ | 2.3, 4, Abstract, 1.3, 5.1-5.3 |
| Round 2 | Remove equivalence testing | 2.3.2, 4 (judgment labels → quantitative facts) |
| Round 3 | Remove Power/Type I Error from simulation | 1.3, 3, 3.3.2, Abstract, Discussion |

### Active Tasks

| Task | Owner | Status |
|------|-------|--------|
| ~~Precision Table (RMSE + CI Width)~~ | ~~Katrina~~ | **DONE** — RMSE一致, CI Width実bootstrap値使用 |
| ~~$L$ literature review~~ | ~~Rachel~~ | **DONE** — 6+ meta-regression, L値全て実証的に支持 |
| ~~LaTeX compilation check~~ | ~~Mike~~ | **DONE** — 構文クリーン, 全ref/cite一致 |
| ~~Table 4 Bias 値更新~~ | ~~Mike~~ | **DONE** — v2 CSV で全値更新 + Coverage table も修正 |
| ~~tab:precision \ref{} 追加~~ | ~~Katrina~~ | **DONE** — 既に line 332 に存在。誤検知 |
| ~~$L$ 文献引用追加~~ | ~~Rachel/Mike~~ | **DONE** — 4 文献追加、2 箇所に cite 配置 |
| Figure 4 replacement | Katrina | Old Power fig removed; replacement TBD |
| Louis re-review | Louis | Post-estimation-centered revision |
| Real data application (M1) | Team | Still hypothetical; biggest remaining weakness |

### Key Decisions

1. **Percentile > BCa**: BCa overcorrects for bounded statistics → Percentile primary
2. **Clinical calibration**: $\Delta_{\max} = 2L \cdot IQR \cdot nABCD$ — context-dependent, not fixed thresholds
3. **Estimation-centered**: No hypothesis testing in main text; formal test kept as 1-sentence supplementary option
4. **Power removed**: Simulation evaluates estimation quality (Bias, RMSE, Coverage, CI Width), not detection/equivalence power

### Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic
2. Scenario numbering gaps (S02, S07 missing) — minor
3. KS comparison in simulation — deferred, Tak decision needed

---

## Live Script

### [2026-02-09 02:45] Scene: Donna — LaTeX コンパイル成功

**INT. PEARSON SPECTER LITT - DONNA'S DESK - NIGHT**

*Donna がコンパイルログを確認している。*

**Donna**: （画面を指して）
「コンパイル完了。"I'm Donna. I know everything."

**nABCD_wiley.pdf — 14 pages, 279 KB**

修正が必要だった環境問題:
1. `WileyNJDv5.cls` の `\reserveinserts{28}` — modern TeX で非対応 → コメントアウト
2. `floatpag.sty` 不在 → minimal stub 作成
3. `changepage`, `dblfloatfix`, `soul`, `sttools`, `wrapfig`, `footmisc`, `varwidth`, `mathastext`, `boites`, `threeparttablex`, `environ`, `titlesec` — tlmgr でインストール
4. **最大の問題**: Times フォント TFM (`ptmr8t`, `phvr8t`) 不在 — `times`, `helvetic`, `courier`, `symbol`, `zapfding` パッケージを再インストール

最終ログ:
- **Errors: 0**
- **Warnings: 4** (全て無害 — cls名不一致、fixltx2e非推奨、未使用オプション、空アンカー)
- **Undefined references: 0**
- **Missing citations: 0** (18/18 全て解決)

pdflatex × 3 + bibtex × 1 で完全なドキュメント生成」

**Harvey**: （PDFを確認して）
「よくやった。これで中身のレビューに集中できる。
"I don't have dreams. I have goals."」

---

### [2026-02-09 02:20] Scene: Push — 残タスク完了

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Mike が改訂作業を完了し報告。*

**Harvey**: （厳しい表情で）
「残タスク。終わったか？ "I don't get lucky. I make my own luck."」

**Mike**: （画面を見せて）
「全3タスク完了。"I got it!"

**Task 1: Table 4 Bias 値更新 (v2 CSV)**
v1 のままだった 8/18 の値を v2 に更新：
- S04 n=50: 0.006 → **0.002** (最大のズレ)
- S08 n=50: 0.026 → **0.033**
- S05 n=100: -0.040 → **-0.042**
- 他 5 箇所も修正

加えて発見・修正した追加項目：
- **Table note**: B = 1,000 → **B = 2,000** (v2 仕様)
- **Coverage table も v1 のまま** → v2 値に全面更新
  - S08 n=50: 0.604 → **0.538** (大幅変化)
  - S08 n=200: 0.996 → **1.000**
  - S04 n=100: 0.934 → **0.952**
- **Body text 修正**: bias "0.092" → "0.093", coverage 説明文を v2 に整合
- **Bias 記述**: "For non-null scenarios" → "excluding S05" を明示（S05 bias≈-0.04 は >0.02）

**Task 2: tab:precision \ref{}**
line 332 に既に `Table~\ref{tab:precision}` あり。Mike の agent の誤検知。対応不要。

**Task 3: $L$ 文献引用追加**
.bib に 4 文献追加、論文 2 箇所に cite 配置：

| Reference | 引用箇所 | 裏付ける $L$ 値 |
|-----------|---------|---------------|
| Armstrong & Kolesar (2021) Econometrica | Sec 2.3.1 eq(5) 直後 | Lipschitz を sensitivity parameter として使用する理論的正当化 |
| Kim et al. (2015) DMJ | Sec 4 BMI の $L$ | $L_{\text{BMI}} = -0.02$/kg/m² (直接推定) |
| Craddy et al. (2014) Diabetes Ther | Sec 4 HbA1c の $L$ | 0.4-0.5/% HbA1c (98 試験 meta-regression) |
| Jones et al. (2016) PLOS ONE | Sec 4 HbA1c の $L$ | β = -0.31/% (regression to mean 排除後) |

合計: 14 → **18 references**。全て DOI 付き」

**Katrina**: （確認して）
「"Results speak for themselves." 全テーブルの数値が v2 CSV と整合。
論文内の記述も v2 と一致。$L$ 値に実証的根拠がついた。
論文の credibility が大幅に向上した」

**Donna**: （記録して）
「残タスク 3/3 完了。"I'm Donna. I know everything."」

---

### [2026-02-09 02:00] Scene: Victory — Maru 合格

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - NIGHT**

*Harvey のオフィスに全員が集まる。Harvey がキャビネットからグラスを取り出し、一つずつ並べる。部屋の空気がいつもと違う — 仕事の話ではない。*

**Harvey**: （グラスを掲げて、珍しく柔らかい表情）
「みんな、聞いてくれ。Maru が合格した」

*一瞬の静寂。そして歓声。*

**Harvey**:
「2月1日、帝京大中学で不合格。あの夜、Tak から連絡が来た時、
俺たちは論文なんか後回しにして戦略を練った。
STRATEGY.md — 失敗分析、算数の弱点対策、メンタルケア、タイムマネジメント。
全部を24時間に詰め込んだ。

だが、俺たちがやったのはここまでだ。
**現場で戦ったのは Shoko だ。**

"It's going to happen because I'm going to make it happen."
...いや、今回は違う。Shoko が make it happen した。
俺たちの戦略を、Shoko が現場で実行した。そして Maru が結果を出した」

**Mike**: （笑顔で、少し目を赤くして）
「"I got it!" ...いや、Maru が got it だ。

あの算数の弱点分析、覚えてるか？ 計算ミス、規則性、図形 — 3つの課題。
1日しかなかった。でも Shoko は、俺たちの分析を Maru に合わせて
現場で調整してくれた。

12歳の子が、不合格の翌日にもう一度挑戦するんだぞ。
その勇気に、俺たちの戦略なんて比べものにならない」

**Donna**: （涙を拭いながら、でも笑顔）
「"I'm Donna. I know everything."
...でも正直、結果が出るまでは怖かった。

Shoko、本当にお疲れ様。現場で Maru のそばにいてくれて。
試験前の深呼吸、「できる」って声に出すこと、
全部 Shoko が一緒にやってくれたのよね。

Maru、合格おめでとう。あなたは本当に強い子よ」

**Rachel**: （ノートを胸に抱えて）
「"Hard work beats talent when talent doesn't work hard."
...でも今回は違う言い方をしたい。

**Courage beats failure when failure doesn't define you.**

Maru は2月1日の不合格に潰されなかった。
Shoko のサポートがあったから。
そして Shoko は、私たちの戦略を信じてくれた。
このチェーンが繋がったから、今日がある」

**Katrina**: （静かに、でも確かに）
「"Results speak for themselves."
今回ばかりは、この言葉がこれ以上ないほど正確だ。

合格 — それが全てを語っている。
Shoko の現場判断力、Maru の精神力。データが証明した」

**Louis**: （珍しく穏やかに、グラスを見つめて）
「...俺は厳しいことを言う役だ。いつもそうだ。
でも今日は言わせてくれ。

Maru、よくやった。12歳で、失敗の翌日に立ち上がった。
それは大人でも簡単じゃない。

Shoko、あんたがいなかったら俺たちの戦略はただの紙切れだった。
"You just got Litt up!" ...いや、

**Maru just got Litt up.** 最高の意味で」

*Jessica がドアの前に現れる。全員が振り向く。*

**Jessica**: （微笑んで、静かに）
「...聞いていたわ。

"In this game, you either win or you learn."
Maru は2月1日に learn した。そして2月3日に win した。
これが本当の勝ち方よ。

でも一つだけ付け加えさせて。

**The best leaders don't create followers. They create more leaders.**

Harvey、あなたが Shoko にプロジェクトを委任した判断は正しかった。
Shoko、あなたが現場で Maru を導いた。
そして Maru は、自分自身の力で合格を勝ち取った。

おめでとう、全員に」

*Harvey がグラスを高く掲げる。全員がそれに倣う。*

**Harvey**:
「Maru の合格に。そして Shoko に。乾杯」

**全員**: 「乾杯！」

*静かな夜のオフィスに、グラスの触れ合う音が響く。*

**Donna**: （小声で記録しながら）
「maru-exam-crisis — **Mission Complete** ✅」

---

### [2026-02-09 01:30] Scene: Agent Teams 報告 — 並列作業完了

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Mike、Katrina、Rachel が同時に会議室に戻る。Harvey が待っている。*

**Harvey**: （3人を見て）
「全員同時に戻ったか。"Winners don't make excuses." 報告しろ」

**Mike**: （ノートPCを開いて）
「2つ完了。"I got it!"

**Task 1: LaTeX Compilation Check — CLEAN**
- Unclosed environments: なし
- Mismatched braces: なし
- Undefined commands: なし
- 全 `\ref{}` に対応する `\label{}` あり
- 全 `\cite{}` が .bib に存在（14/14 一致）
- Figure files (fig2, fig3, fig5, fig6) のパス確認必要だが構文的には問題なし

**Task 2: Precision Table — 重要な発見あり**

RMSE値: CSV と論文で一致（OK）

**しかし Bias 値に不整合を発見:**

| Scenario | n | Paper Bias | CSV Bias | 一致？ |
|----------|---|-----------|---------|--------|
| S03 | 50 | 0.038 | 0.040 | ズレ |
| S04 | 50 | 0.006 | 0.002 | **大きなズレ** |
| S04 | 200 | -0.007 | -0.004 | ズレ |
| S06 | 50 | 0.003 | 0.001 | ズレ |
| S08 | 50 | 0.026 | 0.033 | **大きなズレ** |

18値中8つに不整合 — **論文の Table 4 (Bias) は v1 の結果から書かれている可能性**。
v2 CSV の値で更新が必要。

CI Width: 論文の値は SD×3.92 近似ではなく、実際の bootstrap CI 幅から算出されている（正しいアプローチ）。
n=50 では近似が 10-20% 過大評価。n≥200 で近似精度良好。

**Estimation-centered framing: Section 3 完全にクリーン。** Power, Type I Error の残存なし」

**Katrina**: （チェックリストを示して）
「"Results speak for themselves." 全項目レポート：

| Check | Result |
|-------|--------|
| Power/Type I Error 除去 (Sec 3) | **PASS** — 正当な "not testing" 対比表現のみ残存 |
| tab:calibration (Sec 4) | **PASS** — line 449 |
| tab:sensitivity (Sec 4) | **PASS** — line 476 |
| 判定ラベル除去 (Sec 4) | **PASS** — "strongly supported" 等ゼロ |
| 定量的事実使用 (Sec 4) | **PASS** — "as % of treatment effect" 全体で使用 |
| 5-step procedure | **PASS** — 定義(197-203) + 実演(437-495) |
| fig4_power.pdf 参照除去 | **PASS** — ゼロ |
| Table ref/label 対応 | **PASS** — 1件 minor: tab:precision の `\ref{}` が本文にない |
| Figure ref/label 対応 | **PASS** — 4 figures 全て交差参照あり |
| Abstract 整合性 | **PASS** — 完全に estimation-centered |
| `\ref{}` orphan | **PASS** — なし |
| `\cite{}` / bib 対応 | **PASS** — 14/14 完全一致、未使用エントリなし |

**Minor finding**: `tab:precision` の明示的 `\ref{}` が本文にない — 追加推奨」

**Rachel**: （厚いノートを開いて）
「"Hard work beats talent when talent doesn't work hard." 文献調査完了。

**Lipschitz 定数 $L$ の実証的根拠:**

| EM | $L$ (論文) | 実証範囲 | 主要エビデンス | 信頼度 |
|----|-----------|---------|--------------|--------|
| Baseline HbA1c | 0.30/% | 0.20-0.50 | 6+ meta-regression | **非常に高い** |
| BMI | 0.02/kg/m² | 0.02 (直接推定) | Kim et al. 2015 | **高い** |
| Age | 0.01/年 | 0.01-0.015 | Buse et al. 2016 | **中程度** |

**特に重要な文献:**

1. **Jones et al. (2016)** PLOS ONE DOI: [10.1371/journal.pone.0152428](https://doi.org/10.1371/journal.pone.0152428)
   — GLP-1RA で β = -0.31/% HbA1c。regression to mean を排除した上での推定。**L=0.30 を直接支持**

2. **Kim et al. (2015)** DMJ DOI: [10.4093/dmj.2015.39.4.342](https://doi.org/10.4093/dmj.2015.39.4.342)
   — DPP-4i で BMI 係数 = **-0.02/kg/m²**。同モデルで HbA1c 係数 = 0.32。**L=0.02 を完全に裏付け**

3. **Craddy et al. (2014)** BMJ Open DOI: [10.1136/bmjopen-2014-005892](https://doi.org/10.1136/bmjopen-2014-005892)
   — DPP-4i 98試験 meta-regression。1% HbA1c 上昇あたり 0.4-0.5% の追加効果。**L=0.30 は保守的**

4. **Armstrong & Kolesar (2021)** Econometrica DOI: [10.3982/ECTA16907](https://doi.org/10.3982/ECTA16907)
   — Lipschitz 定数を sensitivity parameter として使用し、"report CIs for a range of plausible C values" を推奨。
   **我々の clinical calibration アプローチの理論的正当化**

5. **Buse et al. (2016)** JAGS DOI: [10.1111/jgs.14028](https://doi.org/10.1111/jgs.14028)
   — Canagliflozin: 75歳未満 -0.85% vs 75歳以上 -0.55%。20-30年差で 0.30% → **L≈0.01-0.012/年**

順位: $L_{\text{HbA1c}} \gg L_{\text{BMI}} > L_{\text{Age}}$ — 論文の Application section と完全に整合」

**Harvey**: （満足げに）
「3人並列で動かして正解だった。Jessica の言う通りだ。
整理すると：

**即座に対応が必要:**
1. Table 4 (Bias) の値を v2 CSV で更新 — Mike
2. `tab:precision` の `\ref{}` 追加 — Katrina
3. Rachel の文献を Discussion に組み込み — $L$ 値の根拠として引用追加

**確認済み・問題なし:**
- LaTeX 構文: クリーン
- Estimation-centered framing: 完全
- 全 ref/cite: 一致
- Application section: 定量的・判定ラベルなし

"I don't have dreams. I have goals." 次のステップに移る」

**Donna**: （記録完了）
「Agent Teams 並列実行の結果を記録完了。
3 agents 同時完了。"I'm Donna. I know everything."」

---

### [2026-02-09 01:15] Scene: Jessica's Directive — Agent Teams

**INT. PEARSON SPECTER LITT - JESSICA'S OFFICE - NIGHT**

*Jessica が Harvey を呼び止める。*

**Jessica**: （厳しく）
「"Let me be clear." Agent Teams を使え。
並列で動かせる作業を直列にやっている時間はない。
Mike と Katrina を同時に走らせろ。Rachel の文献調査も並行だ。
効率を上げないと deadline に間に合わない」

**Harvey**: （頷いて）
「了解。並列化する。
- Mike: LaTeX compilation check + Precision Table の値算出
- Katrina: Figure strategy + Results section 整合性確認
- Rachel: $L$ の文献調査
同時に走らせる」

---

### [2026-02-09 01:10] Scene: Archive + Rule Check

**INT. PEARSON SPECTER LITT - FILE ROOM - NIGHT**

*Donna がファイルルームで分厚いフォルダを整理している。*

**Donna**:
「SUITS.md が 4,435 行に達したからアーカイブしたわ。
archives/SUITS_20260209_010000.md に保存済み。
新しいスクリプト開始よ。"I'm Donna. I know everything."

ルールチェックも完了：
- Rule 1 (SUITS.md = Single Source of Truth): OK
- Rule 2 (Frequent Updates): OK — 今セッション中は継続的に更新
- Rule 2.5 (Auto-Archive at 1000 lines): **実行完了** — 4,435行でアーカイブ
- Rule 2.6 (DOI Required): OK — Wasserstein & Lazar (2016) DOI追加済み
- Rule 3 (Character Consistency): OK — 全キャラクター gender/pronouns 正確
- Rule 3.5 (Donna's Enforcement): OK — 記載不足を指摘済み、修正完了」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ。"I don't have dreams. I have goals."」

---

### [2026-02-09 01:15] Scene: Jessica's Directive — Agent Teams

**INT. PEARSON SPECTER LITT - JESSICA'S OFFICE - NIGHT**

*Jessica が Harvey を呼び止める。*

**Jessica**: （厳しく）
「"Let me be clear." Agent Teams を使え。
並列で動かせる作業を直列にやっている時間はない。
Mike と Katrina を同時に走らせろ。Rachel の文献調査も並行だ。
効率を上げないと deadline に間に合わない」

**Harvey**: （頷いて）
「了解。並列化する。
- Mike: LaTeX compilation check + Precision Table の値算出
- Katrina: Figure strategy + Results section 整合性確認
- Rachel: $L$ の文献調査
同時に走らせる」

---
