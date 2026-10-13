# Four-eyes verification — round 3 (2026-10-12) — verifier: Louis (producer: Mike, D-20261012-3)

Method: own one-off R (/tmp/louisv/v.R, not sourcing any project script), Rscript 4.5.1; decimal half-even at printed precision.

## Keys verified: 17/17, 0 mismatches
| key | printed | recomputed (raw) | source used |
|---|---|---|---|
| set4NullSdRatioW1n200 | 1.62 | 1.619156 | per_rep.rds: sd(mix_n200_null[,w1]) / sd(gauss_n200_null[,w1]); = CSV |
| set4NullSdRatioKSn200 | 1.00 | 0.996362 | per_rep.rds, same for ks; = CSV |
| set4IntegralRatio | 1.68 | 1.681760 | own quadrature: I_gauss 16.14744, I_mix 27.15611 (integrate and 0.001-grid Riemann agree) |
| set4DeltaAucGaussN200d2 | 0.029 | 0.029065 (paired DeLong MCSE 0.00249) | per_rep.rds, Mann–Whitney + own DeLong; = CSV |
| set4DeltaAucMixN200d2 | -0.032 | -0.031612 (MCSE 0.00389) | per_rep.rds; = CSV |
| aucW1GaussN200d2 / aucKSGaussN200d2 | 0.839 / 0.810 | 0.839040 / 0.809975 | per_rep.rds |
| aucW1MixN200d2 / aucKSMixN200d2 | 0.732 / 0.764 | 0.732263 / 0.763875 | per_rep.rds |
| surveySpearmanW1KSmin / max | 0.879 / 0.989 | 0.878571 / 0.988944 (13 rows) | real_data_survey_summary.csv |
| monoRatioAgeMin / Max | 0.66 / 1.00 | 0.655002 / 0.999610 | data/gusto.csv (regl, age), own W1; W1 = per-pair CSV to 4e-15 |
| monoRatioSbpMin / Max | 0.72 / 1.00 | 0.720596 / 0.996532 | data/gusto.csv (regl, sysbp); W1 = CSV to 5e-15 |

Mixture definition confirmed in R/selection_simulation.R ext_c(s0=10, st=8), build_set4 A0 = ext_c(50, .05, 40, .05, 40): 0.05 N(10,8^2) + 0.90 N(50,10^2) + 0.05 N(90,8^2).
Identity A+ - A- = mu1 - mu2 (1 = R8, A+ = int (F_partner - F_R8)_+): holds to machine precision for partners 5 and 7, age and SBP (e.g. SBP p5: 2.022321 = 2.022321; A+ + A- = W1 exactly).
§2 criterion at n=200, d=2: dAUC_gauss 0.029 > 2(0.0025); dAUC_mix -0.032 < -2(0.0039); rho_W - 1 = 0.62 > 2(0.035); |rho_KS - 1| = 0.004 <= 2(0.019). Criterion holds.

## Findings
- Minor: monoRatio max prints 1.00 but the raw maxima are 0.9996 / 0.9965 — the bound is never exactly attained; "up to 1.00" is fine, "attains 1" is not.
- Protocol §0 discloses both prior looks (exploratory n_sim=2000 run; referee check at shift 2.5). OK.
- Major (sentence, not in .tex yet): "raise I by 1.68 ... multiplies the null SD by 1.62" juxtaposes two ratios as cause→effect of near-equal size; §2 explicitly does not license SD ∝ I(G), and the grid contradicts it (rho_W = 1.53 at n=400, MCSE 0.032, i.e. ~4.5 MCSE below 1.68). The integral is licensed only as the first-order scale of the null MEAN (mean ratio 1.70).
- Major: "A location difference on a heavy-tailed population therefore favours the KS statistic" — a general rule about KS vs W1 (§2 "does not license"), extended to an untested class ("heavy-tailed"; other bases, shifts, n excluded by §2). The mixture is also not heavy-tailed in the technical sense (Gaussian tails); it is a centre-plus-remote-subgroups mixture.
- Major: two sentences where §2/§7 license one; dAUC and rho printed without MCSE.
- Fix (one sentence): "For the same two-unit shift at n = 200 per region, the Set 4 anchor population, whose two 5% subgroups lie 40 units from the centre, multiplies the null sampling standard deviation of Ŵ1 by 1.62 (MCSE 0.04) relative to N(50,10²) while leaving that of the distribution-free KS statistic unchanged (1.00, MCSE 0.02), and the paired AUC difference between W1 and the KS statistic changes sign, from 0.029 (MCSE 0.002) under the Gaussian anchor to −0.032 (MCSE 0.004) under the Set 4 anchor." Drop the integral clause (or move it to Methods as the first-order scale of the null mean) and drop the "therefore" sentence.
