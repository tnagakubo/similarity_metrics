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

### [2026-02-28 16:45] Scene: そもそも Subpopulation Pooling とは何か — 原文に立ち返る

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak が根本的な問いを投げる。Mike がホワイトボードを消して一から描き直す。Katrina が Song (2025) の原文を開く。*

**Mike**: （ホワイトボードのペンを持って）
「"I got it." まず定義から。ICH E17 と Song (2025) には **2つの pooling strategy** がある。これは全く別のものだ。」

**Katrina**: （Song 原文を読み上げながら）
「"Results speak for themselves." 原文から正確に引用する。

---

## 2つの Pooling Strategy — 根本的に異なるグルーピングの考え方

### Strategy 1: Region Pooling（地域プーリング）

> *'Pooling some geographical regions, countries or regulatory regions at the planning stage, if subjects in those regions are thought to be similar enough with respect to intrinsic and/or extrinsic factors.'* — ICH E17 Section 2.2.5

**考え方**: 地理で括る。

例：「日本と韓国は患者背景が似ているから、まとめて East Asia region として分析しよう」

```
Region Pooling の例:
┌─────────────┐  ┌──────────────┐  ┌──────┐
│ Japan (n=150)│  │ Korea (n=100)│  │ US   │
│ 全患者       │  │ 全患者        │  │(n=200)│
└──────┬──────┘  └──────┬───────┘  └──────┘
       └────────┬───────┘
         East Asia Pool
          (n=250)
```

→ **国境で線を引く**。中の患者がどんな特性でも関係なく、その国の患者は全員プールに入る。

---

### Strategy 2: Subpopulation Pooling（サブ集団プーリング）

> *'Pooling a subset of the subjects from a particular region with similarly defined subsets from other regions whose members share one or more intrinsic or extrinsic factors important for the drug development programme.'* — ICH E17 Section 2.2.5

**考え方**: 国境を無視して、**患者の特性（EM の値）で括る**。

Song (2025) の重要な記述：

> *'By identifying the true EMs, we are able to define pooled subpopulation by different levels of the EMs without discriminating on regions.'*

> *'Pooling on the subpopulation by a specific attribute would yield the data that resembles a particular region, if this region also enriched with that attribute. This allows the pooled subpopulation to serve as a surrogate for evaluating the efficacy and safety within a specific region.'*

```
Subpopulation Pooling の例 (EM = 体重):
                Japan    Korea    US
低体重(<60kg):   80人     50人    30人  → Low-weight Pool (n=160)
高体重(≥80kg):   10人     15人   100人  → High-weight Pool (n=125)
中間(60-80kg):   60人     35人    70人  → Mid-weight Pool (n=165)
```

→ **国境を横断して、EM の値が同じ患者を集める**。」

**Mike**: （図を指しながら）
「ここが核心だ。Song が言っていることを翻訳すると：

### Subpopulation Pooling の目的（Song の論理）

1. 体重が true EM だと分かった（= 体重によって治療効果が変わる）
2. 全地域から低体重の患者を集めて **Low-weight Pool** を作る
3. この Low-weight Pool は **日本の集団に似ている**（日本は低体重が多いから）
4. よって Low-weight Pool の治療効果を **日本集団の効果の代理 (surrogate)** として使える

Song の原文が明確に述べている：

> *'For example, if a regional population has lower weight, a subpopulation that pools all low weight subjects from all regions can provide a good representation of the regional population.'*

---

### 2つの戦略を並べて理解する

| | Region Pooling | Subpopulation Pooling |
|---|---|---|
| **グルーピング軸** | 地理（国境） | 患者特性（EM 値） |
| **国境** | 尊重する | 無視する |
| **前提** | 国内の患者は概ね同質 | EM 値が同じなら国が違っても同質 |
| **使う場面** | EM が特定できない | EM が特定できた |
| **Song の例** | 日本+韓国 → East Asia | 全地域の低体重者 → 日本の代理 |
| **統計的性質** | 国内全データを使える | EM 層別でサンプルが分割される |

---

### なぜ Song は EM ありの場合に Subpopulation Pooling を推すのか

理屈はこうだ：

1. EM が treatment effect を modify する → **同じ EM 値の患者は同じ治療効果を持つはず**
2. であれば、国が違っても EM 値が同じなら「同じ集団」とみなせる
3. よって **EM 値でプールすれば、地理の差はノイズにならない**

…というのが Song の主張。」

**Harvey**: （鋭く割り込んで）
「だが、前回 Katrina と Mike が指摘した通り、**その論理には穴がある**。」

**Katrina**: （続けて）
「その通り。Song の論理の問題点：

### 問題 1: EM 以外の因子の交絡
低体重の日本人と低体重のアメリカ人が本当に「同じ」か？
食事、併用薬、医療慣行、遺伝的背景 — **EM 以外の因子は国に紐づいている**。
Subpopulation pooling は EM を揃えるが、他の因子は揃わない。

### 問題 2: Surrogate としての妥当性
Song は『低体重プールは日本集団の surrogate になる』と言うが、
それは **日本が低体重に enriched されている場合のみ**。
実際には日本の体重分布は広がりがあり、低体重だけでは日本を代表しない。

### 問題 3: 結局、国の EM 分布が必要
Surrogate の妥当性を判断するには「日本の EM 分布がどうなっているか」を知る必要がある。
つまり **subpopulation pooling を正当化するためにも EM 分布の国間比較が前提**。

ここが nABCD の出番。"Results speak for themselves."」

**Mike**: （まとめて）
「一言でまとめると：

> **Region Pooling** = 国で括る（EM 不明のとき）
> **Subpopulation Pooling** = EM 値で括る（EM 判明のとき）

そして Tak が前回指摘した通り、**subpopulation pooling は国を無視する手法だが、国の EM 分布を無視していい手法ではない**。

"I got it." — Song の gap はここにある。」

**Donna**: （記録しながら）
「完璧な整理ね。"I'm Donna. I know everything." これで subpopulation pooling の定義と Song の論理構造、そしてその限界が明確になったわ。」

---

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
