# {STUDY} — provenance of `{results file}`

> 手本: `projects/similarity-metric/results/STUDY1_PROVENANCE.md`

Generated: YYYY-MM-DD HH:MM TZ
Producing script: `projects/{project}/R/{script}.R`（commit `{hash}`）

## Canonical run

| Item | Value |
|------|-------|
| Per-replicate source | `results/{file}.rds`（mtime …） |
| Protocol | `PROTOCOL_{study}.md`（registered …） |
| Replications $n_{\mathrm{sim}}$ / bootstrap B | … / … |
| Seed / RNG stream | `set.seed(…)`; parallel: … |
| Grid | … |
| R version / packages | `sessionInfo` → `results/{study}_sessionInfo.txt`（or `renv.lock`） |
| Run time | … |

Superseded runs（あれば）: path と「なぜ canonical でないか」。削除せず、byte-for-byte で残す。

## Reference (true) values

| scenario | definition | true value | how obtained（exact / quadrature rel.tol / MC $n_{\mathrm{MC}}$ ± SE） |
|---|---|---|---|

## Column semantics

| column | definition（分母・単位・proportion か percent か） |
|---|---|

## Reproducibility statement

- 再実行手順（1 コマンド）: `Rscript R/{script}.R`
- 乱数を使わない集計スクリプトは「決定的」と明記
- 既知の非再現性（parallel RNG 等）と回避策
