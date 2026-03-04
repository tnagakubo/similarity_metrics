"""
IST Country-Level nABCD Analysis
================================
Following the paper's recommended process (Section 4):
  Step 1: Compute nABCD with bootstrap CIs for each candidate EM across country pairs
  Step 2: Summarize results for potential effect modifiers

Background:
- Chen et al. (2000) found NO significant effect modification for aspirin in IST
  across 28 subgroups (age, sex, consciousness, AF, CT, BP, stroke subtype, heparin)
  χ²(18) = 20.9, NS
- Therefore: No confirmed effect modifiers → compare baseline covariates (potential EMs)
- Continuous baseline covariates: Age (AGE), SBP (RSBP), Delay (RDELAY)
  (Paper limitation: nABCD currently applies to continuous EMs only)
- Country-level comparison (not region-level) as requested
"""

import pandas as pd
import numpy as np
from itertools import combinations

# --- Load data ---
ist = pd.read_csv("projects/similarity-metric/data/IST/IST_corrected.csv", encoding='latin-1')
print(f"Dataset: {ist.shape[0]} patients, {ist.shape[1]} variables")

# --- Country distribution ---
country_counts = ist['COUNTRY'].value_counts().sort_values(ascending=False)
print(f"\n=== All {len(country_counts)} countries ===")
print(country_counts.to_string())

# Filter countries with n >= 100 (paper recommends n >= 100 for reliable estimation)
MIN_N = 100
big_countries = country_counts[country_counts >= MIN_N]
print(f"\n=== Countries with n >= {MIN_N}: {len(big_countries)} countries ===")
print(big_countries.to_string())

# --- Baseline summary by country ---
vars_continuous = ['AGE', 'RSBP', 'RDELAY']
var_labels = {'AGE': 'Age (years)', 'RSBP': 'SBP (mmHg)', 'RDELAY': 'Delay (hours)'}

print(f"\n{'='*80}")
print("BASELINE COVARIATES (Potential Effect Modifiers) BY COUNTRY")
print(f"{'='*80}")
print(f"\n{'Country':<8} {'n':>6}  {'Age mean(SD)':>15}  {'SBP mean(SD)':>15}  {'Delay mean(SD)':>15}")
print("-" * 70)
for cntry in big_countries.index:
    d = ist[ist['COUNTRY'] == cntry]
    n = len(d)
    age_m, age_s = d['AGE'].mean(), d['AGE'].std()
    sbp_m, sbp_s = d['RSBP'].mean(), d['RSBP'].std()
    delay_m, delay_s = d['RDELAY'].dropna().mean(), d['RDELAY'].dropna().std()
    print(f"{cntry:<8} {n:>6}  {age_m:>6.1f} ({age_s:>4.1f})    {sbp_m:>6.1f} ({sbp_s:>4.1f})    {delay_m:>5.1f} ({delay_s:>4.1f})")


# --- nABCD computation ---
def compute_w1(x, y):
    """Wasserstein-1 distance = area between CDFs."""
    n1, n2 = len(x), len(y)
    pooled = np.sort(np.concatenate([x, y]))
    # Empirical CDFs at pooled points
    ecdf1 = np.searchsorted(np.sort(x), pooled, side='right') / n1
    ecdf2 = np.searchsorted(np.sort(y), pooled, side='right') / n2
    # Riemann sum
    diffs = np.diff(pooled)
    abs_cdf_diff = np.abs(ecdf1[:-1] - ecdf2[:-1])
    return np.sum(abs_cdf_diff * diffs)


def compute_nABCD(x, y):
    """nABCD = W1 / (2 * IQR_pooled)."""
    w1 = compute_w1(x, y)
    pooled = np.concatenate([x, y])
    q75, q25 = np.percentile(pooled, 75), np.percentile(pooled, 25)
    iqr = q75 - q25
    if iqr == 0:
        return np.nan
    return w1 / (2 * iqr)


def bootstrap_nABCD(x, y, B=2000, alpha=0.05, seed=42):
    """Percentile bootstrap CI for nABCD."""
    rng = np.random.RandomState(seed)
    n1, n2 = len(x), len(y)
    point = compute_nABCD(x, y)
    boot_vals = np.empty(B)
    for b in range(B):
        bx = x[rng.randint(0, n1, n1)]
        by = y[rng.randint(0, n2, n2)]
        boot_vals[b] = compute_nABCD(bx, by)
    lo = np.nanpercentile(boot_vals, 100 * alpha / 2)
    hi = np.nanpercentile(boot_vals, 100 * (1 - alpha / 2))
    return point, lo, hi


# --- Pairwise nABCD for countries with n >= 100 ---
countries = list(big_countries.index)
pairs = list(combinations(countries, 2))

print(f"\n{'='*80}")
print(f"nABCD: PAIRWISE COUNTRY COMPARISON (n >= {MIN_N}, {len(countries)} countries, {len(pairs)} pairs)")
print(f"Bootstrap: B=2000, 95% percentile CI")
print(f"{'='*80}")

results = []
for var in vars_continuous:
    print(f"\n--- {var_labels[var]} ---")
    print(f"{'Pair':<20} {'nABCD':>8} {'95% CI':>20}")
    print("-" * 52)

    for c1, c2 in pairs:
        x = ist.loc[ist['COUNTRY'] == c1, var].dropna().values.astype(float)
        y = ist.loc[ist['COUNTRY'] == c2, var].dropna().values.astype(float)
        if len(x) < MIN_N or len(y) < MIN_N:
            continue
        pt, lo, hi = bootstrap_nABCD(x, y, B=2000)
        results.append({'var': var, 'c1': c1, 'c2': c2, 'nABCD': pt, 'CI_lo': lo, 'CI_hi': hi,
                        'n1': len(x), 'n2': len(y)})
        print(f"{c1} vs {c2:<10} {pt:>8.4f} ({lo:.4f}, {hi:.4f})")

# --- Summary: largest nABCD per variable ---
df = pd.DataFrame(results)
print(f"\n{'='*80}")
print("SUMMARY: TOP 10 LARGEST nABCD VALUES PER VARIABLE")
print(f"{'='*80}")

for var in vars_continuous:
    sub = df[df['var'] == var].sort_values('nABCD', ascending=False).head(10)
    print(f"\n--- {var_labels[var]} ---")
    print(f"{'Rank':<5} {'Pair':<20} {'nABCD':>8} {'95% CI':>20}")
    print("-" * 57)
    for i, (_, row) in enumerate(sub.iterrows(), 1):
        print(f"{i:<5} {row['c1']} vs {row['c2']:<10} {row['nABCD']:>8.4f} ({row['CI_lo']:.4f}, {row['CI_hi']:.4f})")

# --- Reference benchmarks ---
print(f"\n{'='*80}")
print("REFERENCE BENCHMARKS (from paper Table)")
print(f"{'='*80}")
print("  < 0.05: Negligible difference")
print("  0.05 - 0.15: Small difference")
print("  0.15 - 0.30: Medium difference")
print("  > 0.30: Large difference")

# --- Distribution of nABCD values ---
print(f"\n{'='*80}")
print("DISTRIBUTION OF nABCD VALUES BY VARIABLE")
print(f"{'='*80}")
for var in vars_continuous:
    sub = df[df['var'] == var]
    print(f"\n{var_labels[var]} ({len(sub)} pairs):")
    print(f"  Mean={sub['nABCD'].mean():.4f}  Median={sub['nABCD'].median():.4f}")
    print(f"  Min={sub['nABCD'].min():.4f}  Max={sub['nABCD'].max():.4f}")
    print(f"  Negligible (<0.05): {(sub['nABCD'] < 0.05).sum()} pairs ({100*(sub['nABCD'] < 0.05).mean():.0f}%)")
    print(f"  Small (0.05-0.15):  {((sub['nABCD'] >= 0.05) & (sub['nABCD'] < 0.15)).sum()} pairs ({100*((sub['nABCD'] >= 0.05) & (sub['nABCD'] < 0.15)).mean():.0f}%)")
    print(f"  Medium (0.15-0.30): {((sub['nABCD'] >= 0.15) & (sub['nABCD'] < 0.30)).sum()} pairs ({100*((sub['nABCD'] >= 0.15) & (sub['nABCD'] < 0.30)).mean():.0f}%)")
    print(f"  Large (>0.30):      {(sub['nABCD'] >= 0.30).sum()} pairs ({100*(sub['nABCD'] >= 0.30).mean():.0f}%)")

# --- Country-specific profiles (for meeting discussion) ---
print(f"\n{'='*80}")
print("COUNTRY PROFILES: MEAN nABCD ACROSS ALL PAIRS (per country)")
print(f"{'='*80}")
for var in vars_continuous:
    sub = df[df['var'] == var]
    print(f"\n--- {var_labels[var]} ---")
    country_means = {}
    for c in countries:
        c_rows = sub[(sub['c1'] == c) | (sub['c2'] == c)]
        country_means[c] = c_rows['nABCD'].mean()
    sorted_cm = sorted(country_means.items(), key=lambda x: x[1], reverse=True)
    for c, m in sorted_cm:
        n = big_countries[c]
        print(f"  {c:<8} (n={n:>5}): mean nABCD = {m:.4f}")

print("\n=== ANALYSIS COMPLETE ===")
