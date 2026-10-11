# memory/ — versioned principles（repo 版 memory）

二層構造:
- **ローカル auto-memory**（`~/.claude/projects/<path>/memory/`）: Tak の feedback がセッション中に蓄積される。マシン固有・未バージョン管理
- **この `memory/`（repo 版）**: システム（CLAUDE.md / RESEARCH_FRAMEWORK.md / `.claude/**` / `agents/`）が参照する原則の **バージョン管理されたコピー**。cloud session・別マシン・clone 直後でも原則が消えない

**Rule（Donna）**: 両方に同名ファイルがあり内容が食い違うときは新しい方を両方に反映する。システムの文書が memory を参照するときは、この repo 版のパス `memory/<name>.md` を書く。`scripts/check_consistency.sh` が参照先の有無を照合する。

各ファイルは auto-memory と同じ frontmatter（`name` / `description` / `metadata.type`）を持つ。**Source** 行に、repo 内のどの記録から復元したかを書く（捏造防止）。

| file | type | 要旨 | 主な参照元 |
|---|---|---|---|
| `feedback_tak_feedback_patterns.md` | feedback | Tak の原稿レビューで繰り返し出た指摘の集約（段落レビューの型・文言・順序・図表・射程） | RESEARCH_FRAMEWORK §2、agents、skills |
| `feedback_calculation_verification.md` | feedback | 計算後は必ず再検証（producer ≠ verifier、ledger） | hook `check-numbers-verification.sh`、`/verify-numbers` |
| `feedback_compaction_protocol.md` | feedback | 語られた ≠ ディスク。compaction 後の 5-step verification | hooks `pre-compact-snapshot.sh` / `post-compact-remind.sh`、`/handoff` |
| `feedback_quantify_not_decide.md` | feedback | 論文は違いを定量化するだけ。併合の判定規則は規定しない（Tak 2026-09-25） | SUITS.md Current Status、RESTRUCTURE_v6 |
| `feedback_komiyama_no_overreading.md` | feedback | 小宮山 Ch.4 = 1 EM 1 代表値。RV2/RV3 は我々の拡張。原典 verbatim で引く | EXISTING_METHODS_AND_NOVELTY.md、agents/mike・rachel |
| `feedback_bg_report_timing.md` | feedback | background の結果は段落レビューを中断しない。Tak が聞くまで保留、必ず SUITS に落とす | hook `subagent-stop-record.sh` |
| `feedback_speaker_clarity.md` | feedback | Rule 3.7 — 発言者を明示 | CLAUDE.md |
| `feedback_tone_authenticity.md` | feedback | Rule 3.8 — tone が character を決める | CLAUDE.md |
| `feedback_personality_check.md` | feedback | `/rule` で signature と軸を口に出して voice をリセット（Tak 2026-04-25） | `/rule` |
| `project_no_effect_tracking_sim.md` | project | θ を特定する効果追跡 sim はしない（一般性・循環） | `/protocol`、agents/mike、Louis memory |
| `project_ja_paper_deleted.md` | project | JA 版は EN 完成まで意図的に削除（Rule 2.7 保留） | SUITS.md、hook `check-paper-sync.sh` |
| `project_jessica_advisor_role.md` | project | advisor tool の出力は Jessica の声で surface（faithfulness over flavor） | agents/jessica.md Role 4 |
| `project_e17_3layer_positioning.md` | project | 既存実務は EM clustering を提示するが principled 距離を欠く → gap の文言 | （既存、2026-06） |
- `feedback_review_recurrence_patterns.md` — Louis review（2026-10-11）の再発型 3 つ: 区間 overlap ≠ 同等、弁明文は実行した確認だけ引用、cascade は台帳・凡例・protocol まで
