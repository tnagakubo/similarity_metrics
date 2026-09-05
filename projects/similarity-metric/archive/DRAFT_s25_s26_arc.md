# Draft — §2.5 closing clause + new §2.6 (the calibration arc)

**Status: ✅ APPLIED to `paper/per_em_W1_wiley.tex` on 2026-08-18 (Tak: tex をアップデート).** Piece A replaced the closing clause of `sec:inference`; Piece B was inserted as `sec:operability` between `sec:inference` and the Simulation Study section. Verified by compile, not by reading: pdflatex exits 0 on two passes, 18 pages, **no undefined or multiply-defined references**, and `sec:operability` / `eq:tau_clin` / `eq:operability` are each defined exactly once. Backup of the pre-edit file is in the session scratchpad (`per_em_W1_wiley.BEFORE_s26.tex`, checksum-matched at copy time). **One deviation from the draft is recorded below under Piece B.** This file is now a record of what was applied and why, not a pending proposal.

**状態: ✅ 2026-08-18 に `paper/per_em_W1_wiley.tex` へ適用済み。** A は `sec:inference` の末尾節を差し替え、B は `sec:operability` として `sec:inference` と Simulation Study の間に挿入。**検証は通読ではなくコンパイルで実施**: pdflatex 2 pass とも exit 0、18 ページ、**未定義参照・重複 label なし**、3 つの label は各 1 回のみ定義。編集前のバックアップは scratchpad に保存済み。**draft からの乖離が 1 件あり、Piece B の下に記録してある。** Decision (3) (Tak, 2026-08-15) fixed §2.6 as its own subsection written as one arc with §2.5. Two pieces below are of **different kinds** and must be reviewed as such:

- **Piece A** — a *retraction and replacement of one clause* in an existing paragraph (`.tex` line 179). Goes through paragraph review (`memory/feedback_review_process.md`).
- **Piece B** — a *new subsection*, no existing prose displaced.

**状態: DRAFT、`.tex` 未適用。** 判断③（Tak、2026-08-15）で §2.6 は独立節、§2.5 と一本の弧として書くことが確定。下記2件は**性質が異なる**ため区別してレビューする — **A は既存段落（line 179）の1節の撤回と差し替え**、**B は新規節**。

---

## Piece A — §2.5 (`sec:inference`) closing paragraph, line 179

### What is being retracted, and what is not

The paragraph's final clause currently reads "…provides quantitative inputs for sponsor and regulatory judgment **without forcing a binary accept/reject decision.**\cite{wasserstein2016}"

- ❌ **False as written.** The application performs a binary screen (partners are admitted or not at τ_clin = Δ_clin/L_UB). This is the S6 internal contradiction.
  **文字どおりには誤り。** 応用は binary screen を実行している（τ_clin で採否が決まる）。これが S6 の内部矛盾。
- ✅ **The rest of the paragraph is correct and stays.** Estimation-centered rather than testing-based; no universal cutoff intrinsic to $W_1$; the threshold depends on $L_{\text{clinical}}$, which is external to the distributional comparison; Δ_max / L\* with CIs presented alongside clinical context. **Only the final clause is the problem — do not rewrite the paragraph** (P3 cuts both ways).
  **段落の残りは正しく、維持する。** 問題は最終節だけであり、**段落を書き直すな**。
- ✅ **`\cite{wasserstein2016}` survives, re-anchored.** It is Wasserstein & Lazar, *The ASA Statement on p-Values*. The ASA statement opposes **bright-line dichotomization driven by a p-value**, not decision thresholds derived from clinical reasoning. So it supports "the decision is not driven by a significance test" — it never supported "there is no decision." Sole use in the manuscript; no other passage depends on the old reading.
  **`\cite{wasserstein2016}` は再係留して生き残る。** ASA 声明が反対するのは **p 値駆動の bright-line 二分**であって臨床推論から導かれる決定閾値ではない。ゆえに支えるのは「決定が有意性検定に駆動されていない」であり、「決定が存在しない」を支えたことは元より無い。本文中の使用は1箇所のみ。

### Proposed replacement of the final clause (rest of paragraph unchanged)

> …the framework provides quantitative inputs for sponsor and regulatory judgment. The decision is not driven by a significance test\cite{wasserstein2016}: where a screening rule is required, the clinical margin supplies it. Specifying a margin $\Delta_{\text{clin}}$ and an upper bound $L_{\text{UB}}$ induces the threshold
> \begin{equation}
> \tau_{\text{clin}} = \frac{\Delta_{\text{clin}}}{L_{\text{UB}}},
> \label{eq:tau_clin}
> \end{equation}
> the largest $W_1$ at which the distributional difference remains clinically tolerable, expressed in the units of the effect modifier. The threshold is therefore a property of the clinical margin rather than of the distance.
>
> Deriving $\tau_{\text{clin}}$ leaves the calibration half done. A threshold is a usable decision rule only if the estimator can resolve differences on its scale, and $\widehat{W}_1$ cannot resolve arbitrarily small ones. That question is taken up next.

**Why this wording / この文言の理由**
- It states the threshold **positively** rather than as a concession, which is what makes the S6 retraction read as precision rather than as a correction.
  閾値を**譲歩ではなく積極的に**述べる。これが S6 の撤回を訂正ではなく精緻化として読ませる。
- It introduces $\tau_{\text{clin}}$, which the `.tex` currently **never defines** although §4 depends on it throughout.
  §4 が全面的に依拠しながら `.tex` が**一度も定義していない** $\tau_{\text{clin}}$ をここで導入する。
- The last two sentences are the **hinge** decision (3) requires — written as a hinge, not as a summary. **Do not delete them when trimming**; without them §2.6 opens cold and reads as an unprompted admission.
  最後の2文が判断③の要求する**蝶番**。要約ではなく蝶番として書いてある。**削るな** — 無ければ §2.6 が唐突に始まり、促されない告白として読まれる。

---

## Piece B — new §2.6, to be inserted between `sec:inference` and `\section{Simulation Study}`

`\subsection{Operability: The Null Floor}\label{sec:operability}`

> Because $W_1$ is a distance, $\widehat{W}_1$ is non-negative by construction and returns a positive value even when the two regions are draws from the same distribution. The relevant quantity is therefore not a bias to be subtracted but the **sampling distribution of $\widehat{W}_1$ under the null** $F_1 = F_2$, whose upper tail marks the smallest difference the estimator can distinguish from none at the sample sizes actually available. We refer to this distribution as the null floor, and to the comparison of a threshold against it as an operability check.
>
> A threshold rule can discriminate only if its threshold lies above that floor. Writing $q_{1-\alpha}(n_1, n_2, F)$ for the $(1-\alpha)$ quantile of the null distribution of $\widehat{W}_1$ at the two regional sample sizes and the shape $F$ of the effect modifier, the necessary condition is
> \begin{equation}
> \tau_{\text{clin}} > q_{1-\alpha}(n_1, n_2, F).
> \label{eq:operability}
> \end{equation}
> When it fails, an "eligible" verdict is not evidence of similarity: it is compatible with the two regions being identical, and equally compatible with a difference the data cannot see.
>
> The check is inexpensive. Draw two independent resamples, of the two regions' actual sizes, from a single region's empirical distribution; recompute $\widehat{W}_1$; repeat. Because the floor depends on both sample sizes, it is computed per candidate partner rather than once for the trial. No additional data and no distributional assumption are required beyond those already used to estimate $W_1$, and the computation takes seconds.
>
> This condition is not a restatement of a minimum sample size per region. A sample-size recommendation calibrated to bias and coverage (Section~\ref{sec:sim_results}) asks whether $\widehat{W}_1$ estimates $W_1$ well; equation~(\ref{eq:operability}) asks whether the clinical margin is coarse enough for the estimator's resolution, and therefore depends on the strictness of $\Delta_{\text{clin}}$ and the shape of the effect modifier, not on $n$ alone. The two can diverge: in the application of Section~\ref{sec:app_operability} the regional samples exceed two thousand observations, far above any sample-size recommendation we would make, and the operability condition nonetheless fails for one of the two candidate effect modifiers. Which modifier carries a pooling decision is thus a question the data answer, and answer differently from the question of whether the estimator is well behaved.

⚠ **Deviation from the draft, made at apply time and requiring follow-up.** The draft's fourth paragraph forward-referenced `sec:app_operability`. That label **does not exist** — the `.tex` contained zero mentions of operability or the null floor before this edit, so §4.2 is still unwritten. Applying the draft verbatim would have produced an undefined reference rendering as `??`, and a Methods subsection asserting an application result that appears nowhere in the paper. **Resolution: the reference was retargeted to `sec:application` (which exists), and a `% TODO (2026-08-18)` comment was placed immediately above the sentence in the `.tex`** instructing whoever writes §4.2 to retarget it and to state $\alpha = 0.05$ there. **The disclaimer paragraph itself was NOT dropped** — the outline marks it as the one mandatory §2.6 content, and its evidence (n ≈ 2,900 yet age fails) is what distinguishes operability from a sample-size recommendation.
⚠ **適用時に生じた draft からの乖離と、その後始末。** draft の第4段落は `sec:app_operability` を前方参照していたが、**この label は存在しない** — 本編集前の `.tex` に operability / null floor の言及はゼロで、§4.2 は未執筆。そのまま適用すれば未定義参照が `??` となり、**論文のどこにも無い応用結果を Methods が主張する**ことになった。**対応: 参照を既存の `sec:application` に張り替え、当該文の真上に `% TODO (2026-08-18)` コメントを置いた**。§4.2 を書く人に向けて、参照の張り替えと $\alpha = 0.05$ の明記を指示してある。**disclaimer 段落自体は落としていない** — アウトラインが必須とする唯一の §2.6 内容であり、その証拠（n≈2,900 でも age は失敗）こそが operability を例数推奨から区別するものだから。

**Notes for review / レビュー用の注記**

- **Deliberately no GUSTO figures here.** The null-floor values and the 6/15 and 1/15 counts belong to §4.2; §2.6 states the general condition and forward-references. Same discipline as §2.7's "state the theory only."
  **GUSTO の数値を意図的に置いていない。** 帰無床の値と 6/15・1/15 は §4.2 のもの。§2.6 は一般命題を述べ前方参照する。§2.7 の「理論のみ述べる」と同じ規律。
- **The one place §2.6 must gesture at the application** is the non-collapse evidence (n ≈ 2,900 yet age fails). Written as a forward reference to `sec:app_operability`, not as a figure.
  **§2.6 が応用に触れざるを得ない唯一の箇所**が非一致の証拠（n≈2,900 でも age は失敗）。数値ではなく前方参照として書いた。
- ⚠ **Two existing results should be re-anchored to this subsection once it exists** (outline §2.6 bullet 5): Study 1's null-region bias, and the operable-range finding in the threshold calibration study. They currently read as scattered caveats; they are instances of equation~(\ref{eq:operability}). **Not drafted here — they are edits to existing Results prose and need their own review.**
  ⚠ **本節ができたら既存の2結果を再係留すること**: Study 1 の帰無域 bias、閾値較正研究の operable range。現状は散在した caveat だが、式(\ref{eq:operability})の実例である。**ここでは draft していない** — 既存 Results 散文の編集であり別途レビューが要る。
- ✅ **RESOLVED (Tak, 2026-08-18): keep $\alpha$ symbolic in §2.6; state $\alpha = 0.05$ in §4.2.** §2.6 states the condition in general form, so the operability criterion is not tied to one conventional level and a sponsor with a different tolerance can apply it unchanged. **This creates one obligation in §4.2: the choice must be stated there explicitly, not left implicit in the phrase 95th percentile.** Without that sentence the symbolic form in §2.6 has no landing point, and a reader cannot tell whether 0.05 was chosen or inherited by convention.
  ✅ **決着（Tak、2026-08-18）: §2.6 では $\alpha$ を記号のままにし、§4.2 で $\alpha = 0.05$ と述べる。** §2.6 は条件を一般形で述べるので、operability の規準が一つの慣習水準に縛られず、異なる許容度を持つスポンサーもそのまま適用できる。**これは §4.2 に義務を一つ作る: 選択を明示的に述べること。「95パーセンタイル」という語に暗黙に含めてはならない。** その一文が無ければ §2.6 の記号形は着地点を失い、読者は 0.05 が選択されたのか惰性で継承されたのか判断できない。
