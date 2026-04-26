# Color for Scientific Figures — 図種別の実務指針

作図の直前に参照。各 figure type で典型的な選択肢・落とし穴・推奨をまとめる。

---

## 1. Forest Plot（点推定 + 信頼区間）

### 原則

**点推定 + CI は中立色（黒 or 濃灰）** が基本。色は **meaningful な categorical distinction** がある場合のみ使う。

### 推奨

- 単一 series（1種類の推定量） → 黒 `#000000` または 濃灰 `#333333`
- 複数 series（例: subgroup 別、method 別） → Okabe-Ito から ≤4色
- CI bar と point の色は一致させる（視覚的に同一 series と分かる）

### Facet 間の一貫性

複数 panel（例: Age / SBP）で **同じ変数 = 同じ色** を守る。異なる色を使うと「異なる encoding」と読まれる。

### 避けるべき

- 点推定を significance で赤/緑に塗り分け（CVD 不可、dichotomization 暗示）
- CI bar と point で色を変える（冗長・誤解の余地）
- rainbow palette による subgroup 識別

### R snippet

```r
# 単色 neutral
ggplot(df, aes(x = estimate, y = group)) +
  geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper),
                 height = 0.3, color = "#000000") +
  geom_point(size = 2.5, color = "#000000") +
  theme_minimal()

# facet 間で同一変数の色を保つ
# → forest_data の color mapping を変えない
```

---

## 2. Scatter Plot（categorical groups）

### 原則

Categorical で色分けする場合、**Okabe-Ito または ColorBrewer Set2/Dark2**。色数は ≤8。

### Redundant encoding（必須）

- **Shape** を color と同時に使う（CVD + grayscale 対応）
- 例: △ = group A (color1), ○ = group B (color2), □ = group C (color3)

### 推奨

- 単一 group でハイライトしたい subset がある → neutral color + shape/size の変化（色は増やさない）
- 密集領域は alpha で透明度調整（`alpha = 0.6`）

### 避けるべき

- 色数 >8 → 識別不能、facet へ切替
- 色 のみで encoding（shape を併用しない）
- 背景色と似た色（白背景で pale yellow など）

### R snippet

```r
ggplot(df, aes(x, y, color = group, shape = group)) +
  geom_point(size = 2.5, alpha = 0.7) +
  scale_color_manual(values = okabe_ito[1:4]) +
  scale_shape_manual(values = c(16, 17, 15, 18))
```

### Highlighting pattern（本論文の GUSTO scatter でも使用）

特定の partner（R4, R6, R13）を強調する場合：
- color は単一（neutral blue 等）
- shape を変える（円→三角）
- size をわずかに大きく

→ 色を増やさずに強調できる、CVD + grayscale 両立。

---

## 3. Heatmap / Correlation Matrix

### パレット選択

| データ | パレット |
|--------|---------|
| All positive, sequential | viridis, cividis, Blues |
| Zero-centered (correlation, deviation) | **Diverging: RdBu** |
| Bounded [0, 1]（確率など） | viridis / Blues |

### 原則

- **Zero/null が意味を持つ場合は必ず diverging** — 中心を明示（`midpoint = 0`）
- セル内数値表示を考慮した場合、明度が極端な部分はテキスト可読性に注意（白 or 黒 text の自動切替）
- Color bar は等間隔・単調明度であること（perceptual uniformity）

### 避けるべき

- Correlation に sequential palette を使う（正負の区別が消える）
- Rainbow / jet（繰り返し言及するが science figure では禁忌）

### R snippet

```r
# correlation matrix
ggplot(cor_long, aes(var1, var2, fill = correlation)) +
  geom_tile() +
  scale_fill_distiller(palette = "RdBu", type = "div",
                        limits = c(-1, 1), direction = 1) +
  geom_text(aes(label = sprintf("%.2f", correlation)),
            color = ifelse(abs(cor_long$correlation) > 0.6, "white", "black"))
```

---

## 4. Calibration / L* Curves / Sensitivity Plots

### 典型構造

- 複数 series（method, dose, Δ_clin level）を同一軸に重ねる
- series は **順序付き（sequential）** or **カテゴリ** のどちらか → データ構造で選ぶ

### Sequential な series（例: Δ_clin = 1%pt, 2%pt, 3%pt）

- **単 hue の light → dark** を使う
- Okabe-Ito なら Sky blue `#56B4E9` → Blue `#0072B2`（cool の light → dark）
- または Orange `#E69F00` → Vermillion `#D55E00`（warm の light → dark）

### Categorical な series（method A vs method B, arm 1 vs arm 2）

- Okabe-Ito / ColorBrewer Set2 から選ぶ
- **線種（linetype）** を redundant encoding として必ず併用

### Facet 間の一貫性（重要）

**複数 panel で同じ意味の変数には同じ色を使う**。これは本文書の最重要原則の1つ。

**悪い例**：Panel (a) で Δ_clin を青2色、Panel (b) で Δ_clin を橙2色で encode する
→ 読者は「(a) と (b) で異なる変数を plot している」と誤解する。Δ_clin は同じ変数。

**良い例**：両 panel で Δ_clin を同一の単 hue pair（例: 両方 `#56B4E9` / `#0072B2`）で encode。panel 間で何が異なるかは facet label （"Age" vs "SBP"）で示す。

### R snippet

```r
# sequential pair for ordered levels
delta_colors <- c("Delta[clin] == 1*'%pt'" = "#56B4E9",
                  "Delta[clin] == 2*'%pt'" = "#0072B2")

ggplot(df, aes(x, y, fill = delta_label)) +
  geom_col(position = position_dodge(0.7), width = 0.6) +
  scale_fill_manual(values = delta_colors)
```

### 避けるべき

- 多 series（>5）を色だけで区別 → facet へ
- 色だけで series 区別（line plot では linetype も変える）

---

## 5. Significance Encoding

### 落とし穴

- **赤 = significant / 緑 = not significant** → CVD で不可、加えて binary thinking を強化する問題もある

### 推奨

- **Boldness（フォント太さ）**
- **Filled（塗りつぶし）vs Open（輪郭のみ）** の point shape
- **Asterisk 表記** (`*`, `**`, `***`) を text annotation で
- **neutral 色 + 太字の outline** で強調

### 避けるべき

- 赤/緑 の2択 encoding
- 色のみで binary status を示す

---

## 6. 色数が多い場合（>6-8 categories）

色だけの識別は破綻する。以下のいずれかへ切替：

| 戦略 | 実装 |
|------|------|
| **Facet / panel 分割** | 1 group = 1 panel。共通軸で比較可能 |
| **Direct labeling** | 線の右端や point の横に group 名を直接書く |
| **Small multiples** | ggplot2 `facet_wrap()` / `facet_grid()` |
| **Categorization** | 16 groups を meaningful な 4 aggregated groups へ集約 |

### 実装例（direct labeling）

```r
library(ggrepel)
ggplot(df, aes(x, y, group = region)) +
  geom_line(color = "gray70") +
  geom_text_repel(data = df %>% filter(x == max(x)),
                   aes(label = region), nudge_x = 0.2)
```

---

## 7. ジャーナル別 convention（再掲）

| ジャーナル | Policy |
|------------|--------|
| **Statistics in Medicine** | Color online free; grayscale readable が expected |
| **NEJM** | Color free; grayscale interpretable mandatory |
| **JAMA / Lancet / BMJ** | CVD-friendly recommended |

**投稿直前に必ず target journal の figure guidelines を確認**。

---

## 8. 本 nABCD プロジェクトの方針

以下を default として採用：

- **Forest / calibration の点推定** → `#0072B2`（Okabe-Ito blue）または 黒
- **Qualitative highlight**（scatter の leader 強調） → color は単一、shape で区別
- **Ordered pair**（Δ_clin = 1%pt / 2%pt） → `#56B4E9` → `#0072B2`（sky blue → blue の light→dark sequential）
- **Facet 間の色一貫性** を厳守（同じ変数 = 同じ色）
- **Grayscale test** を投稿前に必ず実施

---

## 参照

- Wilke (2019) *Fundamentals of Data Visualization*:
  - Ch.4 Color scales
  - Ch.19 Common pitfalls of color use
  - Ch.24 Use redundant coding
- Okabe & Ito (2008): https://jfly.uni-koeln.de/color/
- ColorBrewer: https://colorbrewer2.org/
- Tufte (1983/2001) — data-ink ratio, avoiding chartjunk
