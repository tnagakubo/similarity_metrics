# Normalizer Comparison Simulation — Resume Instructions

## What is running

`run_normalizer_comparison.R` runs Grid 1 (135 cells) + Grid 2 (135 cells) of
the normalizer comparison study with 10,000 Monte Carlo reps and B=1000
bootstrap reps per cell.

## How to (re)launch

From repo root:

```bash
Rscript projects/similarity-metric/R/run_normalizer_comparison.R \
  --reps=10000 --boot=1000 --cores=5
```

The same command works for **fresh start** and **resume**. Resume is
automatic: completed cells are recorded in
`results/normalizer_comparison_grid1_partial.rds` and
`results/normalizer_comparison_grid2_partial.rds` and skipped on relaunch.

## How to check progress

```bash
Rscript -e 'p <- readRDS("results/normalizer_comparison_grid1_partial.rds"); cat("grid1 cells:", length(p$cells), "/ 27\n"); for (c in p$cells) cat(sprintf("  %s n=%d  %.1fs\n", c$scenario, c$n, c$elapsed_s))'
```

## Final outputs (created when each grid finishes)

- `results/normalizer_comparison_grid1.rds` — full Grid 1 results
- `results/normalizer_comparison_grid2.rds` — full Grid 2 results
- `results/true_nabcd_per_normalizer.rds`   — Grid 1 population true values
- `results/true_nabcd_cross_em.rds`         — Grid 2 population true values

## Per-cell wallclock (observed)

- ~929s for S1 n=50 at 6 cores (test 1)
- ~1015s for S1 n=100 at 5 cores (test 2)

Expected total wallclock: ~14-20 hours wall depending on scenario/n mix.

## CLI flags

- `--test`        small validation (200 reps, B=1000 unless `--reps=` given)
- `--reps=N`      override Monte Carlo reps
- `--boot=B`      override bootstrap reps
- `--grid=1|2|both`
- `--cores=K`     worker count (default = detectCores() - 2)
