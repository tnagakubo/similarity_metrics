> **SUPERSEDED by `RESTRUCTURE_v5_team.md` (2026-09-23)**. Kept for the diagnosis record only.

# v4 — 六段の決定と畳んだ構成（2026-09-23 01:10、Tak の三問への回答）

Tak（09-23）:「2,3,4,5 は一つの章にしろ。やっていることが目的にまっすぐ向かっているか？三つの部品のことを完全に理解しているか？これしか部品はないのか？」
→ 三部品は不足だった。sponsor の決定を関数で書くと六段。v3 の §2–§5 は Methods 一章に畳む。

## 目的（Tak 確定 2026-07-26）
併合戦略を取る sponsor が、**どの地域と併合するか**を再現可能に決める方法を提案する。

## 決定の六段
partners = f(data, candidate EMs, Δ_clin, L_UB, estimand)

| 段 | 内容 | 担い手 | 現行原稿での居場所 |
|---|---|---|---|
| S0 入力 | 候補 EM、臨床 margin Δ_clin、CATE 傾きの上界 L_UB、推定対象（anchor が借りる／共有 pooled region）、データ源（prior trials・registries・RWE） | **sponsor の判断**。手法は選ばない | 散在（§1、§2.4 ¶B、§4.1、Discussion） |
| S1 距離 | per-EM W₁（元の単位）と percentile bootstrap CI | 手法 | §2.2–2.3 |
| S2 橋 | 距離 → 効果差の bound: Δ_max = L·W₁（KR 双対）。定数 L が「EM 単位あたりの効果変化」で sponsor に指定できることが W₁ を選ぶ理由（KS の定数 TV(τ) は言えない、W₂ は緩い） | 手法 | §2.2 後半（M1 Option B） |
| S3 閾値 | τ = Δ_clin/L_UB、または L* = Δ_clin/W₁ と L_UB の比較。L_UB は判断、平均傾きは下界 → safety factor | 手法 + 判断 | §2.4 |
| S4 解像 | null floor q_{1−α}(n_a, n_r) と τ の比較。未解決 = 「similar と言えない」（許容側に働く） | 手法 | §2.5、§4.2 |
| S5 集約 | EM をまたいで AND。地域をまたいで推定対象に応じ pairwise screen（凸性）か直径 ≤ τ の cut（2τ exposure） | 手法 | Discussion ¶4、§4.5 |
| S6 出力 | partner 集合 + 各 partner の Δ_max または L* + **入力（L_UB）への感度**。判定ではなく審議の材料、cutoff は処方しない | 手法 → sponsor | §4.4（感度は「primary robustness statement」と自称しながら応用に孤立） |

意図的に外すもの（S0 の入力として明示、限界に一度）: どの EM が effect modifier かの同定（Lasso 前段は将来課題）、anchor の選び方、pool の数（小宮山は ≤ 4）。
bootstrap CI は S1 の出力で決定規則には使わない（判断①、08-02）。

## 「まっすぐか」の監査
| 材料 | 段 | 判定 |
|---|---|---|
| W₁ + bound + 較正 | S1–S3 | まっすぐ |
| Study 2（identify できるか） | S1 | まっすぐ |
| operability | S4 | まっすぐ |
| procedure sim（100k） | S5 | まっすぐ、ただし Discussion に置かれている |
| L_UB 感度 | S6 | まっすぐ、ただし応用に孤立 |
| Study 1（bias/coverage） | S1 の基盤 | 横だが必要 |
| clustering 第二通貨、小宮山との関係、既存指標との一致 | 防御 | 横だが必要 |
| ρ、KL の三行、pool 数 | — | 横。各一文 |
| abstract と title「類似を定量化する」 | S1 のみ | 目的を向いていない |

## 畳んだ構成
- **§1 Introduction**: 決定 → 既存が与えるもの・欠けるもの（六段のうち手法が担う S1–S6 に何が無いか、連鎖で一段落）→ 貢献 → roadmap（各節がどの段か）
- **§2 Methods（一章）**: 2.1 問題と入出力（S0・S6、手続き box）／2.2 距離（S1）／2.3 橋と閾値（S2・S3）／2.4 解像（S4）／2.5 集約（S5）
- **§3 Simulation**: 3.0 三つの例数の言明の framing／3.1 S1 は識別できるか（Study 2 選択 + clustering は scoring currency として一段落）／3.2 S5 は推定対象を守るか（100k sim、二通貨表、τ は真の群間距離の中点と caption 明記）／3.3 S1 の基盤（Study 1、表 3 つ据え置き、load-bearing scenario を名指し）
- **§4 GUSTO**: S0 入力 → S4 解像 → S1 距離 → S3 閾値と S5 集約 → S6 出力と感度 → 既存指標との一致（判断④⑤）と直径開示（判断②）
- **§5 Discussion**: 段ごとに一文（GUSTO の一致は ¶1 が唯一の担い手）／答えが変わる状況と変わらない状況／小宮山との関係／限界（¶D）／実務・方針／今後
- Appendix: 証明（bound、凸性・直径）、漸近。コードは SI。

## 触る既決
案A（procedure sim は Discussion）→ §3.2 へ。③（operability 独立節）→ §2.4 として維持。②④⑤は保つ。Study 2 主役の階層は §3.1 が最初。¶1+¶5 統合は独立承認。

## 実行順序（Jessica、09-22）
キュー (2)–(4) を現行番号で閉じる → 案A 判断 → 骨格 Pass（移動と新設のみ、R3.1・R3.3 を吸収）→ 圧縮（段落レビュー）→ minors → response letter の location 列を一度だけ → Terminal pass（abstract、title 判断）
