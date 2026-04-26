# Visualization Knowledge Base — INDEX

Lab 内部向けの実用リファレンス。論文・ポスター・スライドの figure 作成前にここを参照する。

**Scope**: 色使いを中心に、科学論文向け可視化の実務指針をまとめる。Statistics in Medicine 等のジャーナル投稿を想定。

---

## ファイル一覧

### `color_fundamentals.md`
色スケールの3類型（sequential / diverging / qualitative）と、なぜ rainbow/jet/HSV が科学可視化で不適切とされるか（perceptual uniformity の欠如、誤った band 強調）。データ構造に合ったスケール型を選ぶ原則。**迷ったら最初に読む**。

### `color_palettes.md`
実用パレット集：viridis 系（viridis/magma/inferno/plasma/cividis）、ColorBrewer、Okabe-Ito 8色。データ型 → 推奨パレットの cheat sheet と ggplot2 のコード snippet。**実装時の参照**。

### `accessibility.md`
色覚多様性（deuteranopia/protanopia/tritanopia/achromatopsia）と grayscale 印刷対応。CVD 有病率、赤緑を唯一の encoding にしない原則、shape/line-type/label との併用、WCAG コントラスト比、検証ツール（colorblindr, colorbrewer2.org 等）。**投稿前チェック**。

### `color_for_scientific_figures.md`
図の種類別の実務指針：forest plot（中立色 + 点推定）、categorical scatter（Okabe-Ito + shape）、heatmap/correlation（diverging if 正負, sequential if all positive）、calibration/L* curves、significance encoding の落とし穴、ジャーナル別 convention（grayscale 互換性）、色数が >6-8 のときの対処。**図を描く直前の参照**。

---

## 参照方針

| 状況 | まず見る |
|------|----------|
| どのパレット型か迷う | `color_fundamentals.md` |
| 具体的なパレット名・コード | `color_palettes.md` |
| 投稿前に CVD/grayscale 確認 | `accessibility.md` |
| 特定の図（forest, scatter, heatmap...） | `color_for_scientific_figures.md` |

---

## 主要な出典（典拠）

- **Okabe & Ito (2008)** "Color Universal Design (CUD)" — https://jfly.uni-koeln.de/color/ — CVD-friendly 8色パレットの由来
- **Brewer, C.A. et al.** "ColorBrewer" — https://colorbrewer2.org/ — sequential / diverging / qualitative の curated sets
- **van der Walt & Smith** "viridis" — https://bids.github.io/colormap/ — perceptually uniform パレット
- **Wilke, C.O. (2019)** *Fundamentals of Data Visualization* — https://clauswilke.com/dataviz/ — 包括的なデザイン原則
- **Tufte, E.R. (1983/2001)** *The Visual Display of Quantitative Information* — data-ink ratio, chartjunk の基礎

---

*Last updated: 2026-04-24 | Maintained by Katrina*
