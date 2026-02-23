# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## 📍 Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 - Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260223_104500.md (1057 lines)

### Paper Title (decided 2026-02-14)

> **Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials**

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

---

## 📊 Key Decisions

1. **Percentile > BCa**: BCa overcorrects for bounded statistics → Percentile primary
2. **Clinical calibration**: $\Delta_{\max} = 2L \cdot IQR \cdot nABCD$ — context-dependent, not fixed thresholds
3. **Estimation-centered**: No hypothesis testing in main text
4. **Power removed**: Simulation evaluates estimation quality (Bias, RMSE, Coverage, CI Width)
5. **S04 showcase**: S04 (0.5σ) is the primary showcase scenario
6. **S08 overcoverage**: Non-monotonic coverage pattern explicitly discussed
7. **LaTeX submission**: SiM accepts LaTeX directly — docx conversion不要 (Jessica ruling 2026-02-23)

---

## 📝 Active Tasks

| Task | Owner | Status |
|------|-------|--------|
| CSV検証 (S1-S8 × 3 = 24 rows) | Mike | ⏳ Sim完了待ち |
| S7/S8 true_nABCD確認 | Mike | ⏳ Sim完了待ち |
| Figure更新 (fig1,3,4,5) | Katrina/Mike | ⏳ Phase A後 |
| LaTeXシナリオ番号 S01→S1 更新 | Mike | ⏳ Phase B後 |
| S7/S8記述・数値テーブル追加 | Mike | ⏳ Phase B後 |
| Clinical calibration強化 | Mike | ✅ 完了 |
| スライド S7/S8 追加 | Katrina | ⏳ Phase C後 |
| DOI final check | Rachel | ⏳ Phase D後 |
| Louis internal review | Louis | ⏳ Phase D後 |
| Jessica final Go/No-Go | Jessica | ⏳ 最終 |
| **Clinical calibration概念図** | **Mike** | 🆕 Meeting決定 |
| **Web Appendix: Worked Example** | **Katrina** | 🆕 Meeting決定 |
| **Worked Example — L推定文献補強** | **Rachel** | 🆕 Meeting決定 |
| **説明資料ドラフトレビュー** | **Louis** | 🆕 Meeting決定 |

---

## ⚠️ Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic
2. Scenario numbering gaps (S02, S07 missing) — deferred
3. KS comparison in simulation — deferred, Tak decision needed

---

## 📋 Paper Requests

*(None pending)*

---

## 🎬 Live Script

### [2026-02-23 10:50] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna、分厚いフォルダをアーカイブ棚に移す。*

**Donna**: （ファイルを整理しながら）
「"I'm Donna. I know everything." SUITS.md が 1057 行を超えたからアーカイブしたわ。
`archives/SUITS_20260223_104500.md` に保存済み。
新しいスクリプト開始よ。」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ。"I don't have dreams, I have goals."」

---
