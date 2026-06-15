// =============================================================================
// nABCD Bootstrap — 5-Normalizer Rcpp Implementation
// Author: Mike Ross (Methodologist)
// Date: 2026-05-10
//
// Computes point estimate + percentile bootstrap CI for 5 normalizers
// (IQR, Range, Q95Q5, SD, MAD) in a single C++ pass.
//
// Speedup vs R-vectorized: ~5-8x expected
// (W1 + sort + merge done once per bootstrap; 5 normalizers from same pool)
//
// Usage from R:
//   Rcpp::sourceCpp("projects/similarity-metric/R/nABCD_5norm_rcpp.cpp")
//   res <- nABCD_bootstrap_5norm_cpp(x, y, B = 1000, conf = 0.95)
//   res$estimate  # named c(IQR, Range, Q95Q5, SD, MAD)
//   res$ci_lower / res$ci_upper
// =============================================================================

#include <Rcpp.h>
#include <algorithm>
#include <cmath>
#include <vector>
#include <numeric>
using namespace Rcpp;

// --- Helpers ----------------------------------------------------------------

// Quantile type=7 from 0-indexed sorted array (matches R default)
static inline double quantile7(const double* sorted, int n, double p) {
  double h = (n - 1) * p;
  int lo = (int)h;
  if (lo + 1 >= n) return sorted[n - 1];
  return sorted[lo] + (h - lo) * (sorted[lo + 1] - sorted[lo]);
}

// Median from sorted array
static inline double median_sorted(const double* sorted, int n) {
  if (n % 2 == 1) return sorted[n / 2];
  return 0.5 * (sorted[n / 2 - 1] + sorted[n / 2]);
}

// W1 via CDF integration (for unequal sample sizes)
static double wasserstein1_general(const std::vector<double>& xs,
                                   const std::vector<double>& ys) {
  int n1 = (int)xs.size(), n2 = (int)ys.size();
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

// Compute all 5 pooled normalizers from raw + sorted arrays
//   pooled_sorted: ascending-sorted pooled vector of length n_total
//   sum_total, sumsq_total: precomputed sum / sum-of-squares of raw pooled
//   abs_dev_buf: scratch buffer of size n_total (will be overwritten)
// Output: 5 doubles in `out` (IQR, Range, Q95Q5, SD, MAD); 0 if degenerate
static inline void compute_5_normalizers(
    const double* pooled_sorted, int n_total,
    double sum_total, double sumsq_total,
    double* abs_dev_buf, double* out) {

  // IQR
  double h25 = (n_total - 1) * 0.25;
  double h75 = (n_total - 1) * 0.75;
  int f25 = (int)h25, f75 = (int)h75;
  double q25 = pooled_sorted[f25] +
               (h25 - f25) * (pooled_sorted[f25 + 1] - pooled_sorted[f25]);
  double q75 = pooled_sorted[f75] +
               (h75 - f75) * (pooled_sorted[f75 + 1] - pooled_sorted[f75]);
  out[0] = q75 - q25;

  // Range
  out[1] = pooled_sorted[n_total - 1] - pooled_sorted[0];

  // Q95Q5
  double h05 = (n_total - 1) * 0.05;
  double h95 = (n_total - 1) * 0.95;
  int f05 = (int)h05, f95 = (int)h95;
  double q05 = pooled_sorted[f05] +
               (h05 - f05) * (pooled_sorted[f05 + 1] - pooled_sorted[f05]);
  double q95 = (f95 + 1 < n_total)
    ? pooled_sorted[f95] +
      (h95 - f95) * (pooled_sorted[f95 + 1] - pooled_sorted[f95])
    : pooled_sorted[n_total - 1];
  out[2] = q95 - q05;

  // SD (population formula matches R's sd(): divisor n-1)
  double mean_p = sum_total / n_total;
  double var_p = (sumsq_total - n_total * mean_p * mean_p) / (n_total - 1);
  out[3] = (var_p > 0) ? std::sqrt(var_p) : 0.0;

  // MAD: median of |x - median(x)|, c=1
  double med_p = median_sorted(pooled_sorted, n_total);
  for (int i = 0; i < n_total; i++) {
    abs_dev_buf[i] = std::abs(pooled_sorted[i] - med_p);
  }
  std::sort(abs_dev_buf, abs_dev_buf + n_total);
  out[4] = median_sorted(abs_dev_buf, n_total);
}

// --- Main: 5-normalizer bootstrap ------------------------------------------

// [[Rcpp::export]]
List nABCD_bootstrap_5norm_cpp(NumericVector x, NumericVector y,
                                int B = 1000, double conf = 0.95) {
  int n1 = x.size(), n2 = y.size();
  int n_total = n1 + n2;

  CharacterVector norm_names =
    CharacterVector::create("IQR", "Range", "Q95Q5", "SD", "MAD");

  NumericVector est(5, NA_REAL);
  NumericVector ci_lo(5, NA_REAL);
  NumericVector ci_hi(5, NA_REAL);
  est.names() = norm_names;
  ci_lo.names() = norm_names;
  ci_hi.names() = norm_names;

  // --- Point estimates ---
  std::vector<double> xs(x.begin(), x.end());
  std::vector<double> ys(y.begin(), y.end());
  std::sort(xs.begin(), xs.end());
  std::sort(ys.begin(), ys.end());

  std::vector<double> pooled_sorted(n_total);
  std::merge(xs.begin(), xs.end(), ys.begin(), ys.end(), pooled_sorted.begin());

  double sum_obs = 0, sumsq_obs = 0;
  for (int i = 0; i < n1; i++) { sum_obs += x[i]; sumsq_obs += x[i] * x[i]; }
  for (int i = 0; i < n2; i++) { sum_obs += y[i]; sumsq_obs += y[i] * y[i]; }

  std::vector<double> abs_dev_buf(n_total);
  double norm_obs[5];
  compute_5_normalizers(pooled_sorted.data(), n_total,
                         sum_obs, sumsq_obs,
                         abs_dev_buf.data(), norm_obs);

  // W1 observed
  double w1_obs = 0;
  if (n1 == n2) {
    for (int i = 0; i < n1; i++) w1_obs += std::abs(xs[i] - ys[i]);
    w1_obs /= n1;
  } else {
    w1_obs = wasserstein1_general(xs, ys);
  }

  for (int k = 0; k < 5; k++) {
    if (norm_obs[k] > 0) est[k] = w1_obs / norm_obs[k];
  }

  // --- Bootstrap (B iterations) ---
  std::vector< std::vector<double> > boot_vals(5);
  for (int k = 0; k < 5; k++) boot_vals[k].reserve(B);

  std::vector<double> xb(n1), yb(n2), pb(n_total);
  double norm_b[5];

  for (int b = 0; b < B; b++) {
    // Resample with replacement (R's RNG for reproducibility)
    double sum_b = 0, sumsq_b = 0;
    for (int i = 0; i < n1; i++) {
      double v = x[std::min((int)(R::unif_rand() * n1), n1 - 1)];
      xb[i] = v;
      sum_b += v; sumsq_b += v * v;
    }
    for (int i = 0; i < n2; i++) {
      double v = y[std::min((int)(R::unif_rand() * n2), n2 - 1)];
      yb[i] = v;
      sum_b += v; sumsq_b += v * v;
    }

    // Sort resamples
    std::sort(xb.begin(), xb.end());
    std::sort(yb.begin(), yb.end());

    // W1
    double w1b = 0;
    if (n1 == n2) {
      for (int i = 0; i < n1; i++) w1b += std::abs(xb[i] - yb[i]);
      w1b /= n1;
    } else {
      w1b = wasserstein1_general(xb, yb);
    }

    // Merge sorted pooled
    std::merge(xb.begin(), xb.end(), yb.begin(), yb.end(), pb.begin());

    // 5 normalizers
    compute_5_normalizers(pb.data(), n_total, sum_b, sumsq_b,
                           abs_dev_buf.data(), norm_b);

    // Append boot_vals
    for (int k = 0; k < 5; k++) {
      if (norm_b[k] > 0) boot_vals[k].push_back(w1b / norm_b[k]);
    }
  }

  // --- Percentile CI per normalizer ---
  double alpha = 1 - conf;
  for (int k = 0; k < 5; k++) {
    int B_valid = (int)boot_vals[k].size();
    if (B_valid < 10) continue;
    std::sort(boot_vals[k].begin(), boot_vals[k].end());
    ci_lo[k] = std::max(0.0,
      quantile7(boot_vals[k].data(), B_valid, alpha / 2));
    ci_hi[k] = quantile7(boot_vals[k].data(), B_valid, 1 - alpha / 2);
  }

  return List::create(
    Named("estimate") = est,
    Named("ci_lower") = ci_lo,
    Named("ci_upper") = ci_hi
  );
}
