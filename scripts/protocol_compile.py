#!/usr/bin/env python3
"""
protocol_compile.py — the protocol compiler (RESEARCH_FRAMEWORK S1 → executable).

Reads the YAML front matter of a pre-registered PROTOCOL_{study}.md and generates
  R/{study}.R                       simulation skeleton: seed, DGM table, estimator stubs, replicate loop with
                                    per-task seeding, performance measures WITH Monte Carlo SE, summary CSV
                                    (estimate + mcse columns), per-replicate .rds, log with sessionInfo
  results/{STUDY}_PROVENANCE.md     provenance skeleton (templates/provenance_template.md)
  SIMULATION_FINDINGS_{study}.md    findings skeleton (templates/simulation_findings_template.md)

and validates the protocol before anything runs:
  - required fields present; keys well formed
  - n_sim large enough for the target Monte Carlo SE of coverage: n_sim >= p(1-p)/eps^2 at p = 0.95
  - every DGM scenario has a true_value (or truth.method says how it will be obtained)
  - every method has an owner (ours | existing) — misattribution guard

Usage: python3 scripts/protocol_compile.py projects/<p>/PROTOCOL_<study>.md [--force] [--dry-run]
       python3 scripts/protocol_compile.py projects/<p>/PROTOCOL_<study>.md --verify [R/file.R] [--strict]
  --verify: protocol ↔ code drift (S13). The seed, n_sim, every n of the grid, every method's fn and the summary CSV
            named in the front matter must appear in the R script (default R/{study}.R, or the front matter's `code:`).
            Exit 1 on drift unless the protocol is post_hoc (then advisory: the code predates the registration).
The generated R contains `# TODO` markers where the protocol cannot know the code (the DGM draw, the estimator).
Everything else — the ADEMP bookkeeping that is usually typed by hand and gets wrong — is generated.
"""
import argparse
import re
import sys
from datetime import date
from pathlib import Path

try:
    import yaml
except ImportError:  # pragma: no cover
    yaml = None

FRONT_RE = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.S)
REQUIRED = ["study", "claim_id", "seed", "n_sim", "estimand", "dgm", "n_grid", "methods", "measures", "outputs"]
MEASURES = {"bias", "empse", "mse", "rmse", "coverage", "ci_width", "proportion"}


def load_front_matter(path: Path):
    text = path.read_text(encoding="utf-8")
    m = FRONT_RE.match(text)
    if not m:
        raise SystemExit(f"protocol_compile: {path.name} has no YAML front matter (--- … --- at the top)")
    if yaml is None:
        raise SystemExit("protocol_compile: PyYAML not installed (apt install python3-yaml / pip install pyyaml)")
    data = yaml.safe_load(m.group(1)) or {}
    return data, text[m.end():]


def validate(p: dict):
    errors, warnings = [], []
    for k in REQUIRED:
        if k not in p:
            errors.append(f"missing field: {k}")
    if errors:
        return errors, warnings
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", str(p["study"])):
        errors.append("study must be an identifier (letters, digits, underscore)")
    if not re.fullmatch(r"C-\d+", str(p["claim_id"])):
        warnings.append(f"claim_id '{p['claim_id']}' is not of the form C-NN (CLAIMS.md)")
    try:
        n_sim = int(p["n_sim"])
    except (TypeError, ValueError):
        errors.append("n_sim must be an integer"); n_sim = 0
    tgt = (p.get("target_mcse") or {})
    if "coverage" in [str(m).lower() for m in p["measures"]]:
        eps = float(tgt.get("coverage", 0.005))
        need = 0.95 * 0.05 / eps ** 2
        if n_sim and n_sim < need:
            errors.append(f"n_sim = {n_sim} < {need:.0f} required for coverage MCSE <= {eps} at p = 0.95 "
                          f"(n_sim >= p(1-p)/eps^2)")
    for i, d in enumerate(p["dgm"]):
        if "name" not in d:
            errors.append(f"dgm[{i}] has no name")
        if "true_value" not in d and not (p.get("truth") or {}).get("method"):
            errors.append(f"dgm[{d.get('name', i)}]: no true_value and truth.method not given (estimand truth must be fixed in advance)")
    for m in p["methods"]:
        if m.get("owner") not in ("ours", "existing"):
            errors.append(f"method {m.get('name')}: owner must be 'ours' or 'existing' (misattribution guard)")
        if "fn" not in m:
            errors.append(f"method {m.get('name')}: fn (R function name) missing")
    bad = [m for m in p["measures"] if str(m).lower() not in MEASURES]
    if bad and not p.get("post_hoc"):
        errors.append(f"unknown measures {bad}; known: {sorted(MEASURES)} (a post-hoc registration of an existing study may "
                      f"declare task-specific measures with post_hoc: true; the compiled skeleton then computes no MCSE for them)")
    elif bad:
        warnings.append(f"post-hoc protocol: task-specific measures {bad} are documented, not compiled (no MCSE formula in the skeleton)")
    for k in ("summary_csv", "per_rep_rds", "log"):
        if k not in p["outputs"]:
            errors.append(f"outputs.{k} missing")
    if not p.get("prior_look"):
        warnings.append("prior_look not declared in front matter (the §0 honesty clause must still be written in the body)")
    return errors, warnings


def r_str(s) -> str:
    return '"' + str(s).replace("\\", "\\\\").replace('"', '\\"') + '"'


def r_vec(xs) -> str:
    return "c(" + ", ".join(str(x) for x in xs) + ")"


def gen_r(p: dict, protocol_rel: str, commit: str) -> str:
    study = p["study"]
    dgm_rows = []
    for d in p["dgm"]:
        params = d.get("params") or {}
        plist = ", ".join(f"{k} = {v}" for k, v in params.items()) if params else ""
        tv = d.get("true_value", "NA")
        dgm_rows.append(f'  list(name = {r_str(d["name"])}, description = {r_str(d.get("description", ""))}, '
                        f"true_value = {tv}, params = list({plist}))")
    methods = p["methods"]
    method_stubs = []
    for m in methods:
        method_stubs.append(f"""
# ---- {m['name']} ({m.get('owner')}): {m.get('description', '')}
# Returns list(est = <numeric>, ci = c(lower, upper) or NULL).
{m['fn']} <- function(x1, x2, B = {m.get('B', 'NULL')}) {{
  # TODO(Mike): implement exactly as PROTOCOL §3M describes it. Existing methods: as written in the source, no "improvements".
  stop("not implemented: {m['fn']}")
}}""")
    measures = [str(m).lower() for m in p["measures"]]
    outputs = p["outputs"]
    par = p.get("parallel") or {}
    workers = par.get("workers", 1)
    lines = f'''#!/usr/bin/env Rscript
# {study}.R — GENERATED SKELETON from {protocol_rel} (commit {commit}) by scripts/protocol_compile.py on {date.today().isoformat()}.
# Protocol: {protocol_rel}   Claim: {p['claim_id']}   Estimand: {p['estimand']}
# Everything marked TODO is the part the protocol cannot know (the data draw and the estimator). Everything else
# (seeds, grid, performance measures with Monte Carlo SE, outputs, provenance) is generated and should not be retyped.
# Deviations from the protocol go to its §9 — not into this header.

suppressPackageStartupMessages({{ }})
SEED      <- {int(p['seed'])}
N_SIM     <- {int(p['n_sim'])}
N_GRID    <- {r_vec(p['n_grid'])}
STUDY     <- {r_str(study)}
PROTOCOL  <- {r_str(protocol_rel)}
OUT_SUMMARY <- {r_str(outputs['summary_csv'])}
OUT_RDS     <- {r_str(outputs['per_rep_rds'])}
OUT_LOG     <- {r_str(outputs['log'])}
dir.create(dirname(OUT_SUMMARY), showWarnings = FALSE, recursive = TRUE)
set.seed(SEED)
t_start <- Sys.time()

# ---- D: data-generating mechanisms (PROTOCOL §3D) ------------------------------------------------------------
DGM <- list(
{",\n".join(dgm_rows)}
)
draw_sample <- function(scenario, n) {{
  # TODO(Mike): return list(x1 = <n draws for region 1>, x2 = <n draws for region 2>) for scenario$name,
  # using scenario$params only. The truth is scenario$true_value (fixed in the protocol; never recomputed from data).
  stop("not implemented: draw_sample for ", scenario$name)
}}

# ---- M: methods compared (PROTOCOL §3M) ----------------------------------------------------------------------
METHODS <- list(
{",\n".join(f'  list(name = {r_str(m["name"])}, fn = {r_str(m["fn"])}, owner = {r_str(m.get("owner"))}, has_ci = {"TRUE" if m.get("ci") else "FALSE"})' for m in methods)}
)
{"".join(method_stubs)}

# ---- P: performance measures with Monte Carlo SE (Morris, White & Crowther 2019, Table 6) --------------------
perf_measures <- function(est, truth, lower = NULL, upper = NULL) {{
  est <- est[!is.na(est)]; nsim <- length(est)
  out <- list()
  m_est <- mean(est); dev <- est - m_est
  out$bias     <- c(mean(est - truth),            sqrt(sum(dev^2) / (nsim * (nsim - 1))))
  empse        <- sqrt(sum(dev^2) / (nsim - 1))
  out$empse    <- c(empse,                        empse / sqrt(2 * (nsim - 1)))
  sq           <- (est - truth)^2
  out$mse      <- c(mean(sq),                     sqrt(sum((sq - mean(sq))^2) / (nsim * (nsim - 1))))
  out$rmse     <- c(sqrt(mean(sq)),               NA_real_)  # MCSE by delta method if needed: mcse(mse) / (2 * rmse)
  out$rmse[2]  <- out$mse[2] / (2 * out$rmse[1])
  if (!is.null(lower) && !is.null(upper)) {{
    cov <- mean(lower <= truth & truth <= upper, na.rm = TRUE)
    out$coverage <- c(cov, sqrt(cov * (1 - cov) / nsim))
    w <- upper - lower
    out$ci_width <- c(mean(w, na.rm = TRUE), sd(w, na.rm = TRUE) / sqrt(nsim))
  }}
  out
}}

# ---- replicate loop: per-task seeding (bit-reproducible regardless of scheduling) -----------------------------
run_cell <- function(scenario, n) {{
  res <- vector("list", N_SIM)
  for (i in seq_len(N_SIM)) {{
    set.seed(SEED + 1000003L * match(scenario$name, vapply(DGM, `[[`, "", "name")) + 1009L * match(n, N_GRID) + i)
    s <- draw_sample(scenario, n)
    res[[i]] <- lapply(METHODS, function(m) {{
      r <- do.call(m$fn, list(s$x1, s$x2))
      c(est = r$est, lower = if (is.null(r$ci)) NA_real_ else r$ci[1], upper = if (is.null(r$ci)) NA_real_ else r$ci[2])
    }})
  }}
  res
}}
{"# NOTE: parallel = " + str(par) + " — use parallel::clusterSetRNGStream or keep the per-task set.seed above; never rely on scheduling order." if workers and int(workers) > 1 else ""}

per_rep <- list(); summary_rows <- list()
for (scenario in DGM) for (n in N_GRID) {{
  cell <- run_cell(scenario, n)
  per_rep[[paste(scenario$name, n, sep = "-")]] <- cell
  for (mi in seq_along(METHODS)) {{
    m <- METHODS[[mi]]
    est   <- vapply(cell, function(r) r[[mi]][["est"]], numeric(1))
    lower <- vapply(cell, function(r) r[[mi]][["lower"]], numeric(1))
    upper <- vapply(cell, function(r) r[[mi]][["upper"]], numeric(1))
    pm <- perf_measures(est, scenario$true_value, if (m$has_ci) lower else NULL, if (m$has_ci) upper else NULL)
    for (meas in intersect({r_vec([r_str(m) for m in measures])}, names(pm))) {{
      summary_rows[[length(summary_rows) + 1]] <- data.frame(
        scenario = scenario$name, n = n, method = m$name, measure = meas,
        estimate = pm[[meas]][1], mcse = pm[[meas]][2], n_sim = sum(!is.na(est)), stringsAsFactors = FALSE)
    }}
  }}
}}
summary_df <- do.call(rbind, summary_rows)
write.csv(summary_df, OUT_SUMMARY, row.names = FALSE)
saveRDS(list(config = list(seed = SEED, n_sim = N_SIM, n_grid = N_GRID, protocol = PROTOCOL), per_rep = per_rep), OUT_RDS)

# ---- log: seed, n_sim, run time, sessionInfo ------------------------------------------------------------------
writeLines(c(
  sprintf("study: %s", STUDY), sprintf("protocol: %s", PROTOCOL), sprintf("seed: %d", SEED),
  sprintf("n_sim: %d", N_SIM), sprintf("n_grid: %s", paste(N_GRID, collapse = ",")),
  sprintf("started: %s", format(t_start)), sprintf("finished: %s", format(Sys.time())),
  sprintf("elapsed_min: %.1f", as.numeric(difftime(Sys.time(), t_start, units = "mins"))),
  "", capture.output(sessionInfo())), OUT_LOG)
cat(sprintf("%s: wrote %s (%d rows), %s, %s\\n", STUDY, OUT_SUMMARY, nrow(summary_df), OUT_RDS, OUT_LOG))
'''
    return lines


def gen_provenance(p: dict, protocol_rel: str, commit: str) -> str:
    return f"""# {p['study']} — provenance of `{p['outputs']['summary_csv']}`

Generated skeleton by scripts/protocol_compile.py on {date.today().isoformat()} (commit {commit}). Fill the run facts after the canonical run.

## Canonical run

| Item | Value |
|------|-------|
| Protocol | `{protocol_rel}` |
| Producing script | `R/{p['study']}.R` |
| Per-replicate source | `{p['outputs']['per_rep_rds']}` (mtime: …) |
| Replications n_sim | {p['n_sim']} |
| Seed / RNG | `set.seed({p['seed']})`; per-task seed = SEED + f(scenario, n, i) |
| Grid | n ∈ {{{', '.join(str(x) for x in p['n_grid'])}}} × {len(p['dgm'])} scenarios × {len(p['methods'])} methods |
| R version / packages | see `{p['outputs']['log']}` (sessionInfo) |
| Run time | … |

## Reference (true) values

| scenario | description | true value | how obtained |
|---|---|---|---|
""" + "\n".join(f"| {d['name']} | {d.get('description','')} | {d.get('true_value','—')} | {(p.get('truth') or {}).get('method','fixed in protocol')} |" for d in p["dgm"]) + """

## Column semantics

| column | definition |
|---|---|
| estimate | performance measure value (bias, empse, mse, rmse, coverage as a proportion, ci_width) |
| mcse | Monte Carlo standard error of `estimate` (Morris, White & Crowther 2019) |
| n_sim | replications with a non-missing estimate |
"""


def gen_findings(p: dict, protocol_rel: str) -> str:
    return f"""# SIMULATION_FINDINGS — {p['study']}

**Protocol**: `{protocol_rel}`（registered …, commit …）。逸脱は protocol §9 のとおり。
**Producing script**: `R/{p['study']}.R` **Results**: `{p['outputs']['summary_csv']}` **Provenance**: `results/{p['study'].upper()}_PROVENANCE.md`
**Run**: …、$n_{{\\mathrm{{sim}}}}$ = {p['n_sim']}、seed = {p['seed']}、実行時間 …

## 1. ADEMP 要約（protocol §3 と一致させる）

A: … / D: {len(p['dgm'])} scenarios ({', '.join(d['name'] for d in p['dgm'])}) / E: {p['estimand']} / M: {', '.join(m['name'] for m in p['methods'])} / P: {', '.join(str(m) for m in p['measures'])} (with MCSE)

## 2. 結果（performance measure ごと、MCSE を併記）

| scenario | n | method | measure | estimate | MCSE | $n_{{\\mathrm{{sim}}}}$ |
|---|---|---|---|---|---|---|
（`{p['outputs']['summary_csv']}` から生成。手で転記しない — `numbers_registry.csv` に行を足して `\\numval{{}}` / `num()` で引く）

## 3. 図

| figure | path | what is plotted |
|---|---|---|

## 4. この結果が licenses する主張 / しない主張（protocol §2 と照合）

- **Licenses**: …（`CLAIMS.md` {p['claim_id']}）
- **Does not license**: …

## 5. 探索的所見（protocol 外）

## 6. 検証（four-eyes）

| item | producer | verifier（≠ producer） | method | max abs diff | verdict |
|---|---|---|---|---|---|

## 7. 既知の限界・バグ
"""


def verify_code(p: dict, proj: Path, rfile: str | None):
    """Protocol ↔ code drift. Returns (rows, n_fail); each row = (item, expected, found: bool, note)."""
    code = rfile or p.get("code") or f"R/{p['study']}.R"
    path = (proj / code) if not Path(code).is_absolute() else Path(code)
    rows = []
    if not path.exists():
        return [("code file", code, False, "missing")], 1, code
    src = path.read_text(encoding="utf-8", errors="replace")
    src = "\n".join(l.split("#", 1)[0] for l in src.splitlines())   # comments do not count as code

    def has_num(v) -> bool:
        return re.search(rf"(?<![\w.]){re.escape(str(v))}(?![\w.])", src) is not None

    rows.append(("seed", p["seed"], has_num(p["seed"]), "set.seed / SEED"))
    rows.append(("n_sim", p["n_sim"], has_num(p["n_sim"]), "replications"))
    for n in p["n_grid"]:
        rows.append((f"n_grid", n, has_num(n), "sample size in the grid"))
    for m in p["methods"]:
        fn = m.get("fn")
        if fn:
            rows.append((f"method {m.get('name')}", fn, re.search(r"(?<![\w.])" + re.escape(str(fn)) + r"(?![\w.])", src) is not None, "estimator function"))
    outs = p.get("outputs") or {}
    sc = outs.get("summary_csv") if isinstance(outs, dict) else None
    if sc:
        rows.append(("summary_csv", sc, (sc in src) or (Path(sc).name in src), "output path in code"))
    n_fail = sum(1 for r in rows if not r[2])
    return rows, n_fail, code


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("protocol")
    ap.add_argument("--force", action="store_true", help="overwrite existing generated files")
    ap.add_argument("--dry-run", action="store_true", help="validate and print what would be written")
    ap.add_argument("--verify", nargs="?", const="", default=None, metavar="R_FILE",
                    help="check that the R script agrees with the front matter (seed, n_sim, grid, method fns, summary CSV)")
    ap.add_argument("--strict", action="store_true", help="with --verify: exit 1 on drift even for post_hoc protocols")
    a = ap.parse_args()
    path = Path(a.protocol).resolve()
    proj = path.parent
    p, _body = load_front_matter(path)
    errors, warnings = validate(p)
    for w in warnings:
        print(f"  ⚠️ {w}")
    for e in errors:
        print(f"  ❌ {e}")
    if errors:
        print("protocol_compile: FAIL — fix the protocol before generating code"); return 1
    if a.verify is not None:
        rows, n_fail, code = verify_code(p, proj, a.verify or None)
        for item, exp, found, note in rows:
            print(f"  {'✅' if found else '❌'} {item:<14} {str(exp):<40} {note}")
        post_hoc = bool(p.get("post_hoc"))
        todo = 0
        cp = proj / code
        if cp.exists():
            todo = len(re.findall(r"TODO\(", cp.read_text(encoding="utf-8", errors="replace")))
        if todo:
            print(f"  ⚠️ {todo} TODO( marker(s) remain in {code} — skeleton not fully implemented")
        verdict = "PASS" if n_fail == 0 else ("DRIFT (advisory: post_hoc protocol)" if post_hoc and not a.strict else "DRIFT")
        print(f"protocol_compile verify: {p['study']} ↔ {code}: {len(rows) - n_fail}/{len(rows)} agree — {verdict}")
        return 0 if (n_fail == 0 or (post_hoc and not a.strict)) else 1
    try:
        import subprocess
        commit = subprocess.run(["git", "rev-parse", "--short", "HEAD"], capture_output=True, text=True, cwd=proj).stdout.strip() or "uncommitted"
    except Exception:
        commit = "unknown"
    rel = path.name
    targets = {
        proj / "R" / f"{p['study']}.R": gen_r(p, rel, commit),
        proj / "results" / f"{p['study'].upper()}_PROVENANCE.md": gen_provenance(p, rel, commit),
        proj / f"SIMULATION_FINDINGS_{p['study']}.md": gen_findings(p, rel),
    }
    for t, content in targets.items():
        if t.exists() and not a.force:
            print(f"  skip (exists; use --force): {t.relative_to(proj)}"); continue
        if a.dry_run:
            print(f"  would write {t.relative_to(proj)} ({len(content.splitlines())} lines)"); continue
        t.parent.mkdir(parents=True, exist_ok=True)
        t.write_text(content, encoding="utf-8")
        print(f"  wrote {t.relative_to(proj)}")
    eps = float((p.get("target_mcse") or {}).get("coverage", 0.005))
    print(f"protocol_compile: OK — study {p['study']}, {len(p['dgm'])} scenarios × {len(p['n_grid'])} n × {len(p['methods'])} methods, "
          f"n_sim {p['n_sim']} (coverage MCSE at p=0.95: {(0.95*0.05/int(p['n_sim']))**0.5:.4f}, target {eps})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
