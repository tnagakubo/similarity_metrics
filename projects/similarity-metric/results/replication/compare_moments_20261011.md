# Comparison — study2_estimation_louis.csv vs canonical w1_raw_summary.csv (2026-10-11)

- keys: `scenario, n` · rows canonical 21, candidate 21, matched 21 · tol |diff| ≤ 0.3

| column | n | max abs diff | max rel diff | worst row | verdict |
|---|---|---|---|---|---|
| `bias` | 21 | 9.911e-02 | 8.612e+00 | S4/50 | ✅ |
| `mean_est` | 21 | 9.911e-02 | 2.136e-02 | S4/50 | ✅ |
| `rmse` | 21 | 9.106e-02 | 4.885e-02 | S6/100 | ✅ |
| `mean_ci_width` | 21 | 7.601e-02 | 1.344e-02 | S6/50 | ✅ |

**Verdict: PASS** — every compared column within tolerance.
