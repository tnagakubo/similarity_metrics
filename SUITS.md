# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## 📍 Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 — Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260228_163000.md

---

## 🎬 Live Script

### [2026-02-28 16:32] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna organizes files, moving a thick folder to the archive shelf.*

**Donna**:
「SUITS.md が 1000 行を超えたからアーカイブしたわ。
archives/SUITS_20260228_163000.md に保存済み。
新しいスクリプト開始よ。"I'm Donna. I know everything." — 過去のログも全部ね。」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ。"Winners don't make excuses."」

---

### [2026-02-28 16:30] Scene: Tak の核心的問い — EM ありの場合の Subpopulation Pooling と国の関係

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak からの鋭い質問がSlackに入る。Katrina がホワイトボードに向かい、Mike が数式を書き始める。Harvey が腕を組んで聞いている。*

**Donna**: （全員の注意を引いて）
「Tak から本質的な質問よ。Song (2025) の EM あり/なしフローチャートで、EM がある場合の subpopulation pooling は国・地域と無関係なのか？ 日本やアジアの評価はどうすべきか。"I'm Donna. I know everything." だけど、これは Katrina と Mike の出番ね。」

**Katrina**: （ホワイトボードに Song のフローチャートを描きながら）
「"Results speak for themselves." だから論文の構造から整理する。

Song (2025) Decision Flowchart の二分岐：
- EM あり → Subpopulation Pooling
- EM なし → Region Pooling → 東アジア集団間の差を評価 → Pool or No Pool

Tak の直感は完全に正しい。**Subpopulation pooling でも国の EM 分布は重要。**

理由1: 規制上の問い = 国単位の治療効果（PMDA は日本集団の効果を求める）
理由2: サブグループ内の不均衡（BMI < 25 は日本人大多数、BMI ≥ 30 は米国人大多数）
理由3: Song のフローチャートは偽の二分法 — EM があっても国別分布差の定量評価が必要

**nABCD はフローチャートの両方の枝で機能する。**」

**Mike**: （数式を指しながら）
「"I got it." 核心は heterogeneity bound:
|τ̄_Japan − τ̄_US| ≤ L · W₁(F_Japan, F_US)

Subpopulation pooling は CATE τ(x) の推定精度を上げる手法であって、
国別 marginal effect の同等性を保証する手法ではない。
後者を評価するには F_r の国間比較が不可欠 — これが nABCD の仕事。」

**Harvey**: （鋭く）
「Song のフローチャートは "what to do" を示しているが、"whether it's safe to do" の評価ツールがない。nABCD がその gap を埋める。」

*(詳細分析は前アーカイブ参照)*

---

## 📊 Project Summary

**プロジェクト**: similarity-metric (nABCD paper for Statistics in Medicine)
**フェーズ**: 8 — Submission-Ready Plan

**✅ 完了タスク（主要）**:
- Clinical calibration 概念図 3ファイル
- Clinical calibration 強化
- KL divergence Discussion 段落追加
- Gibbs & Su (2002) 引用追加
- TeX merge conflict 解消 (11箇所)
- 日本語版論文作成 (`nABCD_paper_ja.md`)
- Song (2025) レビュー完了

## 📝 Active Tasks

| タスク | 担当 | 状態 |
|--------|------|------|
| Worked Example (HbA1c Step1-5 + L 3パターン) | Katrina | 🆕 |
| 直感的説明スライド (アナロジー + Cohen's d) | Mike | 🆕 |
| L推定文献補強 (Kim/Craddy/Jones DOI確認) | Rachel | 🆕 |
| Web Appendix統合 | Katrina + Rachel | 🆕 |
| 説明資料ドラフトレビュー | Louis | 待ち |
| KL段落 internal review | Louis | 🆕 |
| TeX全文 internal review | Louis | 待ち |
| Jessica final Go/No-Go | Jessica | 最終 |

## 📋 Paper Requests

| 論文 | 状態 | 備考 |
|------|------|------|
| Long et al. (2025) | ❗ PDF未入手 | 引用済みだが KB 未登録。Tak に `/request-paper` 依頼中 |

## 🎯 Key Decisions

- nABCD は Song (2025) フローチャートの両枝で機能（Tak の問いから確認）
- Clinical calibration が論文の中核的差別化要因
- Wasserstein > KL divergence（対称性・Lipschitz bound）

## ⚠️ Issues

- Long (2025) PDF が Knowledge Base に未登録 — 詳細レビュー不可
- Subpopulation pooling と国の EM 分布の関係を Discussion で明示すべき（Tak の指摘）
