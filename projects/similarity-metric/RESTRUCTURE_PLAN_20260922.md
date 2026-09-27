> **SUPERSEDED by `RESTRUCTURE_v5_team.md` (2026-09-23)**. Kept for the diagnosis record only.

# Restructure plan v2 — 構成の背骨を直す（2026-09-22）

Tak の指示（09-22）:「section 4.5 だけでなく、論文の構成に無駄がある。全体の構成を見直して何を目的として何を主張しているのかわかりやすく修正しろ」
v1（Harvey）は語数ダイエット（11,800 → 7,600）として書いた。Louis と Jessica の審査で **却下** — 苦情は clarity であって length ではなく、SIM の本文語数制限は未検証（outline §9 T9）。v2 は「**重複除去 + 配置修正**」として再定義する。削除は語数でなく clarity で正当化する。

目的（Tak 確定 2026-07-26）: 併合戦略を取る際の**併合相手を選択する方法**を提案する。
問い（outline §0）: **Q_metric**（何で測るか）→ **Q_procedure**（距離をどう相手集合に変換するか）→ **Q_operability**（その判断が手元の n で解像するか）。Study 1 はこの三つのどれでもなく **Q_estimation**（推定基盤、競合に対する主張ではない）に答える。

---

## 1. 診断 — 病巣は語数ではなく列挙のドリフト

| # | 事実（実測） | 帰結 |
|---|---|---|
| D1 | Intro L70「Komiyama leaves **two** gaps」/ §2.1 L120「(i)(ii)(iii) three requirements」/ Discussion ¶1 L691「**three** gaps identified in Section 2.1」（中身は識別・臨床換算・bootstrap で §2.1 と別物）/ Discussion ¶5 L712（SMD/KS/KL の別の三つ組）— **同じ三つ組と称する列挙が 4 種類** | どの列挙にも Q_procedure も Q_operability も無い → **Q_procedure に答える義務を負う節が存在しない** |
| D2 | Methods + Simulation（L94–480）の本文に `procedur` の出現 **0**（LaTeX コメント 1 件のみ） | Q_procedure の理論（凸性、2τ exposure）も唯一の証拠（100k reps）も Discussion ¶4（394 words、数値 9 個、表なし）にある |
| D3 | roadmap L91 は §2 の項目を 5 つ並べ procedure が無い。§3 preamble は順序の言い訳に ≈200 words | 読者は「三つの問いがどこで答えられるか」を最後まで教えられない |
| D4 | 「SMD は location しか捉えない」が L78・L111・L120・L691(i)・L712 の **5 箇所** | Intro の真の重複はここ（¶6/¶7 は別内容。v1 の D6 は誤り） |
| D5 | Discussion ¶1 と ¶5 が gap を二度閉じる — しかも三つ組が**不一致** | 圧縮で隠すと矛盾が残る。先に三つ組を統一 |
| D6 | §4.5 1,211 words が三つの仕事（指標一致 / 直径開示 / ρ） | 判断②④で load-bearing なのは前二つ |
| D7 | τ が二役: τ(x) = CATE（L97）、τ_clin = 閾値（L210）、τ̄_r = 地域平均 | §2.5 / §3.1.5 を足すと衝突が増える。outline は CATE を θ(x) と書いている |
| D8 | "clustering" が三重用法: §3.1.4 = scoring currency、§4.5 = decision procedure、Discussion ¶4 = procedure | 新節を §3.1.4 の隣に置くと確実に混同 |

---

## 2. 目標骨格 — 「一つの問いに、一つの Methods 節、一つの証拠、一つの応用結果、Discussion に一文」

| 問い | Methods | 証拠（§3） | 応用（§4） | Discussion ¶1 |
|---|---|---|---|---|
| Q_metric | §2.2 W₁ + bound（定数と tightness）; §2.3 較正 | §3.1 決定性能（primary） | §4.3 距離; §4.4 適格性 + 感度; §4.5 既存指標との一致 | 一文 |
| Q_procedure | §2.1 に estimand 文（anchor 推定対象 vs 共有 pool）+ **§2.5 新設**（凸性 ⇒ anchor screen で十分; 2τ exposure ⇒ 直径 ≤ τ の cut。**τ は sponsor が Δ_clin と L_UB から与える入力で、手法が産出しない**と明記） | **§3.1.5 新設**（Study 2 配下、同じ 4 世界・12 anchors なので第三の study ではなく ADEMP を継承）。表は**二通貨**: viol_pair + anchor-violation ≤ 5% 下の best sensitivity。caption に「τ は真の群間距離の中点、臨床閾値ではない」 | **§4.6 新設**（§4.5 から直径開示 = Result 4 と 9/11 → 2/2 を切り出す） | 一文 |
| Q_operability | §2.4 null floor | §3.2 の S1 上側裾 | §4.2 | 一文 |
| Q_estimation（基盤） | §2.2 の推定 + bootstrap | §3.2（Study 1） | — | 一文（n ≥ 100） |

---

## 3. Pass の順位 — 変更語数あたりの clarity（Louis 順位、Jessica の Phase 8 順序に従う）

| 順 | 作業 | 語数 | 触る既決 |
|---|---|---|---|
| **1** | **One triple, three locations**: Intro の gap 段落 / §2.1 (i)–(iii) / Discussion ¶1 を同一の三つ組に統一し、三つの問いに写像。Q_metric の文には必ず "constant" を入れる（"optimal"/"tighter" は M1 修正を壊す） | ≈100 | ¶1 は Tak 承認済み（08-30）→ 再承認 |
| **2** | **roadmap L91 + §3 framing** で「どの問いをどこで答えるか」を名指し。§3 preamble の順序の言い訳を削除 | ≈60 | なし |
| **3** | **Intro の三つの問い段落**（列挙でなく依存関係の連鎖として 1 段落: 距離なしに手続きは決まらず、解像しなければどちらも使えない）+ contribution 段落で三つの問いを問いとして名指す（editor の skim path = Intro 末 2 段） | ≈120 | Intro は 09-01 レビュー完了 → 段落レビュー |
| **4** | **Q_procedure に家を**: §2.1 に estimand 文（+150、§2.1 は**増える**唯一の節: 335 → ≈480）、§2.5 新設（Discussion ¶4 の文 1–3 と §4.5 ¶5 を**移動**、書き直さない）、§3.1.5 新設（Discussion ¶4 の文 4–8 + 二通貨表）、§3.1.4 を「Clustering as a scoring currency」と改題して D8 を解消。L328–336 の「will NOT be written here」コメントを更新 | ≈+300 本文 / −394 Discussion | **案A（08-30）を覆す** → Tak 三択（§4） |
| **5** | **SMD location-only の 5 重複を 1 箇所に**（§2.1 に残し他は参照） | ≈−350 | ¶7（08-31 承認）、¶1（08-30 承認）→ 再承認 |
| **6** | **Discussion ¶1 + ¶5** の統合（1 の下流。判断④の「¶5 = GUSTO 一致の sole carrier」を ¶1 が引き継ぐことを明記） | ≈−250 | **判断④の帰結に触れる → 独立承認** |
| **7** | **§4.5 分割**: §4.5 = 既存指標との一致（Table 11 に "agreement with W₁" の group header、RV1≡SMD の scope 文、ρ は判断⑤の画定一文）≈ 550、§4.6 = pool 直径と手続き（Result 4）≈ 330 | ≈−330 | ②⑤は保つ |
| **8** | **τ → θ**: CATE を θ(x) に改名（outline 表記）。restructure が最安の機会 | 記号のみ | なし（P4） |
| **9** | **Method summary block**（≈120 words、§2 末尾: 候補 EM → Δ_clin/L_UB → τ → operability → anchor screen か diameter cut → Δ_max/L*）。R3.3 の workflow float と同一項目 | +120 | なし |
| 10 | Methods の展開を Supplement へ（三つの表現のうち 2 つ、正規化冗長性 → Supp A; L の文献詳細 → Supp D）。§2.3 Estimation は独立節のまま（§2.5 が参照、SIM の期待） | ≈−250 | なし（clarity 寄与は小） |
| 11 | Discussion の残り: ¶8+¶9 統合、¶10 を ¶D の周りに整理（¶D は 09-22 承認、247 words は維持） | ≈−150 | ¶D は保つ |
| **最下位** | Study 1 の圧縮 — **やらない**。3 表は残す。本文で load-bearing な scenario（S1 boundary / S2 n≥100 / S5 coverage / S6 shape）を名指す一文だけ足す。CI width → Δ_max = 5.0%pt の一文（推定精度が臨床尺度に換算される唯一の箇所）は body 残置 | +40 | なし |

やらないこと: 語数目標を置かない。§2.2 と §2.3 を畳まない。§4.5 を 400 にしない（直径段落だけで 330）。fig:simulation の panel A/B/C は body 残置。tab:coverage の S1 は「0 (boundary)」と明示（空欄は未実施と読まれる）。Appendix A.1 の削除は**未決**（T7）— §2.5 の凸性と直径の proof home を先に決める。

---

## 4. Tak の判断が要る項目

1. **案A の三択**（Q_procedure の証拠の置き場）。理由は「09-22 の訂正」ではなく **Q_procedure に home がない**こと。判断③の記録済み根拠 (a)「Q_operability は最上位の問いの一つなので折り込むと主張が降格する」を Q_procedure に適用する = 反転ではなく一貫性。
   - ① Discussion 留置 + 二通貨表を Supplement（既決を守り、数値に表を与える）
   - ② **§3.1.5 昇格（Study 2 配下、ADEMP 継承）— 推奨**
   - ③ 現状維持
2. **Discussion ¶1 + ¶5 統合**の可否（判断④の帰結を ¶1 が引き継ぐ）。
3. **abstract の headroom**: Option B は 248/250 words で Q_procedure 句がゼロ。Q_procedure を最上位の問いに上げるなら一文（≈20 words）が要る。削る候補: "Because only baseline distributions are needed, W₁ can be computed from prior trials, registries, or real-world evidence."（Intro/Discussion に既出、≈20 words）。Terminal pass で確定。
4. **title** は Q_metric しか広告していない（"Quantifying Effect Modifier Similarity…"）。改題は要求しない。記録のみ。
5. **Phase 8 の順序**（Jessica）: ①キュー (2)–(4) を現行番号で閉じる → ②案A 判断 → ③(5) presentation（R3.1 番号・R3.3 workflow float）を Pass 1 に畳む → ④Pass 1 骨格 + C1 cascade grep + recompile → ⑤圧縮（¶1+¶5 は独立承認）→ ⑥(6) minors → ⑦response letter の location 列を最終番号で一度だけ → ⑧Terminal pass（abstract）。**先に出せるのは番号を動かさない部分だけ** = 上の順位 1–3。

---

## 5. 検証規則（全 pass 共通）

- 段落単位で Option A/B/C、Tak が選ぶ。承認済み段落に触る hunk は再提示。
- 適用 → 旧文言の残存 grep 0 → コンパイル error 0 → `/verify-numbers`。数える対象（cells、words）は plan 内でも再測（v1 の「63 cells」は 88 の誤り）。
- 三つ組の統一後、`unique` / `specific to` / `optimal` / `tighter` の残存 0（M1 の再破壊防止）。
