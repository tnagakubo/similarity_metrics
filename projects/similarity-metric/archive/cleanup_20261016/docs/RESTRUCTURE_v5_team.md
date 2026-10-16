# v5 — 全員審査後の構成（2026-09-23 01:45）

> **SUPERSEDED（2026-09-26）** by `RESTRUCTURE_v6_no_decision.md` — Tak「判定の仕組みを抜いて」。v5 は判定の仕組みを増やす方向だった。

Tak（09-23 01:17）「この構成でいいのかメンバー各人でじっくり考えて」→ Mike・Louis・Rachel・Katrina・Jessica・Donna が v4 を独立に審査（互いの出力は非共有）。判定は 6/6 で **adopt with changes**（Jessica は Go・条件 3）。全員が一致した点: **方向は正しい。だが「六段の決定関数」を看板にするな。** v2/v3/v4 は本ファイルに superseded。

## 0. 目的と主張（変更なし、言い方だけ確定）
目的: 併合戦略を取る sponsor が、どの地域と併合するかを再現可能に決める方法を提案する。
主張（Jessica の一文）: 併合相手の選択は、**sponsor が指定できる定数で較正される per-EM W₁ の Lipschitz bound**、**推定対象が決める集約規則**（凸性 → pairwise / 直径 → shared pool）、**閾値が planning 例数で解像するかの必要条件** — この三つに還元できる。
看板は「四つの定理・条件」であって「手続き」ではない。手続き（入力 → 出力）は §1 の roadmap 一文と Figure 1 に一度だけ出す。

## 1. v4 からの修正（全員の指摘を統合）

| # | 修正 | 誰が | 理由 |
|---|---|---|---|
| 1 | **六段 → Methods 五小節と 1:1**。S6（L_UB 感度）は段から外す — 手法の部品ではなく L* 列上のカットを滑らせる算術で、格上げは判断①（第三の robustness 項目を落とした）を無言で再開する。S2 と S3 は同一不等式 `Δ_max = L·W₁ ≤ Δ_clin ⟺ W₁ ≤ τ ⟺ L* ≥ L_UB` の順逆読み → 一小節 + Corollary 一行 | Louis, Jessica, Mike | P5、判断① |
| 2 | **§2 は対象から開ける**（distance・bound・定数・必要条件）。手続き box を §2 冒頭に置かない — 置いた瞬間 editor は SOP を読む（Jessica の No-Go 条件） | Jessica | methods paper として |
| 3 | **列挙は 1 セット**。三つの問い ↔ 五小節 ↔ gap の写像表を §1 roadmap に一度だけ。Discussion ¶1 L691「three gaps identified in Section 2.1」は圧縮でなく**訂正**（(iii) は §2.1 に無い）。"currency" の二重使用（§3.1 scoring currency / §3.2 二通貨）は片方を改名 | Donna, Louis | D1 の再発防止 |
| 4 | **決定写像と二つの estimand を Definition として書く**（現行 §2.1 は eq(1) だけの prose-only）。未解決 partner の扱い・α・anchor の指定を規則の一部として明文化。GUSTO の出力は「6（compatible 基準）／2（demonstrated 基準）」を並記し分裂を規則にする | Louis, Mike | 「同じ入力で答えが 6 か 2 に割れる」 |
| 5 | **EM をまたぐ AND は rule ではなく assumption**。Prop. 1 は per-EM の bound で、周辺 W₁ は joint W₁ を抑えない（μ={(0,0),(1,1)}, ν={(0,1),(1,0)}: 周辺 0、joint 1）。additive separability τ(x)=Σ_k τ_k(x_k) を置いて |Δτ̄| ≤ Σ_k L_k·W₁^(k)。AND は joint を **K·Δ_clin** までしか抑えない — **GUSTO の joint eligible 6 地域の additive Δ_max は 1.064–1.586 %pt で全て Δ_clin = 1 %pt を超える**。地域方向の 2τ exposure と同型（EM 版の triangle inequality）。→ §2.5 で仮定と和 bound を述べ、joint 保証が要る場合の τ_k = Δ_clin/(K·L_UB,k) を選択肢として書く。Discussion L720 の "conservative approach based on the maximum Δ_max" は joint に対して conservative ではないので一句限定 | Mike | **新しい科学的発見。Tak 判断** |
| 6 | **§3.2 の表は二通貨ではない**。CSV で検算すると best sensitivity @ viol_anchor≤5% と @ viol_pair≤5% は 20 セル全部で同一 → 証拠にならない。差し替え: nesting（同一 τ で CLUST ⊆ ANCHOR）を **lemma として先に**述べ、fixed-τ exhibit（Set4 τ=4.51: anchor 違反 0.046→0.005 に下がりながら pool 違反 0.074→0.252 に上がる = 定理が出せない唯一の中身）、τ が oracle（真の群間距離の中点）である scope limitation を一文。100k sim が定理に足すもの: 頻度・構造 vs 標本の分離・推定誤差の代価 | Louis, Mike | 09-22 の私の指示が誤り |
| 7 | **§3.0 に証拠マップ**: S1・S5 には sim、S2・S3 は定理ゆえ設計上 sim なし（θ を特定する検証は禁止事項）、S4 の基盤は Study 1 の境界挙動。「§2 = dependency order、§4 = execution order」を一文で宣言 | Mike | §3.2 が effect-tracking と誤読されるのを防ぐ |
| 8 | **§4 は物理的に並べ替えない**。承認済み散文（判断①②④⑤）を再び開けるだけ損。§4.1 冒頭一文で段対応と「解像度を先に見る理由」を述べ、小節見出しに段番号 | Donna, Louis | Tak の turn を減らす |
| 9 | **落としてはいけないもの**: CDF 形（推定量本体）と KR dual（Prop. 1 の engine）は両方 load-bearing、quantile 形のみ一句に。正規化冗長性は「original units」の唯一の根拠 → Corollary 一行 + Supp A。漸近は本文二文（universal critical value が無い = bootstrap の必然、境界の非正則 = null floor の理由）。削ってよいのは Appendix A.1 のみ（T7）。TV(τ) 比較は §2.3 に着地 | Mike | v4 は削りすぎ |
| 10 | **§2.5 の三命題（凸性・2τ・直径）と証明は新規執筆**。Appendix に存在しない（A.1 非負性 + A.2 漸近のみ）。外部文献は不要 — "by construction"。近似比文献（Arutyunova 2024）を引くと誤 citation | Mike, Rachel | v4 は「移動」と書いたが移動元が無い |
| 11 | **Figure 1（手法全体の模式図）を新設** — 読者が手法を一目で見る図が今は無い。R/ggplot、width 7 in、base_size 11、greyscale #1A1A1A、手法が担う段は実線、sponsor 判断（入力、L_UB）は破線。caption は描画内容のみ | Katrina | P1 |
| 12 | float 予算は 4 図・11 表のまま吸収可: `fig:simulation`（表と重複）と `tab:app_allmethods`（防御）→ Supplement（**Tak 承認要**）、`tab:scenarios` → 本文記述、`tab:gusto_r8` → S0 入力表に統合（Δ_clin・L_UB・estimand・α・データ源）、§3.2 exhibit 表と S6 → §4 の感度は既存 CSV から | Katrina | |
| 13 | **E17 の pooled regions（地理）と pooled subpopulations（地域横断・factor 共有）の区別** — 本論文の S5 は後者の軸を持たない。scope 外と明記（「意図的に外すもの」に追加） | Rachel | 原典 glossary |
| 14 | Intro の連鎖段落に小宮山の三譲歩（recipe 完備／Lasso 優位／pool 数 ≤ 4 は彼らの答え）を明示の一文で。§5 まで遅らせない | Rachel | outline §7 |
| 15 | outline §2.3 L158 の修正前文言（「meta-regression が per-unit slope を報告」）を tex L184 の承認済み文言（平均傾きは下界）に訂正 — 折り畳み時の regression 防止。§2.4 に del Barrio 1999 と Andrews 2000 を接続 | Rachel | |
| 16 | 案A の反転は台帳 §9 の却下理由を引用して反駁する形で書く。¶1+¶5 統合は判断④の sole carrier を誰が担うか明文で再指定し独立承認。R3.2（notation table）の処遇を骨格 Pass 前に決める。title/abstract の**方向**（partner selection を主語にするか）は §1 執筆前に決める、文言は Terminal | Jessica, Donna, Louis | |
| 17 | キュー (3)（L208「induces the threshold」と L720「deliberation rather than binary decisions」の対）を**最初に**決着。τ の導出を残すなら "no cutoff" の言い回しを、"no cutoff" を残すなら τ の導出を、整合させる | Jessica | S3/S6 の両立 |
| 18 | 数値訂正 1 件: 09-22 の anchor 段落 "13--16% at n = 25 in the same configurations" — 3 cell なら 8–16%（Set1 τ9.2 CLUST は 0.084）。"13–16%" は 2 cell の帯 | Mike | 要修正（本日） |

## 2. 確定した構成
- **§1 Introduction**: 決定 → E17 が与えるもの（分布の類似で pooling を記述、interaction test の低検出力に言及）と与えないもの → 小宮山が与えるもの（三譲歩）と欠けるもの → 三つの問いを依存関係の連鎖で一段落 → 貢献 → roadmap（三問 ↔ 五小節 ↔ 証拠の写像表、手続きの一文、Figure 1 参照）
- **§2 Methods（一章、対象から開ける）**: 2.1 問題設定 — 二つの estimand の Definition、入力（判断）と出力（審議材料）、Figure 1／2.2 per-EM W₁ と推定（CDF 形 + KR dual、quantile 形は一句、estimator、bootstrap、漸近二文）／2.3 異質性 bound と較正 — Prop. 1、定数と順序（M1-B、TV 比較）、一つの不等式の三読み（Δ_max / τ / L*）+ Corollary、正規化冗長性 Corollary、L_UB は判断・safety factor／2.4 解像可能性 — null floor、未解決の扱いを規則として、del Barrio・Andrews／2.5 距離から partner 集合へ — Lemma（凸性 → anchor screen）、2τ exposure、直径 cut、**EM 方向: 加法性の仮定と和 bound、K·Δ_clin**、pooled subpopulations は scope 外
- **§3 Simulation**: 3.0 証拠マップ + 三つの例数言明 + dependency/execution order の宣言／3.1 識別（Study 2、clustering は scoring 検証として一段落）／3.2 集約規則と推定対象（nesting lemma → fixed-τ exhibit → oracle τ の限定）／3.3 推定量の基盤（Study 1、表据え置き、load-bearing を名指し）
- **§4 GUSTO**: 小節は現行のまま、見出しに段番号、§4.1 冒頭一文。S0 入力表。出力は「6／2」並記。既存指標との一致（Table: agreement with W₁）と直径開示は現行の場所
- **§5 Discussion**: ¶1 三問ごとに一文（GUSTO の一致の担い手を明記）／答えが変わる状況／小宮山／限界（¶D + AND の加法性 + pooled subpopulations）／実務・方針／今後
- Appendix: Prop. 1、**Lemma（凸性）・2τ・直径の証明（新規）**、漸近。A.1 は Villani 引用に（T7）。コードは SI

## 3. Tak の判断（束ねて 1 turn）
1. キュー (3): τ の導出と "no cutoff" の整合（Option A/B/C を次に出す）
2. 案A: §3.2 昇格（台帳の却下理由への反駁付き）／Discussion 留置 + Supplement 表／現状維持
3. ¶1+¶5 統合の可否と sole carrier の再指定
4. **AND の加法性**: 仮定として開示のみ／τ_k = Δ_clin/(K·L_UB,k) を選択肢として本文に／GUSTO の joint Δ_max（1.064–1.586 %pt）を開示するか
5. title/abstract の方向（partner selection を主語に）
6. R3.2 notation table の処遇、`fig:simulation`・`tab:app_allmethods` の Supplement 移動

## 4. 実行順序（Jessica、Donna）
pre-flight（本日 recompile・verify-numbers・LAB_STATUS 同期・response letter の location を節/段落アンカーに・v2–v4 superseded・baseline commit）→ キュー (3) → 上の判断 6 件を 1 turn → team のみで移動・renumber・C1 cascade grep・recompile → 新規散文の段落レビュー（§2.1 → Intro 連鎖 → §2.5 → §3.2 → Discussion ¶1、依存順、≈7 turn）→ minors → location 列を一度 → Terminal（abstract、title 文言）。**新設散文は段落レビューを通るまで draft placeholder**であり「適用済み」と扱わない。

## 5. 数値の裏取り（Mike、CSV 突合）
61–68% @ n=50 ✓、45–61% @ n=400 ✓、Set4 τ4.51 の逆方向 ✓、"at most 0.9%" ✓、pairwise の sensitivity 優位は world×n 20 群すべて ✓（cell 単位 47/48、同点 1）。**"13–16% @ n=25" は要修正（8–16%）**。joint eligible 6 地域の additive Δ_max: R1 1.369 / R4 1.076 / R5 1.064 / R6 1.586 / R14 1.575 / R15 1.555 %pt（09-23 訂正: 正本 `results/gusto_operability.csv`、旧値は tex 表の2桁丸めから計算）。

## 6. チーム推奨（09-23 22:55 meeting、Tak 未承認）
| # | 推奨 | 賛否 |
|---|---|---|
| 1 キュー(3) | τ 導出は残す。L720 "rather than binary decisions" を限定（τ はスクリーニングの参照点、審議材料は CI 付き Δ_max/L*） | 6/6 |
| 4 AND 加法性 | 仮定 + 和 bound + GUSTO joint Δ_max（1.064–1.586 %pt）を開示。τ_k は選択肢一文、GUSTO 非適用（K=2 分割で通過 0 地域）。L617/L625/L693/L720/abstract に限定句 | 実質 6/6（Jessica: Go 条件） |
| 2 案A | Discussion 留置 + 表は Supplement。昇格は §2.5 の証明執筆後に再審 | Mike・Louis・Donna／Jessica・Katrina は昇格（Rachel は棄権） |
| 3 ¶1+¶5 | 統合しない。¶1 の "three gaps" は訂正必須。sole carrier は ¶5 のまま。判断④に触れる旨を前置き | Mike・Donna／Jessica・Louis・Katrina は統合 |
| 5 title/abstract | 主語は動かさない（scope = Q_metric）。abstract の "previously qualitative judgment" は削除 | Louis のみ（Mike は条件付きで主語変更可）／Jessica・Katrina・Rachel は主語変更。Harvey は scope = Q_metric（Tak 07-12）を優先 |
| 6 R3.2 ほか | notation table を §2.1 に新設、`fig:simulation` → Supplement、`tab:app_allmethods` は本文に残す | table: 5/6（Rachel は Supplement 案）、app_allmethods 残置: Jessica・Louis・Donna |
Tak への提示順: ④+① → ② → ③ → ⑤ → ⑥（②③は既決に触れる旨を前置き）。
