# RESEARCH_FRAMEWORK — 科学研究 → 論文執筆の lifecycle（SUITS 実装）

> *"I don't have dreams, I have goals."* — 研究を 10 の Phase と gate に分け、各 gate を Claude Code の機構で機械化する。
> State は `projects/{project}/LAB_STATUS.md`、記録は `SUITS.md`、操作は `/phase`。
> 作成: 2026-09-21。CLAUDE.md（Rule 1–4）を上書きしない。CLAUDE.md が「何を守るか」、本書は「どの順で・何を証拠に進めるか」。

---

## 1. Lifecycle（10 Phase）

| # | Phase | Owner（支援） | 主要 artifact（on disk） | Gate（抜ける条件） | 使う skill / 機構 |
|---|---|---|---|---|---|
| 0 | **Question** 問い | Harvey（Jessica） | `EXISTING_METHODS_AND_NOVELTY.md`（既存法と我々の差分） | 1 文の claim と「なぜ今この論文か」に Jessica が Go | `/start`, `/meeting`, `agents/jessica` |
| 1 | **Literature** 文献 | Rachel | `knowledge/INDEX.md`、`summaries/`、gap statement | 主要文献が KB に処理済み・全 DOI・gap が 1 段落で書ける | `/process-paper(s)`, `/search-kb`, `/request-paper`, PubMed MCP |
| 2 | **Protocol** 設計 | Mike（Louis） | `PROTOCOL_{study}.md`（claim / 比較対象 / シナリオ / seed / licenses する主張） | Louis の攻撃に耐え、Jessica が Go。θ 特定・循環設計なし | `/protocol`, `/defend` |
| 3 | **Implementation** 実装・検証 | Mike（Katrina） | `R/`、出力 CSV、`sessionInfo`、build script | 一発再現・数値の traceability・`/verify-numbers` PASS | `/verify-numbers`, rules `r-code.md`, hook numbers gate |
| 4 | **Results** 結果 | Katrina | `SIMULATION_FINDINGS.md`（licenses する/しない）、figures、tables | 図規格準拠・caption 規則・evidence→claim 対応表 | rules `r-code.md`（図規格）、`/verify-numbers` |
| 5 | **Writing** 執筆 | Harvey / Mike / Katrina | `.tex`、`PAPER_LOGIC.md`（論証地図）、`PAPER_OUTLINE_BILINGUAL.md` | 各段落 Tak OK（5 段階レビュー）。本体→Discussion→Terminal の順 | 段落レビュー（`templates/review_checklist.md`）、rules `paper-writing.md`、Option A/B/C |
| 6 | **Internal review** 内部審査 | Louis（全員） | `review_response/PRE_REVIEW_*.md`、external review 報告 | `/pre-review` → `/review` → `/external-review` の Critical/Major 全件に方針 | `/pre-review`, `/review`, `/external-review`, `/simulate-qa`, `/defend` |
| 7 | **Submission prep** 投稿準備 | Katrina（Rachel, Mike） | `paper/submission/SUBMISSION_CHECK_*.md`、abstract ≤ 250 words | Terminal pass 全項目 ✅、Jessica 承認、`/handoff` | `/submission-check`, `/verify-numbers`, `/handoff` |
| 8 | **Revision** 査読応答 | Harvey（Donna） | `review_response/RESPONSE_TRACKER.md`、`RESPONSE_LETTER.md` | 全 comment closed（各変更は段落レビュー済み）→ Phase 7 へ戻る | `/respond-reviewers`, ARS `/ars-revision-coach`（素材） |
| 9 | **Closeout** 完了 | Donna（Harvey） | memory feedback patterns 更新、`archives/`、`IDEAS_BACKLOG.md` | Lessons が memory に入り、次の Question が backlog にある | `/victory`, `/archive`, `/handoff` |

**遷移規則**
- 前進は `/phase next` のみ。Donna が各 gate を **on-disk evidence** で検証（語られただけは ❌）。
- 後退は自由（Phase 8 → 7、Phase 6 → 5 など）。理由を LAB_STATUS の history に書く。
- Phase 6→7 と 7→投稿は Jessica の承認が必須。Louis は全 gate で一件以上の risk を述べる。
- Phase 5 と 8 の原稿変更は **必ず段落レビュー**（Tak OK）。`@bg` 不可。

---

## 2. 各 Phase の作業原則（既存 memory の集約）

| Phase | 原則 | 出典 |
|---|---|---|
| 0–2 | 選択肢 → 選択 → 理由。いきなり結論を出さない | `feedback_writing_logic_flow` |
| 2 | θ を置く効果追跡 sim はしない（一般性を破壊、循環論法） | `project_no_effect_tracking_sim` |
| 2, 5 | 小宮山 Ch.4 = 1 EM 1 代表値。RV2/RV3 は我々の拡張 | `feedback_komiyama_no_overreading` |
| 3, 4, 7 | 計算後は必ず再検証してから報告。Mike が verifier | `feedback_calculation_verification` |
| 4 | 図: 7"・base 11・greyscale。caption は「何がプロットされているか」のみ | `feedback_figure_paper_standard`, `feedback_caption_writing` |
| 5 | Tak の 5 原則（P1–P5）、`\emph{}` 禁止、E17 に "recommends" 禁止 | `feedback_tak_review_principles`, `feedback_paper_no_emph` |
| 5, 8 | 段落単位、EN が原稿、全メンバー参加、Louis 必須、Option A/B/C | `feedback_review_process`, `feedback_review_characters` |
| 5 | 本体 → Discussion → Abstract/略語（Terminal pass） | `feedback_tak_feedback_patterns` 作業順序 |
| 6 | reviewer に言われる前に自分で弱点を見つける | `feedback_proactive_review` |
| 全 | 語られた ≠ ディスクにコミット。compaction 後は 5-step verification | `feedback_compaction_protocol` |

---

## 3. Claude Code 機能レビュー（2026-09-21、docs 照合済み）と SUITS への割当

| 機能 | 状態（本プロジェクト） | SUITS での用途 |
|---|---|---|
| **CLAUDE.md** | 既存（Rule 1–4）。ARS scope guard により編集は Tak のみ | 憲法。本書と rules は CLAUDE.md を補う位置 |
| **`.claude/rules/*.md`（`paths:` で範囲限定）** | **新設 3 本**: `paper-writing.md` / `r-code.md` / `suits-script.md` | 原稿・R・脚本を触るときだけ該当規則を注入。CLAUDE.md を肥大化させない |
| **Skills（`.claude/skills/*/SKILL.md`）** | 既存 22 本 + **新設 5 本**: `/phase` `/protocol` `/pre-review` `/submission-check` `/respond-reviewers` | Phase gate と各段階の手順書。`argument-hint` で引数を明示 |
| **Subagents（`.claude/agents/*.md`）** | **新設 7 本**（harvey, mike, donna, rachel, katrina, louis, jessica） | `@bg @katrina` や `/pre-review` の並列を、persona・tool 範囲・model を固定した本物の subagent で実行。Louis/Jessica は `disallowedTools: Edit, Write`（批評は原稿を触らない）。Louis は `memory: project` で「過去に突かれた穴」を蓄積 |
| **Hooks** | 既存 10 本 + **新設 2 本** + 修正 3 本 | 下表参照 |
| **Auto memory（`~/.claude/projects/.../memory/`）** | 既存 25 件 | Tak の feedback pattern。Phase 9 で更新 |
| **`@bg` / Agent tool（background）** | 運用中（Rule 3.6） | Phase 1, 3, 4 の独立調査。Tak 判断を要する作業は不可 |
| **Agent Teams**（`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`） | 未使用 | 3/1 実績（5 チーム並行）に相当。Phase 3–4 の大規模並列時に opt-in |
| **Workflow tool / `ultracode`** | 未使用 | `/pre-review` の 6 並列 → Louis 統合、を script 化する候補（Tak が明示 opt-in したときのみ） |
| **`isolation: worktree`** | 既存運用（`.claude/worktrees/`） | Phase 3 の sim 実装を隔離 |
| **`/loop`, CronCreate, `/schedule`** | 未使用 | 長い R 実行の監視（Phase 3）。定期 `/suits` は不要（hook で足りる） |
| **`/compact` + PreCompact hook** | **新設** `pre-compact-snapshot.sh` | compaction 前にディスクの実状態を保存 → 5-step verification の入力 |
| **Plugins（ARS）** | 導入済み（`/ars-*` 14 本） | 素材生成器として利用（`/ars-lit-review`, `/ars-revision-coach`, `/ars-citation-check`）。persona・判断・記録は SUITS 側 |
| **MCP（PubMed, Clinical Trials, Mermaid, IDE）** | 導入済み | Rachel subagent に PubMed ツールを付与済み |
| **Checkpoints / `/rewind`** | 利用可 | 段落適用の失敗（splice 空振り）からの復帰 |
| **Artifacts / Claude Docs** | 利用可 | 外部共有用の report（response letter 草案の共有など）。SUITS の記録先ではない |

### Hooks（settings.json）

| Event | Script | 役割 | 状態 |
|---|---|---|---|
| SessionStart | `session-start-context.sh` | 行数・branch・**Phase**・snapshot の有無 | 修正（Phase 表示追加） |
| SessionStart(compact) | `post-compact-remind.sh` | role reminder + 5-step + **LAB_STATUS から Phase を動的表示** | 修正（nABCD 固定文言を撤去） |
| **PreCompact** | `pre-compact-snapshot.sh` | git log/status/diff、SUITS 最新 scene、Phase を `.claude/state/` に保存 | **新設** |
| UserPromptSubmit | `remind-suits-on-prompt.sh`, `validate-paper-request.sh` | 5 分未更新の警告、DOI 必須 | 既存 |
| PreToolUse(Bash) | `pre-bash-safety.sh` | rm -rf / force push 遮断 | 既存 |
| PostToolUse(Write\|Edit) | `check-suits-update.sh`, `check-suits-lines.sh`, `check-paper-sync.sh`, `check-numbers-verification.sh` | 記録・行数・EN/JA 同期・数値検証 | `check-paper-sync.sh` を汎用化（JA が存在するときだけ発火） |
| **SubagentStop** | `subagent-stop-record.sh` | bg メンバー完了 → SUITS 記録を促す（レビュー中は保留） | **新設** |
| Stop | `check-suits-lines.sh`, `check-persistence.sh` | archive 警告、Persistence Guard | 既存 |

---

## 4. 一日の流れ（運用例）

```
セッション開始  → hook が Phase を表示 → /phase で gate を確認
作業           → 各 significant action を SUITS.md に scene（Rule 2）
並列が要る     → @bg @rachel ... / Agent(subagent_type: "louis") ...
段落を Tak へ  → review_checklist（P1–P5）→ Option A/B/C → Tak OK → 適用 → 検証 grep → compile
gate が揃った  → /phase next（Donna 検証、Louis risk、必要なら Jessica 承認）
終了           → /handoff（claimed vs on-disk）→ Stop hook
```

---

## 5. 未採用（意図的）

- **CLAUDE.md への Rule 追記**: scope guard により Tak の手動編集が必要。追記案: 「Rule 5: Lifecycle — 進行は `RESEARCH_FRAMEWORK.md` の Phase/gate に従い、`/phase next` 以外で Phase を進めない」
- **Agent Teams / Workflow の常時化**: cost と複雑さ。必要な Phase で Tak が opt-in
- **Tone/Speaker linter（prompt-type hook）**: 効果はあるが毎編集で LLM 呼び出しが走る。Rule 3.7/3.8 違反が再発したら導入
- **全 subagent への `memory:`**: 散らばると管理不能。Louis のみ（reviewer の穴の蓄積が最も価値がある）
