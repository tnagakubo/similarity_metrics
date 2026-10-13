# LIT_POSITIONING_20261012 - references for the Proposition 1 positioning paragraph

**Owner**: Rachel. For: Harvey (positioning paragraph), after EXTERNAL_REVIEW_20261012.md M1 and M4.
**Manuscript and .bib NOT edited.** The BibTeX block below is for pasting by whoever owns the .bib.
**Flags**: GROUNDED = passage read in a full-text copy (original or preprint, stated). ABSTRACT-ONLY = publisher abstract (Crossref / Europe PMC / RePEc) read, full text not. OPEN = no primary text read.
All DOIs were resolved against Crossref on 2026-10-12. Three DOIs I first recalled from memory were wrong (they resolved to other papers) and are corrected here: Tipton, Munk-Czado, Hong-Li.
KB check: none of the nine is in knowledge/summaries or INDEX.md (the grep hits were Bickel-Freedman 1981, Bickel-Rosenblatt 1973, Sommerfeld & Munk 2018: name matches only). No PDFs were added to knowledge/pdfs (preprint copies sit in /tmp only).

## 1. Summary table

| # | Reference | DOI | Flag | Supporting passage (verbatim unless [推測]) | Relation to our Proposition 1 |
|---|---|---|---|---|---|
| 1 | Redko, Habrard, Sebban (2017) ECML-PKDD, LNCS 10535:737-753 | 10.1007/978-3-319-71246-8_45 | GROUNDED (arXiv:1610.04420v4, 28 Jul 2017, full text; LNCS print not read) | Lemma 1: "Then the following holds eps_T(h,h') <= eps_S(h,h') + W1(mu_S,mu_T) for every hypothesis h', h." Conditions: cost c(x,y)=\|\|phi(x)-phi(y)\|\| in an RKHS, loss of form \|h(x)-f(x)\|^q, "convex, symmetric, bounded, obeys the triangular equality". | **Same inequality family, different route.** Proof (read to the end): eps_T - eps_S = <E_T phi - E_S phi, l>_H <= \|\|l\|\|_H \|\|int phi d(mu_S - mu_T)\|\|_H <= int \|\|phi(x)-phi(y)\|\|_H dgamma, then "taking the infimum over gamma", giving W1. This is the coupling (primal) route, with the loss normalised to RKHS norm <= 1, i.e. 1-Lipschitz in the kernel-induced metric that defines their W1; it is not stated with a Lipschitz constant and not via Kantorovich-Rubinstein duality (Shen's eq. 13 is the dual route with an explicit K). Conditions differ (RKHS losses, kernel-induced cost). The reviewer's "Lipschitz loss" wording is therefore a fair gloss rather than the paper's own, and Harvey may cite Redko and Shen together. |
| 2 | Shen, Qu, Zhang, Yu (2018) AAAI-18, 32(1) | 10.1609/aaai.v32i1.11784 | GROUNDED (arXiv:1707.01217v4, 9 Mar 2018, full text; AAAI print not read) | Lemma 1: "Assume the hypotheses h in H are all K-Lipschitz continuous for some K. Then the following holds eps_t(h,h') <= eps_s(h,h') + 2K W1(mu_s,mu_t) for every hypothesis h, h' in H." Proof, eq. (13): "<= sup_{\|f\|_L<=2K} E_mu_t[f(x)] - E_mu_s[f(x)] = 2K W1(mu_s,mu_t)". Dual form, eq. (2): "W1(P,Q) = sup_{\|f\|_L<=1} E_{x~P}[f(x)] - E_{x~Q}[f(x)]". | **Same inequality.** Eq. (13) is Kantorovich-Rubinstein duality applied to g=\|h-h'\| (2K-Lipschitz): \|E_t g - E_s g\| <= Lip(g) W1. Proposition 1 is the same step with g=tau and Lip=L_clinical. The reviewer is right for Shen. Shen states the difference from Redko: "Compared with the proof in (Redko, Habrard, and Sebban 2016) the assumptions are different". |
| 3 | Tipton (2014) J Educ Behav Stat 39(6):478-501 | 10.3102/1076998614558486 | ABSTRACT-ONLY (formula only from a secondary review) | Abstract (Crossref): "we provide a generalizability index that can be used to assess the degree of similarity between the sample of units in an experiment and one or more inference populations on a set of selected covariates. The index takes values between 0 and 1 and indicates both when a sample is like a miniature of the population and how well reweighting methods may perform when differences exist." Secondary (Degtiar & Rose, arXiv:2102.11904v1): the index "bins propensity scores and is bounded between 0 and 1: sum_{j=1}^k sqrt(w_pj w_sj)"; "<0.5 ... very challenging to generalize from ... >0.9 indicates high generalizability (Tipton, 2014)". That sum is the Bhattacharyya coefficient of the binned propensity-score distributions. [推測: the name "Bhattacharyya", Tipton's own wording and the thresholds were not read in the original.] | **Same problem setting, different purpose.** One-number similarity of trial sample and population on a 0-1 overlap scale (1 = identical), computed on the one-dimensional selection propensity score, not on an effect-modifier distribution, and with no link to a bound on the effect difference. The reviewer's "Bhattacharyya on sampling-score distributions" agrees with the secondary source; unconfirmed in the original. |
| 4 | Stuart, Cole, Bradshaw, Leaf (2011) JRSS-A 174(2):369-386 | 10.1111/j.1467-985X.2010.00673.x | ABSTRACT-ONLY (Europe PMC abstract verbatim; the Sect. 3.3 and Fig. 2 strings below are fetch-tool renderings of the PMC4051511 page, not verified verbatim) | Abstract: "We propose the use of propensity-score-based metrics to quantify the similarity of the participants in a randomized trial and a target population. In this setting the propensity score model predicts participation in the randomized trial, given a set of covariates." Sect. 3.3: "the propensity score difference between the trial sample and population (Delta p)"; Fig. 2 caption: "standardized by standard deviation of propensity scores". | **Same problem setting, different purpose.** Trial-versus-population similarity via the difference of mean selection propensity scores (standardised by the SD of the score); no distributional distance, no bound on the treatment-effect difference. Closest to our SMD comparator, applied to the propensity score. |
| 5 | Dahabreh, Robertson, Steingrimsson, Stuart, Hernan (2020) Stat Med 39(14):1999-2014 | 10.1002/sim.8426 | ABSTRACT-ONLY (Europe PMC; arXiv:1805.00550v3 first page carries the same abstract) | "When treatment effect modifiers influence the decision to participate in a randomized trial, the average treatment effect in the population represented by the randomized individuals will differ from the effect in other populations. In this tutorial, we consider methods for extending causal inferences about time-fixed treatments from a trial to a new target population of nonparticipants, using data from a completed randomized trial and baseline covariate data from a sample from the target population." The word "transportability" does not occur in the abstract. | **Same estimand logic, different purpose.** The abstract states our premise (effect modifiers + differing populations => differing average effects) and estimates the target-population effect by outcome modelling / participation modelling / both. It neither ranks populations nor bounds a difference through a distance. [推測, not read: the target ATE is the integral of the conditional effect against the target covariate law, i.e. our \bar tau_r = int tau dF_r.] |
| 6 | Munk & Czado (1998) JRSS-B 60(1):223-241 | 10.1111/1467-9868.00121 | ABSTRACT-ONLY (full abstract from Crossref; also RePEc) | "In this paper the problem of assessing the similarity of two cumulative distribution functions F and G is considered. An asymptotic test based on an alpha-trimmed version of Mallows distance Gamma_alpha(F, G) between F and G is suggested, thus demonstrating the similarity of F and G within a preassigned Gamma_alpha(F, G) neighbourhood at a controlled type I error rate. ... It is shown that Gamma_alpha(F, G) can be interpreted as average and population equivalence." | **Same object family (Mallows/Wasserstein distance for "similarity"), different purpose.** Equivalence-type test (distance below a margin, controlled type I error) for goodness of fit and bioequivalence: the frame the reviewer's M5 asks for. We estimate W1 with an interval and tie the margin to an effect difference through L. The abstract says "similarity within a preassigned neighbourhood", not "relevant difference" (that phrase is the reviewer's). Mallows order and trimming definition not read [推測: L2]. |
| 7 | Alvarez-Esteban, del Barrio, Cuesta-Albertos, Matran (2008) JASA 103(482):697-704 | 10.1198/016214508000000274 | OPEN (no abstract retrievable: Crossref none, T&F 403) | Only secondary: arXiv:1205.1950 (a follow-up) says "As in Alvarez-Esteban et al., our choice for the metric d is the L2 Wasserstein distance" and calls it "The first approach to model validation based on impartial trimming" (fetch-tool quotation). [推測: similarity at level alpha = trimmed versions coincide/are close; not read in the original.] | **Same object family, different purpose** (robust similarity via impartial trimming with L2-Wasserstein; not W1; no effect-difference bound). Cite only as "trimmed Wasserstein similarity" until the PDF is obtained. |
| 8 | Bickel, Goetze, van Zwet (1997) Statistica Sinica 7(1):1-31 | **no DOI for the original** (Crossref has none). Reprint: 10.1007/978-1-4614-1314-1_17 (Selected Works of Willem van Zwet, Springer 2012, pp. 267-297) | GROUNDED (Berkeley tech report 419, 10-page version of the paper; the 31-page published version not read) | Abstract: "We discuss a number of resampling schemes in which m = o(n) observations are resampled. We review nonparametric bootstrap failure and give results old and new on how the m out of n with replacement bootstraps and without replacement works." Intro: "The m out of n with replacement bootstrap with m = o(n) has been known to work in all known realistic examples of bootstrap failure." | **Different purpose.** Supports the remedy named in M4(c) for settings where n-out-of-n bootstrap fails. The source does not treat W1 or boundary parameters, and does not claim bias correction. [推測: W1 at F1=F2 is a non-regular functional where this applies; the paper does not say so.] |
| 9 | Hong & Li (2018) J Econometrics 206(2):379-394 | 10.1016/j.jeconom.2018.06.007 | ABSTRACT-ONLY (RePEc via fetch tool; Crossref has no abstract) | Fetch-tool quotations of the abstract: the paper "provides a numerical derivative based Delta method"; with suitable step sizes it "provides consistent inference for functions of parameters that are only directionally differentiable" and "uniformly valid inference for certain convex and Lipschitz functions". Complements Fang and Santos (2014). | **Different purpose.** An alternative to the directional bootstrap of Fang-Santos / Sommerfeld-Munk for functions that are only directionally differentiable. [推測: W1 at F1=F2 is such a functional; the abstract does not mention W1.] `fang2019` is already in our .bib. |

## 2. Where the reviewer's description is NOT what the source says

1. **Redko et al. 2017 states the bound differently from the reviewer's gloss, but it is the same inequality family.** Lemma 1 is conditioned on an RKHS structure (kernel-induced cost, loss of RKHS norm <= 1, coefficient 1) and is proved by a coupling argument, not stated with a Lipschitz constant. The explicit K-Lipschitz form "eps_t <= eps_s + 2K W1" via Kantorovich-Rubinstein duality is Shen et al. 2018 eq. (13), who note their assumptions differ from Redko's. Cite Shen as the exact analogue of Proposition 1 and Redko as the originating W1 domain-adaptation bound; no "reviewer is wrong" framing.
2. **Tipton 2014**: the abstract confirms similarity between sample and inference populations "on a set of selected covariates", scale 0-1. The Bhattacharyya form and the 0.5 / 0.9 thresholds come from a secondary review; unverified in the original. It acts on the selection propensity score, not on an effect-modifier distribution.
3. **Munk-Czado 1998**: abstract says "similarity ... within a preassigned neighbourhood", not "relevant difference".
4. **Stuart 2011 and Dahabreh 2020** give neither a distributional distance nor a bound on the effect difference; they match the reviewer only in "trial vs target-population covariate difference".
5. The reviewer's "standard in covariate-shift OT" is supported: Shen eq. (13) is the same step as Proposition 1, and Redko Lemma 1 is the same family under RKHS conditions. What the sources do NOT state is any use for effect-modifier distributions or treatment-effect differences.

## 3. BibTeX block (paste-ready; nothing inserted into the .bib)

```bibtex
@inproceedings{redko2017,
  author    = {Redko, Ievgen and Habrard, Amaury and Sebban, Marc},
  title     = {Theoretical Analysis of Domain Adaptation with Optimal Transport},
  booktitle = {Machine Learning and Knowledge Discovery in Databases (ECML PKDD 2017)},
  series    = {Lecture Notes in Computer Science},
  volume    = {10535},
  pages     = {737--753},
  year      = {2017},
  publisher = {Springer},
  doi       = {10.1007/978-3-319-71246-8_45}
}

@inproceedings{shen2018,
  author    = {Shen, Jian and Qu, Yanru and Zhang, Weinan and Yu, Yong},
  title     = {Wasserstein Distance Guided Representation Learning for Domain Adaptation},
  booktitle = {Proceedings of the AAAI Conference on Artificial Intelligence},
  volume    = {32},
  number    = {1},
  year      = {2018},
  doi       = {10.1609/aaai.v32i1.11784}
}

@article{tipton2014,
  author  = {Tipton, Elizabeth},
  title   = {How Generalizable Is Your Experiment? An Index for Comparing Experimental Samples and Populations},
  journal = {Journal of Educational and Behavioral Statistics},
  volume  = {39},
  number  = {6},
  pages   = {478--501},
  year    = {2014},
  doi     = {10.3102/1076998614558486}
}

@article{stuart2011,
  author  = {Stuart, Elizabeth A. and Cole, Stephen R. and Bradshaw, Catherine P. and Leaf, Philip J.},
  title   = {The Use of Propensity Scores to Assess the Generalizability of Results from Randomized Trials},
  journal = {Journal of the Royal Statistical Society: Series A (Statistics in Society)},
  volume  = {174},
  number  = {2},
  pages   = {369--386},
  year    = {2011},
  doi     = {10.1111/j.1467-985X.2010.00673.x}
}

@article{dahabreh2020,
  author  = {Dahabreh, Issa J. and Robertson, Sarah E. and Steingrimsson, Jon A. and Stuart, Elizabeth A. and Hern{\'a}n, Miguel A.},
  title   = {Extending Inferences from a Randomized Trial to a New Target Population},
  journal = {Statistics in Medicine},
  volume  = {39},
  number  = {14},
  pages   = {1999--2014},
  year    = {2020},
  doi     = {10.1002/sim.8426}
}

@article{munk1998,
  author  = {Munk, Axel and Czado, Claudia},
  title   = {Nonparametric Validation of Similar Distributions and Assessment of Goodness of Fit},
  journal = {Journal of the Royal Statistical Society: Series B (Statistical Methodology)},
  volume  = {60},
  number  = {1},
  pages   = {223--241},
  year    = {1998},
  doi     = {10.1111/1467-9868.00121}
}

@article{alvarezesteban2008,
  author  = {{\'A}lvarez-Esteban, Pedro C. and del Barrio, Eustasio and Cuesta-Albertos, Juan A. and Matr{\'a}n, Carlos},
  title   = {Trimmed Comparison of Distributions},
  journal = {Journal of the American Statistical Association},
  volume  = {103},
  number  = {482},
  pages   = {697--704},
  year    = {2008},
  doi     = {10.1198/016214508000000274}
}

% The original has no DOI; the DOI in `note` is the Springer reprint chapter.
@article{bickel1997,
  author  = {Bickel, Peter J. and G{\"o}tze, Friedrich and van Zwet, Willem R.},
  title   = {Resampling Fewer Than $n$ Observations: Gains, Losses, and Remedies for Losses},
  journal = {Statistica Sinica},
  volume  = {7},
  number  = {1},
  pages   = {1--31},
  year    = {1997},
  note    = {Reprinted in Selected Works of Willem van Zwet, Springer 2012, pp. 267--297, doi:10.1007/978-1-4614-1314-1_17}
}

@article{hong2018,
  author  = {Hong, Han and Li, Jessie},
  title   = {The Numerical Delta Method},
  journal = {Journal of Econometrics},
  volume  = {206},
  number  = {2},
  pages   = {379--394},
  year    = {2018},
  doi     = {10.1016/j.jeconom.2018.06.007}
}
```

Given names confirmed against Crossref (Han Hong, Jessie Li; Pedro César, Eustasio, Juan Antonio, Carlos). LNCS volume 10535 is NOT confirmed by Crossref (it returned ISBN 9783319712451 / 9783319712468 and container "Lecture Notes in Computer Science / Machine Learning and Knowledge Discovery in Databases"); check the volume number against the Springer page before pasting. [推測]

## 4. Paper Requests (to close ABSTRACT-ONLY / OPEN)

- Tipton 2014, 10.3102/1076998614558486: pp. 478-501 for the index definition and thresholds.
- Alvarez-Esteban et al. 2008, 10.1198/016214508000000274: abstract and definition of the trimmed distance.
- Munk & Czado 1998, 10.1111/1467-9868.00121: Mallows order, definition of Gamma_alpha.
- Dahabreh 2020, 10.1002/sim.8426: identification formula for the target-population effect.
- Hong & Li 2018, 10.1016/j.jeconom.2018.06.007: full text if the numerical delta method is named in the text.

## 5. New idea (one line for /idea)

Equivalence-test framing of W1 against Delta_clin/L_UB with Munk-Czado-type size control, compared with our percentile interval (overlaps M5 of the external review).
