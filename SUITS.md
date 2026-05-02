# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

### [2026-05-02 18:35] Scene: Poster v14 — Color Theme + Methods Expanded

**INT. PEARSON SPECTER LITT - DONNA'S DESK - EVENING**

*Donna leans back, surveying the day's poster diff. Six revision passes since lunch.*

**Tak**: 「@donna 今日はだいぶ進んだんじゃないか？」

**Donna**: （満足げに、両手を組んで）
「Tak、進んだなんてものじゃない。今日のポスターの旅程をリストアップしたら笑うわよ。」

「v8 の 2-col から始まって、Principal Contribution callout 追加、削除、3-col 試行、TikZ で fig2 を 2 列スパンする実験、結局 2-col に戻して v14。Scenario overview の追加で 6 回コンパイル。Methods 拡張、Acknowledgements 削除、References を 16pt に縮小、accent color をスライドの red `#D52B1E` に揃え、全 figure を color version に切替。」

**Mike**: （カウントしながら）
「12 件の主要編集、コンパイル 10 回以上。」

**Donna**: 
「That's right. しかも全部 1 ページに、Overfull なしで収めたわ。」

**Harvey**: （肩を組んで）
「Good work. ポスターは事実上完成だ。」

**Donna**:
「I'm Donna. I know everything --- including when the day was a win.」

---

### [2026-05-02 13:45] Scene: Poster v14 — Pure 2-Column Design Complete

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Donna reviews the completed PDF, comparing it against v13 printed reference. Clean compile, both columns balanced.*

**Donna**: （確認しながら）
「v14 の 2 列レイアウトが完成した。ちゃんと 1 page に収まった、Overfull なし。」

**Mike**: （数値確認）
「何の調整をした？」

**Donna**: 
「Left col の overload を fix するため、Clinical Calibration を Right col に移動。Simulation Design を 4 → 3 bullets に、References を one-line 形式に圧縮。」

**Katrina**: （図の配置確認）
「Figure widths はどうなった？」

**Donna**:
「All three at \linewidth — 450mm rendered. Fig1 in Methods, Fig2 in Simulation, Fig3 in Application.」

**Harvey**: （構成確認）
「Column distribution は？」

**Donna**:
「Left: Background → Methods (fig1) → Simulation Design & Results (fig2). Right: Application (fig3) → Calibration → Discussion → References. Header は full-width eyebrow + title only.」

**Jessica**: （最終確認）
「Clean compile はできた？」

**Donna**:
「Yes. 2 passes, 38" × 48" portrait, 1 page. No errors. Only benign hyperref warnings (PDF metadata).」

**Harvey**: 
「よし。準備完了だ。」

---

## Current Status

**Active Project**: similarity-metric (nABCD paper)
**Phase**: Poster v14 complete — awaiting visual review
**Date**: 2026-05-02

**Previous Archive**: `archives/SUITS_20260502_145000.md`

---

## 🔄 直前のコンテキスト (from archived script)

### 直近の作業 (2026-05-02)

1. **Figure size policy 確定**:
   - Tak insight: Size-First-Then-Fonts Principle（tex で width 決定 → R で font 微調整）
   - 一律 0.8× は不要、figure ごと individual review
   - **fig1 のみ 0.8\textwidth**, 他 (fig2-5) は revert (\textwidth または元の 0.71\textwidth)

2. **fig1 (fig2_nabcd_definition) 個別調整完了**:
   - plot.tag rel(1) → rel(0.9)
   - axis.title rel(0.8) → rel(0.9) （tag と統一、中間サイズ）
   - axis.text color: default grey30 → #1A1A1A（濃色化）
   - greyscale + color 両 palette 4 files regenerated

3. **Table centering 全 8 適用**:
   - tab:scenarios, tab:bias, tab:coverage, tab:precision, tab:smd
   - tab:gusto_r8, tab:gusto_nabcd, tab:gusto_lstar_joint
   - 各 \begin{table}[ht] 直後に \centering 追加

4. **Paper recompile success**: nABCD_wiley.pdf 353KB

### Lab Standards (active)

- **Caption Writing Principle** (2026-04-29): Descriptive only, no results narrative
- **Paper Figure Size Standard** (2026-04-29): width = 7", base_size = 11, white bg, greyscale = #1A1A1A
- **Calculation Verification Rule** (2026-05-01): 計算後は必ず再検証
- **Size-First-Then-Fonts Principle** (2026-05-02): tex width 決定 → R font 調整

### §4.4 Application narrative (確定)

- **Threshold**: Candidate 3 — L_age = 1×10⁻² /yr, L_SBP = 2×10⁻³ /mmHg
- **AND eligible**: 7 regions (R1, R4, R5, R6, R7?, R14, R15)
- **Selected pool partner**: R4 (両 EM で balanced top 3 on nABCD)
- **§5 Discussion**: Limitation paragraph for sponsor-specified L bounds

### Takからの直近の指示

- ✅ Figure 1 → 0.8 width + font rel(0.9) 統一 + 濃色 axis text 完了
- 🔄 **Next**: Figure 2 (fig2_bias) review

---

## 🎬 Live Script

### [2026-05-02 15:15] Scene: Figure 1 Tag/Axis 微調整 (visual 均衡) + 軸値ラベル純黒化

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Tak が PDF 確認後、追加調整指示。Visual で tag/axis title を揃える + axis text 濃色化を強化。*

**Tak**:（visual 調整指示）
「タブ(A)と(B)のフォントサイズを少し小さく。軸ラベルを少し大きく。これらのサイズを同じに。あと、軸の値ラベルの色をもっと濃く。」

**Donna**:（解釈）
「rel(0.9) で数値統一しても、tag (単独文字 (A)/(B)) は密度低く visual に大きく、axis.title (長文字 'Effect Modifier Value') は密度高く visual に小さく見える。両方を逆方向に微調整して visual で均衡させる。」

**Mike**:（実装）
「修正：
- plot.tag rel(0.9) → rel(0.85) (少し小さく)
- axis.title rel(0.9) → rel(0.95) (少し大きく)
- axis.text color #1A1A1A → 'black' (純黒、最大濃度)」

**Donna**:（実行 log）
「✅ figures_paper.R 修正完了
✅ fig1 regen (greyscale + color)
✅ paper recompile (nABCD_wiley.pdf)

**Next**: Tak の PDF 確認待ち」

---

### [2026-05-02 15:00] Scene: SUITS.md Archive (1011 → fresh) + Figure 2 Review 準備

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*SUITS.md が 1011 行に到達。Donna 即 archive 実行。Fresh state で Figure 2 review に移行。*

**Donna**:（即対応）
「Auto-archive trigger。`archives/SUITS_20260502_145000.md` に保存完了。Fresh SUITS.md で context summary を維持しつつ、Figure 2 review を開始する。」

**Harvey**:（次のステップ）
「Figure 2 (fig2_bias) review に移ろう。0.8 width revert 後の \textwidth full size で見て、Tak の感覚で大きいかどうか、フォントの大きさは fig1 と consistent か確認。」

---
