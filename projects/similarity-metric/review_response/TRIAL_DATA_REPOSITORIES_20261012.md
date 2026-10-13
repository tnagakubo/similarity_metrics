# Catalogue of sites / repositories / packages holding participant-level trial data (Rachel, 2026-10-12)

Question (Tak): 「RCT bench のような臨床試験データをもってるサイトって他にはないのかな」.
Scope: reconnaissance only. No manuscript, SUITS.md, CLAIMS.md or DECISIONS.md was edited. No restricted IPD was downloaded. Only public documents (BioLINCC data dictionaries / CRFs / protocols, Data Compass dictionary, Dryad metadata, R package datasets) were read. Scratch files are in /tmp only.

Legend: **V** = verified this session by fetching the primary page, dictionary, API record or PubMed record. **S** = web-search snippet only. **[推測]** = my inference. **UNV** = could not be reached or not searched.
Criteria (Tak, 2026-10-12): A = real country/region label, >= 4 regions, NO per-region n floor. B = continuous baseline covariates. C = literature-documented regional TE heterogeneity (ideal). D = obtainable (tier 1 direct, tier 2 free registration, tier 3 application/DUA).
Already assessed (not redone): IST-1, IST-3, TOPCAT, ISCHEMIA, ACCORD, HF-ACTION, PEACE, CRASH-2, CRASH-3, WOMAN, RCT Bench, Project Data Sphere, YODA, Vivli, Gateway to Global Aging, WHO STEPS, NHANES/KNHANES (see `CASE_STUDY_CANDIDATES_20261012.md`).

## 0. Headline (Rachel)

1. **No new site or trial meets C.** I found no publication that attributes a regional treatment-effect difference to a continuous-EM distribution for any new candidate. For COLCORONA, STICH, BARI 2D and CABANA my PubMed queries returned nothing relevant, which is "not found", not "absent" (search log, section 6). PMID 35241218 (surfaced by my STICH query) is a US claims-database study of CAD testing and is irrelevant to C.
2. **The new, verified A+B+D leads are all in BioLINCC (tier 3):** COLCORONA (`COUNTRY` in DM; 6 countries; age, height, weight, creatinine, eGFR in the annotated CRF), STICH (`country_grp`, `region1`; age, weight, height, BMI, creatinine, systolic BP, LVEF), BARI 2D (`geographic_reg`; 6 countries but US-dominated [推測]). Level labels of the grouped variables are UNV in all three.
3. **RCT Bench count discrepancy, stated not reconciled:** the website brief says 125 trials; the published JCE paper (PubMed record) and the GitHub repository title say **50 trials / 29,094 participants**. Methods paper DOI: [10.1016/j.jclinepi.2026.112374](https://doi.org/10.1016/j.jclinepi.2026.112374) (PMID 42285376, *J Clin Epidemiol* 197:112374, published 2026-06-13; V via PubMed). The arXiv record (2602.00434, v3 revised 2026-06-09) carries the same title as the JCE paper; the v1 HTML I read carries an earlier title, "Benchmarking covariate-adjustment strategies for randomized clinical trials" (S: title taken from search-result link text).
4. **Where RCT Bench got its trials (arXiv v1 HTML, first 100,000 of 158,338 characters read, V):** searched Dryad, Harvard Dataverse, Zenodo and CRAN; 41 of 50 trials from Dryad / Dataverse / Zenodo, 9 from R packages (6 *medicaldata*, 1 *survival*, 1 *speff2trial*, 1 *mosaicData*). Inclusion: data dictionary present, human health outcome, individual randomisation, peer-reviewed publication, completed 1990 or later. **Sibling collections: none named in the part I read; the remaining 58,338 characters (including the reference list) are unread**, so "no sibling collection is cited" is NOT established. Repository: https://github.com/syl051088/RCT_Bench (V, title line only).
5. **A genuinely new access fact (V):** the public CRASH-1 (corticosteroid, head injury, 10,008 patient records) data dictionary at LSHTM Data Compass states: "EXCLUDED FROM THE CRASH DATA SET ARE THE VARIABLES: Country, hospital code and intervention. THESE VARIABLES MAY BE REQUESTED FROM THE CTU. A SUMMARY PROTOCOL DETAILING THE USE THAT WILL BE MADE OF THIS DATA MUST BE PROVIDED WITH THE REQUEST." (CRASH_Data_Dictionary_PDF.pdf, p.1). This is CRASH-1 only. It must not be extended to CRASH-2 / CRASH-3 / WOMAN, which were assessed separately (CRASH-2: no country variable in the dictionary; WOMAN: country removed by anonymisation; CRASH-3 dictionary UNV).
6. Dictionary negatives (V, grep for `countr|region|nation|geograph|continent`): CABANA, BEST-CLI and Kids-DOTT dictionaries contain no such string. The grep pattern was the test; a variable such as `SITEID` would not have been caught.

## 1. Catalogue

Columns: site | what it holds | access tier + URL | country/region variable typically retained? | example multi-country trial with continuous EMs | status.

### 1.1 Curated collections, benchmarks, packages

| Site / package | Holds | Tier + URL | Country/region retained? | Example | Status |
|---|---|---|---|---|---|
| RCT Bench (Shao, Lyu, Yu, Wang 2026) | 50 trials, 29,094 participants (JCE, PubMed) vs 125 trials (website, per brief and prior check) | Tier 1; https://github.com/syl051088/RCT_Bench ; https://bingkaiwang.github.io/RCT_Bench-main/website/ | Rarely: prior check found one trial with a country variable (Release Study, UK/Uganda/Pakistan, 3 regions) | Release Study, Dryad 10.5061/dryad.g3gj1 (V: appears in Dryad search) | V (PubMed, arXiv HTML first 100k chars, GitHub title); website not refetched |
| TrialBench (ML benchmark of clinical-trial design) | not searched | UNV | [推測] design/outcome tables built from registry records, not IPD | - | UNV, not searched |
| Vickers' open datasets | not searched | UNV | - | - | UNV, not searched |
| R `medicaldata` | datasets scanned by column-name pattern (V, loaded locally): `covid_testing` (not a trial), `indo_rct` (site: 4 US sites, n=602), `opt` (Clinic: KY/MN/MS/NY, n=823) | Tier 1; CRAN | No country; US sites only | none multi-country | V |
| R `survival` | `cgd` (centre: 13 named centres incl. Copenhagen, Zurich, Amsterdam + US hospitals; 203 counting-process rows, not 203 patients) | Tier 1; CRAN | Centre name only; ~4 countries only by inference [推測] | CGD interferon-gamma trial; age, height, weight; tiny | V (centre table) |
| R `pec` | `Pbc3` (n=349, `unit` = 1..6 with n = 23/150/46/79/23/28; age, creatinine, albumin, bilirubin, weight) | Tier 1; CRAN | Unit codes only, labels not given in the object; whether units are countries is UNV | PBC3 cyclosporin trial, European multicentre [推測] | V (object), UNV (meaning of `unit`) |
| R `predtools` | `gusto` (current case, `regl` 16 regions) | Tier 1 | Anonymised regions | GUSTO-I | V (loaded) |
| R `HSAUR3` / `HSAUR` | `respiratory` (2 centres) | Tier 1 | 2 centres | too small | V |
| R `speff2trial`, `TH.data`, `JM`, `joineR`, `riskRegression`, `asaur`, `causaldata`, `mstate`, `KMsurv`, `flexsurv`, `timereg`, `smcure`, `rms`, `mosaicData`, `Ecdat`, `gamlss.data` | all loaded (V); column-name scan found no trial dataset with a country/region column (hits were non-trial, e.g. `gapminder`, `Forbes2000`, `Crime`; `KMsurv::pneumon` has `region`/`hospital` but looks like an infant-pneumonia cohort, not a randomised trial [推測]) | Tier 1 | No | - | V for "loaded and scanned"; the scan matched column names only |
| Python `causalml` datasets; Kaggle / UCI | not searched. UCI Heart Disease (Cleveland / Hungary / Switzerland / VA) is a 4-site observational set, not a trial [推測] | Tier 1 | - | - | UNV, not searched |

### 1.2 Public repositories

| Site | Holds | Tier + URL | Country/region retained? | Example multi-country trial with continuous EMs | Status |
|---|---|---|---|---|---|
| **NHLBI BioLINCC** | 316 studies; 232 clinical trials, 3 trial/epidemiology, 80 epidemiology, 1 programme evaluation (V, studies index). Banner on the studies index: "This repository is under review for potential modification in compliance with Administration directives." (V, site-wide) | Tier 3 (registration + request + DUA). https://biolincc.nhlbi.nih.gov/studies/ | Study-specific. V-positive: COLCORONA `COUNTRY`; STICH `country_grp` ("Site location (country - grouped)") and `region1`; BARI 2D `geographic_reg`; TOPCAT `country`; ISCHEMIA `REGION4`. V-negative (pattern-based): CABANA, BEST-CLI, Kids-DOTT | COLCORONA, STICH, BARI 2D (section 2) | V (index, dictionaries, CRF) |
| Edinburgh DataShare | API query "randomised trial" returned 32 items; trial datasets: IST-1 (two versions), IST-3, RESTART and SoSTART (request forms), TOPPIC (Crohn's), GaPP1 (pelvic pain) | IST-1 tier 1; others by request form. https://datashare.ed.ac.uk | Only the IST family is multinational (prior check) | IST-1 (36 country codes, prior check) | V (API listing); country content of RESTART / SoSTART / TOPPIC / GaPP1 UNV, [推測] UK |
| LSHTM Data Compass / freeBIRD | EPrints repository; OAI-PMH scan lists CRASH (CRASH-1), CRASH-2, HALT-IT (protocol/forms only seen), WOMAN-ETAC, many LMIC cluster trials (single-country) | Tier 2-3; https://datacompass.lshtm.ac.uk | CRASH-1: country excluded from public file, **requestable from CTU** (V quote above). CRASH-2: no country (prior). HALT-IT IPD route UNV | CRASH-1: continuous baseline = age, minutes since injury; GCS ordinal | V (CRASH-1 dictionary, OAI listing) |
| **IDDO / WWARN** (malaria, COVID-19, Ebola, VL, Chagas, schistosomiasis, ...) | WWARN Malaria Data Inventory (monthly) lists shared studies with site country (S); COVID-19 platform: "more than 80,000 patients from over 60 countries" (V, iddo.org/covid-19 page text) | Application + DUA; free for non-profit researchers (S); requester must offer collaboration to the data contributor (S). https://www.iddo.org/node/3914 (V: page exists; describes Mapper vs SDTM formats) | Public tables list study country (S). Variable-level country in the IPD: UNV ([推測] present in SDTM DM; IDDO SDTM manual returned "Unauthorized") | WWARN pooled artemisinin trials [推測]; continuous: age, weight, parasitaemia, Hb [推測] | S / V mix; data dictionary UNV |
| **C-Path TB-PACTS** | 34 studies (TB-1001 ... TB-1039), about 28,627 subjects (sum reported by the fetch tool from the page table, not recomputed by me); REMoxTB, RIFAQUIN, OFLOTUB named (S) | Tier 2-3: CP-DAP account + Steering Committee approval, "may take up to 4 weeks", "There is no fee" (V). https://c-path.org/tools-platforms/tb-pacts | UNV: page lists demographics, HIV/CD4, outcomes, SDTM mapping, but no country list | REMoxTB (multi-country [推測]); continuous: age, weight, CD4 | V (access, size), UNV (country) |
| NICHD DASH | Not trial-only; home page lists recent items (ATN 144, Global DHM Study, AMP Up Lite, AMP Up); search interface is JavaScript-driven | Registration + DASH User Agreement; https://dash.nichd.nih.gov | UNV. Could not confirm that Global Network trials (e.g. ACT, 6 countries; NCT01084096, S) are hosted | Global Network ACT trial (cluster-randomised, 6 countries; S) | UNV for hosting |
| NIA / NACC, NIMH NDA, NIDA Data Share, NIDDK Central Repository, ImmPort | not searched | - | [推測] NIDA CTN and NIDDK are mostly US; ImmPort is immunology, country rarely retained | - | UNV, not searched |
| ClinicalTrials.gov IPD links, dbGaP | dbGaP phenotype-only [推測]; NCI NCTN/NCORP Data Archive requests moved to dbGaP from Q3 2025, 16 trials listed as of 2026-05-15 (S) | S; https://dctd.cancer.gov/research/networks/nctn/data-archive | UNV | NRG / SWOG / CCTG trials, some international [推測] | S only |
| Dryad | Search API "randomized trial" returns 316 records (V). Sweep of three queries filtered for "multicentre / international / countries" in title+abstract: mostly single-country or small trials | Tier 1 (CC0); https://datadryad.org | Rarely. The only international-trial IPD hit, "Sex differences in treatment and outcome after stroke: pooled analysis including 19,000 participants" (10.5061/dryad.4qt8510), contains **only a supplementary PDF** (V: single file listed), no IPD | - | V (file list) |
| Harvard Dataverse, Zenodo, figshare, OSF, ICPSR, UK Data Service | Dataverse search API reachable but keyword search is dominated by non-clinical hits; Zenodo API returned 403 (blocked); the others not searched | Tier 1 | - | - | UNV |
| MRC CTU, Oxford ORA, Cochrane IPD, CSDR, TransCelerate | CSDR: sponsors (Astellas, Bayer, GSK, Novartis, Teva; S), account + research proposal + independent review panel (S). Others not searched | CSDR tier 3 (S); https://clinicalstudydatarequest.com | CSDR: UNV | industry multinational phase III [推測] | S / UNV |
| Japan (JAPIC, PMDA, UMIN-ICDR, J-STAGE data), China (NMPA), EU (EMA clinical data publication), WHO ICTRP | not searched. [推測] EMA publishes CSRs, not IPD; ICTRP is a registry | - | - | - | UNV, not searched |

### 1.3 Disease platforms and trial networks

| Platform | Holds | Tier + URL | Country retained? | Example | Status |
|---|---|---|---|---|---|
| VISTA (Virtual International Stroke Trials Archive) | Described in 2007 as 21 trials, > 15,000 patients; anonymised data at Robertson Centre, University of Glasgow (S, 2007 paper); VISTA-Rehab 23 trials (2009 poster, S) | Current request process UNV; vistacollaboration.org returned 403 to my fetch | UNV | stroke trials (international by name) | S only; access terms UNV |
| ANZICS CTG (NICE-SUGAR, CHEST, SAFE) | I found only the ANZICS CORE registry data-request form (S); no route to trial IPD found | - | - | - | UNV |
| ACTG / HPTN | ACTG: IPD shared after publication, proposal approved by ACTG, DUA (S); HPTN 065 datasets via HPTN LOC request (S) | Tier 3 | HPTN 065 fields include "state" (US) (S); country/site UNV | HPTN / ACTG multinational trials [推測] | S |
| PRO-ACT (ALS) | about 11,685 records from 29 trials (secondary report, S); free download after request at alsdatabase.org | Tier 2 (S) | UNV | - | S |
| RECOVERY / SOLIDARITY / ISARIC / ENCHANTED / INTERACT / TICH-2 / ENOS | not searched individually; the ENCHANTED query returned design facts only (110 hospitals, 15 countries, S) | - | - | - | UNV |

## 2. Concrete new trial candidates (all BioLINCC, tier 3, unless stated)

| Trial | Era / N | Regions | Country variable | Continuous baseline covariates (dictionary / CRF) | C (regional heterogeneity) | Status |
|---|---|---|---|---|---|---|
| **COLCORONA** (colchicine, community COVID-19) | 2020; 4,488 randomised (V, PMID 34051877) | Brazil, Canada, Greece, South Africa, Spain, USA (V, abstract). Annotated CRF country list: Canada, USA, Spain, South Africa, UK, France, "Other, specify" (V); Brazil and Greece therefore entered through "Other" on the CRF, and whether `COUNTRY` (Char 3) codes them separately is UNV | `COUNTRY` (Char 3) in DM (V, COLCORONA_2022a.pdf) | `AGE` (DM); `HEIGHT`, `WEIGHT` (VS, so BMI is derivable); `CREAT` creatinine, `GFR` (LB) (V, annotated CRF gives SDTM test codes). **No baseline blood-pressure test code found in the CRF text I grepped** | Not found; PubMed queries did not target it successfully (log). Per-country N unknown | V for A and B; UNV for per-country N and C |
| **STICH** (CABG +/- medical therapy, ischaemic LV dysfunction) | 2002-2007; 2,136 patients (BioLINCC V); hypothesis-1 comparison 1,212 patients (Velazquez 2011, [10.1056/NEJMoa1100356](https://doi.org/10.1056/NEJMoa1100356), V) | multinational per the BioLINCC `country_grp` variable name (V); country list and number of countries UNV (PubMed returned an affiliation only for the first author of each STICH paper, so no country list was derived from it) | `country_grp` ("Site location (country - grouped)") and `region1` ("Region a patient is from") (V, STICH_2018a.pdf). Level labels UNV; "grouped" may mean fewer than 4 named countries | `age`, `weightkg`, `heightcm`, `bmi`, `crt` creatinine, `BPSYS`, `BPDIA`, `PULSE`, `bestlvef`, `esvi0` (V) | Not found (one query returned an unrelated claims-data paper; two others 0 hits). Treat as UNV | V for variable names; UNV for levels and C |
| **BARI 2D** | 2001-2005; 2,368 patients, 49 sites in US, Canada, Brazil, Mexico, Czech Republic, Austria (V, BioLINCC description) | 6 countries; US-dominated [推測] | `geographic_reg` (GREGION format) (V, BARI2D_V4.pdf) | `hdl`, `ldl`, `trig`, `acr` (urine ACR) and others (V); BP/BMI not read | Not found (PubMed query 0 hits) | V for variable; levels UNV |
| CRASH-1 (LSHTM, request route) | 10,008 patient records (V, dictionary: 10,009 rows incl. header) | many countries [推測] | **Excluded from public file; requestable from the CTU with a summary protocol** (V quote) | `AGE`, `MINS_SINCE_INJURY` only (GCS ordinal) (V) | None known | V for access route |
| TB-PACTS studies (e.g. REMoxTB, RIFAQUIN, OFLOTUB) | up to 34 studies | multi-country [推測] | UNV | age, weight, CD4 [推測] | UNV | access V, country UNV |
| Not recommended: CABANA, BEST-CLI, Kids-DOTT (BioLINCC) | CABANA "international" (V, BioLINCC text), BEST-CLI "international" (V) | - | none found in dictionary (V-negative by grep) | - | - | V-negative |

## 3. Ranked shortlist (A and D first; C stated per row, and nothing here meets C)

### Top 5 sites
1. **NHLBI BioLINCC** (tier 3): the only site where I verified country/region variable names in multinational trials (COLCORONA, STICH, BARI 2D, TOPCAT). Risk: site-wide "under review" banner (V).
2. **Edinburgh DataShare** (tier 1 for IST-1): the only verified tier-1 source of a real-name country variable in a large multinational trial (36 codes); nothing else multinational found there.
3. **IDDO / WWARN** (tier 3, free for non-profit, S): large multi-country pooled data with study-level country listed; variable-level country UNV, so rank is conditional.
4. **C-Path TB-PACTS** (tier 2-3, no fee, review up to 4 weeks, V): 34 studies / about 28.6k subjects; country UNV.
5. **LSHTM Data Compass** (tier 2-3): CRASH-1 country is requestable from the CTU (V); CRASH-2 is not. Useful as a template for "ask the CTU for the stripped variable", which may apply to other CTU-held trials [推測].

### Top 5 concrete trials (new ones; IST-1 remains the verified tier-1 option from the earlier file)
| Rank | Trial | A | B | C | D | One-line reason |
|---|---|---|---|---|---|---|
| 1 | COLCORONA | 6 countries (V), `COUNTRY` (V) | age, BMI (height+weight), creatinine/eGFR (V); no baseline BP found | not found | tier 3 | 2020, international, country in SDTM DM; per-country N must be checked after approval |
| 2 | STICH | `country_grp`, `region1` (V); levels UNV | age, BMI, weight, SBP, creatinine, LVEF (V) | not found | tier 3 | richest continuous EM set among the new finds; "grouped" country may collapse regions |
| 3 | BARI 2D | `geographic_reg` (V); 6 countries (V) | lipids, ACR (V) | not found | tier 3 | real regions but US-dominated [推測], so effective regions may be < 4 |
| 4 | CRASH-1 (via CTU request) | country exists but excluded (V) | age, time since injury only | none known | request to CTU | strong A if granted, weak B (two continuous variables) |
| 5 | TB-PACTS trial (REMoxTB etc.) | UNV | age, weight, CD4 [推測] | UNV | tier 2-3 | cannot rank higher until a data dictionary is read |

Honest ranking note: ranks 1-3 are ordered on A+B+D. None is better than the already-known IST-1 on D (tier 1), and none improves on C.

## 4. What I could not verify (required list)

1. Level labels of `country_grp`, `region1` (STICH) and `geographic_reg` (BARI 2D): SAS format catalogues are not in the PDFs.
2. Per-country N for COLCORONA, STICH, BARI 2D (requires the IPD). For COLCORONA, whether Brazil and Greece are coded separately in `COUNTRY` or pooled as "Other" is UNV; if pooled, the named regions drop to four plus Other.
3. Whether COLCORONA has any baseline blood-pressure measurement: only the annotated CRF text was grepped; the SDTM VS/LB codelists are not in the dictionary.
4. Regional TE heterogeneity (C) for COLCORONA, STICH, BARI 2D, CABANA: my PubMed queries were complex and returned 0 or irrelevant hits; a search gap, not evidence of absence.
5. RCT Bench: reference list of the methods paper (characters 100,000-158,338 of the arXiv HTML) unread; whether any sibling collection is cited is open. The 50 vs 125 count discrepancy is unreconciled.
6. IDDO / WWARN variable-level country (IDDO SDTM Implementation Manual: "Unauthorized"; WWARN data dictionary page text did not mention country).
7. TB-PACTS country per study.
8. NICHD DASH hosting of Global Network trials (ACT etc.): search interface is JavaScript; web search found nothing.
9. VISTA current access terms (site 403; only 2007-2009 papers).
10. ANZICS CTG trials (NICE-SUGAR, CHEST, SAFE), ENCHANTED, INTERACT, TICH-2, ENOS, RECOVERY, SOLIDARITY, ISARIC: no route found / not searched.
11. Not searched at all: TrialBench, Vickers datasets, Python `causalml`, Kaggle / UCI (beyond a [推測] note), NIA/NACC, NIMH NDA, NIDA Data Share, NIDDK Central Repository, ImmPort, ClinicalTrials.gov IPD links, figshare, OSF, ICPSR, UK Data Service, MRC CTU, Oxford ORA, Cochrane IPD, TransCelerate, JAPIC / PMDA / UMIN-ICDR / J-STAGE, NMPA, EMA, WHO ICTRP. Prior expectations, all [推測]: NIDA/NIDDK are US-centric; EMA / ICTRP / PMDA do not hold IPD.
12. Zenodo API returned 403 (blocked); Harvard Dataverse keyword search is not selective. Dryad coverage is a keyword sweep of three queries, not exhaustive.
13. The general claim "platforms using SDTM carry COUNTRY in DM" (TB-PACTS, IDDO, Vivli, CSDR) is [推測] as a rule; verified only for COLCORONA.
14. The R package scan matched column names only; a country stored in a non-obvious column (e.g. an anonymised centre code) would be missed. `pec::Pbc3$unit` meaning is not documented in the object.
15. BioLINCC: whether new data requests are being processed under the "under review" banner is UNV.

## 5. Notes for Tak's decision (no decision taken)

The binding constraints are (i) whether a country variable survives anonymisation and (ii) criterion C. COLCORONA and STICH are the first new trials with a named country/region variable plus a continuous-EM set, but "grouped" labels and per-country N must be seen before any commitment. A cheap probe before an application: read the COLCORONA and STICH main publications and supplements for per-country enrolment (not done this session).

New paper idea (one line for `/idea`): "request the stripped country variable from the CTU (CRASH-1 route) as a general data-access tactic for trials whose public file omits country."

## 6. Search log (verbatim)

Knowledge base first: grep of `knowledge/INDEX.md` and `knowledge/summaries/` for `BioLINCC|COLCORONA|STICH|BARI|IDDO|WWARN|TB-PACTS|VISTA|Dryad|RCT.Bench|Shao` = 0 hits (V, this session). Earlier session: TOPCAT|ISCHEMIA|CRASH|IST-3|PLATO|MERIT = 0 hits.

| Database | Verbatim query / URL | Hits | Decision |
|---|---|---|---|
| WebSearch | Shao Lyu Yu Wang RCT Bench participant-level randomized trials covariate adjustment Journal of Clinical Epidemiology 2026 | 10 | found arXiv 2602.00434; DOI not in result |
| WebSearch | "How should covariates be handled in randomized trials" Empirical evidence from 50 trials Journal of Clinical Epidemiology doi | 9 | DOI not found; resolved via PubMed |
| PubMed | Shao Y[Author] Wang B[Author] covariates randomized trials empirical evidence 50 trials (from 2026) | 1 (42285376) | included; DOI 10.1016/j.jclinepi.2026.112374 |
| WebFetch | https://arxiv.org/abs/2602.00434 ; https://arxiv.org/html/2602.00434v1 (offset 0-100000) | - | data sources named; reference list unread |
| WebSearch | TB-PACTS TB Platform for Aggregation of Clinical Trial Data access country variable trials | 10 | included |
| WebFetch | https://c-path.org/tools-platforms/tb-pacts | - | 34 studies, no fee, up to 4 weeks |
| WebSearch | IDDO data platform access individual participant data country variable WWARN malaria clinical trials data request | 10 | included |
| curl | https://www.iddo.org/node/3914 ; https://www.iddo.org/covid-19 ; https://www.wwarn.org/data-dictionary-V1 ; https://wiki.iddo.org/en/Data-Engineering/IDDO-SDTM-Implementation-Manual | - | page text only; manual unauthorized |
| WebSearch | VISTA Virtual International Stroke Trials Archive data access request terms trials number of patients | 9 | 2007-2009 papers only |
| WebSearch | Virtual International Stroke Trials Archive VISTA collaboration request data access Glasgow Robertson Centre 2025 | 9 | no current terms |
| WebSearch | "Virtual International Stroke Trials Archive" "Virtual Trials Archives" VISTA data request website | 9 | no current terms |
| WebSearch | NICHD DASH Global Network for Women's and Children's Health Research data country Maternal Newborn Health Registry | 9 | registry facts only |
| WebSearch | dash.nichd.nih.gov Global Network Antenatal Corticosteroids Trial ACT dataset OR "Women First" OR "Helping Babies Breathe" OR "Emergency Obstetric" study dataset DASH | 9 | no DASH hosting found |
| WebFetch | https://dash.nichd.nih.gov/ | - | home page only |
| curl | https://biolincc.nhlbi.nih.gov/studies/ and ?s=rank&s=acronym&p=1..22 (313 study slugs); per-study pages for all slugs grepped for country/region words | - | 316 studies, 232 trials; multinational subset identified |
| curl | BioLINCC data dictionaries: cabana (CABANA_2023a.pdf), best_cli (BEST_CLI_2023a.pdf), stich (STICH_2018a.pdf), colcorona (COLCORONA_2022a.pdf), bari2d (BARI2D_V4.pdf), kids_dott (Kids_DOTT_2025a.pdf); COLCORONA annotated forms and protocol | - | grep `countr|region|nation|geograph|continent` |
| WebSearch | BioLINCC multinational heart failure trial data dictionary country SOLVD DIG AIM-HIGH FREEDOM BARI 2D STICH countries | 9 | no dictionary content |
| PubMed | STICH trial regional differences geographic region outcomes surgical ventricular reconstruction CABA medical therapy | 0 | too narrow |
| PubMed | Surgical Treatment for Ischemic Heart Failure STICH geographic regional variation | 1 (35241218) | excluded: US claims study |
| PubMed | STICH trial ischemic cardiomyopathy regional differences North America Europe Asia Latin America | 0 | gap |
| PubMed | Velazquez Coronary-artery bypass surgery in patients with left ventricular dysfunction N Engl J Med 2011 | 2 (21463150, 21463153) | included: DOI 10.1056/NEJMoa1100356 |
| PubMed | COLCORONA colchicine regional OR country differences treatment effect | 6, noise | excluded |
| PubMed | Colchicine for community-treated patients with COVID-19 (COLCORONA) | 1 (34051877) | included; DOI 10.1016/S2213-2600(21)00222-8 |
| PubMed | COLCORONA colchicine outpatients COVID-19 randomised trial Tardif Lancet Respiratory Medicine | 0 | replaced by previous |
| PubMed | BARI 2D geographic region differences baseline characteristics outcomes Brazil Mexico Czech | 0 | gap |
| PubMed | CABANA catheter ablation atrial fibrillation regional differences North America Europe Asia outcomes enrolment region | 0 | gap |
| PubMed | CABANA Packer catheter ablation vs antiarrhythmic drug therapy atrial fibrillation JAMA 2019 | 2 (30874766, 30874716) | not used |
| WebSearch | ANZICS CTG trial individual patient data sharing NICE-SUGAR CHEST SAFE data access request | 9 | no IPD route |
| WebSearch | HPTN data sharing individual-level data request ACTG data sharing trials country site variable | 9 | access terms only |
| WebSearch | Vivli platform Welcome Trust ENCHANTED INTERACT trials data available stroke multinational dataset | 10 | nothing on Vivli |
| WebSearch | "individual participant data" Dryad multicentre international randomised trial countries dataset deposited country variable | 10 | nothing useful |
| Dryad API | /api/v2/search?q=randomized trial (4 pages), randomised controlled trial participants (3 pages), clinical trial individual participant data (3 pages), filtered for country/multinational/international/multicent + random | 316 for first query | sweep; candidates listed |
| Dryad API | datasets/doi:10.5061/dryad.4qt8510 (versions, files) | 1 file (PDF) | not IPD |
| Edinburgh DataShare API | /server/api/discover/search/objects?query=randomised trial | 32 | IST-1, IST-3, RESTART, SoSTART, TOPPIC, GaPP1 |
| LSHTM Data Compass | OAI-PMH ListRecords oai_dc, filtered on trial/randomi | about 90 | CRASH-1 dictionary read |
| WebSearch | HALT-IT tranexamic acid gastrointestinal bleeding trial data sharing individual patient data freeBIRD countries 15 | 9 | no IPD route found |
| WebSearch | NCI NCTN/NCORP Data Archive request data registration free clinical trial patient-level data | 9 | moved to dbGaP (S) |
| WebSearch | PRO-ACT Pooled Resource Open-Access ALS Clinical Trials database registration free number of patients trials | 10 | S |
| WebSearch | clinicalstudydatarequest.com CSDR how to request data academic researchers free sponsors country anonymisation | 10 | S |
| Local R | scan of dataset columns matching `countr|region|cent(er|re)|site|hospital|^unit$|nation|clinic|continent|geog|hosp|centre` in 28 packages (section 1.1) | 15 non-gapminder hits | listed |

Gap statement: "No new site or trial I could verify meets A+B+C+D together." Falsifier: a trial with (i) named country/region in the obtainable file, (ii) a continuous baseline EM, and (iii) a publication attributing its regional TE difference to that EM's distribution.

## 7. References (all with DOI where retrieved)

- Shao Y, Lyu L, Yu M, Wang B (2026) "How should covariates be handled in randomized trials? Empirical evidence from 50 trials and recommendations for practice" *J Clin Epidemiol* 197:112374. DOI: [10.1016/j.jclinepi.2026.112374](https://doi.org/10.1016/j.jclinepi.2026.112374) (PubMed 42285376; V)
- Shao Y et al. (2026) arXiv:2602.00434. DOI: [10.48550/arXiv.2602.00434](https://doi.org/10.48550/arXiv.2602.00434) (V, abs page)
- Tardif J-C et al. (2021) "Colchicine for community-treated patients with COVID-19 (COLCORONA): a phase 3, randomised, double-blinded, adaptive, placebo-controlled, multicentre trial" *Lancet Respir Med* 9(8):924-932. DOI: [10.1016/S2213-2600(21)00222-8](https://doi.org/10.1016/S2213-2600(21)00222-8)
- Velazquez EJ et al. (2011) "Coronary-artery bypass surgery in patients with left ventricular dysfunction" *N Engl J Med* 364(17):1607-1616. DOI: [10.1056/NEJMoa1100356](https://doi.org/10.1056/NEJMoa1100356)
- Bonow RO et al. (2011) "Myocardial viability and survival in ischemic left ventricular dysfunction" *N Engl J Med* 364(17):1617-1625. DOI: [10.1056/NEJMoa1100358](https://doi.org/10.1056/NEJMoa1100358) (retrieved, not used for a claim)
- Zheng J et al. (2022) "Variability in Coronary Artery Disease Testing for Patients With New-Onset Heart Failure" *J Am Coll Cardiol* 79(9):849-860. DOI: [10.1016/j.jacc.2021.11.061](https://doi.org/10.1016/j.jacc.2021.11.061) (retrieved, judged irrelevant to C)
- Carcel C et al. (2019) "Sex differences in treatment and outcome after stroke: Pooled analysis including 19,000 participants" *Neurology* 93(24):e2170-e2180. DOI: [10.1212/WNL.0000000000008615](https://doi.org/10.1212/WNL.0000000000008615) (PubMed 31719135; V). Dryad deposit: [10.5061/dryad.4qt8510](https://doi.org/10.5061/dryad.4qt8510) (supplementary PDF only).
- CRASH (CRASH-1) data dictionary, LSHTM Data Compass eprint 35: https://datacompass.lshtm.ac.uk/id/eprint/35/ dataset DOI [10.17037/DATA.11](https://doi.org/10.17037/DATA.11) (V: `eprints.id_number` meta tag of the eprint page; resolver not tested)
- BioLINCC dictionaries: https://biolincc.nhlbi.nih.gov/studies/colcorona/ , /stich/ , /bari2d/ , /cabana/ , /best_cli/ , /kids_dott/
