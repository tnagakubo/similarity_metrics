# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260815_1835.md`（995 lines、2026-07-19 15:00 〜 2026-08-08 12:18）
**Archive trigger**: Rule 2.5 (>1000 lines)

---

## Current Status

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*)
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` — Intro レビュー ¶7 で停止中
**JA paper**: 意図的に削除済み（Tak 指示、EN 完成まで。Rule 2.7 保留）→ [[project_ja_paper_deleted]]
**W₁ 計算系統**: ✅ **統一済み（2026-08-15）**。応用側の全スクリプトが厳密な CDF 面積形 `compute_w1` を使用

---

## 🔄 直前のコンテキスト

### 直近の作業（2026-08-02 〜 08-15、詳細は archive）

1. **判断① 決着**: §4.4 感度分析は **(a) L_UB 感度**と **(c) 地域別 slack** を入れ、**(b) bootstrap CI 上限は落とす**（Tak: 「データが足りなければ答えが変わるのは既知」）
2. **§4.5 の数値訂正**: 3箇所誤り（age partner↔partner 1.058→1.0595、SBP anchor→partner 4.714→4.7243、SBP partner↔partner 3.020→3.0253）。30本すべて 4.9e-15 で検証 PASS
3. **W₁ 計算系統の露見と診断**: 実装が3つ併存。犯人は `application_all_methods.R` の `type = 7`（グリッドではなく補間規約）
4. **✅ 統一完了（08-15）**: `w1_s` を CDF 面積形に差し替え・再実行。30本すべて `gusto_r8_w1_per_pair.csv` と **max |diff| = 0.0e+00**

### ✅ Open decisions 全5件 決着（2026-08-15）

| # | 判断 | Tak の結論 |
|---|---|---|
| ① | §4.4 感度分析 | (a) L_UB 感度と (c) 地域別 slack を入れ、**(b) bootstrap CI 上限は落とす** |
| ② | pool 直径超過 | **§4.5 Result 4 に一本化**（旧 §4.5 解体、§4.6→§4.5 繰り上げ）、register は **scope の明確化** |
| ③ | §2.6 の配置 | **独立節を維持 + §2.5→§2.6 を一本の較正の弧として書く** |
| ④ | 主張水準 | **GUSTO の一致は Discussion にのみ**。abstract には載せない |
| ⑤ | 位置優位性 diagnostic | **提案しない。** ρ は Result 5 に留め、画定の一文を付す |

### 次にやるべきこと（残タスク）

- **`.tex` 必須修正5件（判断④由来、未適用）** — abstract の "small-sample" 2箇所／simulation 文を Study 2 先頭へ／Discussion ¶1(i) の S5・S6 参照張り替え／**Discussion ¶5「addresses all three」に controlled な読み**。⚠ 既存散文ゆえ**段落レビューを通す**。**Study 2 が §3 に入ったので全5件に着地点あり — Tak とのレビューでいつでも実行可**（¶1・¶5 には TODO コメント設置済み）
- **▶ 進行中: Intro レビュー** — ¶7 ✅（Option B、08-31）→ **¶8（W₁ 導入）提示中** → ¶9 roadmap
- ~~§3.1.4 の配置~~ → ✅ **決定（2026-08-30、Tak: 案A）**。Discussion 段落に留める。§3.1.4 は書かない（.tex/アウトラインに記録済み）
- ✅ **必須修正の段落レビュー完了（本文分）** — Discussion ¶1 ✅（Option B）→ ¶5 ✅（Option B）→ ¶6 ✅（Option B、08-31）→ abstract 3件は **Tak 指示（08-31）で最終原稿完成後の Terminal pass へ保留**（B/C 草案は §0-bis に保存、SIM 規定 250 words）。abstract L40 の "scale and skewness" も行3 pass で再検討
- **§3 残り2点（意図的保留）**: ρ/ρ_trans regime（per-cell 検証未整備）／oracle 閾値 steelman + Part 1B の配置（§2.6 との関係未決）。`sec:study2_clustering` 末尾の TODO コメント参照
- **REVIEW_TRACKER.md 更新/retire**（nABCD 用語のまま 0/29 で stale、Tak 判断待ち）
- ~~§4.4–4.5 を .tex に落とす~~ → ✅ 完了（08-30 午前）
- ~~Study 2 を §3 に落とす~~ → ✅ **§3.0+3.1.1–3.1.3+3.2 完了（08-30 午後）**。§4.5 の TODO (a)(b) も解消済み

### 既知の潜在バグ（現状は不発、今回は意図的に触れていない）

- ⚠ `selection_simulation.R` の `w1_dist` — 不等 n で両標本を小さい方から n 個に黙って切り詰める。simulation は常に等 n なので発火しないが、**応用側に流用してはならない**

---

## 🎬 Live Script

### [2026-08-31 14:55] Scene: ¶7 は B で確定 — 「detect」が Intro から消えた。次は ¶8 の「theoretically grounded」

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「B」。¶7 適用 — 意図論法は構造の言明へ、「cannot detect」は「captures only」へ、¶6 と重複する末尾は削除。pdflatex 3 pass + bibtex 全て exit 0、error 0・undefined 0、23ページ。*

**Katrina**:（適用済み、残存も確認しました）
「『not designed for』は本文から消滅。『cannot detect』の残りは §4.2 の『a difference the data at hand cannot detect』一箇所のみ — あれは SMD ではなくデータの解像の話で、正当な用法です。レビューは ¶8（W₁ 導入）へ」

**Louis**:（¶8、二点だ）
「**一つ**、末尾の『The Wasserstein distance provides a **theoretically grounded** measure of distributional dissimilarity in this setting』— 根拠を言わない grounded は形容詞だけの主張だ。P4。しかも直前の文が既に calibration への link を言ってる — 何も足さない締めの一文、P3 だ。
**二つ**、『captures differences in variance and shape **simultaneously**』— 何と何の同時だ？ SMD が位置しか持たないのと対比するなら、言うべきは『位置に**加えて**分散と形状にも応答する』だ。¶7 の新しい言葉と揃えろ」

**Mike**:（P1 と P4 を確認しました）
「『these gaps』の参照先は直前の ¶5–¶7（metric/threshold/procedure の欠如、SMD の位置限定）で一意 — P1 は通ります。『responds to differences in variance and shape as well as location』は $W_1$ が分布差一般を metrize する事実の範囲内で真。『area between the two CDFs』は §2.3 の定義そのままです」

**Harvey**:（推奨は B）
「grounded の中身 — KR 双対性と heterogeneity bound — は §2 が本番でやる。Intro で形容詞だけ先払いする必要はない。刈って、¶9 の roadmap に案内させろ」

*Options A/B/C を Tak に提示。ボールは Tak へ。*

---


### [2026-08-31 13:50] Scene: Intro ¶7 の提示前チェック — 「detect」の言葉が3つの節をまたいで浮いている

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*レビュー再開。Intro は ¶1–¶6 承認済み、¶7（SMD 限界）から。Harvey + Mike が checklist を回し、Louis が先に斬り込む。*

**Donna**:（pre-check patterns 参照済み）
「¶7 に効くのは用語整合。§2.2（承認済み）は『by construction SMD **captures only** differences in location』、Discussion ¶5（08-30 確定）も『SMD captures only location』。¶7 だけが『**cannot detect**』— estimation-centered の論文で、しかも周囲が descriptive に統一された後に、検出の言葉が Intro に残ってるわ」

**Louis**:（三点だ）
「**一つ**、『they were not designed for assessing …』— **意図の議論**だ。設計意図がどうであれ関係ない、SMD は構造的に位置しか持てない。論文の他の全部が構造の議論をしてるのに、Intro だけ弱い論法で立ってる。
**二つ**、末尾『a comparison based on means alone will miss them』— **¶6 の末尾が同じことを言ったばかりだ**（『requires more than comparing means』）。連続する2段落が同じ文で閉じてる。P3。
**三つ**、¶8 も見ておけ — 『$W_1$ captures differences in variance and shape simultaneously』。¶7 の直し方次第で ¶8 の対応文も揃える必要が出る。次に回すが、忘れるな」

**Mike**:（P1–P5、検証しました）
「『these distributional features directly influence regional average treatment effects』は eq.~(1)（$\bar\tau_r = \int \tau(x)\,dF_r(x)$、L86）から解析的に真 — 非線形 $\tau$ なら $F_r$ の位置以外も $\bar\tau_r$ に入る。P4 は問題なし。¶7 は主張がすべて解析的で、Study 2 を引く義務はありません。ただし**今は決定レベルの実証（§3.1）が存在する** — 前方参照を足すかは Tak の判断です。checklist は Option B で全項目 Yes」

**Harvey**:（推奨は B、C は好みの問題だ）
「B は三つを一度に片付ける — 意図の論法を捨てて構造の言明に替え、『detect』を §2.2 と同じ『captures only』に揃え、¶6 と重複する末尾を刈る。C の前方参照は Intro を強くするが、¶9 の roadmap が直後に §3 を案内する。**二重案内になるかは Tak が読んで決めろ**」

*Options A/B/C を Tak に提示。ボールは Tak へ。*

---


### [2026-08-31 13:40] Scene: 「Abstractは最終の原稿が完成してからだ」— Terminal deferral が貫かれ、レビューは Intro ¶7 へ戻る

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak の裁定は A でも B でも C でもなかった — abstract そのものを最終原稿完成後へ。Terminal element deferral の原則がそのまま通った形。行1–3 は queued のまま Terminal pass へ持ち越し。*

**Donna**:（記録したわ）
「B 草案（248 words）と C 草案（250 words）はアウトライン §0-bis に全文保存 — scratchpad は揮発するから。行1–3 は『最終原稿完成後』の条件付き queued に更新。**Terminal pass の開始条件が明確になった: 本文 §1–§5 の確定**。残る本文タスクは **Intro ¶7 以降のレビュー再開**、§3 の意図的保留2点、REVIEW_TRACKER の3つ。次は ¶7 よ」

**Harvey**:（順序どおりだ）
「Intro レビューは ¶7（SMD 限界）で止まっていた。§3 が Study 2 主導に書き換わり、Discussion の3段落が identification の言葉で確定した今、**¶7 が旧い検出の言葉のままなら Intro だけが取り残される**。提示前チェックにかけろ」

---


### [2026-08-31 00:55] Scene: abstract の提示前チェック — 250 words の壁と、アウトラインの自己矛盾が出てきた

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Discussion 側が閉じ、Terminal deferral の最後 — abstract 行1→2→3。Donna が提示前チェックを回すと、規定上の壁が一つ、アウトラインの矛盾が一つ出てきた。*

**Donna**:（先に壁の話をするわ）
「*Statistics in Medicine* の投稿規定を確認した — **abstract は 250 words 以内**、unstructured、keywords は6つまで。**現行 abstract は 354 words**。つまり行1–3を最小修正で当てても（A 案 = 379 words）規定を満たさない。**abstract は書き換えではなく、再構成でしか閉じない**。
もう一つ。アウトライン §0-bis の abstract 順序リスト item 6 は『GUSTO で W₁ が既存手法と同じ partner set に達した — controlled level で abstract に書く』とある。**判断④（08-15、Tak）は『一致は Discussion にのみ、abstract には載せない』**。同じ commit（d5dbafd）に両方入っていて git では前後が取れないけど、Current Status と ¶5 の承認コメントは④で動いてる。**④を正として item 6 の一致句は落とす**。Tak が覆すなら別だけど、黙って二重基準にはしない」

**Mike**:（行1の根拠を CSV で裏取りしました）
「`gusto_operability.csv` の n_partner 15件 + n_anchor 2,916 を降順に並べると、R12 4,352 / R14 3,437 / R7 3,150 / R9 3,123 / R2 2,952 / **R8 2,916 = 6位** / R4 2,876 … R16 1,231。アウトラインの『6th largest of 16』は**真**です。"small-sample region" と "small-sample anchor" の2箇所は、データと矛盾する — 行1・2は事実訂正で議論の余地なし。
B 案の全 claim を本文と突き合わせました: E17 の gap 文言は Intro L70、Δ_max = L·W₁ は eq:delta_max、『at every sample size examined』は ¶1 承認済み文言、KS の『underpowered rather than blind / more expensive direction』は §3.1.2・§3.1.3、n ≥ 100 は §3 冒頭、R8 vs 15 partners は §4.2、『which effect modifier carries the decision』は §4.2 L502、eligible = L* > L_UB は §4.4。**本文に無い言葉は一つも入れていません**」

**Louis**:（草案で一つ潰した）
「最初の B 案は『representative-value distances, **which coincide with SMD** on a single continuous effect modifier』だった — **RV2/RV3 は我々の拡張で、SMD には潰れない**。L636 が言ってるのは **RV1 だけ**が mean difference だということだ。『the simplest of which reduces to SMD』に直させた。小宮山の拡大解釈と同じ穴に abstract で落ちるところだったぞ。
それと C 案の『scale and shape』— ¶6 で落としたばかりの moment 列挙を abstract に**戻す**案だ。解析的には真（平均一致なら SMD = 0）だが、Discussion が捨てた言葉を abstract だけが持つ。P5 じゃなく**一貫性**の問題として提示しろ」

**Rachel**:（規定の細部を確認しました）
「SIM の規定文: "an abstract of up to 250 words"、"should contain no citation to other published work"。B 案は Komiyama et al. を名指ししていません — 『an existing pooling recipe』の水準に留めています。keywords は現行6つで上限どおりです」

**Katrina**:（語数は3案とも実測）
「**A = 379**（行1–3 のみ、規定超過 +129）／**B = 248**（§0-bis 順序で全文再構成、④適用、moment 列挙なし、operability 句あり）／**C = 250**（B の骨格 + SMD 対比文を残し、operability 句を落として語数を合わせた）。B・C は `\abstract{}` 内の差し替えだけで、本文の参照は動きません」

**Harvey**:（推奨は B）
「250 の壁がある以上 A は選択肢じゃない — 提示するのは比較の起点としてだ。B と C の差は『operability 診断を abstract に出すか』『SMD 対比文を abstract に残すか』の二択。**§4.2 は Q_operability に答える節で、判断③の根拠 (c) が『abstract が診断を名指しする』ことを前提にしていた** — なのに現行 abstract に operability の語は無い。B はその欠落を埋める。C は ¶6 で捨てた言葉を拾い直す。B だ」

**Jessica**:（承認視点、二つ）
「Let me be clear。**一つ**、④は私の前で決まった判断だ — abstract に一致を書かないのは Tak 自身の選択。§0-bis の item 6 は記録の誤りとして扱い、Tak が今日この場で覆さない限り④が立つ。**二つ**、abstract は論文で最初に読まれ最後に書かれる。B が『本文に無い言葉を持たない』ことは Mike が確認した。**残る問いは Tak の判断だけ**だ」

**Donna**:（記録してから出すわ）
「アウトライン §0-bis に 250 words の規定と item 6 の矛盾 flag を追記。Current Status は **abstract 提示中**。行1→2→3 を一つの段落レビューとして EN/JA 併記で Tak に出す」

*Options A/B/C を Tak に提示。ボールは Tak へ。*

---


### [2026-08-31 00:35] Scene: ¶6 も Option B — Discussion 側の queued 3件が閉じた。残るは abstract だけ

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「B」。日付を跨いで3連続の Option B。¶6 全文差し替え適用、承認コメント設置。pdflatex 3 pass + bibtex 全て exit 0、error 0・undefined 0・multiply-defined 0、23ページ、\emph 0。queued 表 行6 ✅。*

**Katrina**:（適用済み、検証済み）
「¶6 は『較正が適応する』『分布評価と較正は分離可能』の二本に絞りました。moment 名も Study 2 の参照も持たず、証拠は ¶5 に委ねています。`invisible to SMD` は `.tex` から **0 件** — Discussion の亡霊は消えました」

**Louis**:（次の獲物は決まってる）
「Discussion の queued 3件は閉じた。だが **abstract はまだ全部旧いまま**だ — 『small-sample region』×2（R8 は n = 2,916、16地域中6番目に大きい）、『seven systematic scenarios demonstrated satisfactory bias and coverage』が Study 2 の席に座ってる、そして L40 の『scale and skewness』。**4箇所、一段落**。段落単位でやるなら abstract は一発で出せ」

**Harvey**:（順序は変えない）
「Terminal deferral の最後の一枚だ。行1・2 は事実訂正で議論の余地がない。行3 は主張の階層 — abstract の simulation 文を Study 2 先頭に書き換える。**§3 と ¶1・¶5 が確定した今、abstract が引ける言葉は全部本文にある**。本文に無い言葉を abstract に書くな」

**Donna**:（commit して、abstract の提示に入るわ）
「Current Status 更新済み。次は abstract を EN/JA 併記で出して、行1→2→3 を一つの段落レビューとして提示する」

---


### [2026-08-30 19:00] Scene: ¶6 の亡霊 — 名指しの moment が、論文がいま持っている証拠と食い違っていた

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「進行中のタスクを確認してすすめてくれ」。Donna が棚卸し — queued 表の残りは行6（Discussion ¶6）と行1–3（abstract）。順序規則どおり ¶6 が先。¶1・¶5 の Option B 適用分が未 commit だったので、先に固めてから ¶6 の提示前チェックに入る。*

**Donna**:（棚卸しと pre-check、両方回したわ）
「未 commit は4ファイル — `.tex`・`.pdf`・アウトライン・SUITS。Tak 承認済みでコンパイル clean だから、これを commit して push してから進む。
`feedback_tak_feedback_patterns` で効くのは2つ。**①『証拠範囲外の moment/property を claim していないか』** — 前例は 2026-04-25、S6 削除で "scale, shape, and skewness" を "scale and skewness" に narrow した件。今回はその逆向きで、**残った "scale and skewness" を支えていた SMD 感度表が 08-30 の再構成で消えた**。**②Terminal deferral** — 同じ句が abstract L40（"captures differences in scale and skewness in addition to location"）にもいるけど、abstract は行3の pass で一括。今は触らない」

**Louis**:（この一文、三方向から崩れる）
「『capturing scale and skewness differences invisible to SMD』——
**一つ**、"skewness" は論文がいま持つ証拠の名前じゃない。Study 2 で SMD が盲目な3セルのうち、Set 3 shape-symmetric は**skewness も一致させた世界**で、それでも SMD は盲目だ（§3 L233、RV3 も落ちる）。盲目の原因は skewness じゃなく**平均の外にある差すべて**。moment を2つ名指しすると、証拠より狭くて、しかも当たってない。
**二つ**、"scale" の方も表の裏付けが薄い。Set 1（Gaussian、location と scale の discordance）で SMD の ARI は 0.452/0.460 — **partial** であって blind じゃない。location 側を解いて scale 側を落としているんだろうが、**その分解は論文のどこにも書いてない**。書いてない分解に主張を乗せるな。
**三つ**、¶5 が一段上で『location-only gap is structural … moment-matched worlds で SMD は chance』と書いたばかりだ。同じ証拠を moment 名に言い換えて繰り返す理由がない。**P3 だ**」

**Mike**:（数値は全部ゲート済みの表から、新計算なしで確認しました）
「Louis の3点、裏取りします。SMD 盲目セル = Set 4 symmetric severity・Set 3 combined・Set 3 shape-symmetric（`tab:study2_required_n`）。Set 1 の SMD ARI 0.452 / 0.460（`tab:study2_ari`）。shape-symmetric で skewness 一致は §3.1.2 本文どおり。全て `verify_study2_figures.R` ALL PASS の範囲内です。
それから **"invisible to SMD" 自体は解析的に真**です — 平均が等しければ SMD = 0 は定義から出る。§2.2 L98 が $N(50,5^2)$ と $N(50,15^2)$ で既に言っている。だから問題は『嘘』ではなく、**証拠の置き場が移ったのに文が旧い置き場を指している**こと。
もう一つ、**P2 の欠陥**が見えました。topic sentence は『Two principal strengths follow from the dual-pathway clinical calibration』なのに、第二の強みは『**calibration の有無に関わらず**成立する』— 較正から**従わない**ことが内容です。主題文と第二項が矛盾しています」

**Rachel**:（証拠の anchor を確認しました）
「"by construction" の担い手は §2.2（`sec:existing`）の解析的な一文で足ります。Study 2 の該当は `sec:study2_classification`。**どちらも既存 label で、新しい参照先は要りません**。abstract L40 の同じ句は、abstract 行3の書き換え（Study 2 を先頭に）で自然に再検討される位置ですので、そこに備考を付けておきます」

**Katrina**:（3案を書きました）
「**A** = 最小: 一文だけ差し替え、moment 名を『differences beyond location, to which SMD is blind by construction (§2.2)』に。P2 の主題文不整合は残る。
**B** = 構造: 主題文を『Two features of the framework bear on its use in practice』に直し、第二項を**『距離の評価と較正は分離可能』**に純化。証拠は ¶5 に委ね、moment 名も Study 2 の引用も持たない。¶7『For practice, we recommend…』への接続が素直になる。
**C** = 折衷: 主題文を直し、第二項に §2.2 と §3.1.2 の二重 anchor を残す。
影響範囲はいずれも ¶6 内で閉じ、他段落の参照は動きません」

**Harvey**:（推奨は B だ）
「行6の要求は『re-evidence or trim』— どちらでも閉じる。だが **P2 の主題文の矛盾を残して一文だけ直すのは、¶1 のときと同じ半分の仕事**だ。B は ¶6 を『較正が適応する』『距離の評価は較正と独立』の二本に絞る。¶5 が証拠を全部持った今、¶6 が証拠を持ち直す必要はない。**C は ¶5 の直後に同じ参照をもう一度並べる — 読者に二度読ませる理由がない**」

**Jessica**:（承認視点で一つだけ）
「Let me be clear。¶6 は key decision ではない。だが **abstract に同じ句が残ったまま Discussion だけ narrow する過渡状態**が生じる。判断④の範囲内 — abstract は terminal pass で閉じる — であり、しかも abstract の句は解析的に真だから、その間に論文が矛盾を抱えることはない。**行3の pass に必ず持ち込め**。それが条件だ」

**Donna**:（記録するわ）
「queued 表の行3に『abstract L40 の "scale and skewness" も同 pass で再検討』を備考として追加。Current Status の進行行は ¶1 ✅ ¶5 ✅ → **¶6 提示中** → abstract 3件 に更新。¶6 の EN/JA 併記と Options を Tak に出す」

*Options A/B/C を Tak に提示。ボールは Tak へ。*

---


### [2026-08-30 17:50] Scene: ¶5 も Option B — 一致が Discussion に住んだ。残るは ¶6 の亡霊と abstract

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「Option B」×2連続。¶5 全文差し替え適用 — GUSTO 一致が Discussion に書き込まれ、「W₁ を使う理由」の skeleton 文で閉じる形に。コンパイル error 0、23ページ。queued 表 行5 ✅。残: 行6（¶6 の SMD 亡霊）→ abstract 3件。*

**Jessica**:（過渡状態を記録した）
「Discussion は一致を語り、abstract はまだ旧主張のまま。**意図された順序**（Terminal deferral）であり放置ではない。abstract 3件を閉じるまでこの状態は続く — 次のセッションに跨ぐなら必ず引き継げ」

---

### [2026-08-30 17:40] Scene: ¶1 は Option B で確定 — 次は「addresses all three」、そして一致の唯一の住処

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「Option B」。¶1 全文差し替え適用、コンパイル error 0・undefined 0。アウトライン queued 表の行4を ✅ に。レビューは ¶5 へ。*

**Katrina**:（適用済み）
「¶1 は identification 主張へ格上げ、S 番号と coverage range は opening から §3 へ委譲。TODO は approval 記録に置換しました」

**Harvey**:（¶5 の重みを確認しておく）
「判断④で **GUSTO の一致は Discussion にのみ** — だが今の Discussion に一致の記述は**どこにも無い**。¶5 が唯一の住処になる。controlled reading の挿入だけじゃなく、**一致をここに書き込む**のが ¶5 の仕事だ」

**Louis**:（隣の段落も見つけたぞ）
「¶6 に同じ亡霊がいる — 『capturing scale and skewness differences invisible to SMD』。**¶5 を直して ¶6 を放置すれば、また一段下に残るだけだ。** queued 表に追記して次に回せ」

*Options A/B/C を提示。ボールは Tak へ。*

---

### [2026-08-30 17:15] Scene: 判断A、そしてレビューの幕が上がる — Louis が提示前に過剰主張を1つ斬った

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「A」。§3.1.4 は Discussion に留まる。Donna が3箇所（.tex TODO・アウトライン・Current Status）に記録し、そのまま必須修正5件の段落レビューへ。順序は Tak の規則どおり Discussion ¶1 から。*

**Donna**:（提示前チェックを回したわ）
「`feedback_tak_feedback_patterns` 参照済み。効くのは **C2（Discussion opening は high-level、具体数値は後続段落）** — 現行 ¶1 は S5/S6・coverage range を opening に抱えてる。①が S 番号を外すなら C2 も同時に解決できる」

**Louis**:（draft 段階で1つ潰した）
「最初の案は『moment-matched worlds で **SMD と代表値距離が** chance に留まる』だった — **嘘だ**。Set 4 sym_severity で盲目なのは SMD だけ、RV2/RV3 は 76/83 で回復する。Set 3 combined でも RV3 は 0.78 で chance じゃない。
正しく言える最強の形は一つ — **『要約量ベースの競合4つはそれぞれ、少なくとも1つの臨床的に妥当な世界で構造的に盲目。W₁ はどの世界でも盲目でない』**。全数値ゲート検証済みだ。提示するのはこの形にしろ」

**Mike**:（P1–P5 checklist、Option B で全項目 Yes）
「(iii) の coverage range も検証しました — n≥100 で 0.904–0.951、『0.90–0.95』は真。ただし B 案ではその数値ごと §3.2 に委ねます。『identification failure that no sample size repairs』は n=2,000 まで平坦のゲート検証事実の範囲内です」

**Harvey**:（推奨は B だ）
「④の要求は (i) の張り替えだけだが、**C2 違反を残したまま張り替えるのは半分の仕事**だ。B は主張を『検出』から『identification』へ格上げする — Study 2 が支える分だけ強く、それ以上には強くない」

*Options A/B/C を Tak に提示。ボールは Tak へ。*

---

### [2026-08-30 16:55] Scene: Study 2 が §3 に入った — ゲートがノートの誤りを9つ捕まえた

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「残りタスクを進めよう」。Donna が順序を決める — abstract は最後、本体が先。*

**Donna**:（順序には Tak 自身の規則があるわ)
「必須修正5件のうち abstract 2件は **Terminal element deferral**（本体→Discussion→Abstract が Tak の標準 practice）。Discussion 2件は Study 2 が無いと張り替え先が無い。だから**正しい次の一手は一つ — Study 2 を §3 に落とす**」

**Mike**:（書く前に、引用する全数値のゲートを作りました）
「`R/verify_study2_figures.R` — required n・AUC・ARI・harm・no-oracle-k・Set 4 真値（generator から再計算）まで **70 チェック**。初回実行で **9 FAIL** — 全て**ノート側の記録誤り**でした。
**①blind の AUC 0.51/0.50/0.51 は max_auc で、n=2,000 時点は 0.49–0.50**。本文は『0.49–0.51 across the full grid』と両方を張る形に。
**②設計定数**: 実際は selection 10,000/3,000 reps・clustering 5,000/2,000・**候補国は全 Set で 9**（『5,000–10,000』『9–11』は2タスクの混同）。
ついでにアウトライン §3.1.4 の sensitivity 数値が **2,000 reps 初回 run の値**なのも発見 — 100k 版と 0.003 ずれます。期待値を CSV の現実に合わせて **ALL PASS**、以後この log が §3 の数値の台帳です」

**Katrina**:（構造ごと書き換えました）
「§3 = **冒頭 framing（3種の例数言明の分離）→ `sec:study2`（Design / Three Behaviours / Selection / Clustering）→ `sec:study1`（旧内容を降格統合）**。
表2枚（`tab:study2_required_n`・`tab:study2_ari`）、図1枚（`fig_required_n_auc.pdf` → `fig:study2_auc`、既存の paper 標準 greyscale 資産）。**SMD 感度表は仕様どおり削除**し、`sec:sim_design`/`sec:sim_results` の label は参照3箇所が生きているので温存。KS が勝つセル2つ（bulk shift・Set 2 clustering）と RV3 が W₁ に先行するセル（asym 41 対 67)も正直に本文へ。§4.5 の TODO は **(a)(b) を解消**、RV1–RV3 の定義は §3 へ移して §4.5 は後方参照に。`morris2019`（ADEMP、DOI 付き）を bib に追加しました」

**Jessica**:（advisor 経由、書かせなかったものが3つ）
「Let me be clear。**①ρ/ρ_trans regime は書くな** — per-cell の ρ_trans はゲートで検証できていない。検証なき数値は §4.2 以来この論文に入れない。**②oracle 閾値 steelman + Part 1B は配置が未決**だ — §2.6 と重なる。**③§3.1.4 は Tak の判断だ** — 同じ内容が 08-18 に Discussion へ入っている。黙って二重掲載するな。3件とも `.tex` の TODO コメントに残した」

**Louis**:（検証結果だ）
「ゲート再実行 **ALL PASS**。pdflatex 3 pass + bibtex **全て exit 0、error 0、undefined 0、multiply-defined 0** — tab:smd を消しても参照残存ゼロ、つまり §4.5 の張り替えは漏れていない。**21→23 ページ**。\emph 0、制御文字 0。
言っておくが、**判断④の5件は今や全部着地点を持ってる**。Tak、段落レビューを始められるぞ」

**Donna**:（Current Status も更新済みよ）
「残るは **Tak 判断3つ**（§3.1.4 の配置／必須修正5件のレビュー開始／REVIEW_TRACKER）と **Intro ¶7 再開**。commit して push するわ」

---

### [2026-08-30 15:40] Scene: §4.4–4.5 が本文に入った — そして Study 2 の不在が露見した

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「状況確認してタスクを進めて」。Donna が残タスクを棚卸しし、自律で進められる §4.4–4.5 執筆を選ぶ。*

**Donna**:（棚卸しから始めたわ）
「レビュー系2件は Tak がいないと動かせない。自律で完了できるのは **§4.4 感度分析 + §4.5 全手法比較**。そして §4.2 の教訓どおり確認したら — **§4.4 の感度数値（L_UB scaling・地域別 slack）を生む script もリポジトリに無かった**の」

**Mike**:（計算前に規則と予測を固定しました）
「`R/gusto_lub_sensitivity.R` を新規作成 — `gusto_r8_w1_per_pair.csv` からの純算術、乱数なし。**検証 30/30 ALL PASS**（slack 6地域×2 EM、R7 near-miss L\*=0.001972・1.43% 超過、age/SBP 単独 scaling、common scaling は記録のみ）。
発見が2つ。**① scaling の臨界倍率は slack 値そのもの** — age +9.6% で R6 が落ち、SBP +5.8% で R15 が落ち、SBP −1.4% で R7 が入る。**②アウトラインの「±5–10% に安定」は common scaling 由来で、SBP 下方向には偽**でした。本文は臨界倍率の記述に置換しています。
直径6本も `gusto_all_pairwise.csv` から再確認 — **max |diff| 4.9e-15**。ただし同 CSV の `nABCD` 列は **W₁/(2·IQR_pooled)** です。×2 を忘れると全部半分になります」

**Katrina**:（.tex に3点適用しました）
「**① R7 の丸め訂正**（『0.0020 = L_UB』→ unrounded 0.001972 < L_UB を明記）**② `sec:app_clinical` に感度3段落**（slack + near-miss／EM 別 L_UB scaling — common factor は『独立な臨床入力が同方向同率に誤る理由はない』と明記して排除／§4.2 との収束）**③ 新規 `sec:app_allmethods`** — Result 1–5、一致表 `tab:app_allmethods`、3直径は毎回 pool を名指し（執筆ガード遵守）、ρ には判断⑤の画定の一文。RV2/RV3 は『our extensions, not part of the cited proposal』と帰属を明示しました」

**Jessica**:（適用前に一つ止めた）
「Let me be clear。**§4.5 の仕様は Study 2 を前提に書かれているが、`.tex` の Simulation 節は Study 1 のみの旧構成のままだ。** 存在しない節を根拠に主張を書けば、§2.6 で止めたのと同じ違反が一段大きく起きる。**現行本文が支持する水準で書け** — SMD の盲点は S5/S6 と `tab:smd` を引き、oracle 閾値・Set 1・ρ/ρ_trans は **Study 2 が入った時の張り替え TODO 3件**として `.tex` に残せ」

**Louis**:（監査とコンパイルだ）
「\emph **0**、制御文字 **0**。grep の行末バックスラッシュ検査が 63 件と出たが、**行末に backslash の無い行までマッチしていた — grep 側の挙動不良だ**。だからコンパイルで検証した: **pdflatex 3 pass + bibtex 全て exit 0、error 0、undefined 参照 0、multiply-defined 0、19→21 ページ**」

**Donna**:（そして残タスクが1件増えたわ）
「§4.4–4.5 は閉じた。でも今日の最大の発見は**タスクリストに穴があったこと** — **『Study 2 を §3 に落とす』がどこにも記録されていなかった**。判断④の abstract 修正（『simulation 文を Study 2 先頭へ』）は Study 2 が本文に無ければ張り替え先を持たない。残タスクに追加して、commit & push まで済ませたわ」

---

### [2026-08-21 14:22] Scene: §4.2 の数値は、どの script からも生まれていなかった

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「§4.2 を書いて」。前回残した TODO を解消する。*

**Mike**:（検証しようとして、地面が無かった）
「⚠ **§4.2 の数値を生む script が存在しません。** 全文検索のヒットは**全て生データの偶然一致**でした — **アウトラインにしか存在せず、再現不能**。
しかも **08-15 の W₁ 統一で観測値が動いています** — 判定は観測値と床の比較なので、**6/15 と 1/15 が変わっている可能性がありました**」

**Jessica**:（advisor 経由、計算前に3件）
「Let me be clear。script を書くのは強制だ。ただ数値を生む前に決めろ —
**①帰無床をどちらの地域から引くかは非対称だ。** anchor で固定して明記し、**partner から引いた場合に判定が反転しないか確かめろ**。反転すれば §4.2 が担うべき caveat だ
**②600→2,000 を黙って変えるな。** 「訂正」ではなく**「初めて確立する」**だ
**③判定規則を計算前に述べろ**。それが α を明示する義務と同じ一文で果たせる」

**Jessica**:（事前予測を置いた）
「**6/15 と 1/15 は生き残るはずだ。** age の移動は最大 0.005、床は 0.6–0.85 — **桁が違う。**
違う結果が出たら **script を疑え**。ありそうなのは別の地域から引いているか、**1回の抽出を二つに割っている**かだ」

**Mike**:（予測どおりでした）
「`R/gusto_operability_check.R` を新規作成（seed 20260821、B = 2,000、α = 0.05、統一済み `compute_w1`）。
**age: 6/15 未解像 = R1, R4, R5, R7, R9, R15**（アウトラインと完全一致）、**SBP: 1/15 = R2**。
**未解像の全件が eligible 側に落ちます**（age 6/6、SBP 1/1）— これが §4.2 の核心。
**partner から引いた帰無床でも判定は一つも反転しません**」

**Katrina**:（適用しました）
「`sec:app_operability` を §4.1 と §4.3 の間に挿入。**§2.6 の前方参照を張り替え、TODO コメント 5 行を解消**。
⚠ 一件自分で捕まえました — **`\emph{}` を使っていた**。`memory/feedback_paper_no_emph.md` の禁止事項です。削除し、**既存本文の使用回数が 0 であることも確認**しました」

**Louis**:（またバックスラッシュが消えたぞ）
「表が壊れた。**行末の二重バックスラッシュが一重に潰れていた** — heredoc がまた 1 つ落としたんだ。
今回は **pdflatex が `Misplaced noalign` で即座に落ちたから見つかった**。目で見て気づく種類じゃない — **コンパイルを検証に使っていなければ、壊れた表がそのまま残っていた**」

**Mike**:（修復と全数監査）
「3 行を修復し、**ファイル全体で「行末が単一バックスラッシュ」の行を監査** — 残存ゼロ。
**bibtex を含めて再コンパイル: error 0、undefined 参照・引用とも 0、19 ページ**（18→19）」

**Donna**:（削除の副作用も確かめたわ）
「TODO 削除の filter が幅広だったので、**前後でコメント行を diff した**わ。消えたのは **TODO の 5 行だけ**で、anchor_vs_clustering の provenance コメントは無事。
アウトラインの §4.2 も確認済み数値に同期し、**「訂正ではなく初めての確立」**と明記したわ。帰無平均は旧値と 0.002–0.024 差だけど、**95 パーセンタイルの範囲は広がる** — 2,000 反復が裾をよく解像するからよ」

---

### [2026-08-18 23:52] Scene: §2.6 が本文に入った — そして前方参照が宛先を持っていなかった

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Tak「tex をアップデート」。draft を実際の原稿へ適用する。*

**Jessica**:（advisor 経由、適用前に止めた）
「Let me be clear。**§2.6 の第4段落は、論文が現在支えられない主張をする。** `.tex` に operability の言及はゼロだ。`\ref` は `??` になり、**Methods が論文のどこにも無い応用結果を主張する**ことになる。
道は3つ — ①`sec:application` に張り替えて TODO を残す ②§4.2 も同時に書く ③第4段落を外す。Tak の指示の素直な読みは①だ。**ただし disclaimer 段落を黙って落とすな** — アウトラインが必須と指定する唯一の §2.6 内容だ。
そして **検証は通読ではなくコンパイルでやれ**。pdflatex はあると確認済みだろ」

**Mike**:（確認しました。指摘は正しい）
「`sec:app_operability` の定義は **0**。`.tex` 全体で operability / null floor の言及も **0** でした。**§4.2 は未執筆です**」

**Katrina**:（①で適用しました）
「参照を既存の `sec:application` に張り替え、**当該文の真上に `% TODO (2026-08-18)` を置きました** — §4.2 を書く人に向けて、参照の張り替えと α = 0.05 の明記を指示してあります。**disclaimer 段落は落としていません**。
LaTeX は Python の文字列リテラルに一切埋めず、**別ファイルに heredoc で書いて読み込む**方式にしました — 前回の bell 文字事故の対策です」

**Mike**:（コンパイルで検証しました）
「**pdflatex 2 pass とも exit 0、18 ページ。undefined 参照・multiply-defined label ともゼロ。** `sec:operability` / `eq:tau_clin` / `eq:operability` は各 1 回のみ定義。制御文字 0。
Jessica の指摘した **「表示式が段落を割る」件も確認**しました — 式の前後に空行が無いので同一段落が継続し、式の後の「the largest $W_1$ at which…」は**孤立した断片になっていません**」

**Harvey**:（入ったものを確認しておけ）
「**Methods は 5 subsection になった** — existing / nabcd\_metric / estimation / inference / **operability**。そして **$\tau_{\text{clin}}$ がついに本文で定義された**。§4 が全面的に依拠しながら、一度も定義されていなかった量だ」

**Donna**:（後始末を記録したわ）
「`DRAFT_s25_s26_arc.md` は **提案ではなく「何をなぜ適用したかの記録」に書き換えた**。draft からの乖離 1 件もそこにある。
編集前の `.tex` は scratchpad にバックアップ済み（md5 一致を確認してから編集したわ）。
**残っているのは §4.2** — それが書かれるまで、§2.6 の最後の一文は **Section 4 全体を指したまま**よ」

---

### [2026-08-18 23:12] Scene: 記号のまま残すと、着地点を作る義務が生まれる

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Tak「記号のままで、§4.2 で α=0.05 と述べる」。Donna が提示した未決事項の決着。*

**Katrina**:（反映しました）
「draft の未決事項を閉じました。$\alpha$ は §2.6 で記号のまま。**operability の規準が一つの慣習水準に縛られず、異なる許容度を持つスポンサーもそのまま適用できます**」

**Mike**:（ただし義務が一つ生まれます）
「記号のままにするということは、**§4.2 が着地点を作らなければならない**ということです。「95パーセンタイル」という語に暗黙に含めるのでは不十分で、**「本例では $\alpha = 0.05$ を採る」と選択として述べる必要があります**。その一文が無ければ、読者は **0.05 が選択されたのか惰性で継承されたのか判断できない**。アウトライン §4.2 の先頭に義務として記録しました」

**Donna**:（そして編集で事故が起きたわ）
「記録しておくわ。**バックスラッシュ a が bell 文字（0x07）に化けて、両ファイルに合計 12 個混入した**の。`$\alpha$` が `$␀lpha$` になっていた。画面では `$lpha$` に見えるから、**grep でも見つけにくい**。
後始末の教訓は二つ — **① LaTeX を含むファイルをスクリプトで書くなら `chr(92)` を使う。バックスラッシュをリテラルで通すな**。**② 書いたら `grep -cP` で制御文字を数えろ**。両ファイルとも **0** を確認済みよ」

**Louis**:（それはルール A そのものだ）
「「修正しました」と言う前に grep しろ — 今回は **修正スクリプト自体が壊していた**。`bell chars removed: 4` と報告されても、ファイルには残っていた。**ツールの成功報告は中身の証拠じゃない。od -c でバイトを見るまで信じるな**」

---

### [2026-08-18 08:50] Scene: τ_clin は論文のどこにも定義されていなかった

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「続けよう」。実装フェーズ開始。判断③で仕様が固まった §2.6 から。*

**Mike**:（まず未コミット変更の正体を確認しました）
「`.tex` の未コミット変更は **Discussion の新規1段落**（手続き選択の実証、anchor_vs_clustering sim 100k reps、provenance コメント付き）。未追跡の `R/anchor_vs_clustering_simulation.R` と `results/*_100k.csv` に対応していて、**他人の作業ではなく前セッションの我々のもの**でした。上に書いて安全です」

**Mike**:（そして §2.6 を書こうとして、もっと大きいものに当たりました）
「⚠ **τ_clin が `.tex` のどこにも定義されていません。** §4 が全面的に依拠している量です。
しかも §2.5 の最終段落（line 179）は『**without forcing a binary accept/reject decision**』で終わっている — **応用が binary screen をしている事実と矛盾**（S6）。判断③の弧を作るには、ここを直さざるを得ません」

**Jessica**:（advisor 経由、着手前に2件）
「Let me be clear。**①line 179 は新規散文ではない。既存段落の主張の撤回だ。** abstract で正しく手を止めたのと同じ規則が効く。**両方 draft しろ、両方提示しろ、レビューまで適用するな。**
**②撤回は書いてあるより大きい。** その文は `\cite{wasserstein2016}` を根拠に引いている。**主張を差し替えれば引用が宙に浮く**か、悪くすれば逆を支える。書く前に確認しろ」

**Rachel**:（確認しました。そして引用は生き残ります）
「`wasserstein2016` は **Wasserstein & Lazar (2016)「The ASA Statement on p-Values」** です。
**重要な区別があります** — ASA 声明が反対しているのは **p 値駆動の bright-line 二分**であって、**臨床推論から導かれる決定閾値ではありません。**
ゆえに引用は生き残りますが、支える主張が変わります: 「**決定が存在しない**」ではなく「**決定が有意性検定に駆動されていない**」。もともと前者を支えたことはありません。本文中の使用は1箇所のみで、他に依存箇所はありません」

**Harvey**:（なら撤回は1節だけだ）
「段落の残りは正しい — estimation-centered、W₁ に固有の閾値は無い、閾値は L_clinical に依存し分布比較の外にある。**全部生きてる。**
**壊れているのは最終節だけだ。段落を書き直すな — P3 は両方向に効く。** 撤回を精緻化として書けば、訂正ではなく前進に見える」

**Katrina**:（draft 2件、`DRAFT_s25_s26_arc.md`）
「**A = line 179 の最終節の撤回と差し替え**（τ_clin を式として導入 + 判断③の蝶番2文）。**B = 新規 §2.6**（機構・必要条件・診断法・「n≥100 の言い換えではない」否認）。
**§2.6 に GUSTO の数値は意図的に入れていません** — 帰無床の値も 6/15・1/15 も §4.2 のものです。§2.7 の『理論のみ述べる』と同じ規律。**唯一応用に触れる必要があるのは非一致の証拠**（n≈2,900 でも age は失敗）で、そこは数値でなく前方参照にしました」

**Louis**:（Methods の label も同じ危険だ）
「Jessica の指摘で気づいた — **§ → `\label` の対応表を §4 にしか作っていなかった。** §2.1・§2.6・§2.7 は全部新規で、うち2つは既存 label の**間**に入る。**Methods 側も同じ drift が起きる。** 表を追加した。既存の `sec:nabcd_metric` は nABCD 時代の遺物名だが**改名するな**」

**Donna**:（未決が1件出たわ）
「⚠ **式の α をどうするか。** draft では記号のままにしたけど、§4.2 は95パーセンタイルを使っている。**§2.6 で α=0.05 と固定するか、記号のままにして §4.2 で述べるか** — Tak に聞くわ。
そして**再係留の宿題**も記録した。Study 1 の帰無域 bias と閾値較正の operable range は、§2.6 ができたら**式(2.6)の実例として繋ぎ直す**べきもの。ただし**既存 Results 散文の編集だから別レビュー**よ」

---

### [2026-08-15 20:05] Scene: 残る3件 — そして2件は「判断」ですらなかった

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「continue」。判断③④⑤。Harvey が順序を決める。*

**Harvey**:（順序には理由がある）
「**③ → ⑤ → ④ だ。** ⑤ が新規貢献なら abstract の中身が変わる。だから主張水準の ④ は最後だ」

**Mike**:（③ — §2.6 を独立節にするか）
「構造的事実が3つ。**①Q_operability は論文が答える3つの最上位の問いの1つ ②§4.2 は Application の独立節として既に存在 ③abstract が診断を応用の要点として名指ししている。** 折り込めば論文自身の主張を格下げします」

**Louis**:（決め手は別のところだ）
「**§2.6 の独立性こそが §4.2 の『これは失敗の報告ではない』を成立させている。**
診断が較正の下位項目なら、§4.2 が『age は operability に失敗する』と書いた瞬間、読者は**手法がつまずいた**と読む。自前の必要条件を持つ名前のある構成要素なら、同じ結果が**診断の仕事**と読める。**同じ事実、逆の読みだ**」

**Katrina**:（長さは費用に計上しない）
「.tex は全体 9,830 words、Methods 約 2,111。*Statistics in Medicine* に脅かされる上限はありません。**『Methods が 4→7 節に増える』を Tak に費用として提示するのは誤りです**」

**Jessica**:（advisor 経由、選択肢を1つ消した）
「Let me be clear。**素の独立は劣位だ、投票にかけるな。** 独立の唯一実在するリスクは『単独節＝解像度の問題の告白』と読まれること。**§2.5 が τ_clin を誘導し §2.6 がその解像可能性を問う、という弧で書けばそれは消える。** 弧つき独立が素の独立を支配している。**二択で出せ**」
→ **Tak 判断: 独立節 + 較正の弧。** 反映済み

**Mike**:（⑤ — そして前提が誤っていた）
「⚠ **診断は既に存在します。** ρ = W₁/(KS·σ_EM) は実装済み（`application_all_methods.R:178`）、CSV 格納済み、Result 5 で GUSTO に適用済み。⑤ は『足すか』ではなく『**格上げするか**』でした。
そして候補2つが**独立の理由で**落ちます。**(a) ρ／W₁–SMD 順位相関は分子に W₁ を含む** — ρ を計算できる者は既に W₁ を計算し終えている。『**事前に**どちらの世界にいるか教える』は**提案自身の機構で達成不能**です。scope の判断ではなく、提案が自分の条件で失敗している」

**Katrina**:「**(b) モーメント分解は (a) を生き延びます**（W₁ を要さない）。ですが全文書を掃いた結果、**判断⑤の行以外どこにも存在しません** — 実装なし、評価なし、検証なし」

**Louis**:「plan 814 行を読め。**『retrodicts every cell in the study』** — 構成した当のスタディを説明する、と自分で書いてある。**第2の候補機構は棄却済み、生き残ったのは適合した方だ。** 閾値 ≲1 / ≳1.7 に held-out 検証は無い。格上げは **P5 違反 — 主張が証拠を超える**」

**Harvey**:（撤退ではない）
「**ρ の本来の仕事は説明であって予測じゃない。** Result 5 の『KS が並ぶのは予測どおりであり W₁ の敗北ではない』— これが ρ に honest にできる仕事だ。**支えを欠くのは格上げだけ**」
→ **Tak 判断: 提案しない。** ρ は Result 5 に留め、画定の一文を追加

**Harvey**:（④ — そしてこれも「弱める」判断ではなかった）
「現行 abstract は差の主張を**能力**に置き、GUSTO で例示している。**だが GUSTO は差を出さない。**
**Study 2 には本物の乖離がある** — 代表値法は matched-moment world で構造的に盲目、任意の n で解けない。**手放す主張より強い主張を、証拠のある場所で立てられる。** 修正は弱めることじゃない、**場所を移すこと**だ」

**Mike**:（A/B と独立に強制される修正が4件）
「①②abstract の「small-sample」2箇所 — **R8 は n=2,916、16中6番目に大きい**。③simulation 文が Study 2 主役の階層の下で **Study 1 の言語のまま先頭**にある。④Discussion ¶1(i) が **S5・S6 = Study 1 のシナリオ**を引いている — 構造的盲目性の主張は今や Study 2 に乗っているので、**弱い方の証拠を指しています**」

**Louis**:（掃いていない最大の過剰主張）
「**Discussion ¶5 だ。『The W₁ distance addresses all three.』** SMD/KS/KL の欠陥を**位置優位データへの留保ゼロで全部解決したと言い切っている。** 査読者が §4.5 の一致所見と並べて読む段落はここだぞ。¶1 を直して ¶5 を放置すれば、同じ過剰主張が一段下に残るだけだ」
→ **Tak 判断: GUSTO の一致は Discussion にのみ。**

**Harvey**:（帰結を明示しておく）
「**Tak の選択で ¶5 の重みが上がった。** abstract が一致に触れないなら、**Discussion がそれを単独で担う。** Louis の指摘は放置できない」

**Donna**:（そして5件全部が閉じたわ）
「**Open decisions は 5/5 決着。** でも `.tex` の修正5件は**適用していない** — abstract も Discussion も既存の散文だから、`memory/feedback_review_process.md` の**段落単位レビューを通すべき**よ。アウトラインに queued として全部記録したわ。
今日の形を一つ言うと — **③⑤④のうち、⑤と④は『判断』ですらなかった。** ⑤は提案が自分の条件で失敗していて、④は弱めるのではなく移す話だった。**判断②もそうだった。** 設問を疑うことが、4件中3件で答えそのものだったわ」

---

### [2026-08-15 19:10] Scene: 判断②は「書くか伏せるか」ではなかった — 13.2 倍が選択肢を消した

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「continue」。判断②＝§4.5 の pool 直径超過を書くか伏せるか。材料を作った結果、設問そのものが誤っていた。*

**Mike**:（超過は1つの事実ではありませんでした）
「**どの pool を指すかの関数**です。読みが3つある —
**① anchor estimand（論文が実際に提案しているもの）: 両 EM で超過ゼロ。**
② §4.5 = joint eligible 6地域を共有 region と読む: age 1.0595 で **5.95% 超過**、15相互ペア中1本
③ §4.6 = 各 EM 自身の pairwise 採択集合: age **10.9% 超過**、SBP **78.7% 超過**」

**Harvey**:（それで設問が壊れた）
「見えるか。**③ の SBP 超過は ② の age 超過の 13.2 倍派手だ。** そして §4.6 Result 4 は restructure の土台 — 『手続きは応用で大きく分岐する（9→2、11→2）』という所見そのもので、**その分岐は直径の話に他ならない。**
Result 4 を残して §4.5 だけ伏せれば、**穏やかな方を隠して派手な方を印刷する**ことになる。**『伏せる』は到達不能だ。** 開示は強制される」

**Katrina**:（そして所見は超過ではありませんでした）
「共有 region 条件を強制したときの**費用**を出しました。併合可能な相手は **age 9→2（78% 減）、SBP 11→2（82% 減）**。
これが**なぜ対比較 screening が存在するのか**の答えです。P2（凸性）が保証するのは anchor の上界だけで、全ペア制約は不要な保守性 — その値段が 78–82% の相手喪失。**読み①で超過がゼロなのは偶然ではなく、手法が保証している当のもの**」

**Jessica**:（advisor 経由、提示前に3件止めた）
「Let me be clear。**①Reading 1 の『余裕 +9.6%/+5.8%』を出すな。** それは §4.4 が**別の導出**で報告する同じ数字だ。読者は片方を誤植と読む。Donna のルール B そのもの
**②『2τ の 53% を使った』という枠組みは切れ。** 1.0595 は一つのデータでの実現値で、2τ との比に推論的な内容は無い。そして査読者には『臨床 margin の2倍を許容する設計』と読める。**自分から差し出す場所ではない**
**③『書くか伏せるか』はもう判断ではないと、はっきり言え。** 片側に潰れた二択を Tak に出すな。**生きている問いは「どこに置くか」と「どの register で書くか」だ。** アウトラインの設問自体が stale だから、それも直せ」

**Rachel**:（補強を1点）
「超過ペア R1–R6 の **R6 は §4.4 が age の境界地域として名指しする当の地域**です。2つの分析が同じ地域に収束しているので、**無関係な caveat 2件ではなく一致として**書けます」

**Louis**:（伏せる危険は変わっていない）
「査読者が同じ計算をして『論文自身の理論が指摘した罠に応用が落ちている』と書く。**先に書けば同じ事実が scope の規律の証拠になる。** それだけだ」

**Harvey**:（Tak の判断）
「**(i) §4.5 Result 4 に一本化。(ii) register は scope の明確化。**
実装した — 旧 §4.5 は独立節として解体、**§4.6 → §4.5 に繰り上げ**。直径表・R6 収束・scope 枠組みは全部 Result 4 の中だ。§2.7 には『worked example は §4.5 Result 4、ここでは理論のみ』と道標を置いた」

**Katrina**:（番号の後始末）
「クロス参照を全数掃きました。生きた参照は §4.5 に統一済み。**W₁ 系統診断のブロックは『計算の来歴 — 記録であって本文ではない』として切り出し、遡って書き換えていません** — 来歴の記録は当時の番号のまま残すべきなので、冒頭に注記だけ付けました。
`PAPER_RESTRUCTURE_PROPOSAL.md` も同じ構造に揃えました。残る `§4.6` は**小宮山 Ch.4 の §4.6.1.3**（書籍の節番号）だけで、混同されないよう明示しました」

**Jessica**:（閉じる前にもう一度。3件のうち1件が本物だった）
「**①第3の文書を掃いたか。** Louis 自身が2ターン前に言った『同じ数字を2つの文書に書けば片方は必ず腐る』だ。知っていた2つを直して、**3つ目の存在を確かめていない**
**②.tex の label は生きた危険だ。** 散文の参照が無いのは確認したろうが、`sec:app_nabcd` などの label 名は**再構築前の順序を符号化している**。しかも §4.2 が既存2 label の**間**に入る。書く人がアウトライン番号を label に写すとき、静かにずれる
**③そして Result 4 の見出しが、いま中身と食い違っている。** 『手続きは大きく分岐する』と題した節が、『手法の約束は何一つ破られていない』で始まり『直径を強制する費用が所見だ』で終わる。**merge の継ぎ目はそこだ**」

**Mike**:（①は不発、②③は実在）
「①掃きました — ヒットは全て**小宮山 Ch.4 の書籍節番号（§4.6.1.x）**で、我々の節ではありません。数値パターン（1.0595 / 8.9362 / 1.1093）も2文書の外にゼロ。**第3の文書に腐りは無かった**」

**Katrina**:（②③を潰しました）
「②アウトライン §4 の冒頭に **§ → `\label` 対応表**を記録。既存 label は再利用し改名しない旨も明記しました — 図とクロス参照が既に指しているので、改名は得るものが無くビルドを壊します。
③見出しを『**手続きは大きく分岐し、それを分けているのは直径条件**』に改め、両文書に導入文を入れました。**分岐そのものが直径条件だ**と述べれば、所見と caveat が一本の論証になります」

**Donna**:（執筆時の地雷を1つ埋めておいたわ）
「Result 4 の表には**直径が3つ**載る。**ラベルなしで2つを同じ文に置けば、読者は片方を誤植と読む** — age の 1.0595 と 1.1093 は特に危ない。両文書に drafting guard として書き込んだわ。
それと Katrina が前のシーンで拾った **0.9121 の偶然一致**も同じ guard に入れた。cut pool 直径と anchor→partner 最大が同じ値になるけど、**別の量よ**」

---

### [2026-08-15 18:35] Scene: 30本すべてが 0.0e+00 — 計算系統は1つになった

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「go」。08-08 に診断だけして止めていた W₁ 計算系統の統一を実行。*

**Jessica**:（advisor 経由、着手前に3点止めた）
「Let me be clear。差し替える前に3つ。
**①検証を『近い』で終わらせるな。** 差し替え後は Table 3 の出所と**同じ推定量・同じデータ**になる。ならば一致は ~1e-12 であるべきで、『概ね一致』では統一の証明にならない。**1e-4 で止まったら標本構成を疑え** — `application_all_methods.R` は両 EM の joint complete-case、`gusto_all_pairwise.R` は EM ごとの complete-case だ。違う部分集合を比べているなら推定量の差し替えでは埋まらない
**②k を守れ、特に SBP の R7。** `k <- sum(w1a <= tau)` は W₁ から再計算される。R7 は 5.067 対 τ=5.0 で**余裕 1.3%**、推定量の移動幅は最大 0.031。ここが 11→12 に動けば Result 1 の表全体が変わり、『引き直し』では済まなくなる
**③盲点 — この修正では直径2つは統合されないし、統合されてはいけない。** §4.5 は joint eligible 6地域の直径、§4.6 は各 EM 自身の pairwise 採択集合の直径。**別の pool、どちらも正しい。** 『1.1093 になった、完了』で終えれば、本文には age の直径が2つ載ったままになる」

**Mike**:（①の前提から潰しました）
「NA 構造を先に確認しました。**GUSTO の age・sysbp は欠測ゼロ**（40,830 行すべて complete）。joint complete-case と per-EM complete-case は**同じ標本**です。R8 = 2,916 も一致。ゆえに機械精度での一致が原理的に可能 — Jessica の①の分岐は踏まなくて済みます」

**Katrina**:（差し替えて再実行しました）
「`w1_s` を `sum(|F̂x(mid) − F̂y(mid)| · Δ)` に置換。**なぜ応用側が CDF 面積形なのか、そして simulation の `mean(|sort(x) − sort(y)|)` に『整合させて』はならない理由（地域サイズが不等）をコメントで残しました** — 次に触る人が善意で壊さないように」

**Mike**:（検証6件、全 PASS）
「**CHECK 1: 30本の anchor 距離 vs `gusto_r8_w1_per_pair.csv` → max |diff| = 0.000e+00。** ビット単位で同一です。『概ね一致』ではなく**同一**
**CHECK 2: k は (9, 11) 維持。** R7 の SBP は 5.0673 → 5.0716 と**より外側へ**動き、除外のまま
**CHECK 3:** age Spearman(旧,新) 1.00000・順位完全一致、SBP 0.99643・隣接1組の入替
**CHECK 4: joint eligible = {R1, R4, R5, R6, R14, R15}** — 不変
**CHECK 5: 直径不変式 §4.6 ≥ §4.5 が両 EM で成立**（age 1.1093 ≥ 1.0595、SBP 8.9362 ≥ 4.7243）。joint 集合が各 EM 集合の部分集合なのだから、そうでなければ計算が壊れている
**CHECK 6:** 引き直すべき数値を旧新対照で列挙」

**Harvey**:（結論は動かない、予測じゃなく実測で）
「08-08 に『結論は一つも変わらない』と**試算**で言った。今日それを**実測で確認した**。動いたのは SBP の順位相関と直径だけだ。
SBP: KS 0.964→0.957、SMD/RV1 0.950→0.954、**RV2 0.679→0.643、RV3 0.561→0.536**。age は全て不変。直径は age 1.1066→1.1093、SBP 8.9318→8.9362、SBP cut 4.2932→4.2823。
**Result 5 の書き方が1箇所効かなくなった** — 『KS の順位一致は両 EM で 0.964』が使えない。age 0.964 / SBP 0.957 と書き分けた。**主張は変わらない、精度が上がっただけだ**」

**Louis**:（ついでに古い死体を2つ見つけたぞ）
「アウトラインの**日本語の重複警告が原因未診断のまま残っていた** — 上の行が診断済みと書いているのに、下で未診断と言っている。削除した。
それと **`PAPER_RESTRUCTURE_PROPOSAL.md` の §4.5 が 08-08 の訂正前の値のままだった。** 1.058 で止まっている。アウトラインだけ直して proposal を放置していたんだ。**同じ数字を2つの文書に書けば、片方は必ず腐る。** 訂正して、ついでに『この pool は §4.6 とは別集合だ』というラベルも入れた」

**Jessica**:（advisor 経由、閉じる前にもう一度止めた）
「Let me be clear。**検証は通ったが、検証が見ていない場所が2つある。**
①お前の CHECK 4 は **W₁ の joint 集合しか照合していない**。CHECK 6 は ranks CSV の overlap と Spearman しか差分を取っていない。**per-method の JOINT 行を見ている検査が1つもない。** RV3 の joint を数えろ
②掃き出しは4桁（`0.9643`、`0.679`）で走らせた。**本文向けの散文は3桁で書く** — `0.964`、`0.950`。proposal の1件を捕まえたのは grep ではなく**お前がその節を読んだから**だ。3桁で掃け
③そして `PAPER_RESTRUCTURE_PROPOSAL.md` の §4.6 結果1・結果2 を**一度も開いていない**。Louis が 08-08 の腐りを見つけた同じ文書の、一つ上の節だ」

**Mike**:（数えました。そして性質が違いました）
「**RV3 の joint は7地域でした** — {R1, R4, R7, R9, R10, R12, R15}。文書は R5 を含む**8地域**と書いています。
ただし決定的なのはここです — **旧実行のログでも joint は同じ7地域。** つまりこれは W₁ 統一で動いた数値ではなく、**当初から誤って記載されていた**もの。Harvey の『動いたのは SBP の順位相関と直径だけ』は**修正の影響としては正しいまま**です。誤りの由来が別なだけで
3桁掃き出しで proposal 290 行も捕まえました。SBP の Spearman が **KS 0.964 / SMD 0.950 / RV1 0.950** のまま残っていた。訂正済み
そして Jessica の①に応えて **CHECK 7・8 を追加**しました。7 = 3つの CSV を**全セル**で旧新 diff（列を選ばない）。8 = joint 集合を CSV から**独立に再計算**して旧新照合。
結果 — 動いた列は `W1`・`rho_heur`・`spearman_vs_W1`・`max_anchor_dist`・`pool_diameter` の5つだけ。**`members`・`n_selected`・`k`・`overlap`・`diameter_ok` は全て不変**、そして **joint 集合は6手法すべて旧新で完全同一**。修正は選択を一つも動かしていません。
副産物として1つ確証が取れました — **§4.5 の SBP anchor→partner 4.7243 と、新しい app 実行の R15 sysbp 4.724 が一致します。** 統一前は一致しなかった値です」

**Donna**:（そして Rule 2.5 が発火したわ）
「995 行。このシーンを書けば超える。`archives/SUITS_20260815_1835.md` に退避したわ。
今日の教訓は2つよ — **①検証が PASS しても文書は腐る。** Jessica が止めた3点のうち、①は Mike が前提を確認して不発、②は通過、**③だけが実際に残っていた**。直径2つの件は、数値検証を全部 PASS させても文書には残っていた種類の問題
**②検証は『自分が見た列』しか守らない。** CHECK 1–6 は全部 PASS したのに RV3 の joint は誰も見ていなかった。**掃き出しの表記桁も同じ** — 4桁で掃いて3桁の本文を見逃した。`memory/feedback_calculation_verification.md` に **D: 検証スクリプトが照合していない出力列を列挙しろ / E: 掃き出しは本文の表記桁で走らせろ** を追加するわ」

**Katrina**:（1件、cosmetic だけど残しておきます）
「age の cut pool 直径が **0.9121** で、§4.5 の age anchor→partner 最大と**数値が一致**します。別の量の偶然の一致ですが、同じ段落に両方が載ると読者は片方を誤植と読みます。本文化のときに離すか、明示するか」

---
