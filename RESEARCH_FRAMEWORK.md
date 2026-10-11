# RESEARCH_FRAMEWORK — 科学研究 → 論文執筆の lifecycle（SUITS 実装）

> *"I don't have dreams, I have goals."* — 研究を 10 の Phase と gate に分け、各 gate を Claude Code の機構で機械化する。
> State は `projects/{project}/LAB_STATUS.md`、記録は `SUITS.md`、操作は `/phase`。
> 作成: 2026-09-21。改訂: 2026-10-10（科学的妥当性の機構 — §6–§8）、**2026-10-11（Option B: 生成 pipeline・protocol compiler・replication・CI — §9）**。CLAUDE.md（Rule 1–6）を上書きしない。CLAUDE.md が「何を守るか」、本書は「どの順で・何を証拠に進めるか」。

---

## 1. Lifecycle（10 Phase）

| # | Phase | Owner（支援） | 主要 artifact（on disk） | Gate（抜ける条件） | 使う skill / 機構 |
|---|---|---|---|---|---|
| 0 | **Question** 問い | Harvey（Jessica） | `EXISTING_METHODS_AND_NOVELTY.md`、`DECISIONS.md` D-…-1（claim と「なぜ今」）、`CLAIMS.md` 1 行目 | 1 文の claim と「なぜ今この論文か」に Jessica が Go。estimand の候補が数式で書ける | `/start`, `/decide`, `/meeting`, `agents/jessica` |
| 1 | **Literature** 文献 | Rachel | `knowledge/INDEX.md`、`summaries/`（verbatim passages + "does not say"）、`LITERATURE_SEARCH_LOG.md` | 主要文献が KB に処理済み・全 DOI・gap が 1 段落で書け、**反証条件**が書ける | `/process-paper(s)`, `/search-kb`, `/request-paper`, PubMed MCP |
| 2 | **Protocol** 設計 | Mike（Louis） | `PROTOCOL_{study}.md`（§0 honesty clause / claim / licenses / **ADEMP** / **MCSE と n_sim** / seed・環境 / Louis 攻撃 / 出力 / Go / 逸脱） | protocol が **commit** 済み、Louis の攻撃に回答、Jessica Go。θ 特定・循環設計なし | `/protocol`, `/defend`, hook `pre-run-protocol-check.sh` |
| 3 | **Implementation** 実装・検証 | Mike（Katrina） | `R/`、出力 CSV（estimate + MCSE）、`sessionInfo` / `renv.lock`、`*_PROVENANCE.md`、`results/REPRODUCTION_*.md` | `check_r_reproducibility.sh` ❌ 0、clean checkout 再実行が許容差内（`/reproduce` PASS）、数値の traceability | `/reproduce`, `/verify-numbers`, rules `r-code.md`, hooks numbers / r-repro |
| 4 | **Results** 結果 | Katrina | `SIMULATION_FINDINGS_{study}.md`（MCSE 付き、licenses / しない、探索的所見を分離）、figures、tables（CSV 生成） | 図規格・caption 規則、evidence → `CLAIMS.md` の該当行が supported、four-eyes 検証表 | rules `r-code.md`、`/verify-numbers`, `/claims check` |
| 5 | **Writing** 執筆 | Harvey / Mike / Katrina | `.tex`、`CLAIMS.md`（全主張）、`PAPER_LOGIC.md`、段落台帳 | 各段落 Tak OK（P1–P5 + S）。`/claims check` PASS。本体→Discussion→Terminal の順 | 段落レビュー（`templates/review_checklist.md`）、rules `paper-writing.md`、Option A/B/C、`/claims` |
| 6 | **Internal review** 内部審査 | Louis（全員） | `review_response/PRE_REVIEW_*.md`、`INTERNAL_REVIEW_*.md`、external review 報告 | `/pre-review` → `/review` → `/external-review` の Critical/Major 全件に方針（直す / 反論 / narrow）。Jessica 承認 | `/pre-review`, `/review`, `/external-review`, `/simulate-qa`, `/defend` |
| 7 | **Submission prep** 投稿準備 | Katrina（Rachel, Mike） | `paper/submission/SUBMISSION_CHECK_*.md`、`CITATION_AUDIT_*.md`、abstract ≤ 250 words | `templates/reporting_checklist.md` R1–R8 全 ✅（claims / ADEMP+MCSE / 不確かさ / numbers ledger / citations / reproduction / 図表 / 記録）、Jessica 承認、`/handoff` | `/submission-check`, `/verify-numbers`, `/cite-check`, `/claims check`, `/handoff` |
| 8 | **Revision** 査読応答 | Harvey（Donna） | `review_response/RESPONSE_TRACKER.md`、`RESPONSE_LETTER.md` | 全 comment closed（各変更は段落レビュー済み、新しい claim は `CLAIMS.md` 経由）→ Phase 7 へ戻る | `/respond-reviewers`, `/decide`, ARS `/ars-revision-coach`（素材） |
| 9 | **Closeout** 完了 | Donna（Harvey） | `memory/` の principles 更新、`archives/`、`IDEAS_BACKLOG.md`、`DECISIONS.md` の lessons | Lessons が versioned memory に入り、次の Question が backlog にある | `/victory`, `/archive`, `/handoff` |

**遷移規則**
- 前進は `/phase next` のみ。Donna が各 gate を **on-disk evidence** で検証（語られただけは ❌）。`scripts/check_consistency.sh` を先に走らせる
- 後退は自由（Phase 8 → 7、Phase 6 → 5 など）。理由を LAB_STATUS の history と `DECISIONS.md` に書く
- Phase 2→3（protocol Go）、6→7、7→投稿は Jessica の承認が必須。Louis は全 gate で一件以上の risk を述べる
- Phase 5 と 8 の原稿変更は **必ず段落レビュー**（Tak OK）。`@bg` 不可。包括指示で適用した段落は `DECISIONS.md` に指示の日時を残し、投稿前に Tak の拒否権期間を閉じる

---

## 2. 各 Phase の作業原則（versioned memory の集約 — `memory/INDEX.md`）

| Phase | 原則 | 出典（repo 版） |
|---|---|---|
| 0–2 | 選択肢 → 選択 → 理由。いきなり結論を出さない | `memory/feedback_tak_feedback_patterns.md` |
| 2 | θ を置く効果追跡 sim はしない（一般性を破壊、KR 双対の循環） | `memory/project_no_effect_tracking_sim.md` |
| 2, 5 | 小宮山 Ch.4 = 1 EM 1 代表値。RV2/RV3 は我々の拡張。原典 verbatim で引く | `memory/feedback_komiyama_no_overreading.md` |
| 2–5 | 論文は違いを定量化するだけ。判定規則・閾値・手続きは規定しない | `memory/feedback_quantify_not_decide.md` |
| 3, 4, 7 | 計算後は必ず再検証。producer ≠ verifier。ledger に結ぶ | `memory/feedback_calculation_verification.md` |
| 4 | 図: 7"・base 11・greyscale。caption は「何がプロットされているか」のみ | `.claude/rules/r-code.md` |
| 5 | Tak の 5 原則（P1–P5）+ S、`\emph{}` 禁止、E17 に "recommends" 禁止 | `templates/review_checklist.md`、`.claude/rules/paper-writing.md` |
| 5, 8 | 段落単位、EN が原稿、全メンバー参加、Louis 必須、Option A/B/C | `memory/feedback_tak_feedback_patterns.md` |
| 5 | 本体 → Discussion → Abstract/略語（Terminal pass）。作成過程の検討事項は supplement にしない | 同上 |
| 6 | reviewer に言われる前に自分で弱点を見つける | `/pre-review`、Louis memory `.claude/agent-memory/louis/` |
| 全 | 語られた ≠ ディスクにコミット。compaction 後は 5-step verification | `memory/feedback_compaction_protocol.md` |
| 全 | bg の結果は段落レビューを中断しない。必ず SUITS に落とす | `memory/feedback_bg_report_timing.md` |

---

## 3. Claude Code 機能レビューと SUITS への割当（2026-09-21、2026-10-10 更新）

| 機能 | 状態（本プロジェクト） | SUITS での用途 |
|---|---|---|
| **CLAUDE.md** | Rule 1–6（10-10 に Rule 5 Lifecycle・Rule 6 Scientific Integrity を追加） | 憲法。本書と rules は CLAUDE.md を補う位置 |
| **`.claude/rules/*.md`（`paths:` で範囲限定）** | 4 本: `paper-writing.md` / `r-code.md` / `suits-script.md` / **`protocol-and-results.md`**（新） | 原稿・R・脚本・研究記録を触るときだけ該当規則を注入 |
| **Skills（`.claude/skills/*/SKILL.md`）** | 33 本。10-11 新設 `/replicate`。10-10 新設 5 本: `/claims` `/reproduce` `/cite-check` `/decide` `/lint-suits`。改訂 9 本: `/protocol`（ADEMP+MCSE）`/review`（構造化・on-disk）`/verify-numbers`（ledger・four-eyes）`/start`（scaffold）`/meeting`（decision record）`/phase`（機械的 gate）`/submission-check`（R1–R8）`/pre-review` `/handoff` | Phase gate と各段階の手順書 |
| **Subagents（`.claude/agents/*.md`）** | 7 本。persona は `agents/*.md`。Louis/Jessica は `disallowedTools: Edit, Write`。Louis は `memory: project`。10-10 に scientific-method duties を各 agent に追記 | `@bg @katrina` や `/pre-review` の並列を persona・tool 範囲固定で実行 |
| **Hooks** | 15 本（下表） | Donna の enforcement |
| **Scripts（`scripts/`）** | 12 本 + R 2 本 + 回帰テスト 60 件（§7） | hook・skill・CI から呼ぶ機械的検証と生成 |
| **CI（`.github/workflows/`）** | **新設 2 本**（10-11）: `lab-checks.yml`（tests・consistency・lint・cite・registry・ratchet・protocol dry-run）、`r-and-tex.yml`（全 R の parse、生成表と macros の鮮度、LaTeX build） | gate を advisory から **blocking** に |
| **Cloud setup（`scripts/cloud_setup.sh`）** | **新設**（10-11）: R 4.3 + TeX Live + PyYAML。環境設定 → Setup script に登録（Tak） | cloud session で sim・再現・compile を実行できる |
| **Quarto（`templates/paper_template.qmd`, `_quarto.yml`）** | **新設**（10-11）。`/start` が scaffold | 新論文は数値を `num()` で引く executable manuscript |
| **Versioned memory（`memory/`）** | **13 本 + INDEX**（10-10 に 12 本を復元） | ローカル auto-memory に依存しない原則。cloud session・clone でも消えない |
| **Templates（`templates/`）** | 18 本。10-10 新設 9 本（protocol / simulation_findings / provenance / claims / decisions / lab_status / literature_search_log / reporting_checklist / numbers_ledger_header） | 研究記録の型 |
| **Auto memory（`~/.claude/projects/.../memory/`）** | ローカル 25 件 | Tak の feedback pattern。Phase 9 で `memory/` に反映 |
| **`@bg` / Agent tool（background）** | 運用中（Rule 3.6） | Phase 1, 3, 4 の独立調査。Tak 判断を要する作業は不可 |
| **Agent Teams / Workflow** | 未使用 | 大規模並列時に Tak が opt-in |
| **`isolation: worktree`** | `/reproduce` が使う | clean checkout 再実行 |
| **`/compact` + PreCompact hook** | `pre-compact-snapshot.sh` | compaction 前にディスクの実状態を保存 |
| **Plugins（ARS）** | 導入済み（`/ars-*`） | 素材生成器。persona・判断・記録は SUITS 側 |
| **MCP（PubMed 等）** | Rachel subagent に付与 | DOI 取得・引用確認 |

### Hooks（settings.json）

| Event | Script | 役割 | 状態 |
|---|---|---|---|
| SessionStart | `session-start-context.sh` | 行数・branch・Phase・snapshot の有無 + **`check_consistency.sh`** | 修正（10-10） |
| SessionStart(compact) | `post-compact-remind.sh` | role reminder + 5-step + Phase | 既存 |
| PreCompact | `pre-compact-snapshot.sh` | git log/status/diff、SUITS 最新 scene、Phase を `.claude/state/` に保存 | 既存 |
| UserPromptSubmit | `remind-suits-on-prompt.sh`, `validate-paper-request.sh` | 5 分未更新の警告、DOI 必須 | 既存 |
| PreToolUse(Bash) | `pre-bash-safety.sh` | 危険な再帰削除（root / home）と main への force push の遮断 | 既存 |
| PreToolUse(Bash) | **`pre-run-protocol-check.sh`** | PROTOCOL に無い結果生成スクリプトの `Rscript` を警告（protocol first） | **新設** |
| PostToolUse(Write\|Edit) | `check-suits-update.sh`, `check-suits-lines.sh`, `check-paper-sync.sh`, `check-numbers-verification.sh` | 記録・行数・EN/JA 同期・数値検証（ledger と `numbers_audit.py` を案内） | 既存（numbers は修正） |
| PostToolUse(Write\|Edit) | **`lint-suits.sh`** | SUITS.md 編集時に `lint_suits.py`（ラストネーム・敬語・label・順序） | **新設** |
| PostToolUse(Write\|Edit) | **`check-r-reproducibility.sh`** | R ファイル編集時に静的再現性 lint（seed・絶対パス・sessionInfo・parallel RNG） | **新設** |
| SubagentStop | `subagent-stop-record.sh` | bg メンバー完了 → SUITS 記録を促す | 既存 |
| Stop | `check-suits-lines.sh`, `check-persistence.sh` | archive 警告、Persistence Guard | 既存 |

---

## 4. 一日の流れ（運用例）

```
セッション開始  → hook が Phase と consistency findings を表示 → /phase で gate を確認
作業           → 各 significant action を SUITS.md に scene（Rule 2）。判断は /decide、主張は /claims
新しい結果が要る → /protocol（ADEMP・MCSE・licenses を commit）→ 実装 → /reproduce → /verify-numbers → SIMULATION_FINDINGS
段落を Tak へ  → review_checklist（P1–P5 + S）→ Option A/B/C → Tak OK → 適用 → 検証 grep → compile
gate が揃った  → /phase next（Donna 検証、Louis risk、必要なら Jessica 承認）
投稿前         → /claims check → /verify-numbers → /cite-check → /submission-check（R1–R8）→ Jessica
終了           → /handoff（claimed vs on-disk、consistency、lint）→ Stop hook
```

---

## 5. 未採用（意図的）

- **Agent Teams / Workflow の常時化**: cost と複雑さ。必要な Phase で Tak が opt-in
- **LLM による tone linter**: 毎編集で LLM 呼び出しが走る。機械的 lint（`lint_suits.py`）で取れる違反を先に取り、tone の質は Donna が読む
- **全 subagent への `memory:`**: 散らばると管理不能。Louis のみ
- **数値 gate の blocking 化**（hook exit 2）: 誤検出で執筆を止める。advisory + `/submission-check` での strict 判定に留める

---

## 6. Scientific integrity principles（2026-10-10 — 機構に落とした原則）

| # | 原則 | 何が問題だったか（repo の記録） | 機構 |
|---|---|---|---|
| S1 | **Pre-registration**: 結果を見る前に claim・licenses・ADEMP・MCSE を commit | protocol は 1 本だけ（`PROTOCOL_real_data_survey.md`）。多くの sim は protocol なしで回り、後から用途が変わった | `/protocol` + `templates/protocol_template.md` + hook `pre-run-protocol-check.sh` |
| S2 | **Claims ↔ evidence registry**: 主張は台帳の 1 行、証拠はディスク上のパス、動詞は証拠の型に従う | 構成の迷走 v3→v6、"three gaps" の enumeration drift、per-EM bound を joint に売る overclaim（Louis memory） | `CLAIMS.md` + `/claims` + `review_checklist.md` S 節 |
| S3 | **Decision trail**: 判断は理由付きで append-only に残す。覆すときは理由に答える | ρ 残置決定の reasonless な反転、「決定 X と矛盾」だけの却下 | `DECISIONS.md` + `/decide` + `/meeting` Phase 4 |
| S4 | **Uncertainty always**: 推定値に CI/SE、性能指標に Monte Carlo SE、$n_{\mathrm{sim}}$ は目標 MCSE から | 性能指標が点推定で報告されていた（Morris et al. 2019 の基準未適用） | protocol §3P、`simulation_findings_template.md`、`paper-writing.md` |
| S5 | **Four-eyes numbers**: producer ≠ verifier、原稿の全数値は ledger に source と verifier | S6/S7 の MC 真値誤差、旧 run の読み違い、Study 番号入れ替えに伴う残存 | `scripts/numbers_audit.py` + `NUMBERS_LEDGER.csv` + `/verify-numbers` |
| S6 | **Reproducibility is executed, not asserted**: clean checkout から再実行し許容差を記録 | `w1_raw_simulation.R` の parallel RNG 非再現、絶対パス 20 本、sessionInfo 欠落 | `scripts/check_r_reproducibility.sh` + `/reproduce` + provenance |
| S7 | **Citations say what we say they say**: 原典の verbatim で照合、DOI 必須、要約から引かない | `Song_2025.md` の誤読、「定量手法は存在しない」の誤り | `scripts/cite_audit.py` + `/cite-check` + `summary_template.md` "does NOT say" |
| S8 | **Exploratory ≠ confirmatory**: protocol 外は "exploratory" と明記、prior look は開示 | 事後に選んだ閾値（SMD < 0.1）— `PROTOCOL_real_data_survey.md` §0 が手本 | protocol §0 / §5、findings §5 |
| S9 | **Quantify, do not decide**: 判定規則・閾値・手続きの推奨を書かない | v6 で判定の仕組みを全削除（Tak 09-25） | `memory/feedback_quantify_not_decide.md`、`paper-writing.md` |
| S10 | **Principles are versioned**: 原則はローカル auto-memory ではなく repo の `memory/` に | 参照先 12 本が repo に無く、cloud session では原則が消えていた | `memory/INDEX.md`、`check_consistency.sh` の参照照合 |
| S11 | **Character consistency is checked mechanically where it can be** | ラストネーム・敬語・「全部記録したわ」が再発 | `scripts/lint_suits.py` + hook `lint-suits.sh` + `/lint-suits` |
| S12 | **Numbers are generated, never typed**（10-11）: 結果に由来する数値は registry の 1 行、原稿は `\numval{key}` / `num("key")`、表は single writer が `paper/generated/` に tabular 全体を書く。丸めは decimal half-even | 原稿 672 数値に source なし。0.9425 が機械によって 0.942 / 0.943 に割れた（formatC は binary の丸め） | `paper/numbers_registry.csv` + `scripts/numbers_registry.py` + `scripts/r/numbers_registry.R` + `scripts/make_numbers_macros.R` + `R/make_paper_tables.R` |
| S13 | **Protocols compile**（10-11）: ADEMP の機械可読部（YAML front matter）から R の骨格（seed・grid・MCSE・出力・provenance・findings）を生成。人が書くのは data draw と推定量だけ | protocol は文書、コードは別に手書き → 乖離（prose vs code） | `scripts/protocol_compile.py` + `templates/protocol_template.md` |
| S14 | **Replication from the Methods text**（10-11）: Louis が Methods 本文だけから推定量を再実装し、canonical と列ごとに比較 | 一度だけの `louis_independent_replication.R` | `/replicate` + `louis-replication` agent + `scripts/extract_methods.py` + `scripts/compare_results.py` |
| S15 | **Gates block in CI**（10-11）: 全チェックを push ごとに実行。ratchet baseline は下がるだけ | hook は advisory、語っただけでも merge できた | `.github/workflows/*.yml` + `scripts/ci_ratchet.sh` + `scripts/baseline/` |

---

## 7. Scripts（`scripts/`）

| script | 役割 | 呼ぶ場所 |
|---|---|---|
| `lint_suits.py` | SUITS.md の機械的 character lint（ラストネーム・Harvey/Louis/Jessica の敬語・speaker label・Donna scribe・scene 順・場所見出し・silent メンバー） | hook `lint-suits.sh`、`/lint-suits`、`/handoff` |
| `numbers_audit.py` | 原稿の全数値を抽出し `results/NUMBERS_LEDGER.csv` と照合。`--draft-ledger` で雛形 | `/verify-numbers`、`/submission-check` R4 |
| `cite_audit.py` | `\cite` ↔ `.bib` 照合（missing / uncited / DOI / 重複）+ citation–claim 表の雛形 | `/cite-check`、`/submission-check` R5 |
| `check_r_reproducibility.sh` | R スクリプトの静的 lint（seed・parallel RNG・絶対パス・sessionInfo・install.packages） | hook `check-r-reproducibility.sh`、`/reproduce`、`/submission-check` R6 |
| `check_consistency.sh` | Phase 同期、stale LAB_STATUS、undefined `\ref`、欠けた lifecycle artifacts、未バージョンの memory 参照、SUITS 行数 | hook `session-start-context.sh`、`/phase`、`/handoff` |
| `check_all.sh` | 上の 5 本を一度に回し、`review_response/MECHANICAL_CHECKS_{date}.md` に 1 本の報告（artifacts の有無・CLAIMS の supported/pending も） | `/submission-check`、`/handoff`、`/phase`、Donna |
| `numbers_registry.py` | registry（key → CSV の source・filter・column・agg・fmt）を評価: `build` / `check`（macros ↔ registry ↔ 原稿の `\numval`）/ `verify-draft`（原稿の literal vs CSV）/ `apply`（literal → `\numval{}`）/ `value` | `/verify-numbers`、CI |
| `r/numbers_registry.R` + `make_numbers_macros.R` | 同じ semantics の R 実装（canonical generator）。`num("key")` は Quarto 原稿の inline 用。丸めは `.num_round_dec()`（decimal half-even） | `R/make_paper_tables.R`、Quarto、CI（R vs Python 一致を `cmp`） |
| `protocol_compile.py` | protocol の YAML front matter を検証（$n_{\mathrm{sim}}$ vs 目標 MCSE、owner、true_value）し `R/{study}.R` / provenance / findings の骨格を生成 | `/protocol`、CI（dry-run） |
| `extract_methods.py` | 原稿から Methods（+ Appendix）だけを切り出す（comment・`\input` を除去）。clean-room replicator への入力 | `/replicate` |
| `compare_results.py` | 2 つの CSV を key で突き合わせ、列ごとに max abs / rel diff と欠損行を報告（PASS/FAIL、markdown） | `/replicate`、`/reproduce` |
| `ci_ratchet.sh` | numbers unsourced と R lint ❌ の件数が `scripts/baseline/` を超えたら FAIL。`--update` で現在値を baseline に | CI、Donna |
| `cloud_setup.sh` | cloud session の Setup script（R・TeX Live・PyYAML） | 環境設定（Tak） |
| `tests/run_tests.sh` | fixtures に対する回帰テスト 60 件（各 script の検出・除外・strict exit、丸め境界、R と Python の一致、hooks の発火条件）。script や hook を触ったら必ず回す | 開発時、`/handoff`、CI |

すべて advisory（exit 0）。strict 判定は `--strict` / `STRICT=1` で `/submission-check` が使う。R が無い環境でも動く（静的解析のみ）。**Claude Code は repo root から起動する**（subagent の `memory: project` と hooks のパス解決が cwd に依存する。10-10 に Louis の memory が 3 か所に分裂していたのを統合した）。

---

## 8. 2026-10-10 の見直しで見つかった事実（記録）

- `LAB_STATUS.md` は 09-21 で止まり、SUITS.md と不一致（v6・Terminal pass が未反映）
- `PAPER_LOGIC.md`・`PAPER_OUTLINE_BILINGUAL.md` は削除済み節（§2.5 operability、§4.5）を参照している（stale）
- 段落レビュー #8–#50 は Tak の包括指示で Harvey 推奨を適用（個別拒否権が開いたまま）→ 投稿前に `DECISIONS.md` で閉じる
- 原稿 `per_em_W1_wiley.tex`: 数値トークン 672（355 の異なる値）に ledger なし／cited 25 keys は全件 .bib に存在、DOI 欠落は E17 guideline 1 件（URL あり）／`.bib` の 19 entries は未引用
- R スクリプト 83 本中、絶対パス 20 本、結果を書くのに `sessionInfo` 無し 50 本超、seed 無しで乱数 3 本
- Louis の subagent memory が `.claude/agent-memory/louis/`（2 本）、`projects/similarity-metric/.claude/…`（8 本）、`projects/similarity-metric/claude_science/.claude/…`（3 本）に分裂していた（起動ディレクトリ違い）→ root に統合、`check_consistency.sh` が再発を検出
- `/process-paper` の cleanup が `/tmp` の再帰削除だったため、安全フック `pre-bash-safety.sh` に必ず止められていた → `.claude/tmp/`（gitignored、相対パス）に変更
- `PAPER_LOGIC.md` と `PAPER_OUTLINE_BILINGUAL.md` に STALE banner、`LAB_STATUS.md` を on-disk sync（Phase は 8 のまま、gate は再表現）
- これらは**プロジェクトの作業**であり、本書の改訂では直していない。次セッションで `/claims init` → `/verify-numbers` → `/cite-check` → `/reproduce` → `/phase` の順に消化する

### 10-11（Option B の作業で見つかった事実）
- **丸めが機械依存だった**: S4, n=50 の coverage 0.9425（10,000 回の 9,425 回、decimal の正確な境界）が、同じ `formatC(x, "f", 3)` で Tak のマシンでは 0.942、Linux では 0.943 と印字された（binary の double は 0.9425 のわずか上）。S7, n=50 の 0.9285 も境界。registry は **decimal round-half-even** を両実装に固定し、原稿の 0.942 / 0.928 を再現する（`DECISIONS.md` D-20261011-2）
- `build.sh` の `bibtex` が絶対パスで、Linux の TeX Live（`openout_any = p`）では .bbl を書かず引用が全て undefined になっていた → 相対パスに修正（Windows でも動く）
- tabular の中に行だけを `\input` すると `\bottomrule` の `\noalign` が壊れる → 生成ファイルは **tabular 全体**を持つ
- §3.2（推定の結果）の 34 数値を registry 化、3 表を生成に置換: numbers audit 672 → **526**、compile error 0・undefined 0・20 pp、`pdftotext` の本文差分 **0 行**（内容を変えずに構造だけ変えた証拠）
- 全 R スクリプト 123 本は parse OK（CI の R job が通る前提）

---

## 9. Pipeline（Option B, 2026-10-11）— 論文を protocol と data の関数にする

```
PROTOCOL_{study}.md（YAML front matter = ADEMP の機械可読部 + 登録文書）
   │  python3 scripts/protocol_compile.py            ← n_sim ≥ p(1−p)/ε² を検証、owner・true_value 必須
   ▼
R/{study}.R（seed・grid・per-task seeding・MCSE 付き性能指標・CSV/rds/log・sessionInfo）  ← Mike は draw_sample() と推定量だけ書く
   │  Rscript R/{study}.R
   ▼
results/{study}_summary.csv（estimate + mcse）＋ results/{STUDY}_PROVENANCE.md ＋ SIMULATION_FINDINGS_{study}.md
   │  paper/numbers_registry.csv に行（key → file・filter・column・agg・fmt）／ R/make_paper_tables.R が tabular 全体を生成
   ▼
paper/numbers_macros.tex（Rscript scripts/make_numbers_macros.R）＋ paper/generated/*.tex
   │  原稿は \numval{key} と \input{generated/tab_x} だけ（Quarto なら `r num("key")`）
   ▼
build.sh → PDF；pdftotext の差分で「内容を変えない変更」を証明
   │
   ├─ gate: numbers_registry.py check（macros ↔ registry ↔ 原稿）、numbers_audit（残る literal の件数は ratchet で下がるだけ）
   ├─ gate: /replicate — Methods 本文だけから Louis が再実装 → compare_results.py
   ├─ gate: /reproduce — clean checkout で再実行 → compare_results.py、生成物の git diff 0
   └─ CI: lab-checks.yml（毎 push）、r-and-tex.yml（R parse・生成物の鮮度・LaTeX build）
```

**何が変わるか**: 数値の転記という作業と事故が消える。結果を再実行すれば原稿の数値が自動で変わり、変わらなかった箇所は `pdftotext` の差分で確認できる。protocol を書くことがコードを得る最短経路になるので、事前登録が default になる。Methods の記述不足は Louis の replication で毎回露出する。

**何が変わらないか**: 問いの質、臨床的判断、主張の射程は Tak と team の仕事。Louis も homage も同じモデルで、独立性は人の査読に劣る。pipeline は「正しい」を保証せず、「証拠なしに前へ進めない」ことと「同じ入力から同じ原稿が出る」ことを保証する。

**残作業（project）**: 残り 526 の literal を registry へ（§3.1 identification の表と GUSTO の表が大半 — single writer の R を 2 本書く）、`/claims init`、`/replicate` を Study 2 で初回実施、Tak が `scripts/cloud_setup.sh` を環境に登録、CI の初回 green を見て `r-and-tex.yml` の `continue-on-error` を外す
