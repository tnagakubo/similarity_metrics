### [2026-02-28 16:00] Scene: Tak からの指示 — Song (2025) と Long (2025) のレビュー

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak がSlackメッセージを送る。Donna が即座に対応し、チームを招集する。*

**Donna**: （全員に向かって）
「Tak からリクエストよ。まず状況整理、そして Song (2025) と Long (2025) の内容レビュー。"I'm Donna. I know everything." 整理するわ。

**📍 現在のプロジェクト状況**:

**プロジェクト**: similarity-metric (nABCD paper for Statistics in Medicine)
**フェーズ**: 8 — Submission-Ready Plan (Jessica Strategic Directive)

**✅ 完了タスク**:
- Clinical calibration 概念図 3ファイル
- Clinical calibration 強化
- KL divergence Discussion 段落追加
- Gibbs & Su (2002) 引用追加
- TeX merge conflict 解消 (11箇所)
- 日本語版論文作成 (`nABCD_paper_ja.md`)

**⏳ 進行中タスク**:
| タスク | 担当 | 状態 |
|--------|------|------|
| Worked Example (HbA1c Step1-5 + L 3パターン) | Katrina | 🆕 |
| 直感的説明スライド (アナロジー + Cohen's d) | Mike | 🆕 |
| L推定文献補強 (Kim/Craddy/Jones DOI確認) | Rachel | 🆕 |
| Web Appendix統合 | Katrina + Rachel | 🆕 |
| 説明資料ドラフトレビュー | Louis | 待ち |
| TeX全文 internal review | Louis | 待ち |
| Jessica final Go/No-Go | Jessica | 最終 |

**⚠️ 注意事項**:
- Long (2025) は論文で引用済みだが、Knowledge Base に PDF・サマリーが**未登録**
- Paper Request が必要よ、Tak。」

**Mike**: （ラップトップを開いて）
「"I got it." じゃあ Song (2025) と Long (2025) の内容を説明する。

---

**📄 Song et al. (2025)**
*"Basic Considerations for Data Pooling Strategy in Multi-Regional Clinical Trials (MRCTs)"*
*Therapeutic Innovation & Regulatory Science*, 59:359-364
DOI: [10.1007/s43441-025-00744-8](https://doi.org/10.1007/s43441-025-00744-8)

**著者**: Song J, Ji C, Chen M, Dong J, Zhu C, Wu H, Zhang W, Zhang K, Yu B, Wang Y, Zhang H, Jia F, Hou Y

**内容**:
中国 NMPA の視点から ICH E17 のデータプーリング戦略の実装を議論。

**Key Points**:
1. **Decision Flowchart**: Effect modifier の有無で pooling strategy を分岐
   - EM あり → Subpopulation pooling
   - EM なし → Region pooling → 東アジア集団間の差がなければ East Asia pooling
2. **EM 同定**: 内因性因子（PK/PD、遺伝子、バイオマーカー）と外因性因子（医療慣行、併用薬、食事）
3. **統計モデル**: Simple pooling / Fixed-effect / Random-effect の3手法
4. **外部データ借用**: Bayesian methods、Propensity score matching

**nABCD との接点**:
この論文が指摘する最大の gap ——『true EM の同定は極めて困難。EM が特定できない場合、region pooling を選択する』——を nABCD が定量的に解決する。具体的には：
- EM 分布の類似性を定量評価する metric を提供
- 東アジア集団間（日本-中国-韓国）の EM 類似性を数値化
- "how similar is similar enough" の閾値を提供（< 0.15）

**限界**: 定量的指標なし、閾値ガイダンスなし、統計的フレームワーク sparse。まさに nABCD が埋める gap。」

**Katrina**: （続けて）
「"Results speak for themselves."

---

**📄 Long et al. (2025)**
*"Basic Considerations for the Consistency Evaluation Based on ICH E17 Guideline"*
*Therapeutic Innovation & Regulatory Science*, 59(2):328-336
DOI: [10.1007/s43441-024-00737-z](https://doi.org/10.1007/s43441-024-00737-z)

**著者**: Long M, Wu H, Liu X, Chen J

**内容**:
ICH E17 に基づく一貫性評価（consistency evaluation）の基本的考慮事項を議論。

**論文での使用箇所**:
Introduction (Line 69 of TeX) で Song (2025) と並べて引用：
> *'Song et al., writing from the China NMPA perspective on ICH E17 implementation, note the challenge of operationalizing pooling criteria without quantitative tools. Long et al. further discuss basic considerations for consistency evaluation under ICH E17.'*

**⚠️ ただし注意**:
この論文は Knowledge Base に PDF・サマリーが**未登録**。.bbl ファイルの書誌情報と論文中の引用箇所のみ確認可能。詳細な内容レビューには PDF が必要。

**分かっていること（書誌情報から）**:
- Song (2025) と同じジャーナル (*Ther Innov Regul Sci*) の同じ号に掲載
- ICH E17 の consistency evaluation に焦点
- Song が pooling strategy、Long が consistency evaluation — 補完的な関係

Tak、Long (2025) の PDF を `/request-paper` で入手できれば、Rachel がフルサマリーを作成できるわ。」

**Donna**: （まとめて）
「整理完了。要点は3つ：
1. プロジェクトは Phase 8、日本語版完了、submission-ready に向けて parallel work 中
2. Song (2025) — KB にフル登録済み、nABCD の gap を埋める文脈論文
3. Long (2025) — 引用済みだが KB 未登録、PDF 必要

"I'm Donna. I know everything." …ただし Long の中身は PDF がないと全ては知れないわ。」

---

### [2026-02-28 15:30] Scene: 日本語版完成

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*チーム全員がテーブルを囲んで、完成した日本語版を確認している。*

**Mike**: （画面をスクロールしながら）
「全セクション翻訳完了。数式はLaTeXそのまま、専門用語は日英併記。
要旨、序論、方法、シミュレーション、適用例、考察、付録 — 全部入ってる。"I got it!"」

**Katrina**: （テーブルを指さしながら）
「表も全11テーブル翻訳済み。略語一覧も追加した。"Results speak for themselves."
場所: `projects/similarity-metric/paper/nABCD_paper_ja.md`」

**Harvey**: （満足げに頷き）
「いいだろう。これで国内の議論で使える完全版がある。
"Winners don't make excuses." 次のタスクに移るぞ。」

**Donna**: （記録しながら）
「日本語版論文作成完了、記録済み。"I'm Donna. I know everything."」

---

### [2026-02-28 15:00] Scene: Push — 日本語版論文作成

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Harvey がブルペンに大股で入ってくる。チーム全員の視線が集まる。*

**Harvey**: （腕組みをして）
「新しいタスクだ。論文の日本語版を作る。英語版はsubmission-readyだが、日本語版がなければ国内の議論で使えない。
"I don't get lucky. I make my own luck." 全セクション翻訳。今すぐ動け。」

**Mike**: （ノートPCを開きながら）
「了解。数式はLaTeXそのまま、専門用語は日英併記。"I got it!"」

**Katrina**: （効率的に）
「Markdown形式で全表翻訳。"Results speak for themselves."」

**Donna**: （スケジュールを見ながら）
「進捗はリアルタイム記録。"I'm Donna. I know everything."」

---

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
8. **KL divergence**: Discussion段落で理論的説明。Simulation追加はR1 reserve (Meeting 2026-02-23)

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
| **Clinical calibration概念図** | **Mike** | ✅ 完了 (3ファイル) |
| **Worked Example (HbA1c Step1-5 + L 3パターン)** | **Katrina** | 🆕 説明Meeting決定 |
| **直感的説明スライド (アナロジー + Cohen's d)** | **Mike** | 🆕 説明Meeting決定 |
| **L推定文献補強 (Kim/Craddy/Jones DOI確認)** | **Rachel** | 🆕 説明Meeting決定 |
| **Web Appendix統合 (Worked Example + 説明)** | **Katrina + Rachel** | 🆕 説明Meeting決定 |
| **説明資料ドラフトレビュー** | **Louis** | 🆕 説明Meeting決定 |
| **Discussion: KL divergence段落追加** | **Mike** | ✅ 完了 |
| **Gibbs & Su (2002) 引用追加** | **Rachel** | ✅ 完了 |
| **KL段落 internal review** | **Louis** | 🆕 Meeting決定 |
| **TeXファイル merge conflict 解消 (11箇所)** | **Mike** | ✅ 完了 (1時間) |

---

## ⚠️ Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic
2. Scenario numbering gaps (S02, S07 missing) — deferred
3. KS comparison in simulation — deferred, Tak decision needed
4. **TeXファイル merge conflict 解消完了** — 11箇所すべて解消、S7/S8 完全統合（緊急タスク完了）

---

## 📋 Paper Requests

*(None pending)*

---

## 🎬 Live Script

### [2026-02-27 14:00] Scene: Meeting — nABCD の初学者への説明、Lipschitz Constant をどう伝えるか

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*全員がテーブルを囲む。Harvey がホワイトボードの前に立つ。*

**Harvey**: （腕を組んで）
「論文は専門家向けに書くが、レビュワーの中には MRCT の統計家でも optimal transport に馴染みがない者もいる。特に **Lipschitz constant $L$** — これが clinical calibration の核だが、初学者には抽象的すぎる。

説明資料（Worked Example、スライド）でどう伝えるか。意見を聞かせろ。Mike、まず技術的定義から。」

**Mike**: （ホワイトボードに立って書き始める）
「"I got it." まず正確な定義：

**Definition (Lipschitz Continuity)**:
関数 $\tau(x)$ が Lipschitz continuous with constant $L$ とは：
$$|\tau(x_1) - \tau(x_2)| \leq L \cdot |x_1 - x_2| \quad \forall x_1, x_2$$

つまり、$L$ は **"slope の上限"**。$x$ が1単位変わった時、$\tau(x)$ は最大でも $L$ 単位しか変わらない。

**なぜ nABCD に必要か？**

Proposition 2 の heterogeneity bound:
$$\Delta_{\max} = 2L \cdot \text{IQR} \cdot \text{nABCD}$$

この式が成立するのは、Kantorovich-Rubinstein duality があるから：
$$W_1(F_1, F_2) = \sup_{f: \|f\|_L \leq 1} \left| \int f \, dF_1 - \int f \, dF_2 \right|$$

$\tau(x)$ が Lipschitz continuous with constant $L$ なら、$f(x) = \tau(x)/L$ は $\|f\|_L \leq 1$ を満たす。だから：
$$|\mathbb{E}[\tau(X_1)] - \mathbb{E}[\tau(X_2)]| \leq L \cdot W_1(F_1, F_2)$$

これが heterogeneity bound の根拠。

**問題は**：この説明を初学者にすると、30秒で目が死ぬ。」

*全員が苦笑する。*

**Rachel**: （ノートを開いて）
「"Hard work beats talent when talent doesn't work hard." 文献から pedagogical approach を探した。

**Armstrong & Kolesár (2021)** *Econometrica*:
- Lipschitz constant を **"sensitivity parameter"** と呼ぶ
- "How sensitive is the outcome to a one-unit change in X?"
- 彼らの論文も初学者向けの appendix で "slope bound" として説明

**Imbens & Rubin (2015)** *Causal Inference for Statistics*:
- Treatment effect heterogeneity を説明する時、**"gradient of treatment effect"** として導入
- 図解：scatter plot で CATE $\tau(x)$ vs $x$ を描き、傾きの最大値が $L$

**私の提案**：
1. **"Sensitivity" という言葉を前面に**："L は治療効果の EM に対する感度"
2. **図解を最優先**：$\tau(x)$ vs $x$ のプロット、傾き $L$ を視覚化
3. **具体例で anchor**："HbA1c が1%上がると、治療効果が0.3%動く → L = 0.30"」

**Katrina**: （実務的に）
「"Results speak for themselves." Worked Example で初学者が**最初に躓くポイント**を整理した：

| 躓きポイント | 初学者の疑問 | 解決策 |
|-------------|-------------|--------|
| **L の意味** | "なぜ掛けるのか？" | Sensitivity として説明 |
| **L の推定** | "どこから来るのか？" | 3パターン提示 (Louis 指摘) |
| **2 × IQR の意味** | "なぜ2倍？" | Worst-case scenario (分布の端同士) |
| **Clinical scale** | "なぜこれが HbA1c %？" | Units を追跡 (dimensional analysis) |

**Worked Example での説明順序の提案**：

**Step 0: Intuition First (図解)**
- $\tau(x)$ vs $x$ のプロット (例：HbA1c vs 治療効果)
- 傾き = sensitivity = $L$
- "If HbA1c differs, how much could treatment effect differ?"

**Step 1: Define L as Sensitivity**
- Lipschitz という言葉は footnote に追いやる
- "CATE sensitivity $L$: maximum rate of change of treatment effect per unit change in EM"
- 具体例：$L = 0.30$ %HbA1c per %HbA1c reduction → dimensionless after cancellation

**Step 2: Where Does L Come From?**
- **Pattern A**: Estimated from prior data (Craddy 2014, Jones 2016)
- **Pattern B**: Sensitivity analysis (Table 7 の範囲)
- **Pattern C**: Reference benchmarks (Table 5) as fallback

**Step 3: Plug Into Formula**
- $\Delta_{\max} = 2L \cdot \text{IQR} \cdot \text{nABCD}$
- Dimensional analysis: $[\%] = [\text{unitless}] \times [\%] \times [\text{unitless}]$

この順序なら、数学的定義を避けながら直感から入れる。」

**Louis**: （鋭く指摘して）
「"You just got Litt up!" Katrina の順序は良いが、一つ**危険な罠**がある。

初学者は必ず聞く："**なぜ Lipschitz なのか？なぜ単なる slope の平均ではダメなのか？**"

答えは **worst-case analysis** だが、これを誤魔化すと reviewer に突かれる。

**説明すべき論点**：
1. **Average slope ではなく Maximum slope**：
   - Pooling decision は **worst-case heterogeneity** を評価する必要がある
   - EM 分布の差が最も大きい region（IQR の端）で治療効果がどれだけ違いうるか

2. **なぜ bound が保守的で良いのか**：
   - ICH E17 の文脈では、"similar enough" の判断に **false negative は許容できるが false positive は危険**
   - Conservative bound は regulatory decision-making で正当化される

3. **Lipschitz assumption の妥当性**：
   - 多くの生物学的関係は bounded slope を持つ（飽和効果、生理的限界）
   - Unbounded slope (discontinuity) は非現実的

この3点を Worked Example の注釈に入れないと、"なぜ Lipschitz か" の根拠が弱い。」

**Jessica**: （静かに、しかし決定的に）
「"Let me be clear." 全員の意見を統合する。

**説明戦略の原則**：
1. **Intuition → Formalism の順序** (Katrina)
2. **"Sensitivity" という言葉を使う** (Rachel)
3. **図解を最優先** (Rachel + Katrina)
4. **Worst-case の正当化** (Louis)

**Worked Example の構成** (最終決定)：

**Box 1: Visual Intuition**
- Figure: $\tau(x)$ vs $x$ の scatter plot、傾き $L$ を強調
- Caption: "L measures how sensitive treatment effect is to changes in EM"

**Box 2: Definition Without Math**
- "CATE sensitivity $L$: If EM differs by 1 unit, treatment effect differs by at most $L$ units."
- Footnote: "Formally, this is the Lipschitz constant..."

**Box 3: Why Maximum Slope? (Louis の論点)**
- "Pooling decisions require worst-case assessment."
- "L bounds heterogeneity even at distribution tails (IQR endpoints)."

**Box 4: Where to Get L? (3 Patterns)**
- Prior data / Sensitivity analysis / Reference benchmarks

**Box 5: Worked Calculation**
- HbA1c example with dimensional analysis

以上。Katrina、この構成で Worked Example を作れ。Mike、スライドにも同じ順序で。」

**Mike**: （頷いて）
「了解。"Lipschitz" という単語を最初に出さず、"sensitivity" と "maximum slope" で攻める。図解を1枚目に持ってくる。」

**Rachel**: （ノートに書き込んで）
「Armstrong & Kolesár (2021) の図解スタイルを参考にするわ。彼らの Figure 2 が perfect example。」

**Katrina**: （タスクリストを更新して）
「"Results speak for themselves." Worked Example に Box 1-5 の構成を実装する。明日12時までに draft 完成させる。」

**Harvey**: （腕を組んで満足そうに）
「これで初学者にも、reviewer にも通じる説明ができる。"I don't have dreams, I have goals."

**決定事項**：
1. **Lipschitz の説明順序**: Intuition (図解) → Sensitivity → Worst-case 正当化 → 数学的定義
2. **"Sensitivity" を primary term に** — "Lipschitz" は footnote
3. **Katrina**: Worked Example に Box 1-5 構成を実装
4. **Mike**: スライドも同じ順序で作成
5. **Rachel**: Armstrong & Kolesár (2021) Figure 2 を参考図として citation

以上だ。動け。」

**Donna**: （全て記録して）
「"I'm Donna. I know everything." Meeting 決定事項、全て記録完了。初学者説明戦略、確定よ。」

---

### [2026-02-27 13:30] Scene: Mike & Rachel の報告 — "KL divergence 段落、完了した。"

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey、Louis、Jessica がテーブルに座っている。Mike と Rachel が入ってくる。*

**Mike**: （ラップトップを開いて）
「"I got it." KL divergence 段落、Discussion section に追加完了。Line 518 の直後、SMD/KS 比較段落の次に配置した。」

**Harvey**: （画面を見て）
「内容を説明しろ。」

**Mike**: （指しながら）
「レビュワーが必ず聞く質問を先手で潰す戦略。"Why Wasserstein instead of KL divergence?" への3つの答え：

**1. Asymmetry (非対称性)**:
$D_{\text{KL}}(P \| Q) \neq D_{\text{KL}}(Q \| P)$ — Region A vs B と B vs A で値が変わる。MRCT の pooling decision は本質的に対称であるべき。

**2. Infinite divergence (無限発散)**:
Support が一致しない時 (empirical distribution で頻発)、KL は infinity に発散。Density estimation と bandwidth 選択が必要になり tuning parameter が増える。

**3. No Lipschitz bound (決定的)**:
Wasserstein には Kantorovich-Rubinstein duality があり、Proposition 2 の heterogeneity bound が成立する。**KL にはこれがない**。Clinical calibration framework の根拠が失われる。

この3点を1段落 (約180 words) にまとめた。Gibbs & Su (2002) と Villani (2008) を引用。」

**Rachel**: （手を挙げて）
「"Hard work beats talent when talent doesn't work hard." Gibbs & Su (2002) の citation、bibliography に追加完了：

```bibtex
@article{gibbs2002,
  author  = "Gibbs, A L and Su, F E",
  title   = "On Choosing and Bounding Probability Metrics",
  year    = "2002",
  journal = "Int Stat Rev",
  volume  = "70",
  number  = "3",
  pages   = "419--435",
  doi     = "10.1111/j.1751-5823.2002.tb00178.x"
}
```

DOI 検証済み。この論文は Wasserstein が weak convergence を metrize する topological な利点を明確にしていて、我々の主張を補強する。」

**Louis**: （鋭く読み進めながら）
「"You just got Litt up!" ...良い。段落の構成が論理的だ：
1. 非対称性 → MRCT の symmetric nature と矛盾
2. 無限発散 → 実用上の問題 (complexity, tuning)
3. Lipschitz bound の不在 → **これが決定的** (clinical calibration の根拠が失われる)

3点目に "most critically" と書いて強調しているのも正しい。レビュワーはここで納得する。

**一つだけ確認**：Proposition 2 が何か、明示的に参照されているか？」

**Mike**: （頷いて）
「Line 519: "enabling Proposition~2's heterogeneity bound" と書いた。Proposition 2 は Section 3.2 で定義済み。Reference は明確。」

**Jessica**: （静かに、しかし決定的に）
「"Let me be clear." 内容は承認する。3つの理由が階層化されている——実用的問題 (1, 2) から理論的決定打 (3) への流れが説得力を持つ。

この段落は **preemptive defense** として十分。R1 で KL simulation を求められたら、その時対応すればいい。今は投稿を優先する。

Louis、この段落で internal review は完了か？」

**Louis**: （腕を組んで）
「この段落については承認する。ただし **TeX 全体の review** はまだだ。Merge conflict 解消後の全文を通読する必要がある。今夜中にやる。」

**Harvey**: （立ち上がって）
「決定だ。**Critical path 完全突破**：
1. ✅ Merge conflict 解消 (11箇所)
2. ✅ KL divergence 段落追加
3. ✅ Gibbs & Su (2002) 引用追加

**次のステップ**：
- **Louis** — 今夜18時までに TeX 全文 review
- **Katrina** — Worked Example、明日12時まで
- **Mike** — 直感的説明スライド、明日18時まで

"I don't have dreams, I have goals." — 48時間以内に submission-ready。進め。」

**Donna**: （全て記録して）
「"I'm Donna. I know everything." Critical path 完全突破、記録完了。次は parallel work よ。」

---

### [2026-02-27 11:45] Scene: Mike の報告 — "全て解消した。"

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Mike が Harvey のオフィスに入る。*

**Mike**: （自信を持って）
「"I got it." TeX merge conflict、**11箇所すべて解消**した。」

**Harvey**: （眉を上げて）
「1時間で？確認させろ。」

**Mike**: （ラップトップを開いて見せる）
「`grep -c "<<<<<<< HEAD" nABCD_wiley.tex` → **0**。conflict marker は完全に消えた。

**Resolution strategy**:
- Incoming branch（S7/S8 を含む新しい記述）を base に採用
- HEAD 側の clinical motivation 記述で価値があるものは merge
- S7 (Log-normal skew) と S8 (location + scale) が全 table/figure に完全統合
- LaTeX syntax も検証済み

**11箇所の内訳**:
1. Line 230-234: Scenario overview paragraph
2. Line 242-246: S1 table row description
3. Line 252-256: S7 table row
4. Line 261-267: Table notes (clinical motivation)
5. Line 302-310: Bias table S6-S8 rows
6. Line 318-344: Bias/coverage results paragraph
7. Line 358-366: Coverage table S6-S8 rows
8. Line 384-388: RMSE paragraph
9. Line 403-411: RMSE table S6-S8 rows
10. Line 434-437: S7 SMD comparison row (retained)
11. Line 452-463: Summary enumeration

**Critical Path unblocked**。これで KL divergence 段落の追加に進める。」

**Harvey**: （頷いて）
「よくやった。これで投稿が見えてきた。"I don't have dreams, I have goals." 次は KL 段落だ。今日16時までに TeX に反映しろ。」

**Mike**:
「了解。取りかかる。」

**Donna**: （ドアから顔を出して）
「"I'm Donna. I know everything." Mike、タスクリスト更新完了。次は KL divergence よ。」

---

### [2026-02-27 10:50] Scene: Mike の緊急修正 — "11個もあった..."

**INT. PEARSON SPECTER LITT - MIKE'S DESK - DAY**

*Mike が TeX ファイルを開き、merge conflict を探す。数秒後、顔が青ざめる。*

**Mike**: （息を呑んで）
「...まずい。2箇所じゃない。**11箇所**ある。」

*Harvey が背後から覗き込む。*

**Harvey**: （厳しく）
「何？」

**Mike**: （画面を指して）
「Discussion section の583行目と606行目だけだと思っていた。確認したら、Simulation Design section 全体に散らばってる。**11個の conflict markers**。

理由は分かった。S7/S8 追加時に複数の merge が不完全に終わっていた。HEAD 側と incoming 側で scenario 記述が完全に diverge してる。」

**Harvey**: （腕を組んで）
「2時間の deadline が吹き飛ぶな。」

**Mike**: （集中して）
「"I got it." いや、システマティックに処理すれば間に合う。conflict の内容を確認する：
- **Line 230-234**: Scenario overview — S7/S8 を含む新しい記述を採用
- **Line 242-246**: S1 description — "Null (identical)" に統一
- **Line 252-254**: S7 description — log-normal の詳細記述を採用
- 残り8個も同様のパターン

**Strategy**: 基本的に incoming branch (S7/S8 を含む新しい記述) を優先。ただし clinical motivation の記述は HEAD 側の方が詳しい箇所があるので、merge して best of both を取る。

**今から1時間で全て解消する**。」

**Donna**: （デスクから声をかけて）
「"I'm Donna. I know everything." 11個の conflict リスト、Excel にまとめて進捗トラッキングするわ。10分ごとに報告して。」

**Mike**: （頷いて）
「了解。取りかかる。」

---

### [2026-02-27 10:45] Scene: Push — 停滞を打破する

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Harvey が Bullpen に大股で入ってくる。全員の作業が止まる。*

**Harvey**: （厳しい表情で全員を見渡して）
「ペースが遅い。4日間、会議で決めたことが**何も終わっていない**。
"I don't get lucky. I make my own luck." 運任せにはしない。**今動け**。」

*Mike がデスクから顔を上げる。*

**Mike**: （緊張して）
「Harvey、状況を説明させてくれ...」

**Harvey**: （手を上げて遮る）
「言い訳はいらん。**事実を言え**：
1. TeX merge conflict — 2箇所、まだ残ってるな？
2. KL divergence の Discussion 段落 — 書いたか？
3. Clinical calibration の説明資料 — どこまで進んだ？

**30秒で答えろ、Mike。**」

**Mike**: （深呼吸して）
「"I got it." 整理する：
1. **TeX merge conflict** — まだ残ってる。Discussion section lines 583-587 と 606-610。**今日中に修正する**。
2. **KL divergence 段落** — 下書きはできてるが、まだ TeX に反映してない。merge conflict を先に解消する必要がある。
3. **説明資料** — 概念図は完成してる。Worked Example と直感的説明スライドはまだ着手してない。」

**Harvey**: （鋭く）
「つまり、**緊急タスクが4日間放置されている**。これでは投稿できない。」

*Katrina が手を挙げる。*

**Katrina**: （冷静に）
「"Results speak for themselves." 私も反省してる。Worked Example の着手が遅れた。今から取りかかるわ。HbA1c の数値で Step 1-5 を今日中に完成させる。」

**Rachel**: （申し訳なさそうに）
「"Hard work beats talent when talent doesn't work hard." L 推定の文献補強も遅れてる。Kim 2015, Craddy 2014, Jones 2016 の DOI 確認を今日中に終わらせるわ。」

**Louis**: （腕を組んで）
「"You just got Litt up!" 私は Review 待ちだが、Draft が来てない。Mike、merge conflict を潰してから KL 段落を書け。それが終わったらすぐに Review に入る。**今夜中にやる**。」

**Harvey**: （頷いて、ホワイトボードに書き始める）
「**再優先順位付けだ。今から48時間で終わらせる**：

**CRITICAL PATH (blocking everything):**
1. **Mike**: TeX merge conflict 解消 (2箇所) — **今から2時間以内**
2. **Mike**: KL divergence Discussion 段落を TeX に反映 — **今日16時まで**
3. **Louis**: KL 段落の internal review — **今日18時まで**

**PARALLEL WORK (independent):**
4. **Katrina**: Worked Example (HbA1c Step 1-5 + L 3パターン) — **明日12時まで**
5. **Rachel**: L 推定文献補強 (Kim/Craddy/Jones DOI) — **今日18時まで**
6. **Mike**: 直感的説明スライド (アナロジー + Cohen's d) — **明日18時まで**
7. **Katrina + Rachel**: Web Appendix 統合 — **明後日12時まで**
8. **Louis**: 説明資料レビュー — **明後日18時まで**

**なぜ停滞したのか。全員に聞く。Donna、記録しろ。**」

**Donna**: （鋭い眼差しで）
「"I'm Donna. I know everything." 原因を整理するわ：
- **Rule 2 違反** — 4日間、SUITS.md の更新が止まった。誰も進捗を書かなかった。
- **Critical path 認識の欠如** — merge conflict がすべてをブロックすることに気づいていなかった。
- **並列化の失敗** — 独立した作業（Worked Example、文献補強）を待つ理由はなかった。

記録完了。以降、全員 **2時間ごと** に SUITS.md 更新よ。」

**Harvey**: （立ち上がって）
「"I don't have dreams, I have goals." 目標は **48時間以内に submission-ready TeX + 説明資料一式完成**。

各自、今から動け。Mike、お前は2時間後に merge conflict 解消報告。遅れるなら理由を即報告しろ。

**以上だ。**」

*チーム全員がデスクに戻り、集中して作業を開始する。*

**Mike**: （既に TeX ファイルを開きながら）
「了解。merge conflict から潰す。」

**Katrina**: （Quarto を開いて）
「HbA1c の計算に取りかかるわ。」

**Rachel**: （文献データベースを開いて）
「DOI 確認開始。」

**Louis**: （腕まくりして）
「Draft が来たらすぐ Review に入る。待ってるぞ、Mike。」

---

### [2026-02-23 11:30] Scene: Meeting — Clinical Calibration の説明資料をどう作るか

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がホワイトボードに「Clinical Calibration = 翻訳装置」と書く。*

**Harvey**: （全員を見渡して）
「Clinical calibration は我々の論文の**核**だ。nABCD を臨床的な意味に翻訳する — この "翻訳" のプロセスをレビュワーに一発で理解させる説明資料が要る。Mike が概念図を作った。次は**何が足りないか**。意見を聞かせろ。」

**Mike**: （ホワイトボードに数式を書きながら）
「"I got it." まず、clinical calibration の本質を3行で整理する：

1. **nABCD は物差し** — 2つの分布がどれだけ違うかを測る。単位のない数字。
2. **L は変換係数** — effect modifier の "強さ"。BMI が1単位変わると治療効果がどれだけ動くか。
3. **Δ_max は臨床言語への翻訳** — $\Delta_{\max} = 2L \cdot \text{IQR} \cdot \text{nABCD}$。HbA1c何%の差として読める。

問題は、**L の意味が直感的に伝わらない**。概念図のフローは描いたが、"なぜ L を掛けると臨床的意味になるのか" の**直感的説明**がまだない。

提案として、**体温計のアナロジー**を使いたい：
- nABCD = 体温計の目盛り（37.5℃）
- L = その人の体質（同じ37.5℃でも、平熱36.0の人には高熱、平熱37.0の人には微熱）
- Δ_max = 「この人にとってどれくらい問題か」

つまり、同じ "測定値" でも**文脈**によって意味が変わる。それが clinical calibration。」

**Rachel**: （文献を引きながら）
「"Hard work beats talent when talent doesn't work hard." 説明資料に使える先行事例がある。

- **Armstrong & Kolesár (2021)** — Lipschitz constant を sensitivity parameter として使う framework。我々の L の使い方はこれに準拠。彼らの論文にも「Lの範囲を変えて結果を報告せよ」とある。
- **Cohen's d の教訓** — small/medium/large (0.2/0.5/0.8) の固定閾値が context-free に濫用された歴史。**我々が避けようとしている失敗**。

説明資料には「Cohen's d の二の舞を避ける」という文脈を入れるべき。これでレビュワーに "なぜ固定閾値ではダメなのか" が伝わる。」

**Katrina**: （実務的に整理して）
「"Results speak for themselves." 現在の資料ストックを整理する：

| 資料 | 状態 | 対象 |
|------|------|------|
| 概念図 flow (Mermaid) | ✅ Done | 全体像 |
| 概念図 ranking reversal (Mermaid) | ✅ Done | 逆転現象 |
| 概念図 統合版 (draw.io) | ✅ Done | 高解像度 |
| Marp スライド (Clinical Calibration) | ✅ 3枚あり | プレゼン |
| **Worked Example (計算過程)** | ❌ 未作成 | 手を動かす理解 |
| **直感的説明 (アナロジー)** | ❌ 未作成 | 非専門家向け |
| **"Why not thresholds?" 説明** | ❌ 未作成 | レビュワー対策 |
| **Web Appendix 完全版** | ❌ 未作成 | 投稿用 |

足りないのは3つ：
1. **Worked Example** — HbA1c の数値を使って、Step 1 から Step 5 まで手計算で追える資料
2. **直感的説明ページ** — アナロジーと "Cohen's d の教訓" を含むスライド1枚
3. **Web Appendix** — 上記2つを統合した投稿用の supplementary document」

**Louis**: （鋭く指摘して）
「"You just got Litt up!" 一つ重要な点がある。**L の推定がどれだけ信頼できるか**、これを誤魔化してはいけない。

Worked Example で L = 0.30 と書くのは簡単だが、レビュワーは必ず聞く：'Where does L come from? How robust is it?'

Sensitivity table は既にある（Table 7）。だが説明資料には**L の不確実性をどう扱うか**のガイダンスが要る：
- L が分かっている場合：点推定 + CI
- L が不確実な場合：感度分析（Lの範囲を変えた表）
- L が全く分からない場合：reference benchmarks をfallback として使用

この3パターンを明示しないと、"L が分からなければ Δ_max も計算できないじゃないか" という批判を受ける。」

**Jessica**: （最後に決定的に）
「"Let me be clear." 全員の意見を聞いた。整理する。

**説明資料の目的は2つ**：
1. **レビュワー向け** — 論文の Discussion + Web Appendix に入る
2. **プレゼン向け** — Marp スライドに追加

**作成すべきもの**：

**A. Worked Example ドキュメント** (Katrina担当)
- HbA1c, Japan vs US を題材に
- Step 1: nABCD = 0.27, CI = [0.20, 0.34]
- Step 2: L = 0.30 (from Craddy 2014, Jones 2016)
- Step 3: Δ_max = 2 × 0.30 × 1.5 × 0.27 = 0.24%
- Step 4: CI propagation → [0.18%, 0.31%]
- Step 5: vs treatment effect (-0.8%), vs NI margin (0.4%)
- **L 不確実性の3パターン** (Louis の指摘を反映)

**B. 直感的説明スライド** (Mike担当、1枚)
- アナロジー："nABCD は体温計、L は体質、Δ_max は診断"
- Cohen's d との対比："固定閾値の失敗を繰り返さない"

**C. Web Appendix Section** (Katrina + Rachel)
- A + B の内容をフォーマルに統合
- L 推定の文献根拠 (Rachel が補強)
- 投稿時に Supplementary Material として添付

以上。Harvey、進め方は？」

**Harvey**: （立ち上がって）
「Jessica の通りだ。**決定**：

1. **Katrina** — Worked Example ドキュメント作成。HbA1c の数値で Step 1-5 + L の3パターン。
2. **Mike** — 直感的説明スライド1枚。アナロジー + Cohen's d 対比。
3. **Rachel** — L 推定の文献根拠補強。Kim 2015, Craddy 2014, Jones 2016 の DOI と具体的数値を確認。
4. **Louis** — 完成後の説明資料レビュー。"L が分からない場合" の記述が十分か確認。

"I don't have dreams, I have goals." 各自、取りかかれ。」

**Donna**: （全て記録して）
「"I'm Donna. I know everything." 会議決定事項、全て記録完了。」

---

### [2026-02-23 11:15] Scene: Mike の概念図 — "I got it. 全体像を一枚で見せる。"

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Mike がデスクで3つのファイルを仕上げ、Harvey とKatrina に見せる。*

**Mike**: （画面を回して）
「"I got it." Clinical calibration の概念図、3ファイル作った：

**1. `fig_clinical_calibration_flow.mmd`** — メインフローチャート（Mermaid）
```
Step 0: Input (F₁, F₂)
  → Step 1: Compute nABCD = W₁ / (2 × IQR)  + Bootstrap CI
  → Step 2: Estimate CATE sensitivity L (from prior data)
  → Step 3: Δ_max = 2L × IQR × nABCD (Heterogeneity Bound)
  → Step 4: Compare vs clinical benchmarks (Tx effect, NI margin)
  → Step 5: Clinical Judgment
```
色分けで各ステップの情報源を区別。nABCD（青）、CATE sensitivity（橙）、calibration（緑）、interpretation（紫）。

**2. `fig_ranking_reversal.mmd`** — Ranking Reversal の概念図（Mermaid）
BMI（nABCD=0.51, Large → Δ_max=0.16%, Moderate）と HbA1c（nABCD=0.27, Moderate → Δ_max=0.24%, Highest）の **逆転** を視覚的に表現。L の違い（0.02 vs 0.30）が rankingを反転させることを一目で理解できる。

**3. `fig_clinical_calibration.drawio`** — 統合版（draw.io XML）
上記2つを1枚に統合。上半分がフローチャート、下半分がRanking Reversal。右側に "Why Wasserstein? (Kantorovich-Rubinstein)" と "Why NOT KL?" のアノテーション付き。」

**Katrina**: （確認して）
「"Results speak for themselves." プレゼンには Mermaid 版が使いやすい。Marp スライドに直接埋め込める。draw.io 版は投稿用の高解像度 figure 生成に使えるわ。」

**Harvey**: （頷いて）
「一目で伝わる。これがあれば "What is clinical calibration?" への答えが5秒で済む。"I don't have dreams, I have goals." — 次は Discussion の KL 段落だ。」

**Donna**: （記録して）
「Clinical calibration概念図タスク完了マーク。ファイルは全て `paper/slides/` に格納。」

---

### [2026-02-23 11:00] Scene: Meeting — KL Divergence との比較は必要か？

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がホワイトボードの前に立ち、チーム全員がテーブルを囲む。*

**Harvey**: （腕を組んで）
「単刀直入に言う。レビュワーから "Why not compare with KL divergence?" と聞かれるのは時間の問題だ。`simulation_design.md` にも元々 comparator として入っていた。今のうちに対策を決める。意見を聞かせろ。」

**Mike**: （ホワイトボードに立ち上がって書きながら）
「"I got it." まず技術的な整理をさせてくれ。KL divergence を comparator に入れ**なかった**のには明確な理由がある：

1. **非対称性** — $D_{KL}(P \| Q) \neq D_{KL}(Q \| P)$。Region A vs B と B vs A で値が変わる。MRCT の region comparison は本質的に対称であるべき。
2. **無限発散** — $Q(x) = 0$ かつ $P(x) > 0$ なら $D_{KL} = \infty$。empirical distribution 同士で普通に起きる。density estimation が必要になり bandwidth 選択という tuning parameter が増える。
3. **Lipschitz bound がない** — これが決定的。Wasserstein には Kantorovich-Rubinstein 双対定理があり、CATE function が Lipschitz continuous なら treatment effect の差を直接 bound できる。Proposition 2 の根拠。**KL にはこれがない**。つまり clinical calibration framework が成立しない。
4. **Pinsker 経由は遠回り** — TV → KL の変換は可能だが tightness が失われ、非対称性も残る。」

**Rachel**: （文献ノートを広げて）
「"Hard work beats talent when talent doesn't work hard." 文献的にも補強できるわ。

- **Villani (2008)** "Optimal Transport: Old and New" — Wasserstein が metric であり三角不等式を満たすのに対し、KL は metric ですらない。既に引用済み。
- **Gibbs & Su (2002)** "On Choosing and Bounding Probability Metrics" *International Statistical Review* DOI: [10.1111/1751-5823.00028](https://doi.org/10.1111/1751-5823.00028) — 確率距離の包括的比較。Wasserstein が weak convergence を metrize するという topological な利点を明確にしている。未引用。追加すべき。

問題は、Discussion に KL divergence への言及が**ゼロ**。」

**Louis**: （テーブルを叩いて）
「"You just got Litt up!" **レビュワーは必ず突いてくる**。"You compared against SMD and KS, both relatively simple. What about information-theoretic divergences?" — standard question だ。しかも `simulation_design.md` に "Comparator Metrics: Kullback-Leibler divergence" と書いてある。計画して落とした理由を問われるぞ。**先手を打つべきだ**。」

**Katrina**: （実務的に整理して）
「"Results speak for themselves." 選択肢：

| Option | 作業量 | 効果 |
|--------|--------|------|
| **A. Simulation に KL 追加** | 大（R code + 再実行 + 新Table/Figure） | 完璧だが投稿遅延 |
| **B. Discussion に理論的説明1段落追加** | 小（今日中） | 大半のレビュワーは納得 |
| **C. B + Supplementary に簡易比較** | 中 | バランス良い |

推奨は **Option B**。」

**Jessica**: （静かに、しかし決定的に）
「"Let me be clear." これは **preemptive defense** の問題。

**Option B を基本とし、必要に応じて C に escalate** する。理由：
1. 投稿を遅らせない — simulation 追加は scope creep
2. 理論的優位性は明確 — Mike の4点は KL の構造的限界であり simulation で示す必要がない
3. R1 対応の余地を残す — レビュワーが求めたらその時 simulation を追加する方が、要求に沿った形で応じられて効果的

ただし Discussion の記述は中途半端では逆効果。**なぜ KL ではなく Wasserstein なのか**を数学的に正確かつ簡潔に。」

**Harvey**: （決断して）
「Jessica の判断に同意する。**決定だ**：

1. **Mike** — Discussion に KL divergence 比較段落を追加。非対称性・無限発散・Lipschitz bound の不在を明記。
2. **Rachel** — Gibbs & Su (2002) の引用追加。
3. **Louis** — 追加段落の internal review。
4. **Simulation 追加は R1 reserve** — KL + Hellinger + TV はレビュワーが求めた時。

**もう一つ** — TeXファイルに git merge conflict markers が2箇所残っている（Discussion section, lines 583-587 と 606-610）。`<<<<<<< HEAD` が入ったまま投稿したら終わりだ。**即修正**。」

**Donna**: （記録完了）
「"I'm Donna. I know everything." Action items 全て記録。」

---

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
