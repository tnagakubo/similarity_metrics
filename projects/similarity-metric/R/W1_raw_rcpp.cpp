// =============================================================================
// W1 (Wasserstein-1) raw bootstrap — Rcpp implementation
// Author: Katrina Bennett (Technical Writer)
// Date: 2026-05-16
//
// Purpose:
//   Path α rewrite uses Delta_max = L_clinical * W_1 (no normalization).
//   This file computes operating characteristics (bias, coverage, RMSE,
//   CI width) of the SAMPLE Wasserstein-1 distance Wn(F1, F2) — original
//   variable units — via percentile bootstrap.
//
// Usage from R:
//   Rcpp::sourceCpp("projects/similarity-metric/R/W1_raw_rcpp.cpp")
//   res <- W1_raw_bootstrap_cpp(x, y, B = 2000, conf = 0.95)
//   # res$estimate, res$ci_lower, res$ci_upper  (scalars)
//
// Notes:
//   - Equal-n vectorized W1 (sorted-pair |x_(i) - y_(i)| mean).
//   - Unequal-n uses CDF integration (same as wasserstein1_general from
//     nABCD_5norm_rcpp.cpp).
//   - Quantile type=7 to match R quantile() default.
// =============================================================================

#include <Rcpp.h>
#include <algorithm>
#include <vector>
#include <cmath>

using namespace Rcpp;

// --- Helpers ---------------------------------------------------------------

static inline double quantile7(const double* sorted, int n, double p) {
  if (n < 1) return NA_REAL;
  if (n == 1) return sorted[0];
  double h = (n - 1) * p;
  int lo = (int)std::floor(h);
  int hi = lo + 1;
  if (hi >= n) return sorted[n - 1];
  return sorted[lo] + (h - lo) * (sorted[hi] - sorted[lo]);
}

// W1 for general (possibly unequal n) sorted samples via CDF integration.
static double wasserstein1_general(const std::vector<double>& xs,
                                    const std::vector<double>& ys) {
  int n1 = (int)xs.size();
  int n2 = (int)ys.size();
  int N = n1 + n2;
  std::vector<double> all(N);
  std::merge(xs.begin(), xs.end(), ys.begin(), ys.end(), all.begin());

  // Step CDF jumps at sample points. Integrate |F1(t) - F2(t)| over t.
  // Use trapezoid between consecutive distinct support points.
  double w1 = 0.0;
  int i1 = 0, i2 = 0;
  for (int k = 0; k < N - 1; k++) {
    double t = all[k];
    // Advance counters to include all values <= t
    while (i1 < n1 && xs[i1] <= t) i1++;
    while (i2 < n2 && ys[i2] <= t) i2++;
    double F1 = (double)i1 / n1;
    double F2 = (double)i2 / n2;
    double dt = all[k + 1] - all[k];
    w1 += std::abs(F1 - F2) * dt;
  }
  return w1;
}

// --- Main: W1 bootstrap ----------------------------------------------------

// [[Rcpp::export]]
List W1_raw_bootstrap_cpp(NumericVector x, NumericVector y,
                          int B = 2000, double conf = 0.95) {
  int n1 = x.size(), n2 = y.size();

  // Point estimate
  std::vector<double> xs(x.begin(), x.end());
  std::vector<double> ys(y.begin(), y.end());
  std::sort(xs.begin(), xs.end());
  std::sort(ys.begin(), ys.end());

  double w1_obs;
  if (n1 == n2) {
    double s = 0;
    for (int i = 0; i < n1; i++) s += std::abs(xs[i] - ys[i]);
    w1_obs = s / n1;
  } else {
    w1_obs = wasserstein1_general(xs, ys);
  }

  // Bootstrap
  std::vector<double> w1_boot;
  w1_boot.reserve(B);

  std::vector<double> xb(n1), yb(n2);

  for (int b = 0; b < B; b++) {
    for (int i = 0; i < n1; i++) {
      xb[i] = x[std::min((int)(R::unif_rand() * n1), n1 - 1)];
    }
    for (int i = 0; i < n2; i++) {
      yb[i] = y[std::min((int)(R::unif_rand() * n2), n2 - 1)];
    }
    std::sort(xb.begin(), xb.end());
    std::sort(yb.begin(), yb.end());

    double w1b;
    if (n1 == n2) {
      double s = 0;
      for (int i = 0; i < n1; i++) s += std::abs(xb[i] - yb[i]);
      w1b = s / n1;
    } else {
      w1b = wasserstein1_general(xb, yb);
    }
    w1_boot.push_back(w1b);
  }

  double alpha = 1 - conf;
  std::sort(w1_boot.begin(), w1_boot.end());
  double ci_lo = std::max(0.0, quantile7(w1_boot.data(), B, alpha / 2));
  double ci_hi = quantile7(w1_boot.data(), B, 1 - alpha / 2);

  return List::create(
    Named("estimate") = w1_obs,
    Named("ci_lower") = ci_lo,
    Named("ci_upper") = ci_hi
  );
}
