# Cover Letter

*Draft rewritten 2026-11-14 (D-20261114-1) for the per-effect-modifier W₁ manuscript; the 2026-02 draft described the retired nABCD index. Fields in [brackets] are for the authors.*

---

[Date]

**Editor-in-Chief**
Statistics in Medicine
Wiley

**Re: Submission of a Research Article**
**Title: Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials**

Dear Editor,

We submit the manuscript "Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials" for consideration as a Research Article in *Statistics in Medicine*.

The ICH E17 guideline describes the pooling of regions in multi-regional clinical trials in terms of the similarity of effect modifier distributions, but it names no measure of that similarity. The manuscript presents one: the Wasserstein-1 distance between two regions' distributions of each candidate effect modifier, kept in the modifier's original units.

The manuscript makes three contributions.

1. **A clinical-scale reading of a distributional distance.** If the conditional average treatment effect is common to the regions, depends on the modifier alone and is Lipschitz with a per-unit clinical slope, the regional average treatment effects differ by at most the slope times the distance. The inequality is the Kantorovich–Rubinstein duality; what is new is its formulation for regional pooling with a clinical slope as the constant, and the reading of each distance against a sponsor's stated bound when the slope is unknown.
2. **An evaluation of the estimator.** A simulation study, reported in the ADEMP structure with Monte Carlo standard errors, gives the bias and the coverage of the percentile bootstrap interval, including where the interval undercovers and on which side it errs. A registered extension covers unequal regional sizes, a heavy-tailed reference distribution and grid-recorded data.
3. **An evaluation of identification.** A selection simulation shows that the standardized mean difference on the original scale stays at chance at every sample size examined when regional means are matched, whereas the Wasserstein-1 distance and the Kolmogorov–Smirnov statistic reach the discrimination target in every configuration.

An example based on the publicly available GUSTO-I data illustrates how the distances and their intervals are read.

The paper quantifies differences between regional distributions. It deliberately prescribes no pooling rule or threshold; that judgment remains clinical, and we say so in the text. We also report the limits of the work plainly: the bound is a conservative worst case, the calibration constant is a clinical judgment, and bootstrap coverage falls below the nominal level in part of the range studied.

The R code, the registered protocols and all outputs will be made available at [repository URL].

**Statements**

- The manuscript has not been published and is not under consideration elsewhere.
- All authors have approved the submitted version.
- The authors declare no conflict of interest.
- [Funding statement]
- [Statement on the use of AI tools in preparing the manuscript, as the journal's policy requires]

Sincerely,

[Corresponding author name]
[Title, affiliation]
[Email]
