// =============================================================================
// nABCD Bootstrap — Rcpp Implementation
// Author: Mike Ross (Methodologist)
//
// Complete bootstrap CI (Percentile + optional BCa) in C++.
// ~50-100x faster than pure R replicate-based approach.
// Key optimizations:
//   - No ecdf object creation (sort-based W1 for equal n)
//   - No R function call overhead (single C++ loop for B iterations)
//   - Merge-sort for pooled IQR (O(n) vs O(n log n))
//   - BCa jackknife fully in C++ (eliminates vapply bottleneck)
//   - Memory reuse across bootstrap iterations (no matrix allocation)
//
// Usage from R:
//   Rcpp::sourceCpp("R/nABCD_rcpp.cpp")
//   result <- nABCD_bootstrap_cpp(x, y, B = 2000, compute_bca = TRUE)
// =============================================================================

#include <Rcpp.h>
#include <algorithm>
#include <cmath>
#include <vector>
#include <numeric>
using namespace Rcpp;

// --- Helpers ----------------------------------------------------------------

// Quantile type=7 from 0-indexed sorted array (matches R default)
static double quantile7(const double* sorted, int n, double p) {
  double h = (n - 1) * p;
  int lo = (int)h;
  if (lo + 1 >= n) return sorted[n - 1];
  return sorted[lo] + (h - lo) * (sorted[lo + 1] - sorted[lo]);
}

// IQR from sorted array
static double iqr_sorted(const double* sorted, int n) {
  return quantile7(sorted, n, 0.75) - quantile7(sorted, n, 0.25);
}

// General W1 via CDF integration (for unequal sample sizes in jackknife)
// x_sorted and y_sorted must be pre-sorted
static double wasserstein1_general(const std::vector<double>& xs,
                                   const std::vector<double>& ys) {
  int n1 = xs.size(), n2 = ys.size();
  int n = n1 + n2;
  std::vector<double> all_v(n);
  std::merge(xs.begin(), xs.end(), ys.begin(), ys.end(), all_v.begin());

  double w1 = 0;
  for (int k = 0; k < n - 1; k++) {
    double mid = (all_v[k] + all_v[k + 1]) / 2;
    int cx = (int)(std::upper_bound(xs.begin(), xs.end(), mid) - xs.begin());
    int cy = (int)(std::upper_bound(ys.begin(), ys.end(), mid) - ys.begin());
    w1 += std::abs((double)cx / n1 - (double)cy / n2) *
          (all_v[k + 1] - all_v[k]);
  }
  return w1;
}

// nABCD from two sorted samples (general, for jackknife)
static double compute_nABCD_sorted(const std::vector<double>& xs,
                                   const std::vector<double>& ys) {
  int n = xs.size() + ys.size();
  std::vector<double> pooled(n);
  std::merge(xs.begin(), xs.end(), ys.begin(), ys.end(), pooled.begin());

  double iqr = iqr_sorted(pooled.data(), n);
  if (iqr <= 0) return NA_REAL;
  return wasserstein1_general(xs, ys) / (2 * iqr);
}

// Remove element at position `pos` from sorted vector (O(n) copy)
static std::vector<double> sorted_without(const std::vector<double>& sorted,
                                          const double* original, int n,
                                          int remove_idx) {
  // Find position of original[remove_idx] in sorted array
  double val = original[remove_idx];
  std::vector<double> result;
  result.reserve(n - 1);
  bool removed = false;
  for (int i = 0; i < n; i++) {
    if (!removed && sorted[i] == val) {
      removed = true;
      continue;
    }
    result.push_back(sorted[i]);
  }
  return result;
}

// --- Main bootstrap function ------------------------------------------------

// [[Rcpp::export]]
List nABCD_bootstrap_cpp(NumericVector x, NumericVector y,
                         int B = 2000, double conf = 0.95,
                         bool compute_bca = false) {
  int n1 = x.size(), n2 = y.size();
  int n_total = n1 + n2;

  List null_res = List::create(
    Named("estimate")  = NA_REAL,
    Named("pct_lower") = NA_REAL, Named("pct_upper") = NA_REAL,
    Named("bca_lower") = NA_REAL, Named("bca_upper") = NA_REAL,
    Named("se")        = NA_REAL
  );

  // --- Original estimate ---
  std::vector<double> xs(x.begin(), x.end());
  std::vector<double> ys(y.begin(), y.end());
  std::sort(xs.begin(), xs.end());
  std::sort(ys.begin(), ys.end());

  // Merge sorted arrays for pooled IQR (O(n) vs O(n log n) for sort)
  std::vector<double> pooled(n_total);
  std::merge(xs.begin(), xs.end(), ys.begin(), ys.end(), pooled.begin());

  double iqr_p = iqr_sorted(pooled.data(), n_total);
  if (iqr_p <= 0) return null_res;

  // W1 for equal-sized sorted samples: mean(|x_(i) - y_(i)|)
  double w1 = 0;
  if (n1 == n2) {
    for (int i = 0; i < n1; i++) w1 += std::abs(xs[i] - ys[i]);
    w1 /= n1;
  } else {
    w1 = wasserstein1_general(xs, ys);
  }
  double est = w1 / (2 * iqr_p);

  // --- Bootstrap (all B iterations in C++, no R overhead) ---
  std::vector<double> boot_vals;
  boot_vals.reserve(B);

  // Reusable buffers (no per-iteration allocation)
  std::vector<double> xb(n1), yb(n2), pb(n_total);

  // Precompute IQR quantile indices
  double h1 = (n_total - 1) * 0.25;
  double h3 = (n_total - 1) * 0.75;
  int f1 = (int)h1, f3 = (int)h3;
  double frac1 = h1 - f1, frac3 = h3 - f3;

  for (int b = 0; b < B; b++) {
    // Resample with replacement (using R's RNG for reproducibility)
    for (int i = 0; i < n1; i++)
      xb[i] = x[std::min((int)(R::unif_rand() * n1), n1 - 1)];
    for (int i = 0; i < n2; i++)
      yb[i] = y[std::min((int)(R::unif_rand() * n2), n2 - 1)];

    // Sort resamples
    std::sort(xb.begin(), xb.end());
    std::sort(yb.begin(), yb.end());

    // W1 (equal n: direct sorted comparison)
    double w1b = 0;
    if (n1 == n2) {
      for (int i = 0; i < n1; i++) w1b += std::abs(xb[i] - yb[i]);
      w1b /= n1;
    } else {
      w1b = wasserstein1_general(
        std::vector<double>(xb.begin(), xb.end()),
        std::vector<double>(yb.begin(), yb.end()));
    }

    // Merge sorted xb, yb for pooled IQR (O(n) merge)
    std::merge(xb.begin(), xb.end(), yb.begin(), yb.end(), pb.begin());

    double q1b = pb[f1] + frac1 * (pb[f1 + 1] - pb[f1]);
    double q3b = pb[f3] + frac3 * (pb[f3 + 1] - pb[f3]);
    double iqr_b = q3b - q1b;

    if (iqr_b > 0) {
      boot_vals.push_back(w1b / (2 * iqr_b));
    }
  }

  int B_valid = (int)boot_vals.size();
  if (B_valid < 10) {
    null_res["estimate"] = est;
    return null_res;
  }

  // Sort bootstrap values for quantile computation
  std::sort(boot_vals.begin(), boot_vals.end());

  // Percentile CI (quantile type=7)
  double alpha = 1 - conf;
  double pct_lower = std::max(0.0,
    quantile7(boot_vals.data(), B_valid, alpha / 2));
  double pct_upper = quantile7(boot_vals.data(), B_valid, 1 - alpha / 2);

  // SE
  double mean_b = std::accumulate(boot_vals.begin(), boot_vals.end(), 0.0) /
                  B_valid;
  double var_b = 0;
  for (int i = 0; i < B_valid; i++)
    var_b += (boot_vals[i] - mean_b) * (boot_vals[i] - mean_b);
  double se = std::sqrt(var_b / (B_valid - 1));

  // --- BCa (optional, fully in C++ — eliminates vapply bottleneck) ---
  double bca_lo = NA_REAL, bca_hi = NA_REAL;
  if (compute_bca) {
    // z0: bias correction
    int n_below = 0;
    for (int i = 0; i < B_valid; i++)
      if (boot_vals[i] < est) n_below++;
    double z0 = R::qnorm5((double)n_below / B_valid, 0, 1, 1, 0);

    // Jackknife for acceleration (fully in C++)
    std::vector<double> jack_vals;
    jack_vals.reserve(n_total);

    // Leave-one-out from x: compute nABCD(x[-i], y)
    for (int i = 0; i < n1; i++) {
      std::vector<double> xi = sorted_without(xs, x.begin(), n1, i);
      double val = compute_nABCD_sorted(xi, ys);
      jack_vals.push_back(val);
    }

    // Leave-one-out from y: compute nABCD(x, y[-j])
    for (int j = 0; j < n2; j++) {
      std::vector<double> yj = sorted_without(ys, y.begin(), n2, j);
      double val = compute_nABCD_sorted(xs, yj);
      jack_vals.push_back(val);
    }

    // Remove NAs and compute acceleration
    std::vector<double> valid_jack;
    for (double v : jack_vals)
      if (!ISNA(v)) valid_jack.push_back(v);

    if (!valid_jack.empty()) {
      double jack_mean = std::accumulate(valid_jack.begin(),
                                         valid_jack.end(), 0.0) /
                         valid_jack.size();

      double sum_d2 = 0, sum_d3 = 0;
      for (double v : valid_jack) {
        double d = jack_mean - v;
        sum_d2 += d * d;
        sum_d3 += d * d * d;
      }
      double denom = 6 * std::pow(sum_d2, 1.5);
      double acc = (std::abs(denom) < 1e-15) ? 0 : sum_d3 / denom;

      double z_lo = R::qnorm5(alpha / 2, 0, 1, 1, 0);
      double z_hi = R::qnorm5(1 - alpha / 2, 0, 1, 1, 0);
      double adj_lo = R::pnorm5(
        z0 + (z0 + z_lo) / (1 - acc * (z0 + z_lo)), 0, 1, 1, 0);
      double adj_hi = R::pnorm5(
        z0 + (z0 + z_hi) / (1 - acc * (z0 + z_hi)), 0, 1, 1, 0);

      double eps = 1.0 / (B_valid + 1);
      adj_lo = std::max(eps, std::min(adj_lo, 1 - eps));
      adj_hi = std::max(eps, std::min(adj_hi, 1 - eps));

      bca_lo = std::max(0.0,
        quantile7(boot_vals.data(), B_valid, adj_lo));
      bca_hi = quantile7(boot_vals.data(), B_valid, adj_hi);
    }
  }

  return List::create(
    Named("estimate")  = est,
    Named("pct_lower") = pct_lower, Named("pct_upper") = pct_upper,
    Named("bca_lower") = bca_lo,    Named("bca_upper") = bca_hi,
    Named("se")        = se
  );
}
