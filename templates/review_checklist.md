# Paragraph Review Checklist — Tak's 5 Principles

段落レビュー（Step 2）で Tak に提示する**前**に Harvey と Mike が実行する。
全項目 Yes なら提示可。No があれば修正してから提示。

---

## P1: 初見理解可能性

- [ ] この段落に初出の専門用語はあるか? → あれば説明が添えてあるか確認
- [ ] 指示語（this, these, such, it）の参照先は一意に特定できるか?
- [ ] 略語は初出時にフルスペルが書かれているか?
- [ ] この分野の統計学者が、この論文を初めて読んで理解できるか?

## P2: 論理的必然性

- [ ] この段落は前段落から論理的に導かれているか?（接続が飛躍していないか）
- [ ] 新しい概念や手法の導入は "選択肢 → 選択 → 理由" の流れになっているか?
- [ ] 段落内の各文の順序に論理的必然性があるか?（入れ替えても同じなら構造が弱い）
- [ ] 「なぜこの段落がここにあるのか」を一文で説明できるか?

## P3: 不要なら削除

- [ ] この段落の各文は論文に不可欠か?（削除して論旨が成立するなら削除候補）
- [ ] 読者が既に知っている情報の繰り返しはないか?
- [ ] 冗長な修飾語（very, highly, extremely 等）はないか?
- [ ] この段落自体が不要ではないか?（他の段落と統合可能か?）

## P4: 用語の数学的正確性

- [ ] 曖昧な表現（rapidly, significant, well-defined, large 等）がないか?
- [ ] 数学的に定義可能な概念は定義で記述されているか?
- [ ] 標準的な学術用語を使っているか?（独自用語を避けているか）
- [ ] 数式で表現すべきものが自然言語のままになっていないか?

## P5: 主張と証拠の比例

- [ ] 主張の動詞（recommends, demonstrates, proves 等）は証拠の強度に合っているか?
- [ ] ICH E17 等のガイドラインに対して overclaim していないか?（recommends → describes）
- [ ] シミュレーション結果を "proves" や "demonstrates" と表現していないか?
- [ ] 比較表現（better, superior, optimal）に根拠が伴っているか?
- [ ] **証拠が削除/縮小された場合、対応する claim 文言も narrow したか?**（例: S6 削除 → "scale, shape, skewness" を "scale and skewness" に）
- [ ] **証拠範囲外の moment/property を claim していないか?**（例: shape/kurtosis evidence がないのに "captures distributional shape"）

---

## C1: Cross-Section Cascade Check（セクション書き換え時）

**適用条件**: 段落ではなくセクション全体（§ 単位）の書き換え、または primary case study 入れ替え（例: IST-3 → GUSTO-I）、または scenario/figure の削除。

- [ ] **Abstract** の数値・名称・case study reference は更新が必要か?（→ Tak 指示で paper 完成後の最終 polish に保留可）
- [ ] **Abbreviations / 略語表** の追加・削除は必要か?（→ 同上、最終 polish に保留可）
- [ ] **Discussion** で対応セクションを参照している記述（key findings, limitations, recommendations）は更新済か?
- [ ] **Methods / Simulation の calibration 例** で当該 case study の数値を引いていないか?
- [ ] **Data availability** statement の citation は対応しているか?
- [ ] 削除した scenario / figure / table を参照している残存 reference は grep で確認したか?
- [ ] **作業順序**: 本体（§1-§5 本文）→ Discussion 整合 → 最後に Abstract / 略語（Tak 標準 practice）

**Tak の実例**: §4 を IST-3 → GUSTO-I に書き換えた際、Discussion 4段落（Para 1, 2, 5, 8）に IST-3 数値が残存。さらに §3 calibration 例（L334, L393）と Data availability（L586）にも波及。Abstract と略語は paper 完成後に同期する判断（"Abstract と略語は最後でいい — 通常の論文の書き方"）。

## C2: Section Opening Abstraction Level（Discussion / 各 § の冒頭段落）

- [ ] Discussion / 各 section の opening paragraph は **high-level summary** になっているか?
- [ ] specific numbers（CI, region IDs, exact nABCD values）は opening ではなく後続段落で再登場させているか?
- [ ] 読者が opening だけで「この章の message」を一行で要約できるか?

**Tak の実例**: §5 Discussion Para 1 で R2/R9 / R4/R6/R13 等の specific region IDs を入れすぎ → opening は abstract level に保ち、具体は Para 2 以降で展開。

---

## Option Presentation Pattern（修正提案フォーマット）

Tak への修正提案は **3 軸** で options を並べると判断が早い:

- **Option A**: 最小修正（現状維持 or 局所 wording 変更）
- **Option B**: 構造改変（段落再構成 / 削除 / 移設）
- **Option C**: 折衷（A と B のハイブリッド、部分的 restructuring）

各 option は **(1) 変更内容 / (2) 影響範囲 / (3) trade-off** を 1-2 行で記述。Tak は典型的に B または C を選ぶが、議論の前提として A が必要。

---

**判定**: 全 Yes → Tak に提示可 / No あり → 修正後に再チェック
