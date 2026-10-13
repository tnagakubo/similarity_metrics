# Academic Integrity Verification Report

**Agent**: ARS `integrity_verification_agent` (academic-pipeline Stage 2.5 gate), executed 2026-10-13.
**Target**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` (776 lines, working tree on top of `fad1010`) with `paper/per_em_W1_wiley.bib` (53 entries).
**Scope as assigned**: the 35 keys actually cited (`\cite{}` split on commas, unique); Phase A on all 35; Phase B on all 35 citing sentences; Phase C on the registry → macro → tex chain (21 numbers) and on every generated table (Tables 1–11 recomputed cell by cell from their source CSV); the 7-mode AI-research failure checklist. The manuscript and the bib were **not** edited.
**Method rule followed**: no reference was accepted from memory. Every DOI was resolved through the Crossref REST API (`https://api.crossref.org/works/<doi>`, paced, one call each, 2026-10-13); the two non-DOI entries were verified against the ICH server (HTTP 200, PDF title page) and the Statistica Sinica / Bielefeld records; biomedical abstracts were pulled from PubMed (12 PMIDs); book chapters got the enhanced check (chapter record + book editors/ISBN from a second source). Local PDFs in `knowledge/pdfs/` were read with `pdftotext` for the citation-context passages.
**Tool note**: the Semantic Scholar batch step (A0) was not available in this environment; Crossref served as the structured-metadata layer (`API_UNAVAILABLE` → A1 for all references, as the protocol prescribes).

## Verification Mode
Initial Verification (Stage 2.5, Mode 1)

## Verdict
**PASS WITH NOTES** — zero SERIOUS, zero MEDIUM, zero MAJOR_DISTORTION, zero UNVERIFIABLE; nine MINOR notes listed below.

## Verification Summary

| Category | Total | Passed | Issues |
|----------|-------|--------|--------|
| Reference Existence (A1) | 35 | 35 VERIFIED | 0 NOT_FOUND, 0 MISMATCH |
| Bibliographic Accuracy (A2) | 35 | 30 clean | 5 MINOR (formatting / incomplete fields; no author, year, venue or DOI error) |
| DOI misdirection check | 33 DOIs + 1 reprint DOI | 34 resolve to the cited work | 0 |
| Ghost Citations (A3) | — | — | 0 dangling / 18 orphan bib entries (never printed by BibTeX; informational) |
| Citation Context Accuracy (B1) | 35 (100%, not a spot-check) | 34 | 1 MINOR (weak support, no misrepresentation) |
| Statistical Data Accuracy (C1: registry → macro → tex) | 21 numbers | 21 | 0 |
| Statistical Data Accuracy (C1: CSV → generated table) | 11 tables, 275 printed cells | 275 | 0 |
| Internal Consistency (C2) | abstract ↔ Table 1 / Table 4 / derived CSVs | Pass | 0 |
| Originality Check (D1) | not run in this pass | — | out of the assigned scope; run before Stage 4.5 |
| Self-Plagiarism (D2) | not run | — | no author list supplied |
| Claim Verification (E) | 12 quantitative / factual claims traced to the cited source | 12 VERIFIED | 0 |
| AI-research failure modes (7) | 7 | 7 CLEAR | 0 SUSPECTED, 0 INSUFFICIENT EVIDENCE |

---

## Phase A — Reference Verification (35 cited keys)

Columns: each field is marked ✓ (matches the publisher/Crossref record), △ (minor deviation, described), or — (not applicable). "Source" is the record the fields were compared against. Year is the year the bib states.

| # | Key | Authors | Title | Venue | Year | Vol/Issue/Pages | DOI resolves to this work | Verdict | Source checked |
|---|-----|---------|-------|-------|------|-----------------|---------------------------|---------|----------------|
| 1 | andrews2000 | ✓ Andrews | ✓ | ✓ Econometrica | ✓ 2000 | ✓ 68(2):399–405 | ✓ 10.1111/1468-0262.00114 | VERIFIED | Crossref |
| 2 | austin2011 | ✓ Austin | ✓ | ✓ Multivariate Behav Res | ✓ 2011 | ✓ 46(3):399–424 | ✓ 10.1080/00273171.2011.568786 | VERIFIED | Crossref + PubMed 21818162 |
| 3 | ballman2015 | ✓ Ballman | ✓ | ✓ J Clin Oncol | ✓ 2015 | ✓ 33(33):3968–3971 | ✓ 10.1200/JCO.2015.63.3651 | VERIFIED | Crossref + PubMed 26392104 |
| 4 | bickel1997 | ✓ Bickel, Götze, van Zwet | ✓ | ✓ Statistica Sinica | ✓ 1997 | ✓ 7(1):1–31 | (no article DOI; reprint DOI 10.1007/978-1-4614-1314-1_17 in `note` resolves to the 2012 Springer reprint, pp. 267–297 ✓) | VERIFIED | Statistica Sinica issue listing www3.stat.sinica.edu.tw/statistica/j7n1/…; pub.uni-bielefeld.de/record/1628025; Crossref (reprint chapter) |
| 5 | chen2010 | △ eight named authors ✓; collective byline "for the Consistency Workstream of the PhRMA MRCT Key Issue Team" omitted | ✓ | ✓ Pharm Stat | ✓ 2010 | ✓ 9(3):242–253 | ✓ 10.1002/pst.438 | VERIFIED (MINOR) | Crossref + PubMed 20872623 |
| 6 | dahabreh2020 | ✓ 5 authors | ✓ | ✓ Stat Med | ✓ 2020 | ✓ 39(14):1999–2014 | ✓ 10.1002/sim.8426 | VERIFIED | Crossref + PubMed 32253789 |
| 7 | delbarrio1999 | ✓ del Barrio, Giné, Matrán | ✓ | ✓ Ann Probab | ✓ 1999 | ✓ 27(2):1009–1071 (pages from the article PDF header; Crossref has no page field) | ✓ 10.1214/aop/1022677394 | VERIFIED | Crossref + local PDF `knowledge/pdfs/Barrio_1999.pdf` p.1 |
| 8 | dumbgen1993 | ✓ Dümbgen | ✓ | ✓ Probab Theory Relat Fields | ✓ 1993 | ✓ 95(1):125–140 | ✓ 10.1007/BF01197342 | VERIFIED | Crossref + local PDF |
| 9 | efron1993 | ✓ Efron, Tibshirani | ✓ An Introduction to the Bootstrap | △ bib: Chapman & Hall/CRC, New York; the DOI record is the Springer US edition (ISBN 9780412042317 / 9781489945419) | ✓ 1993 | — | ✓ 10.1007/978-1-4899-4541-9 (same book) | VERIFIED (MINOR) | Crossref |
| 10 | fang2019 | ✓ Fang, Santos | ✓ | ✓ Rev Econ Stud | ✓ 2019 (online 2018) | ✓ 86(1):377–412 | ✓ 10.1093/restud/rdy049 | VERIFIED | Crossref (no vol/pages in record) + RePEc ideas.repec.org/a/oup/restud/v86y2019i1p377-412..html + academic.oup.com/restud/article/86/1/377/5094886 |
| 11 | fisher2017 | ✓ 5 authors | ✓ | ✓ BMJ | ✓ 2017 | ✓ 356:j573 | ✓ 10.1136/bmj.j573 | VERIFIED | Crossref + PubMed 28258124 |
| 12 | ftt1994 | ✓ FTT Collaborative Group | ✓ | ✓ Lancet | ✓ 1994 | ✓ 343(8893):311–322 | ✓ 10.1016/S0140-6736(94)91161-4 | VERIFIED | Crossref + PubMed 7905143 + local PDF |
| 13 | gusto1993 | ✓ The GUSTO Investigators (group author) | ✓ | ✓ N Engl J Med | ✓ 1993 | ✓ 329(10):673–682 | ✓ 10.1056/NEJM199309023291001 | VERIFIED | Crossref + PubMed 8204123 |
| 14 | hong2018 | ✓ Hong, Li | ✓ | ✓ J Econom | ✓ 2018 | ✓ 206(2):379–394 | ✓ 10.1016/j.jeconom.2018.06.007 | VERIFIED | Crossref + econbiz record |
| 15 | iche17 | ✓ ICH E17 EWG | ✓ General Principles for Planning and Design of MRCTs (E17) | ✓ ICH, Step 4 | ✓ 2017 (adopted 16 Nov 2017) | — | URL `database.ich.org/.../E17EWG_Step4_2017_1116.pdf` → HTTP 200, application/pdf, 29 pp.; title page and document history match | VERIFIED | ICH server (curl) + local copy `knowledge/pdfs/ICH E17.pdf` |
| 16 | ist1_2000 | △ author field not brace-protected (see MINOR) | △ title carries the appended ". IST Collaborative Group" (PubMed collective-author artefact) | ✓ Lancet | ✓ 1997 (key says 2000; entry year correct) | ✓ 349(9065):1569–1581 | ✓ 10.1016/S0140-6736(97)04011-7 | VERIFIED (MINOR) | Crossref + local PDF `IST_1997.pdf` |
| 17 | ist3_2012 | ✓ IST-3 collaborative group | ✓ | ✓ Lancet | ✓ 2012 | ✓ 379(9834):2352–2363 | ✓ 10.1016/S0140-6736(12)60768-5 | VERIFIED | Crossref + PubMed 22632908 |
| 18 | kent2020 | ✓ 17 authors, order matches | ✓ | ✓ Ann Intern Med | ✓ 2020 | ✓ 172(1):35–45 | ✓ 10.7326/M18-3667 | VERIFIED | Crossref + PubMed 31711134 |
| 19 | komiyama2024 (book chapter, enhanced check) | ✓ Komiyama, Hiro, Matsuoka, Yamamoto | ✓ "Pooling Strategies", chapter 4 | ✓ *Simultaneous Global New Drug Development: Multi-Regional Clinical Trials after ICH E17*, eds Li, Binkowitz, Wang, Quan, Chen; Chapman and Hall/CRC (Biostatistics Series) | ✓ 2021 (hardcover 2021-12-30; a 2024 paperback also exists) | △ chapter pages 45–55 absent from the bib | ✓ 10.1201/9781003109785-4 (chapter-level DOI; ISBN 9781003109785) | VERIFIED (MINOR) | Crossref chapter record; taylorfrancis.com chapter page; tenlong.com.tw / ibs.it / abebooks book listings (editors, subtitle, ISBN 9780367565602); local transcription `knowledge/pdfs/Ch4_Pooling_Strategy/Ch4_Pooling_Strategy.md` (DOI header, author line) |
| 20 | lee1995 | ✓ 10 authors, order matches | ✓ (bib keeps the "Results from an international trial of 41,021 patients" subtitle, as PubMed does) | ✓ Circulation | ✓ 1995 | ✓ 91(6):1659–1668 | ✓ 10.1161/01.cir.91.6.1659 | VERIFIED | Crossref + PubMed 7882472 |
| 21 | matsushima2024 | ✓ 11 authors | ✓ | ✓ Clin Pharmacol Ther | ✓ 2024 | ✓ 115(5):965–970 | ✓ 10.1002/cpt.3163 | VERIFIED | Crossref + local PDF |
| 22 | morris2019 | ✓ (△ full first names, inconsistent with the initials style of the rest of the bib) | ✓ | ✓ Stat Med | ✓ 2019 | ✓ 38(11):2074–2102 | ✓ 10.1002/sim.8086 | VERIFIED (MINOR) | Crossref + PubMed 30652356 |
| 23 | munk1998 | ✓ Munk, Czado | ✓ | ✓ JRSS B | ✓ 1998 | ✓ 60(1):223–241 | ✓ 10.1111/1467-9868.00121 | VERIFIED | Crossref |
| 24 | panaretos2019 | ✓ Panaretos, Zemel | ✓ | ✓ Annu Rev Stat Appl | ✓ 2019 | ✓ 6:405–431 | ✓ 10.1146/annurev-statistics-030718-104938 | VERIFIED | Crossref + local PDF |
| 25 | quan2010 | ✓ 13 authors | ✓ | ✓ Drug Inf J | ✓ 2010 | ✓ 44(5):617–632 | ✓ 10.1177/009286151004400509 | VERIFIED | Crossref |
| 26 | redko2017 | ✓ Redko, Habrard, Sebban | ✓ | ✓ ECML PKDD 2017, LNCS 10535 (Part II; eBook ISBN 978-3-319-71246-8), Springer | ✓ 2017 | ✓ 737–753 | ✓ 10.1007/978-3-319-71246-8_45 | VERIFIED | Crossref chapter record; Springer book record for 978-3-319-71246-8 = LNCS 10535; arXiv 1610.04420 |
| 27 | riley2010 | ✓ Riley, Lambert, Abo-Zaid | ✓ | ✓ BMJ | ✓ 2010 | ✓ 340:c221 | ✓ 10.1136/bmj.c221 | VERIFIED | Crossref + PubMed 20139215 |
| 28 | shen2018 | ✓ Shen, Qu, Zhang, Yu | ✓ | ✓ Proc AAAI 32(1) | ✓ 2018 | — | ✓ 10.1609/aaai.v32i1.11784 | VERIFIED | Crossref + arXiv 1707.01217 (AAAI 2018 note) |
| 29 | sommerfeld2018 | ✓ Sommerfeld, Munk | ✓ | ✓ JRSS B | ✓ 2018 (online 2017) | ✓ 80(1):219–238 | ✓ 10.1111/rssb.12236 | VERIFIED | Crossref + local PDF header |
| 30 | song2025 | ✓ 13 authors | ✓ | ✓ Ther Innov Regul Sci | ✓ 2025 | ✓ 59(2):359–364 | ✓ 10.1007/s43441-025-00744-8 | VERIFIED | Crossref + local PDF header |
| 31 | stuart2011 | ✓ Stuart, Cole, Bradshaw, Leaf | ✓ | ✓ JRSS A | ✓ 2011 (online 2010) | ✓ 174(2):369–386 | ✓ 10.1111/j.1467-985X.2010.00673.x | VERIFIED | Crossref |
| 32 | tipton2014 | ✓ Tipton | ✓ | ✓ J Educ Behav Stat | ✓ 2014 | ✓ 39(6):478–501 | ✓ 10.3102/1076998614558486 | VERIFIED | Crossref |
| 33 | vallender1974 | ✓ Vallender | ✓ | ✓ Theory Probab Appl (English translation of the 1973 TVP note) | ✓ 1974 | ✓ 18(4):784–786 | ✓ 10.1137/1118101 | VERIFIED | Crossref + SIAM epubs + mathnet.ru tvp4387 |
| 34 | villani2009 | ✓ Villani | ✓ Optimal Transport: Old and New | ✓ Springer, Grundlehren 338 | ✓ 2009 | — | ✓ 10.1007/978-3-540-71050-9 | VERIFIED | Crossref + Springer book record |
| 35 | wasserstein2016 | ✓ Wasserstein, Lazar | ✓ | ✓ Am Stat | ✓ 2016 | ✓ 70(2):129–133 | ✓ 10.1080/00031305.2016.1154108 | VERIFIED | Crossref |

**Hallucination-pattern scan (TF / PAC / IH / PH / SH, DOI misdirection)**: none detected. Every DOI landed on the work named in the bib (title, authors, venue, year all co-located in one record); no entry lacks volume/pages except books and the AAAI proceedings (which has none); the two "similar pair" cross-checks (chen2010 vs quan2010, same author circle 2010; redko2017 vs shen2018, same topic) are distinct real publications.

**A3 ghost citations**: dangling 0. Orphans (in bib, never cited): armstrong2021, austin2009, bareinboim2016, bonett2000, chen2000, craddy2014, emberson2014, gibbs2002, ikeda2010, jones2016, long2025, pearl2011, rothman2008, sai2021, vanderweele2009, vanderweele2014, vanderweele2019, yagi2015 (18). BibTeX prints only cited keys, so nothing reaches the reader; informational.

---

## Phase B — Citation Context (all 35 keys; every citing sentence read)

| Key | Manuscript location (tex line) | What the sentence attributes to the source | Source passage / evidence | Verdict |
|-----|----------------|---------------------|-------------------|---------|
| chen2010, quan2010 | L65 | MRCTs "have become the standard paradigm for global pharmaceutical development" | Both are reviews of consistency assessment in MRCTs ("A key issue in multi-regional clinical trials (MRCTs) is how to assess the consistency…", PubMed abstract); neither makes the "standard paradigm" statement | VERIFIED — weak support (background cite; no misrepresentation). MINOR note |
| iche17 | L65, L67 (×2), L522, L668 | adopted 2017; principles for planning/design; pooling described in terms of similarity of effect-modifier distributions; holistic evaluation | Title page "Final version Adopted on 16 November 2017"; §2.2.5 "The pooling strategy should be justified based on the distribution of the intrinsic and extrinsic factors known to affect the treatment response, and the disease under investigation and similarity of those factors across regions"; §2.2.7 "…should take into consideration biological plausibility … the clinical relevance, and the statistical uncertainty" | VERIFIED |
| iche17 (absence claim) | L74 "provides no specific metric, threshold, or statistical procedure" | — | `grep -i 'metric\|threshold'` over the full E17 text returns only "psychometric scales" and no similarity metric or threshold; glossary says "similar enough with respect to intrinsic and/or extrinsic factors" without a measure | VERIFIED |
| matsushima2024, song2025 | L67 regulators in Japan and China examine regional consistency | Matsushima: PMDA/JPMA workshop on consistency; Song: NMPA implementing E17 (abstracts) | VERIFIED |
| song2025 | L74 | ambiguity in pooling strategy; with multiple EMs, clustering on distances defined from the correlation between EMs and endpoints; cites the reference volume | p.359 abstract "pooling strategy, effect modifiers (EMs) … remains a challenge"; p.362 "cluster analysis can be used when there are multiple EMs [2]. The correlation between these EMs and endpoints can be used to define the distances between different populations"; ref [2] = Li, Binkowitz, Wang et al., *Simultaneous Global New Drug Development*, CRC 2021 | VERIFIED |
| komiyama2024 | L71, L74, L639 | knowledge of EMs varies and shapes planning; cluster analysis as one example: representative value per EM, standardization, Euclidean distance, Lasso weighting; "selection of distance measure is one of the key decisions"; calls for a "clinically meaningful or not" judgment; does not evaluate the approach | §4.6.1.1 "let a region have a representative value in each candidate parameter … Euclidean and Manhattan distances … standardization … The selection of distance measure is one of the key decisions … If Lasso regression model is applied, the weight of parameters not impacted on the response would be estimated as zero"; §4.6.1 "one of the approaches is introduced"; §4.7 "interpret if these differences are clinically meaningful or not"; Fig. 4.4 "Knowledge of effect modifier and what can be done at the planning stage" | VERIFIED |
| shen2018 | L77 | KR bound on a difference of expectations under a Lipschitz function used in OT domain adaptation | Paper text: "The Kantorovich-Rubinstein theorem shows that…", "Assume the hypotheses h ∈ H are all K-Lipschitz continuous…", "we prove the generalization bound in terms of the Kantorovich-Rubinstein dual formulation" | VERIFIED |
| redko2017 | L77 | W1 bound of the same family under a reproducing-kernel condition | Shen et al. on Redko: "the generalization bound exists when assuming the hypothesis class is a unit ball in RKHS and the transport cost function is RKHS distance"; Redko abstract: Wasserstein-based generalization guarantees | VERIFIED |
| stuart2011 | L77 | trial–population similarity summarized by propensity-score-based metrics | Abstract: "We propose the use of propensity-score-based metrics to quantify the similarity of the participants in a randomized trial and a target population" | VERIFIED |
| tipton2014 | L77 | generalizability index | Abstract: "we provide a generalizability index that can be used to assess the degree of similarity between the sample … and one or more inference populations" | VERIFIED |
| dahabreh2020 | L77 | literature on extending trial inferences to a target population | Title/abstract: "Extending inferences from a randomized trial to a new target population" | VERIFIED |
| munk1998 | L77 | similarity within a trimmed Mallows-distance neighbourhood framed as equivalence testing | Abstract: "asymptotic test based on an α-trimmed version of Mallows distance … demonstrating the similarity of F and G within a preassigned Γα(F,G) neighbourhood" | VERIFIED |
| matsushima2024 | L80 | PREVENT: post hoc pooling into five pooled regions; treatment differences varied slightly with CRP+/MRI+ and sex; Japanese inconsistency attributed to imbalanced assignment and small sample, not EMs | p.966 "clustered into five pooled regions"; "differed slightly depending on the distribution of CRP+/MRI+ and sex (Figure S2). The inconsistent results observed in the Japanese subpopulation could be due to an imbalance in treatment assignment and a small sample size (2 participants in the secukinumab arm and 7 in the placebo arm), but not due to potential effect modifiers" | VERIFIED |
| austin2011 | L86, L123 | SMD routinely applied to baseline covariates; SMD with pooled SD | Abstract: "I describe balance diagnostics for examining whether the propensity score model has been adequately specified" (the standardized-difference formula with pooled SD is that paper's balance diagnostic) | VERIFIED |
| villani2009, vallender1974 | L141, L148 | three equivalent forms of W1 on the line | Vallender abstract: W1 between one-dimensional distributions equals the L1 distance between their CDFs; del Barrio p.1009 eq. (1.2) states the quantile and CDF forms as equivalent | VERIFIED |
| panaretos2019 | L148 | W1 responds to variance, skewness, other distributional features | Review abstract: Wasserstein distances "quantify a natural notion of perturbation of a probability distribution" | VERIFIED |
| villani2009 | L158 (×2), L186 | W1 is a metric; KR dual representation; W1 ≤ W2 | Grundlehren 338 TOC: Ch. 5 "Cyclical monotonicity and Kantorovich duality" (p.51), Ch. 6 "The Wasserstein distances" (p.93) | VERIFIED (textbook content) |
| delbarrio1999 | L206, L733, L737 | √n W1(F̂n,F) → ∫|B(F(x))|dx when ∫√(F(1−F))dx < ∞; rate O(n^-1/2) iff that integral is finite; consistency | Theorem 1.1(a): convergence in law to ∫|B(F(t))|dt "if and only if" X ∈ Λ2,1 (= ∫√(F(1−F)) < ∞); (b) stochastic boundedness iff the same | VERIFIED |
| efron1993 | L206 | percentile bootstrap, B = 2,000 | the standard monograph on the percentile interval (Ch. 13) | VERIFIED |
| fang2019 | L206, L737, L741 | bootstrap consistent iff the derivative is linear; percentile interval valid under linearity | Abstract (RePEc): "full differentiability of φ is necessary and sufficient for bootstrap consistency when the limiting distribution of the estimator is Gaussian" | VERIFIED |
| dumbgen1993 | L206, L741 | naive bootstrap fails where the functional is non-differentiable | Summary: "a class of statistical problems, where usual bootstrap methods fail … minimum distance functionals" | VERIFIED |
| sommerfeld2018 | L206, L737 | finite-space limit = max over dual solutions; Gaussian when the dual solution is unique; naive bootstrap inconsistent | p.220: limit expressed through "the convex set of dual solutions to the Wasserstein problem"; p.221 "Directional Hadamard differentiability is not enough to guarantee the consistency of the naive bootstrap … the bootstrap is not consistent"; p.226 "Dümbgen (1993) showed that the naive n out of n bootstrap is inconsistent for functionals…" | VERIFIED |
| riley2010, fisher2017 | L223 | IPD meta-regression on treatment-by-covariate interaction estimates the interaction slope | Fisher abstract: IPD meta-analysis "provides greater power to investigate interactions between participant characteristics (covariates) and treatment effects"; Riley: IPD meta-analysis rationale/conduct | VERIFIED |
| ballman2015, kent2020 | L247 | prognostic and treatment-effect (predictive) gradients are distinct | Ballman abstract: predictive requires "a formal statistical test of the treatment-by-biomarker interaction"; purely prognostic = "treatment effects do not depend on the biomarker"; PATH: risk-modeling vs effect-modeling | VERIFIED |
| ftt1994 | L247, L516 | benefit irrespective of age and blood pressure among ST-elevation/BBB patients; no per-unit slope reported | Abstract: "Benefit was observed among patients presenting with ST elevation or bundle-branch block (BBB)–irrespective of age, sex, blood pressure, heart rate…" | VERIFIED |
| lee1995 | L247 (×2), L191 | 30-day mortality 1.1% below 45 y and 20.5% above 75 y | Abstract: "rates of 1.1% in the youngest decile (< 45 years) and 20.5% in patients > 75" | VERIFIED (numbers exact) |
| gusto1993 | L247, L511, L650, L711 | 30-day mortality 6.3% accelerated t-PA vs 7.2% and 7.4% streptokinase strategies; GUSTO-I as the data source | Abstract: "streptokinase and subcutaneous heparin, 7.2 percent; streptokinase and intravenous heparin, 7.4 percent; accelerated t-PA and intravenous heparin, 6.3 percent" | VERIFIED (numbers exact). Note: the trial enrolled 41,021; the manuscript's N = 40,830 is the public `predtools::gusto` dataset, which L711 states explicitly; `data/gusto.csv` has 40,830 rows and 16 distinct `regl` values |
| fisher2017 | L247 | "deft" estimator as an alternative specification strategy | Abstract: "testing for interactions using within-trials information alone (the deft approach)" | VERIFIED |
| wasserstein2016 | L252 | the judgment is not driven by a significance test | ASA statement on p-values | VERIFIED |
| morris2019 | L288 | ADEMP structure | Abstract: "defining aims, data-generating mechanisms, estimands, methods, and performance measures ('ADEMP')" | VERIFIED |
| ist1_2000, ist3_2012 | L650 | IST-1 and IST-3 as trials in the region-pair survey | Trial reports (19,435 and 3,035 patients) | VERIFIED |
| andrews2000 | L668 | boundary behaviour of the bootstrap when the true value is 0 | Title: "Inconsistency of the bootstrap when a parameter is on the boundary of the parameter space" | VERIFIED |
| bickel1997 | L683 | resampling fewer than n observations | Title / abstract (m-out-of-n bootstrap) | VERIFIED |
| hong2018 | L683 | numerical delta method for directionally differentiable functionals | Abstract: "consistent inference for functions of parameters that are only directionally differentiable" | VERIFIED |

---

## Phase C — Data Chain

### C1a. Registry → macro → tex (21 numbers recomputed from the source CSV named in `source_file`, rounded half-even to `fmt`, compared with the macro in `numbers_macros.tex`, then located as `\numval{key}` in the tex)

| Key | source_file | filter / column / agg | raw value | fmt | expected | macro | `\numval` uses in tex | Match |
|-----|-------------|------------------------|-----------|-----|----------|-------|-----------------------|-------|
| biasS1n50 | results/w1_raw_summary.csv | S1, n=50 / bias | 2.46317139 | .2f | 2.46 | 2.46 | 1 | ✓ |
| biasS4n50 | results/w1_raw_summary.csv | S4, n=50 / bias | 0.03355687 | .3f | 0.034 | 0.034 | 0 (registry row kept; Table 3 prints the same cell) | ✓ |
| biasMaxS3toS7n200 | results/w1_raw_summary.csv | S3–S7, n=200 / bias / max | 0.19283105 | .3f | 0.193 | 0.193 | 1 | ✓ |
| covS2n50 | results/w1_raw_summary.csv | S2, n=50 / coverage_pct | 0.7028 | .3f | 0.703 | 0.703 | 2 | ✓ |
| covS5n200 | results/w1_raw_summary.csv | S5, n=200 / coverage_pct | 0.9458 | .3f | 0.946 | 0.946 | 2 | ✓ |
| rmseS3n50 | results/w1_raw_summary.csv | S3, n=50 / rmse | 1.83013883 | .2f | 1.83 | 1.83 | 1 | ✓ |
| trueW1S6 | results/w1_raw_summary.csv | S6 / true_W1 | 12.159806 | .2f | 12.16 | 12.16 | 1 | ✓ |
| w1AgeR5 | results/gusto_r8_w1_per_pair.csv | partner=5 / W1_age | 0.38987681 | .2f | 0.39 | 0.39 | 1 | ✓ |
| w1SbpR9 | results/gusto_r8_w1_per_pair.csv | partner=9 / W1_sysbp | 6.80376478 | .2f | 6.80 | 6.80 | 1 | ✓ |
| w1AgeR2 | results/gusto_r8_w1_per_pair.csv | partner=2 / W1_age | 2.14817789 | .2f | 2.15 | 2.15 | 1 | ✓ |
| gustoN | results/derived/derived_scalars.csv | gusto_N | 40830 | {,}d | 40{,}830 | 40{,}830 | 2 | ✓ (also = row count of data/gusto.csv) |
| nR8 | results/derived/derived_scalars.csv | gusto_n_R8 | 2916 | {,}d | 2{,}916 | 2{,}916 | 1 | ✓ (also = rows with regl = 8) |
| reqnW1Set1loc | results/required_n_selection.csv | Set1 location, W1, 0.9 / required_n | 33 | d | 33 | 33 | 2 | ✓ |
| reqnW1Set2loc | results/required_n_selection.csv | Set2 location, W1, 0.9 / required_n | 129 | d | 129 | 129 | 2 | ✓ |
| covExtE5 | results/w1_raw_ext_summary.csv | E5_S2_1000 / coverage | 0.951 | .3f | 0.951 | 0.951 | 3 | ✓ |
| covExtE6 | results/w1_raw_ext_summary.csv | E6_S2_2900_1200_r10 / coverage | 0.947 | .3f | 0.947 | 0.947 | 2 | ✓ |
| nCellsW1FewerKS | results/derived/required_n_separation.csv | verdict=W1_fewer / n | 11 | d | 11 | 11 | 3 | ✓ |
| nCellsSelection | results/derived/selection_cell_auc_range.csv | method=SMD / n | 13 | d | 13 | 13 | 5 | ✓ |
| minW1SdS3toS7 | results/derived/derived_scalars.csv | study2_min_true_w1_sd_S3toS7 | 0.39894228 | .1f | 0.4 | 0.4 | 3 | ✓ |
| maxW1SdS3toS7 | results/derived/derived_scalars.csv | study2_max_true_w1_sd_S3toS7 | 1.2159806 | .1f | 1.2 | 1.2 | 3 | ✓ |
| spearmanAgeVsSbpSigned | results/derived/derived_scalars.csv | gusto_spearman_w1age_vs_w1sbp | −0.3 | .2f | −0.30 | −0.30 | 1 | ✓ |

`numbers_macros.tex` holds 235 macros for 235 registry rows (1:1).

### C1b. CSV → generated table (every cell of every `paper/generated/tab_*.tex` recomputed with decimal half-even rounding from the CSV named in the file's header comment)

| Table | Label | Generated file | Source CSV | Cells recomputed | Mismatches |
|-------|-------|----------------|------------|------------------|------------|
| 1 | tab:study2_required_n_mc | tab_study2_required_n_mc.tex | results/required_n_selection.csv (threshold 0.9; W1, KS, SMD; MC limits) | 13 rows × 3 methods (point + interval) + verdict column (from results/derived/required_n_separation.csv) | 0 |
| 2 | tab:scenarios | inline, via `\numval{trueW1S1..S7}` | results/w1_raw_summary.csv true_W1 | 7 (S5 = 3.99 and S6 = 12.16 recomputed; S1–S4 exact by construction) | 0 |
| 3 | tab:bias | tab_bias.tex | results/w1_raw_summary.csv | 7 × 3 bias + 7 true W1 | 0 |
| 4 | tab:coverage | tab_coverage.tex | results/w1_raw_summary.csv | 6 × 3 | 0 |
| 5 | tab:study2_intervals | tab_study2_intervals.tex | results/study2_interval_variants.csv | 21 rows × 5 columns | 0 |
| 6 | tab:study2_ext | tab_study2_ext.tex | results/w1_raw_ext_summary.csv | 11 rows × 9 columns (n1, n2, reps, true, bias, RMSE, coverage, upper-limit coverage, width) | 0 |
| 7 | tab:precision | tab_precision.tex | results/w1_raw_summary.csv | 7 × 6 | 0 |
| 8 | tab:gusto_r8 | tab_gusto_r8.tex | data/gusto.csv (regl == 8) | mean, SD, skewness for age and SBP (60.2 / 12.1 / −0.17; 132.4 / 22.9 / 0.20) | 0 |
| 9 | tab:operability | tab_operability.tex | results/gusto_operability.csv | null 95th-percentile ranges (0.618–0.900; 1.176–1.691) and unresolved counts (6/15; 1/15) | 0 |
| 10 | tab:gusto_nabcd | tab_gusto_nabcd.tex | results/gusto_r8_w1_per_pair.csv (+ rank intervals) | 15 rows × (n, W1 age, CI, W1 SBP, CI) = 105 numeric cells | 0 |
| 11 | tab:gusto_lstar_joint | tab_gusto_lstar_joint.tex | results/gusto_lstar_intervals.csv (+ gusto_operability.csv daggers) | 15 rows × 6 L* cells + W1 columns | 0 |

Also confirmed: `\numval{nSbpZero}` context — data/gusto.csv has 6 records with SBP = 0 (the manuscript treats these as recorded); 16 distinct region codes.

### C2. Internal consistency
- Abstract ↔ Table 1: "W1 needing fewer patients in 11 of 13 cells, overlapping in one, more in the location-shift control" = 11 `W1_fewer`, 1 `overlap` (Set 3 shape-symmetric), 1 `KS_fewer` (Set 4 bulk shift) in `required_n_separation.csv` ✓. "SMD stayed at chance up to 2,000 patients per region in some configurations" = 8 `blind` SMD cells ✓.
- Abstract ↔ Table 4: coverage from n = 100 for S3–S7 "0.92–0.95" = min 0.917 (S5, n=100) to max 0.951 ✓; "below 0.95 beyond Monte Carlo error in 1 of ten cells" is a derived CSV row (`study2_coverage_vs_mcse.csv`), consistent with S5 n=100 = 0.917 ✓.
- L247 arithmetic: 20.5 − 1.1 = 19.4 percentage points over ≥ 30 years → ≤ 6.5 × 10⁻³ per year ✓ (19.4/30 = 0.647).
- Design constants in Methods vs code: 10,000 replications and B = 2,000 (`R/w1_raw_simulation.R` L24–25, L69), n ∈ {50,100,200} (L86); application B = 2,000 and `set.seed(2026)` (`R/fig3_w1_axis.R` L28, L83, L119), percentile via `quantile()` default type 7 (L93); null floor B = 2,000 (`R/gusto_operability_check.R` L39); rank intervals 1,000 (`R/gusto_rank_intervals.R` L31); extension seed 20261012 (`PROTOCOL_study2_extension.md`, `w1_raw_ext_summary.csv` seed column) ✓.

### C3 / C4 (figure-trace block, experiment passport)
This repository is not an ARS pipeline project: there is no `figure_table_trace[]` block and no passport with `experiment_intake_declaration`. Legacy case → PASS WITH NOTES (trace-unavailable). The equivalent lab artefacts exist on disk and were used instead: `results/*_PROVENANCE.md` (seeds, scripts, run times), `results/REPLICATION_20261011.md` (clean-room replication, 21/21 cells within declared tolerance), `results/NUMBERS_LEDGER.csv` (51 design constants with locators), `CLAIMS.md` (49 claim rows). Boundary statement, verbatim as required: "This check verifies disclosure and claim-to-provenance fidelity. It does not judge whether the experiment was correctly designed, run, statistically adequate, or reproducible by ARS."

---

## Phase E — Claim Verification (12 quantitative / factual claims traced to the cited source; 100% of those that cite an external number)

| Verdict | Claim count | Proportion |
|---------|------------|-----------|
| VERIFIED | 12 | 100% |
| MINOR_DISTORTION | 0 | 0% |
| MAJOR_DISTORTION | 0 | 0% |
| UNVERIFIABLE | 0 | 0% |
| UNVERIFIABLE_ACCESS | 0 | 0% |

Claims: Lee 1995 1.1% / 20.5% (×2 sites); GUSTO 6.3% / 7.2% / 7.4%; FTT "irrespective of age … blood pressure"; Matsushima "five pooled regions", "CRP+/MRI+ and sex", "imbalance in treatment assignment and a small sample size"; Song "correlation between EMs and endpoints … distances", ref [2] = the CRC volume; ICH E17 "adopted 2017"; Komiyama "selection of distance measure is one of the key decisions", "clinically meaningful or not"; del Barrio iff-condition.

## Phase D — Originality
Not executed in this pass (outside the assigned scope: references, contexts, data chain, failure modes). Required before Stage 4.5.

---

## AI-Research Failure-Mode Checklist (Lu et al. 2026; 7 modes)

| Mode | Outcome | Evidence |
|------|---------|----------|
| 1. Implementation bug passing self-review | **CLEAR** | Every manuscript-feeding CSV has a producing script, a log ending in `[done]`, and a `sessionInfo` file (`results/*.log`, `results/*_sessionInfo.txt`). The only warnings in `w1_raw_simulation.log` are "package … was built under R version 4.5.2" (benign). The extension run logged an independent R-vs-C++ gate (max abs diff 6.2e-15, `STUDY2_EXT_PROVENANCE.md`). No suspiciously round effect sizes: the only exact values are structural (coverage 0.000 under the null, upper-limit coverage 1.0000 when W1 = 0), and the manuscript explains both (L435, L456, L468). Error bars vary across cells. Caveat (not a bug signal): Study 1 per-replicate values were not retained (`PROTOCOL_study1_identification.md`, `per_rep_rds: none`) — summaries with MC SE only. |
| 2. Hallucinated citation | **CLEAR** | 35/35 VERIFIED (Phase A); 0 NOT_FOUND / MISMATCH; no DOI misdirection. |
| 3. Hallucinated experimental result | **CLEAR** | 21 prose numbers and all 275 table cells tie to on-disk CSVs (Phase C). The clean-room replication (`results/REPLICATION_20261011.md`) reproduced Study 2 within pre-declared tolerance in 21/21 cells (the only flagged difference was the two-decimal truths printed in Methods, root-caused and resolved by the exact-value macros `trueW1S5exact` etc.). Replication counts in the text (10,000; 5,000; 2,000) match the `n_reps` column. |
| 4. Shortcut reliance | **CLEAR (flag-only note)** | The selection ground truth is the construction label, independent of every compared measure; the design includes a control cell (Set 4 bulk shift) in which the competitor (KS) wins, and it is reported; the abstract discloses that three of the eleven W1-favourable cells are favourable "by construction". The manuscript states the mixture world is adversarial for summary measures (L288). Nothing further to prepare for Stage 3 beyond keeping these disclosures. |
| 5. Bug reframed as insight | **CLEAR** | `grep -i 'surpris|unexpect|counterintuitiv|contrary to|remarkabl'` over the manuscript returns nothing. The one non-obvious result (positive bias and zero percentile coverage at the null) is derived from the non-negativity of W1 and tied to the boundary literature (andrews2000, dumbgen1993, fang2019), not presented as a discovery. |
| 6. Methodology fabrication | **CLEAR** | Every design constant in Methods was found in the run configuration (see C2: reps, B, grid, seeds, quantile type, null-floor and rank-interval replications). Protocol front matter is checked against the production scripts (`protocol_compile.py --verify`, per the protocol headers). Study 2 extension: protocol mtime 2026-10-12 17:56 (amendment registered 17:00) precedes the run that finished 18:42 the same day, with the protocol stating "written 2026-10-12 before any replicate"; Set 4 control: protocol 16:54, results 17:05. |
| 7. Frame-lock | **CLEAR (two notes)** | The project did back out of an earlier framing (nABCD → per-EM W1), which is the opposite of frame-lock; no "in hindsight / we realized later" phrases. Notes: (i) internal labels `fig:nabcd_definition`, `tab:gusto_nabcd`, `lst:nabcd` are residue of the retracted framing (cosmetic, invisible to readers); (ii) Study 1 is a post-hoc registration (`PROTOCOL_study1_identification.md`: `post_hoc: true`, `prior_look: "yes — the extension grid, the three-behaviour taxonomy and the required-n thresholds were fixed after the production results had been seen"`); the manuscript labels the interval variants and the sensitivity analyses as post hoc (L439, L456, L523) and the Study 2 extension as registered (L461), but §3.1 does not say that Study 1's taxonomy and thresholds were fixed after the base-grid results. Recommended disclosure, see IL-MINOR-9. |

Block condition: not met (no SUSPECTED; modes 1, 3, 5, 6 have on-disk evidence).

---

## Issue List (sorted by severity)

### SERIOUS (Must Fix)
None.

### MEDIUM (Must Fix)
None.

### MINOR (Recommended Fix)
| ID | # | Category | Location | Issue Description | Suggestion |
|----|---|----------|----------|------------------|------------|
| IL-MINOR-1 | 1 | Reference | bib `komiyama2024` | Chapter page range missing; Crossref/publisher give pp. 45–55 (chapter 4). Key says 2024, entry year 2021 (the 2021 hardcover is the edition the DOI points to; a 2024 paperback exists). | Add `pages = "45--55"` (and `chapter = "4"`); key name is internal. |
| IL-MINOR-2 | 2 | Reference | bib `efron1993` | `publisher = "Chapman & Hall/CRC", address = "New York"` while the DOI 10.1007/978-1-4899-4541-9 is the Springer US record of the same 1993 book (ISBN 9780412042317 / 9781489945419). Mixed-edition record. | Either cite the Chapman & Hall print edition without the DOI, or keep the DOI and name the Springer edition. |
| IL-MINOR-3 | 3 | Reference | bib `ist1_2000` | (a) `author = "International Stroke Trial Collaborative Group"` is not brace-protected, so BibTeX will parse "Group" as the surname; (b) the title field ends with ". IST Collaborative Group", a PubMed collective-author artefact that is not part of the article title; (c) key suggests 2000, article is 1997 (entry year is correct). | Brace the author (`{International Stroke Trial Collaborative Group}`), drop the trailing ". IST Collaborative Group" from the title, optionally rename the key. |
| IL-MINOR-4 | 4 | Reference | bib `chen2010` | Collective byline "for the Consistency Workstream of the PhRMA MRCT Key Issue Team" (listed by Crossref/PubMed) omitted. | Add as final braced author if the journal style prints group bylines. |
| IL-MINOR-5 | 5 | Reference | bib `morris2019` | Full first names ("Tim P", "Ian R", "Michael J") where every other entry uses initials; AMA style will render inconsistently. | Use initials. |
| IL-MINOR-6 | 6 | Citation context | tex L65 | chen2010 and quan2010 support "have become the standard paradigm for global pharmaceutical development" only indirectly (both are reviews of consistency-assessment methods and do not make that statement). | Cite a source that states it (e.g. ICH E17 §1 background, already in the bib) or soften to "are widely used". |
| IL-MINOR-7 | 7 | Ghost citations | bib | 18 entries never cited (listed under A3). Not printed by BibTeX; housekeeping only. | Prune before submission or keep for the response-to-reviewers phase. |
| IL-MINOR-8 | 8 | Framing residue | tex labels `fig:nabcd_definition`, `tab:gusto_nabcd`, `lst:nabcd` | Internal labels carry the retracted nABCD name. Invisible in the PDF. | Rename when convenient; cascade `\ref{}` sites and `R/make_paper_tables.R` output names. |
| IL-MINOR-9 | 9 | Disclosure | tex §3.1 (L282–L352) | The protocol records Study 1 as a post-hoc registration whose extension grid, three-behaviour taxonomy and required-n thresholds were fixed after the production results had been seen; the manuscript discloses post-hoc status for the interval variants, the sensitivity analyses and (as pre-registered) the Study 2 extension, but not for Study 1. | Add one sentence in §3.1 Design (or the Table 1 note) stating that the extended grid and the AUC = 0.9 target were fixed after the base-grid run (as `PROTOCOL_study1_identification.md` §0 already records). |

---

## Tool Limitation Disclaimer

> This verification report's originality check (Phase D) was not run in this pass; when run, it uses WebSearch heuristics and is not professional plagiarism-detection software (Turnitin / iThenticate). Coverage of the reference check is limited to Crossref, PubMed, the ICH server, publisher landing pages and the local PDFs named above; the Semantic Scholar batch layer was unavailable. Results are a preliminary screen; professional duplicate checking is recommended before formal submission.

---

## Verification Audit Trail

**Extraction**: `grep -oE 'cite[a-zA-Z]*\{[^}]*\}' per_em_W1_wiley.tex | split on ',' | sort -u` → 35 keys; `comm` against the 53 bib keys → 0 dangling, 18 orphans.

**A1/A2 (per reference)** — query → top record → fields confirmed:
- All 33 bib DOIs: `GET https://api.crossref.org/works/<doi>` (User-Agent `lab-integrity-check/1.0`, 1.5 s pacing after an initial 429 burst). Each JSON `message` was parsed for `title`, `author[].family`, `container-title`, `issued`/`published-print`/`published-online`, `volume`, `issue`, `page`, `publisher`, `ISBN`, `DOI` and compared field by field with the bib entry; the per-entry results are the ✓/△ marks in the Phase A table. The raw JSON records were cached at `%TEMP%\crossref\<key>.json` during the session (not part of the repository).
- `ftt1994`: Crossref via WebFetch (10.1016/S0140-6736(94)91161-4 → Lancet 343(8893):311–322, 1994, FTT Collaborative Group) + PubMed 7905143.
- `bickel1997`: WebSearch `Bickel Götze van Zwet 1997 "Resampling fewer than n observations" Statistica Sinica 7 1-31` → www3.stat.sinica.edu.tw/statistica/j7n1/j7n11 (first page 1), pub.uni-bielefeld.de/record/1628025 (7(1):1–31, 1997); reprint DOI 10.1007/978-1-4614-1314-1_17 → Crossref: *Selected Works of Willem van Zwet*, Springer New York, 2012 print, pp. 267–297.
- `iche17`: `curl -I`-equivalent GET on `https://database.ich.org/sites/default/files/E17EWG_Step4_2017_1116.pdf` → HTTP 200, `application/pdf`, 750,446 bytes; `pdftotext` of the local copy `knowledge/pdfs/ICH E17.pdf` → title page "GENERAL PRINCIPLES FOR PLANNING AND DESIGN OF MULTI-REGIONAL CLINICAL TRIALS E17 — Final version — Adopted on 16 November 2017".
- `komiyama2024` (enhanced): Crossref chapter record (title "Pooling Strategies", authors Komiyama/Hiro/Matsuoka/Yamamoto, container *Simultaneous Global New Drug Development*, Chapman and Hall/CRC, 2021, pp. 45–55, ISBN 9781003109785); taylorfrancis.com chapter page (chapter 4, same authors); WebSearch for the book → editors Gang Li, Bruce Binkowitz, William Wang, Hui Quan, Joshua Chen; Chapman & Hall/CRC Biostatistics Series; hardcover ISBN 9780367565602 dated 2021-12-30; full subtitle "Multi-Regional Clinical Trials after ICH E17" (tenlong.com.tw listing); Song 2025 ref [2] independently cites the same volume as "2021: CRC Press".
- `fang2019`: Crossref record lacks volume/pages (online-first 2018); WebSearch → RePEc `ideas.repec.org/a/oup/restud/v86y2019i1p377-412..html` and OUP URL `academic.oup.com/restud/article/86/1/377/5094886` confirm 86(1):377–412, 2019.
- `redko2017`: Crossref (book-chapter, LNCS, pp. 737–753, ISBN 9783319712468); Springer book record for 978-3-319-71246-8 = *Machine Learning and Knowledge Discovery in Databases: ECML PKDD 2017, Part II*, LNCS 10535 → bib volume 10535 correct.
- `vallender1974`: WebSearch → epubs.siam.org/doi/10.1137/1118101 and mathnet.ru/eng/tvp4387 (Russian original 1973, 18(4):824–827; English 1974, 18(4):784–786).
- `villani2009`: Crossref (book, Grundlehren der mathematischen Wissenschaften, Springer Berlin Heidelberg, 2009, ISBN 9783540710493/9783540710509); WebSearch TOC → Ch. 5 Kantorovich duality p.51, Ch. 6 The Wasserstein distances p.93.
- `hong2018`: Crossref + WebSearch (econbiz record; NSF full text) — authors Han Hong and Jessie Li; bib "Hong, H and Li, J" ✓.
- PubMed (`lookup_article_by_citation` → `get_article_metadata`): 7882472 (lee1995), 8204123 (gusto1993), 21818162 (austin2011), 26392104 (ballman2015), 31711134 (kent2020), 20872623 (chen2010), 28258124 (fisher2017), 20139215 (riley2010), 32253789 (dahabreh2020), 7905143 (ftt1994), 22632908 (ist3_2012), 30652356 (morris2019). According to PubMed, the DOIs returned are: [10.1161/01.cir.91.6.1659](https://doi.org/10.1161/01.cir.91.6.1659), [10.1056/NEJM199309023291001](https://doi.org/10.1056/NEJM199309023291001), [10.1080/00273171.2011.568786](https://doi.org/10.1080/00273171.2011.568786), [10.1200/JCO.2015.63.3651](https://doi.org/10.1200/JCO.2015.63.3651), [10.7326/M18-3667](https://doi.org/10.7326/M18-3667), [10.1002/pst.438](https://doi.org/10.1002/pst.438), [10.1136/bmj.j573](https://doi.org/10.1136/bmj.j573), [10.1136/bmj.c221](https://doi.org/10.1136/bmj.c221), [10.1002/sim.8426](https://doi.org/10.1002/sim.8426), [10.1016/S0140-6736(12)60768-5](https://doi.org/10.1016/S0140-6736(12)60768-5), [10.1002/sim.8086](https://doi.org/10.1002/sim.8086) (ftt1994 carries no DOI in PubMed; Crossref DOI used).

**B1 passages** were taken from: `pdftotext` of `knowledge/pdfs/Song_2025.pdf` (p.362 right column and reference list), `Matsushima_2024.pdf` (p.966), `ICH E17.pdf` (§2.2.5, §2.2.7, glossary), `10.1016@S0140-67369491161-4.pdf` (FTT), `Barrio_1999.pdf` (Theorem 1.1), `Dumbgen_1993.pdf` (Summary), `Sommerfield_2018.pdf` (§1.3, §2), `Panaretos_2019.pdf` (abstract), `IST_1997.pdf` (summary); `Ch4_Pooling_Strategy.md` (§4.6.1.1, §4.7); PubMed abstracts above; Crossref `abstract` fields for munk1998, stuart2011, tipton2014, shen2018, panaretos2019; arXiv 1610.04420 (Redko) and the AAAI PDF of Shen et al. (`pdftotext`, lines "The Kantorovich-Rubinstein theorem shows that…", "generalization bound exists when assuming the hypothesis class is a unit ball in RKHS").

**C1/C2** were computed with a throw-away Python script (decimal `ROUND_HALF_EVEN`, the lab's rule) reading `paper/numbers_registry.csv`, `paper/numbers_macros.tex`, the eleven `results/*.csv` named above and `data/gusto.csv`; no file in the repository was modified.

**Cross-model verification**: `ARS_CROSS_MODEL` not set → single-model verification; `[CROSS-MODEL-SKIPPED]` not applicable.

Report written 2026-10-13 by the ARS integrity_verification_agent run (Claude Code).
