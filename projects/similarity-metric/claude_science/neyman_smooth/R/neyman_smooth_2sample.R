## ---------------------------------------------------------------------------
## neyman_smooth_2sample.R
##
## Neyman smooth test for the two-sample problem, with
##   * orthonormal (shifted) Legendre scores on pooled midranks,
##   * EXACT finite-population null covariance (valid with ties / discreteness),
##   * sequentially orthogonalised (Cholesky) components so that
##         W_k = Z_1^2 + ... + Z_k^2   is exactly nested,
##   * data-driven selection of the number of components (BIC / AIC rule),
##   * permutation or asymptotic calibration.
##
## Z_1 is algebraically the standardised Wilcoxon rank-sum statistic, so the
## smooth test embeds Wilcoxon as its first component and adds interpretable
## scale (Z_2), skewness (Z_3) and tail/kurtosis (Z_4) directions.
##
## Base R only. No dependencies.
## ---------------------------------------------------------------------------

#' Orthonormal shifted-Legendre scores on [0, 1]
#'
#' @param u numeric vector in (0,1)
#' @param d highest polynomial degree
#' @return length(u) x d matrix with columns b_1(u), ..., b_d(u);
#'   int_0^1 b_j = 0, int_0^1 b_j b_l = delta_jl
legendre_scores <- function(u, d) {
  stopifnot(d >= 1)
  x <- 2 * u - 1
  P <- matrix(NA_real_, nrow = length(u), ncol = d + 1L)
  P[, 1L] <- 1                                   # P_0
  P[, 2L] <- x                                   # P_1
  if (d >= 2L) {
    for (j in 1:(d - 1L)) {
      P[, j + 2L] <- ((2 * j + 1) * x * P[, j + 1L] - j * P[, j]) / (j + 1)
    }
  }
  B <- P[, -1L, drop = FALSE]
  sweep(B, 2L, sqrt(2 * seq_len(d) + 1), `*`)
}

#' Internal: null mean and covariance of the component sums under H0
#'
#' Under the randomisation (exchangeability) null the group-2 index set is a
#' simple random sample of size n drawn without replacement from the N pooled
#' units, so for score matrix A (N x d):
#'   E[S]   = n * colMeans(A)
#'   Cov[S] = n (N - n) / (N - 1) * C ,   C = population covariance of A rows
#' This is exact for any tie pattern and any N.
.smooth_null_moments <- function(A, n) {
  N <- nrow(A)
  abar <- colMeans(A)
  Ac <- sweep(A, 2L, abar, `-`)
  C <- crossprod(Ac) / N
  list(mean = n * abar,
       cov  = (n * (N - n) / (N - 1)) * C)
}

#' Internal: penalised selection rule (Ledwina's Schwarz-type rule)
.select_k <- function(W, N, penalty = "BIC") {
  pen <- if (penalty == "BIC") log(N) else 2
  which.max(W - pen * seq_len(length(W)))
}

#' Neyman smooth test for the two-sample problem
#'
#' @param x,y numeric vectors (group 1 = reference / control, group 2 = test)
#' @param d maximum number of smooth components considered (default 4)
#' @param selection "BIC" (data-driven, Schwarz rule), "AIC", or "fixed"
#' @param k number of components when selection = "fixed" (default d)
#' @param calibrate "permutation" (default, recommended) or "asymptotic"
#' @param B number of permutations
#' @param seed optional RNG seed for the permutation distribution
#' @return object of class "smooth2s"
smooth_test_2sample <- function(x, y, d = 4L,
                                selection = c("BIC", "AIC", "fixed"),
                                k = NULL,
                                calibrate = c("permutation", "asymptotic"),
                                B = 2000L, seed = NULL,
                                data.name = NULL) {
  selection <- match.arg(selection)
  calibrate <- match.arg(calibrate)
  if (is.null(data.name))
    data.name <- paste(deparse(substitute(x)), "vs", deparse(substitute(y)))

  x <- x[is.finite(x)]; y <- y[is.finite(y)]
  m <- length(x); n <- length(y); N <- m + n
  if (min(m, n) < 5L) stop("need at least 5 observations per group")
  if (d >= min(m, n)) stop("d must be smaller than the smaller group size")

  z <- c(x, y)
  R <- rank(z, ties.method = "average")
  u <- R / (N + 1)
  A <- legendre_scores(u, d)
  grp2 <- rep(c(FALSE, TRUE), c(m, n))

  mom <- .smooth_null_moments(A, n)
  Sig <- mom$cov
  diag(Sig) <- diag(Sig) + 1e-10 * mean(diag(Sig))
  Lt <- tryCatch(t(chol(Sig)), error = function(e) NULL)
  if (is.null(Lt))
    stop("null covariance of the components is singular: reduce d ",
         "(too few distinct values in the pooled sample)")

  S <- colSums(A[grp2, , drop = FALSE])
  Z <- as.vector(forwardsolve(Lt, S - mom$mean))
  W <- cumsum(Z^2)

  k_sel <- if (selection == "fixed") {
    if (is.null(k)) d else as.integer(k)
  } else .select_k(W, N, selection)
  stat <- W[k_sel]
  ties <- anyDuplicated(z) > 0L

  ## ---- calibration --------------------------------------------------------
  if (calibrate == "permutation") {
    if (!is.null(seed)) set.seed(seed)
    nullstat <- numeric(B)
    for (b in seq_len(B)) {
      idx <- sample.int(N, n)
      Zb <- forwardsolve(Lt, colSums(A[idx, , drop = FALSE]) - mom$mean)
      Wb <- cumsum(Zb^2)
      kb <- if (selection == "fixed") k_sel else .select_k(Wb, N, selection)
      nullstat[b] <- Wb[kb]
    }
    p_overall <- (1 + sum(nullstat >= stat - 1e-12)) / (B + 1)
    p_method <- sprintf("permutation (B = %d)", B)
  } else {
    df <- if (selection == "fixed") k_sel else 1L
    p_overall <- stats::pchisq(stat, df = df, lower.tail = FALSE)
    p_method <- if (selection == "fixed")
      sprintf("asymptotic chi-square(%d)", k_sel)
    else "asymptotic chi-square(1) (Ledwina limit for the Schwarz rule)"
    nullstat <- NULL
  }

  comp_p <- 2 * stats::pnorm(-abs(Z))
  labels <- c("1: location (= Wilcoxon)", "2: scale/dispersion",
              "3: skewness", "4: kurtosis/tails",
              paste0(5:20, ": higher order"))[seq_len(d)]

  structure(list(
    statistic   = stat,
    k_selected  = k_sel,
    selection   = selection,
    d           = d,
    Z           = Z,
    W           = W,
    components  = data.frame(
      component = seq_len(d),
      direction = labels,
      Z         = Z,
      Z2        = Z^2,
      p_raw     = comp_p,
      p_holm    = stats::p.adjust(comp_p, "holm"),
      row.names = NULL, stringsAsFactors = FALSE),
    p.value     = p_overall,
    p.method    = p_method,
    null.dist   = nullstat,
    m = m, n = n, N = N, ties = ties,
    method = "Neyman smooth two-sample test (Legendre rank scores)",
    data.name = data.name
  ), class = "smooth2s")
}

print.smooth2s <- function(x, digits = 4, ...) {
  cat("\n", x$method, "\n\n", sep = "")
  cat("data:  ", x$data.name, "   (m = ", x$m, ", n = ", x$n, ")\n", sep = "")
  cat("components considered: d = ", x$d,
      " | selection: ", x$selection,
      " | selected k = ", x$k_selected, "\n", sep = "")
  if (x$ties) cat("ties present: exact finite-population covariance used;",
                  "permutation calibration recommended\n")
  cat("\nW_", x$k_selected, " = ", format(x$statistic, digits = digits),
      ",  p = ", format.pval(x$p.value, digits = digits),
      "  [", x$p.method, "]\n\n", sep = "")
  cm <- x$components
  cm$Z <- round(cm$Z, 3); cm$Z2 <- round(cm$Z2, 3)
  cm$p_raw <- format.pval(cm$p_raw, digits = 3)
  cm$p_holm <- format.pval(cm$p_holm, digits = 3)
  print(cm, row.names = FALSE)
  cat("\nnested statistics W_k:",
      paste0("W", seq_len(x$d), "=", round(x$W, 2), collapse = "  "), "\n\n")
  invisible(x)
}

## ---------------------------------------------------------------------------
## Distribution-free null distribution (no ties)
##
## With continuous data and no ties the pooled rank vector is fixed, so the
## score matrix A depends only on (m, n, d).  The null law of W_k and of the
## data-driven statistic therefore depends only on (m, n, d) -- it can be
## tabulated once and reused for every dataset of that size.
## ---------------------------------------------------------------------------

smooth_null_table <- function(m, n, d = 4L, selection = "BIC",
                              B = 20000L, seed = 1L) {
  N <- m + n
  u <- seq_len(N) / (N + 1)
  A <- legendre_scores(u, d)
  mom <- .smooth_null_moments(A, n)
  Lt <- t(chol(mom$cov))
  set.seed(seed)
  out <- matrix(NA_real_, B, d + 1L)
  for (b in seq_len(B)) {
    idx <- sample.int(N, n)
    Zb <- forwardsolve(Lt, colSums(A[idx, , drop = FALSE]) - mom$mean)
    Wb <- cumsum(Zb^2)
    kb <- if (selection == "fixed") d else .select_k(Wb, N, selection)
    out[b, ] <- c(Wb, Wb[kb])
  }
  colnames(out) <- c(paste0("W", seq_len(d)), "W_selected")
  list(m = m, n = n, d = d, selection = selection, draws = out,
       crit = apply(out, 2L, stats::quantile, probs = c(0.9, 0.95, 0.99)))
}

## ---------------------------------------------------------------------------
## Fast engine for simulation (tie-free data assumed)
## ---------------------------------------------------------------------------

smooth_engine <- function(m, n, d = 4L) {
  N <- m + n
  u <- seq_len(N) / (N + 1)
  A <- legendre_scores(u, d)
  mom <- .smooth_null_moments(A, n)
  Lt <- t(chol(mom$cov))
  force(m); force(n)
  list(
    N = N, d = d, A = A, mom = mom, Lt = Lt,
    stats = function(x, y) {
      R <- rank(c(x, y), ties.method = "average")
      idx <- R[(m + 1L):N]
      Zb <- forwardsolve(Lt, colSums(A[idx, , drop = FALSE]) - mom$mean)
      Wb <- cumsum(Zb^2)
      kb <- .select_k(Wb, N, "BIC")
      c(Wb, Wb[kb], kb)
    })
}

## ---------------------------------------------------------------------------
## Two-sample Anderson-Darling statistic (Scholz & Stephens 1987, version 1)
## benchmark omnibus competitor
## ---------------------------------------------------------------------------

ad2_stat <- function(x, y) {
  m <- length(x); n <- length(y); N <- m + n
  z <- sort(unique(c(x, y)))
  L <- length(z)
  h  <- tabulate(match(c(x, y), z), nbins = L)
  fx <- tabulate(match(x, z), nbins = L)
  Hj <- cumsum(h) - h / 2
  Fx <- cumsum(fx) - fx / 2
  Fy <- cumsum(h - fx) - (h - fx) / 2
  den <- Hj * (N - Hj) - N * h / 4
  ok <- den > 0
  (1 / N) * (sum(h[ok] * (N * Fx[ok] - m * Hj[ok])^2 / (m * den[ok])) +
             sum(h[ok] * (N * Fy[ok] - n * Hj[ok])^2 / (n * den[ok])))
}
