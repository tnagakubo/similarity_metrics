# Reporting Checklist — 投稿前の科学的報告基準（Phase 7、`/submission-check` が使う）

全項目 **on-disk evidence** で判定（語られただけは ❌）。journal 形式要件は `paper/submission/SUBMISSION_CHECKLIST.md`、文章規則は `templates/review_checklist.md`。

## R1. 主張と証拠
- [ ] `CLAIMS.md` の全行が supported（narrowed は新文言で、retracted は残存 0）
- [ ] abstract の各文が `CLAIMS.md` の行に対応し、動詞が許容表に収まる
- [ ] Discussion の limitations が、protocol の "does not license" を網羅している

## R2. シミュレーション研究（ADEMP; Morris et al. 2019, DOI 10.1002/sim.8086）
- [ ] Aims / Data-generating mechanisms / Estimands / Methods / Performance measures が本文または Supplement で読める
- [ ] 性能指標に **Monte Carlo SE** が付いている（表の列、または本文の一文）
- [ ] $n_{\mathrm{sim}}$、B、seed、software version が書かれている
- [ ] 真値の求め方（閉形式 / 数値積分 / MC）が書かれている
- [ ] 非収束・除外の規則と件数
- [ ] protocol 外の解析は "exploratory" と明記

## R3. 推定と不確かさ
- [ ] 推定値には区間（CI）か SE が付く。点推定だけの数値は無い
- [ ] estimand が定義されている（記号と式）。"significant" / binary pooled 表現なし
- [ ] 命題・定理の仮定が明示され、仮定が成り立たない場合の挙動が limitations にある

## R4. 数値の traceability
- [ ] `python3 scripts/numbers_audit.py <tex>` の unsourced が 0（または各件に exclusion reason）
- [ ] `results/NUMBERS_LEDGER.csv` の全行に verified_by（producer と別人）と date
- [ ] 表の数値は CSV から生成（手打ちなし）。桁数規則が一貫

## R5. 文献
- [ ] `python3 scripts/cite_audit.py <tex> <bib>`: cited-but-missing 0、article 系の DOI 欠落 0
- [ ] `CITATION_AUDIT_*.md` の "supports the claim?" が全行 yes（no は本文修正済み）
- [ ] E17: describes / notes / permits のみ。原典の verbatim と照合済み

## R6. 再現性
- [ ] `bash scripts/check_r_reproducibility.sh`: 論文に使うスクリプトで ❌ が 0
- [ ] `results/REPRODUCTION_*.md`: clean checkout からの再実行で論文の数値が一致（max abs diff を記録）
- [ ] Data availability / Code availability に、データの入手経路（DOI/URL）とコードの場所
- [ ] `renv.lock` または `sessionInfo` が同梱

## R7. 図表
- [ ] `.claude/rules/r-code.md` の規格（7"、base 11、greyscale、caption は事実のみ）
- [ ] 図のデータは CSV から読み、スクリプトは single writer

## R8. 記録
- [ ] `DECISIONS.md` に主要判断（構成変更・主張の narrow・supplement の扱い）が理由付きで在る
- [ ] `LAB_STATUS.md` と `SUITS.md` の Phase が一致（`scripts/check_consistency.sh` clean）
