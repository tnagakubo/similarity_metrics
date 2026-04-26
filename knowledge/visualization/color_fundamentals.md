# Color Fundamentals — 色選びの基礎原則

科学可視化における「色使い」は装飾ではなく **encoding**。データ構造と色スケール型を一致させることが原則。

---

## 1. 色スケールの3類型

色スケールは data type に従って3つに分類される。**データの構造と一致しない型を選ぶと、読者に誤った関係性を示唆してしまう**。

### Sequential（連続・順序あり）

- **用途**: 量の大小に順序がある連続値（濃度、密度、p-value、確率、カウント）
- **特徴**: 単一 hue（または近接 hue）で luminance（明度）が単調に変化
- **例**: viridis, magma, plasma, inferno, cividis; ColorBrewer "Blues", "Greens", "YlOrRd"
- **読みやすさの鍵**: 明度の monotone 変化（暗→明 または 明→暗）

### Diverging（発散・中心あり）

- **用途**: 意味のある中心値（0, baseline, null）の両側に正負・対称的な偏差が存在
- **特徴**: 中心が neutral（white or light gray）、両端が対照的な2色（典型: blue ↔ red, purple ↔ green）
- **例**: ColorBrewer "RdBu", "PiYG", "BrBG"; viridis 系の派生
- **注意**: 中心を意味的な zero に合わせる（`scale_fill_gradient2(midpoint = 0)` のように明示）

### Qualitative / Categorical（質的・順序なし）

- **用途**: 無順序のカテゴリ（region、treatment arm、method 名）
- **特徴**: 異なる hue、類似した luminance・saturation
- **例**: Okabe-Ito 8色, ColorBrewer "Set2", "Dark2", "Paired"
- **制約**: 色の数は6-8が実用上限。それを超えると識別困難 → facet/panel または direct labeling へ切替

---

## 2. Perceptual Uniformity — なぜ rainbow/jet/HSV が NG か

**Perceptual uniformity** = 色空間での等間隔 step が、人間の視覚上でも等間隔の差として知覚されること。

### Rainbow/jet/HSV の問題点

1. **明度が非単調に変化** — jet は黄色部分が最も明るく、両端（青・赤）が暗い。grayscale 化すると順序が破綻する
2. **疑似的な banding を生成** — 視覚上の不連続 step（青→シアン→緑→黄→赤）が、データに存在しない境界を強調してしまう
3. **CVD で破綻** — 赤緑区別が困難な人には、jet の中央（黄〜緑〜赤）の順序が読めない
4. **局所的な強調バイアス** — 黄色領域の微小な差が過剰に目立つ一方、青領域の差は潰れて見えない

結果：読者が存在しないパターンを「見てしまう」または実在するパターンを「見逃す」。

### 推奨の代替

- **viridis** 系 — 明度が厳密に monotone、CVD-safe、grayscale 互換
- **cividis** — viridis の CVD-optimized 版、特に deuteranopia に強い

### 参照

Borland & Taylor (2007) "Rainbow Color Map (Still) Considered Harmful"; van der Walt & Smith "viridis" 設計思想（https://bids.github.io/colormap/）

---

## 3. Luminance vs Hue — 何をどちらで encode するか

| 次元 | 得意なタスク |
|------|-------------|
| **Luminance（明度）** | 量の順序を示す（sequential）。grayscale 印刷でも保持される。 |
| **Hue（色相）** | カテゴリの識別（qualitative）。順序付けには不向き。 |
| **Saturation（彩度）** | 強調・弱化の副次的次元。主 encoding には使わない。 |

### 実務的な帰結

- 順序 or 連続量 → 明度を単調に変える色スケール（viridis 系）
- カテゴリ → 明度ほぼ一定で hue を変える（Okabe-Ito）
- **luminance は grayscale 互換性を保証する** — モノクロ印刷や projector 劣化でも順序が読める

---

## 4. Key Takeaway

> **パレット選択はデータ構造で決まる。「きれいだから」で選ばない。**

| データ構造 | パレット型 | 代表例 |
|------------|-----------|--------|
| 連続値、順序あり（単極） | Sequential | viridis, Blues |
| 連続値、zero を中心に正負 | Diverging | RdBu, PiYG |
| 無順序カテゴリ（≤8） | Qualitative | Okabe-Ito, Set2 |
| カテゴリ（>8） | facet / labeling で対応 | — |

---

## 5. 共通の落とし穴

- **2つ以上の facet で同じ変数に異なる色を使う** — 読者は「色が違う = 意味が違う」と読む。同じ変数は同じ色で。
- **Legend が無い / 不十分** — 色が何を encode しているか必ず明示。
- **色だけに頼った encoding** — shape/line-type/label の redundant encoding を併用する（詳細は `accessibility.md`）。
- **過度な色数** — Miller's 7±2 law に近い。6-8 を超えたら別の encoding を検討。
- **印刷を前提としない設計** — `accessibility.md` の grayscale test を必ず実施。

---

## 参照

- Wilke (2019) *Fundamentals of Data Visualization* Ch.4 "Color scales"
- Tufte (1983/2001) *The Visual Display of Quantitative Information* — data-ink ratio
- van der Walt & Smith "A Better Default Colormap for Matplotlib" (SciPy 2015)
