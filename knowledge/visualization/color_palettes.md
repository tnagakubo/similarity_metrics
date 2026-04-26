# Color Palettes — 実用パレット集

実装時の参照用。データ型 → 推奨パレット + R ggplot2 コード snippet。

---

## 1. Viridis Family（van der Walt & Smith）

Perceptually uniform、CVD-friendly、grayscale 互換。**sequential が必要な場面の default choice**。

| パレット | 特徴 | 推奨用途 |
|----------|------|----------|
| `viridis` | 紫→青→緑→黄 | 汎用 sequential（default） |
| `magma` | 黒→紫→赤→黄 | 暗背景との併用、高コントラスト |
| `inferno` | 黒→赤→橙→白 | 熱マップ的な印象 |
| `plasma` | 紫→赤→橙→黄 | viridis より暖色寄り |
| `cividis` | 青→黄 | CVD 最適化（deuteranopia に特に強い） |

### R 実装

```r
library(ggplot2)

# continuous
ggplot(df, aes(x, y, color = value)) +
  geom_point() +
  scale_color_viridis_c(option = "viridis")  # or "magma", "plasma", "cividis"

# discrete (ordered levels)
ggplot(df, aes(x, y, fill = group)) +
  geom_col() +
  scale_fill_viridis_d(option = "cividis")

# direction reversal
scale_color_viridis_c(direction = -1)
```

### 選択の目安

- 迷ったら `viridis` か `cividis`
- **白背景で印刷されることが確実** → `cividis` が grayscale でも最も読みやすい
- 暗背景のスライド → `magma` or `inferno`

---

## 2. ColorBrewer（Cynthia Brewer）

地図学者 Brewer による curated sets。sequential / diverging / qualitative のすべてに定評ある。accessibility ratings が公式に文書化されている（https://colorbrewer2.org/）。

### Sequential（単極、順序）

| パレット | 色調 | 備考 |
|----------|------|------|
| `Blues`, `Greens`, `Reds`, `Purples`, `Oranges` | 単 hue | grayscale 互換、print-safe |
| `YlOrRd`, `YlGnBu`, `BuPu` | 多 hue | より幅広い dynamic range |

### Diverging（両極、中心あり）

| パレット | 両端 | 備考 |
|----------|------|------|
| `RdBu` | 赤 ↔ 青 | **CVD-safe、最推奨** |
| `PiYG` | 桃 ↔ 緑 | CVD では区別困難 |
| `BrBG` | 茶 ↔ 青緑 | CVD-safe |
| `PuOr` | 紫 ↔ 橙 | CVD-safe |

### Qualitative（カテゴリ）

| パレット | 色数上限 | 備考 |
|----------|----------|------|
| `Set1` | 9 | 飽和度が高く目立つ |
| `Set2` | 8 | **CVD-safe、推奨 default** |
| `Set3` | 12 | 色数多いが識別力は下がる |
| `Dark2` | 8 | Set2 の暗版、白背景で読みやすい |
| `Paired` | 12 | 2色 pair（light/dark）。2水準内ネスト構造に |

### R 実装

```r
# qualitative
ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  scale_color_brewer(palette = "Dark2")

# sequential
scale_fill_brewer(palette = "Blues", direction = 1)

# diverging (continuous)
scale_fill_distiller(palette = "RdBu", type = "div", direction = 1,
                     limits = c(-1, 1))
```

---

## 3. Okabe-Ito パレット

Okabe & Ito (2008) が CVD アクセシビリティ設計で提案した **8色の qualitative パレット**。赤緑色覚異常（最頻）にも区別可能。学術誌・プレゼンで推奨多数。

### 色コード（16進数）

| 名称 | Hex | 用途ヒント |
|------|-----|-----------|
| Black | `#000000` | baseline, text |
| Orange | `#E69F00` | warm accent |
| Sky blue | `#56B4E9` | cool accent, sequential pair 1 |
| Bluish green | `#009E73` | |
| Yellow | `#F0E442` | 背景との contrast に注意 |
| Blue | `#0072B2` | cool primary, sequential pair 2 |
| Vermillion | `#D55E00` | warm primary, 赤代替 |
| Reddish purple | `#CC79A7` | |

### R 実装

```r
okabe_ito <- c(
  "#000000", "#E69F00", "#56B4E9", "#009E73",
  "#F0E442", "#0072B2", "#D55E00", "#CC79A7"
)

ggplot(df, aes(x, y, color = group)) +
  geom_point() +
  scale_color_manual(values = okabe_ito)

# R 4.0+ 以降は palette.colors() で取得可能
scales::show_col(palette.colors(palette = "Okabe-Ito"))
```

### Okabe-Ito 内の sequential pair として使える組み合わせ

同じ hue 系で明度差がある pair は **2水準の順序付きデータ**（例: low dose / high dose、Δ=1%pt / Δ=2%pt）に向く。

| pair | 用途例 |
|------|--------|
| Sky blue `#56B4E9` → Blue `#0072B2` | cool の light → dark |
| Orange `#E69F00` → Vermillion `#D55E00` | warm の light → dark |

---

## 4. Cheat Sheet — データ型 → 推奨パレット

| データ構造 | 色数 | 第一推奨 | 代替 |
|------------|------|----------|------|
| Continuous, sequential | — | `viridis`, `cividis` | ColorBrewer `Blues`/`YlOrRd` |
| Continuous, diverging (zero-centered) | — | ColorBrewer `RdBu` | `PuOr`, `BrBG` |
| Categorical, ≤3 | 3 | 単色（neutral）+ shape で区別 | — |
| Categorical, 4-8 | 4-8 | Okabe-Ito | ColorBrewer `Dark2` / `Set2` |
| Categorical, >8 | >8 | **色に頼らない**（facet, label） | `Set3`（識別力は妥協） |
| Ordered 2-level pair | 2 | 単 hue light→dark（Okabe-Ito sky→blue など） | Sequential から2点抜粋 |

---

## 5. 避けるべきパレット

| パレット | 問題 |
|----------|------|
| `rainbow()` (base R) | Perceptual non-uniformity、CVD 不可 |
| `jet` (matplotlib 旧 default) | 同上 |
| `heat.colors()`, `terrain.colors()` | 明度非単調 |
| Auto-generated HSV (ggplot2 default for many levels) | 色数多いとき識別困難 |

---

## 6. パレット選定フロー（実務用）

```
1. データ構造は？
   ├─ Sequential → viridis/cividis
   ├─ Diverging → ColorBrewer RdBu
   └─ Categorical
       ├─ ≤8 → Okabe-Ito
       └─ >8 → facet/labeling に変更（色数を減らす）

2. CVD + grayscale テスト（accessibility.md 参照）

3. ジャーナル投稿なら submission guide を確認
   （Statistics in Medicine は grayscale readability を expects）
```

---

## 参照

- ColorBrewer: https://colorbrewer2.org/
- Okabe & Ito (2008): https://jfly.uni-koeln.de/color/
- viridis: https://bids.github.io/colormap/
- R `scales::show_col()`, `RColorBrewer::display.brewer.all()` で視覚確認
