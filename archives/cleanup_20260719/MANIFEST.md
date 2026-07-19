# Cleanup Archive Manifest — 2026-07-19

**作成**: Donna Paulsen (Project Manager)
**理由**: Tak 指示によるファイル整理。nABCD 撤回済み遺物・役目を終えた文書・散在 archive フォルダの集約。
**復元**: 下表の「元パス」に mv で戻すだけ。全ファイル git 履歴にも残存。

## 移動一覧

| このフォルダ内 | 元パス | 理由 |
|---|---|---|
| `sim_paper/` | `projects/sim_paper/` | 公開 IPD データセット調査レポート (2026-02)。CRASH2/IST/GUSTO 入手済みで役目終了 |
| `results_nABCD/` (20 files) | `results/` | nABCD 時代 (2026-05-10〜12) のシミュレーション結果 (normalizer比較, true_nabcd, normality check, SMD, redesign)。nABCD 撤回により不要 |
| `scripts_test/` | `scripts/test/` | Marp overflow チェッカーのテスト成果物 (2026-04)。`scripts/check_marp_overflow.js` 本体は現役のため残置 |
| `similarity-metric/archive/` | `projects/similarity-metric/archive/` | 旧 project 内 archive (nABCD 草稿・MANIFEST_20260617 含む) をそのまま集約 |
| `similarity-metric/paper_output/` | `projects/similarity-metric/paper/output/` | nABCD 時代の PDF (nABCD_wiley.pdf, nABCD_paper_ja.pdf, 2026-03〜04)。現行は `paper/per_em_W1_wiley.pdf` |
| `similarity-metric/paper_slides/` | `projects/similarity-metric/paper/slides/` | nABCD presentation 一式 (2026-05-07〜08 発表)。7/3 セミナーは poster/Poster_GSC_TN_script_ja.md + figures/slide_* を使用しており本フォルダは未使用 |
| `similarity-metric/paper_archive_superseded_20260615/` | `projects/similarity-metric/paper/archive/superseded_20260615/` | paper 内 archive の集約 |
| `similarity-metric/figures_archive_v2_20260517/` | `projects/similarity-metric/figures/archive_v2_20260517/` | figures 内 archive の集約 |
| `similarity-metric/poster_nABCD/` | `projects/similarity-metric/poster/nABCD_poster.*` + `nABCD_slide_20260508.pdf` | 旧 nABCD ポスター (tex/pdf/ビルド中間物) + 5/8 発表スライド。現行は Poster_GSC_TN_* |
| `similarity-metric/case_study_explained.md` | `projects/similarity-metric/` | nABCD 時代の case study 解説 (2026-05-06) |
| `similarity-metric/PAPER_WRITING_PLAN_v3.md` | `projects/similarity-metric/` | Path α incremental rewrite プラン (2026-05-17)。リライト完了により役目終了 |

## 削除 (アーカイブせず)

| パス | 理由 |
|---|---|
| `logs/` | 空フォルダ |
| `scripts/test/`, `paper/archive/` | 中身移動後の空フォルダ |

## 温存判断 (アーカイブ対象外)

- `results/w1_raw_*` (root, 4 files) — **現役**。`figures_paper_W1.R` / `fig2_bar_chart.R` / `w1_raw_simulation.R` が repo root の `results/` を参照
- `projects/similarity-metric/OBJECTIVE_BRIEFING.md` — 全メンバー必読の設計思想文書 (v3, Path α)
- `projects/similarity-metric/ARS_PLAN_chapter_summaries.md` — レビュー進行中 (Intro ¶7 以降) の参照文書
- `IDEAS_BACKLOG.md` — active backlog
- `knowledge/input/nABCD_from_Tak.md` — KB 原典 (knowledge/ は原典保存の原則)
- `paper/per_em_W1_wiley.*` のビルド中間物 (aux/log/fls 等) — latexmk 現行ビルド
