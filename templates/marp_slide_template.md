---
marp: true
size: 16:9
paginate: true
header: "Feb 12, 2026"
footer: "プレゼンテーションタイトル"
style: |
  /* ============================================
     Marp Slide Template
     - Accent Color 1: #1E3A5F (Deep Navy)
     - Accent Color 2: #199be6
     ============================================ */

  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&display=swap');

  :root {
    --accent1: #1E3A5F;
    --accent2: #199be6;
    --text-main: #000000;
    --text-light: #303030;
    --bg-light: #F8F9FA;
    --bw: 10px;
    --footer-space: 24px;
    --overflow-warn: #D7263D;
  }

  /* ---- Base slide ---- */
  /* overflow:hidden clips stray content so exports never silently
     leak off the slide. Pair with scripts/check_marp_overflow.js
     (see templates/MARP_README.md) to surface clipped slides. */
  section {
    font-family: 'Noto Sans JP', sans-serif;
    color: var(--text-main);
    border: none;
    padding: 90px 60px 46px 60px;
    font-size: 28px;
    line-height: 1.3;
    position: relative;
    overflow: hidden;
    /* Frame drawn with background layers (top/left/right/bottom borders) */
    background-color: white;
    background-image:
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1));
    background-position:
      0 0,
      0 0,
      100% 0,
      0 calc(100% - var(--footer-space));
    background-size:
      100% var(--bw),
      var(--bw) calc(100% - var(--footer-space)),
      var(--bw) calc(100% - var(--footer-space)),
      100% var(--bw);
    background-repeat: no-repeat;
  }

  /* ---- Disable default ::before ---- */
  section::before {
    display: none;
  }

  /* ---- Overflow warning ----
     Author OR validation script can add `<!-- _class: overflow -->`
     to a slide; a red outline + ribbon make the problem visible. */
  section.overflow {
    outline: 6px solid var(--overflow-warn);
    outline-offset: -6px;
  }
  section.overflow::after {
    content: "\26A0  OVERFLOW — content exceeds slide bounds";
    position: absolute;
    top: 4px;
    right: 20px;
    background: var(--overflow-warn);
    color: white;
    font-size: 14px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 3px;
    z-index: 99;
  }

  /* ---- Slide title (h1) - covers frame top seamlessly ---- */
  section h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
    background: var(--accent1);
    color: white;
    font-size: 48px;
    font-weight: 700;
    padding: 18px 60px 14px;
    margin: 0;
    line-height: 1.4;
    z-index: 2;
  }

  /* ---- H2 ---- */
  section h2 {
    color: var(--accent1);
    font-size: 36px;
    font-weight: 700;
    border-bottom: 3px solid var(--accent2);
    padding-bottom: 6px;
    margin-bottom: 20px;
  }

  /* ---- H3 ---- */
  section h3 {
    color: var(--accent2);
    font-size: 28px;
    font-weight: 700;
  }

  /* ---- Footer left: date (below frame) ---- */
  header {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto;
    bottom: 4px;
    left: 20px;
    right: auto;
    font-size: 14px;
    color: var(--text-light);
    letter-spacing: 0.02em;
    z-index: 2;
  }

  /* ---- Footer center: title (below frame) ---- */
  footer {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto;
    bottom: 4px;
    left: 0;
    right: 0;
    width: 100%;
    font-size: 14px;
    color: var(--text-light);
    text-align: center;
    letter-spacing: 0.02em;
    z-index: 2;
  }

  /* ---- Footer right: page number (below frame) ---- */
  section::after {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    bottom: 4px;
    right: 20px;
    top: auto;
    left: auto;
    width: auto;
    height: auto;
    font-size: 14px;
    color: var(--text-light);
    background: none;
    padding: 0;
    text-align: right;
    z-index: 2;
  }

  /* ---- Strong text with accent2 ---- */
  section strong {
    color: var(--accent2);
    font-weight: 700;
  }

  /* ---- Lists ---- */
  section ul, section ol {
    line-height: 1.4;
    margin-left: 10px;
  }

  section li {
    line-height: 1.4;
    margin-bottom: 4px;
  }

  section p {
    line-height: 1.3;
  }

  section li::marker {
    color: var(--accent1);
  }

  /* ---- Tables ---- */
  section table {
    border-collapse: collapse;
    width: 100%;
    font-size: 26px;
    margin: 16px 0;
  }

  section table th {
    background: var(--accent1);
    color: white;
    font-weight: 700;
    padding: 10px 16px;
    text-align: left;
  }

  section table td {
    padding: 8px 16px;
    border-bottom: 1px solid #E0E0E0;
  }

  section table tr:nth-child(even) td {
    background: var(--bg-light);
  }

  /* ---- Code blocks ---- */
  section code {
    font-size: 24px;
    background: var(--bg-light);
    border: 1px solid #E0E0E0;
    border-radius: 4px;
    padding: 2px 6px;
  }

  section pre {
    background: #1E1E2E;
    border-radius: 8px;
    padding: 20px;
    border-left: 4px solid var(--accent2);
    max-height: calc(100% - 140px);
    overflow: hidden;
  }

  section pre code {
    background: none;
    border: none;
    color: #CDD6F4;
    font-size: 22px;
    padding: 0;
  }

  /* ---- Blockquote ---- */
  section blockquote {
    border-left: 4px solid var(--accent2);
    padding: 12px 20px;
    margin: 16px 0;
    background: var(--bg-light);
    font-style: italic;
    color: var(--text-light);
  }

  /* ---- Images ---- */
  section img {
    max-height: 60%;
    max-width: 100%;
    border-radius: 4px;
  }

  /* ============================================
     Title slide class
     ============================================ */
  section.title {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
    padding: 60px;
  }

  section.title h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 86px;
    font-weight: 900;
    margin: 0 0 20px 0;
    padding: 0;
    line-height: 1.3;
    border: none;
  }

  section.title h2 {
    font-size: 68px;
    font-weight: 400;
    border: none;
    margin: 0 0 40px 0;
    padding: 0;
  }

  section.title p {
    font-size: 42px;
    margin: 4px 0;
    align-self: flex-end;
  }

  section.title::before {
    display: none;
  }

  section.title header,
  section.title footer {
    display: none;
  }

  section.title::after {
    display: none;
  }

  /* ============================================
     Section divider slide class
     ============================================ */
  section.section {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
    padding: 60px;
  }

  section.section h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 72px;
    margin: 0;
    padding: 0 0 16px 0;
    border-bottom: 4px solid var(--accent2);
  }

  section.section h2 {
    font-size: 60px;
    font-weight: 400;
    border: none;
  }

  section.section header,
  section.section footer {
    display: none;
  }

  section.section::after {
    display: none;
  }

  /* ============================================
     Two-column layout
     ============================================ */
  section.cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr;
    gap: 0 40px;
  }

  section.cols h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
  }

  /* ============================================
     End slide class
     ============================================ */
  section.end {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
  }

  section.end h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 48px;
    margin: 0;
    padding: 0;
  }

  section.end p {
    color: rgba(255, 255, 255, 0.7);
    font-size: 26px;
  }

  section.end::before {
    display: none;
  }

  section.end header,
  section.end footer {
    display: none;
  }

  section.end::after {
    display: none;
  }

---

<!-- _class: title -->
<!-- _paginate: false -->

# プレゼンテーションタイトル

## 

Tak Nagakubo

---

# アジェンダ

1. 背景と目的
2. 方法
3. 結果
4. 考察
5. まとめ

---

<!-- _class: section -->

# 背景と目的

---

# 背景

- 箇条書き項目1
- 箇条書き項目2
- **強調テキスト**はアクセントカラー2で表示
- 通常テキストの説明文

> 引用テキストはこのように表示されます。
> — 出典

---

# テーブルの例

| 指標 | 特徴 | 制限 |
|------|------|------|
| KS統計量 | ノンパラメトリック | 解釈困難 |
| SMD | 単純明快 | 位置のみ |
| nABCD | 分布全体 | 新提案 |

---

<!-- _class: cols -->

# 2列レイアウト

左カラムのテキスト。
箇条書きやテキストブロックを配置。

- ポイント1
- ポイント2

右カラムのテキスト。
図表やコードを配置。

- 結果A
- 結果B

---

# コードの例

```r
library(tidyverse)

data %>%
  group_by(region) %>%
  summarise(
    mean_age = mean(age),
    sd_age = sd(age),
    n = n()
  )
```

---

# 数式の例

$$
nABCD(F, G) = \frac{\int |F(x) - G(x)| \, dx}{\int F(x)(1 - F(x)) \, dx + \int G(x)(1 - G(x)) \, dx}
$$

### 性質

- $0 \leq nABCD \leq 1$
- $nABCD = 0 \iff F = G$
- スケール不変

---

<!-- _class: section -->

# 3. 結果

---

# 結果スライド

### 主要な知見

1. **知見1**: 説明テキスト
2. **知見2**: 説明テキスト
3. **知見3**: 説明テキスト

---

<!-- _class: end -->
<!-- _paginate: false -->

# ありがとうございました

ご質問をお願いします

<!--
  ========================================================
  Overflow handling (see templates/MARP_README.md)
  ========================================================
  1. Default behavior: long content is CLIPPED to the slide
     box (overflow:hidden on section). Nothing leaks off-page.
  2. To flag a known-oversized slide, add the directive
         <!-- _class: overflow -->
     at the top of that slide. It renders with a red outline
     and an "OVERFLOW" ribbon so the issue is visible at export.
  3. Run the validation script before publishing:
         node scripts/check_marp_overflow.js <path-to-deck.md>
     It auto-flags slides whose rendered content exceeds the
     slide box and exits non-zero in CI.

  Uncomment the slide below to see the warning style:

  ---
  <!-- _class: overflow -->
  # Overflow demo
  - deliberately long bullet list line one
  - line two
  - line three
  - line four
  - line five
  - line six (this slide would overflow without clipping)
-->

