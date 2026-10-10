# SIMULATION_FINDINGS — {study}

**Protocol**: `PROTOCOL_{study}.md`（registered YYYY-MM-DD, commit `{hash}`）。逸脱は protocol §9 のとおり。
**Producing script**: `R/{study}.R` **Results**: `results/{study}_summary.csv` **Provenance**: `results/{STUDY}_PROVENANCE.md`
**Run**: YYYY-MM-DD HH:MM、$n_{\mathrm{sim}}$ = …、B = …、seed = …、実行時間 …

## 1. ADEMP 要約（protocol §3 と一致させる。差があれば逸脱として §9 へ）

A: … / D: … / E: … / M: … / P: …

## 2. 結果（performance measure ごと、MCSE を併記）

| scenario | n | measure | estimate | MCSE | $n_{\mathrm{sim}}$ |
|---|---|---|---|---|---|

- 主要な読み（事実のみ。解釈は §4）

## 3. 図

| figure | path | what is plotted（caption そのもの） |
|---|---|---|

## 4. この結果が licenses する主張 / しない主張（protocol §2 と照合）

- **Licenses**: …（`CLAIMS.md` の C-xx を supported にできる）
- **Does not license**: …
- protocol §2 より **狭くなった**主張があれば、`CLAIMS.md` を narrowed に更新し、C1 cascade（原稿の該当文言を grep）

## 5. 探索的所見（protocol 外）

- 論文で使うなら "exploratory" と明記。使わないなら「使わない」と書く

## 6. 検証（four-eyes）

| item | producer | verifier（≠ producer） | method（clean-room 再実装 / 再実行 / 手計算） | max abs diff | verdict |
|---|---|---|---|---|---|

## 7. 既知の限界・バグ

- …
