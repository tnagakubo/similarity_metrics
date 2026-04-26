# Accessibility — CVD・Grayscale・コントラスト対応

投稿・プレゼン前の **必須チェック**。論文を読む読者の一定数は色覚多様性を持ち、印刷で grayscale に変換される可能性も常にある。

---

## 1. 色覚多様性（CVD: Color Vision Deficiency）

### 主要な型と有病率

| 型 | 概要 | 男性有病率 | 女性有病率 |
|----|------|-----------|-----------|
| **Deuteranopia / Deuteranomaly** | 緑錐体の欠損・変異（緑識別弱い） | ~6% | ~0.4% |
| **Protanopia / Protanomaly** | 赤錐体の欠損・変異（赤識別弱い） | ~2% | ~0.03% |
| **Tritanopia** | 青錐体の欠損（黄⇔青の区別弱い） | <0.01% | <0.01% |
| **Achromatopsia** | 全色覚欠如（完全色盲） | <0.003% | <0.003% |

合計で **赤緑色覚異常（deuteranopia + protanopia）は男性の約8%、女性の約0.5%**。欧州系集団でやや高く、東アジア系でやや低い傾向があるが、無視できない割合。

### 設計上の含意

**論文読者に必ず CVD 保持者が含まれる**と仮定して設計する。

- **赤と緑の対比のみで意味を区別しない** — 最頻の deuteranopia では赤緑が同色に見える
- **色を唯一の encoding にしない** — shape / line-type / label を **redundant encoding** として併用する
- **diverging scale では RdBu（または PuOr/BrBG）を使う** — 赤緑の PiYG/RdYlGn は CVD で潰れる

### 典型的な失敗例

- 赤バー「significant」 + 緑バー「not significant」 → CVD で区別不能
- 赤線 treatment + 緑線 control → 線種を変えない限り CVD で区別困難

### 推奨パターン

- 黒 + オレンジ（Okabe-Ito）
- 青 + オレンジ（Okabe-Ito の `#0072B2` + `#E69F00`）
- 青 + 赤（RdBu の両端） ← CVD でも明度差で区別可能

---

## 2. Redundant Encoding — 色 + α

アクセシビリティの鉄則：**色だけでなく、shape/line-type/label のうち最低1つも併用する**。

| Encoding | 用途 | 例 |
|----------|------|-----|
| **Shape** | discrete groups (≤6) | ○, △, □, ◇ |
| **Line-type** | line plot の series 区別 | solid, dashed, dotted |
| **Direct label** | 3-8 groups まで | 線の右端に group 名を直接書く |
| **Fill pattern** | bar chart（print でも有効） | striped, hatched |
| **Facet / panel** | 多 group（>6） | 1 group = 1 panel |

### 実装例（ggplot2）

```r
# color + shape
ggplot(df, aes(x, y, color = group, shape = group)) +
  geom_point(size = 3) +
  scale_color_manual(values = okabe_ito[1:4]) +
  scale_shape_manual(values = c(16, 17, 15, 18))  # circle, triangle, square, diamond

# line plot: color + linetype
ggplot(df, aes(x, y, color = group, linetype = group)) +
  geom_line(linewidth = 0.8) +
  scale_color_manual(values = okabe_ito[1:3]) +
  scale_linetype_manual(values = c("solid", "dashed", "dotdash"))
```

---

## 3. Grayscale Fallback Test — 「モノクロで伝わるか」

投稿先のジャーナル PDF は読者により白黒印刷される可能性が常にある（査読者も含む）。**カラーが無い前提で図が解釈可能か確認**。

### テスト方法

1. **R で grayscale 変換して確認**
   ```r
   library(colorspace)
   # 既存 plot の色を grayscale へ
   ggplot(df, aes(x, y, color = group)) +
     geom_point() +
     scale_color_manual(values = desaturate(okabe_ito[1:4], amount = 1))
   ```

2. **画像編集ソフト で PNG を grayscale 化** — 視覚的に確認

3. **CVD simulation tool**
   - R package `colorblindr` / `colorspace::simulate_cvd()`
   - R package `dichromat`
   - オンライン: https://www.color-blindness.com/coblis-color-blindness-simulator/

### Pass 条件

- グループが明度で区別可能
- 順序（sequential）が明度の単調変化で保持されている
- shape/linetype の redundant encoding がある

### Fail pattern

- 2色とも中明度（例: 明るい赤 vs 明るい緑）→ grayscale で同色に
- qualitative で hue だけ変えて明度が等しい → 読めない

---

## 4. コントラスト比（WCAG 基準）

可視化内のテキストやシンボルの可読性。特に poster / presentation で重要。

| 用途 | WCAG AA 推奨 | WCAG AAA（高基準） |
|------|--------------|-------------------|
| 本文テキスト | 4.5:1 | 7:1 |
| 大文字テキスト（18pt+） | 3:1 | 4.5:1 |
| グラフィック要素・UI | 3:1 | — |

### 確認ツール

- https://webaim.org/resources/contrastchecker/
- Adobe Color の accessibility tab
- R: `colorspace::contrast_ratio()`

### 実務的な指針

- 本文や軸ラベル は黒 (`#000000`) または濃灰 (`#333333`) を base に
- 軽量な grid line は薄灰 (`#E5E5E5`) 程度 — grid は情報より副次
- ハイライトする要素は 背景との コントラスト比 >3:1 を確保

---

## 5. ジャーナル別の convention

| ジャーナル | Color policy | Grayscale readability |
|------------|-------------|----------------------|
| **Statistics in Medicine** | Color online free, print は著者負担。**grayscale readable を推奨** | Must |
| **NEJM** | Color OK、**figure は grayscale でも interpretable であること expected** | Must |
| **JAMA / Lancet** | Color free、CVD-friendly 推奨 | Recommended |
| **Nature / Science** | Color free、著者責任で CVD/grayscale 確認 | Recommended |
| **BMJ** | Color online、print は limit あり | Recommended |

**投稿前に必ず journal の figure guidelines を再確認する**。

---

## 6. 検証ツール一覧

### R パッケージ

| パッケージ | 機能 |
|-----------|------|
| `colorblindr` | CVD シミュレーション（deuteranopia/protanopia/tritanopia） |
| `colorspace` | `simulate_cvd()`, `desaturate()`, `contrast_ratio()` |
| `dichromat` | 古典的 CVD シミュレーション |
| `viridisLite` | viridis 系 palette |
| `scales::show_col()` | パレットの視覚確認 |

### Web / スタンドアロン

- **ColorBrewer** https://colorbrewer2.org/ — accessibility rating 付き
- **Coblis (Color Blindness Simulator)** https://www.color-blindness.com/coblis-color-blindness-simulator/
- **Vischeck** https://www.vischeck.com/ — 画像アップロードで CVD simulation
- **WebAIM Contrast Checker** https://webaim.org/resources/contrastchecker/

---

## 7. 投稿前チェックリスト

- [ ] 使用した色は CVD-safe か（Okabe-Ito / ColorBrewer 推奨）
- [ ] 赤緑の対比だけで意味を区別していないか
- [ ] Shape / line-type / label で redundant encoding しているか（≥1つ）
- [ ] Grayscale で print して可読か（または `colorspace::desaturate()` で確認）
- [ ] 軸ラベル・凡例のコントラスト比 >4.5:1 か
- [ ] ジャーナルの figure guidelines を再確認したか
- [ ] 各 facet で同じ変数には同じ色を使っているか（色の一貫性）

---

## 参照

- WCAG 2.1 Guidelines: https://www.w3.org/WAI/WCAG21/
- Okabe & Ito (2008): https://jfly.uni-koeln.de/color/
- Wilke (2019) Ch.19 "Common pitfalls of color use"
