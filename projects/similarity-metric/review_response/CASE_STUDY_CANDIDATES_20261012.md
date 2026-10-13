# Case-study candidates to replace / complement GUSTO-I (Rachel, 2026-10-12)

Question (Tak): are there better case studies with obtainable published/IPD data than GUSTO-I (anonymised regions, 1990s, no documented EM-driven regional heterogeneity, SBP=0 artefacts)?

Scope: literature and data-source reconnaissance only. No manuscript, SUITS.md, CLAIMS.md or DECISIONS.md was edited. No IPD of any restricted dataset was downloaded. One open dataset (IST-1, ODC-By) was downloaded to /tmp only to count rows per country and to tabulate descriptive means (exploratory, not protocol-covered, not used as a result).

Legend: **V** = verified in this session by fetching the primary page, data dictionary or PubMed record. **S** = web-search snippet only. **[推測]** = my inference, not checked against a source. **UNV** = could not be reached.

Criteria: A = IPD with real region/country, at least 4 regions with n>=100. B = continuous plausible EM. C = documented regional TE heterogeneity attributed at least partly to an EM-distribution difference. D = access tier. E = post-2010 era.

## 0. Headline

1. No dataset I could verify satisfies A, B, C and D together. The best compromise on A+B+D is IST-1 (tier 1, 24 countries with n>=100 verified) and IST-3 (country, treatment delay, age, SBP, NIHSS verified; needs an application).
2. TOPCAT is not a clean criterion-C case. Its regional difference has a documented drug-exposure explanation (2.1). It remains a good distance case (Russia/Georgia vs Americas baseline), but L would still be an illustrative bound.
3. ISCHEMIA fails A on the public file (only `REGION4`, no country), and Ikemura 2024 reports consistency, not heterogeneity.
4. CRASH-2 fails A (no country variable in the data dictionary). WOMAN fails A (site and country removed by anonymisation). Firm negatives.
5. An estimable L is conceivable with IST-3: Emberson 2014 (IPD meta-analysis, 6,756 pts, 9 trials) documents that alteplase benefit depends on onset-to-treatment delay, a continuous EM. IST-3 carries `treatdelay` and `country`. No source I read claims regional heterogeneity of TE in IST-3, and country-level delay distributions have not been looked at.
6. Matsushima 2024 (E17 workshop) secukinumab case: the original PDF supports "region 1 including Japan had a lower CRP+ and higher MRI+ proportion", but states the Japanese-subpopulation inconsistency was "not due to potential effect modifiers". The KB summary over-reads this (4.1). EMs are binary and IPD is not public [推測].

## 1. Master table

| # | Dataset | Design, era | N | Countries / regions | Region var kept? | Candidate continuous EMs | Documented regional TE heterogeneity (DOI) | Access tier + URL | Status |
|---|---|---|---|---|---|---|---|---|---|
| 1 | IST-1 International Stroke Trial | RCT aspirin/heparin, 1991-96 | 19,435 (V: 19,435 rows) | 36 country codes (V); 24 with n>=100 (V) | Yes: `COUNTRY`, `CNTRYNUM`, `HOSPNUM` (V) | `AGE`, `RSBP`, `RDELAY` (V, CSV header) | None found | Tier 1, ODC-By v1.0 (V, IST-1 record). DOI [10.7488/ds/104](https://doi.org/10.7488/ds/104); https://datashare.ed.ac.uk/handle/10283/124 | V |
| 2 | IST-3 | RCT alteplase <=6 h, recruitment 2000-2011 | 3,035 (V, PMID 22632908) | 12 countries (V); public file has 8 named + "Other" (Austria, Canada, Mexico, Switzerland pooled) (V, Description PDF s1.4) | Yes: `country`, `randhosp_id` (randomised hospital ID) (V) | `age`, `sbprand`, `dbprand`, `weight`, `glucose`, `nihss`, `randdelay`, `treatdelay` (V, contents PDF) | No country interaction found. Delay-dependence of benefit: Emberson 2014 [10.1016/S0140-6736(14)60584-5](https://doi.org/10.1016/S0140-6736(14)60584-5) (V) | Tier 3-ish. DataShare text says embargo ended and no application needed (S); DUA v2.1 PDF (V) requires group + proposal + publication plan. Conflict unresolved. DOI [10.7488/ds/1350](https://doi.org/10.7488/ds/1350); https://datashare.ed.ac.uk/handle/10283/1931 | V (dictionary, DUA, description). Per-country N for the 8 countries not read |
| 3 | TOPCAT (BioLINCC) | RCT spironolactone, HFpEF, 2006-2012 | 3,445 (V) | Americas (US, Canada, Brazil, Argentina) 1,767 vs Russia/Georgia 1,678 (V, PMID 25406305) | Yes: `country` "Country of Origin", format COUNTRYF (V, table t011 of TOPCAT_2024a.pdf). Level labels unverified | `age_entry`, `SBP`, `weight` (BMI derivable only if height exists, UNV), `gfr` "recalculated eGFR", `CR_mgdL` (V) | Yes, Pfeffer 2015 [10.1161/CIRCULATIONAHA.114.013255](https://doi.org/10.1161/CIRCULATIONAHA.114.013255) (V). Not purely EM-attributed, see 2.1 | Tier 3 (BioLINCC registration + request; commercial and area restrictions "No"). https://biolincc.nhlbi.nih.gov/studies/topcat/ | V |
| 4 | ISCHEMIA / ISCHEMIA-CKD (BioLINCC) | RCT invasive vs conservative, 2012-2018 | 5,179 + 777 (V) | 37-38 countries, 6 regions in publication (S; V for Ikemura) | Only `REGION4` (4 categories, labels unverified) (V, ISCHEMIA_2023a.pdf). No country | `RVBPSYS`, `BMI_TRUNC`, `EGFR_TRUNC`, `IAGE_ENR_TRUNC`, `CREAENRL`, `WT_TRUNC` (V) | Ikemura 2024 [10.1161/CIRCOUTCOMES.123.010534](https://doi.org/10.1161/CIRCOUTCOMES.123.010534) (V): consistent benefit across regions; baseline SAQ differs (67.4 Eastern Europe vs 78.6 North America) | Tier 3, "Open BioLINCC Study", datasets updated 11 Jul 2023 (V). https://biolincc.nhlbi.nih.gov/studies/ischemia/ | V |
| 5 | CRASH-2 (freeBIRD / Data Compass) | RCT TXA, trauma, 2005-2010 | 20,211 (V) | 274 hospitals, 40 countries (V) | No. Dictionary variables (V): `isource`, `iboxid`, `ipacknum`; "countr" occurs 0 times | `iage`, `isbp`, `irr`, `ihr`, `igcs`, `ninjurytime` (V) | CRASH-2/3 pooled: no heterogeneity by country income, p=0.68 (V, PMID 33172504; DOI 10.1186/s13054-020-03243-4) | Tier 2 (registration, S). DOI 10.17037/DATA.10 (as shown on record). https://datacompass.lshtm.ac.uk/id/eprint/34/ | Fails A (V) |
| 6 | WOMAN | RCT TXA, PPH, 2010-2015 | 20,060, 193 hospitals (S) | 21 countries (S) | No: anonymisation removed "dates, site and country information" (V) | not read | - | Tier 2 (data sharing agreement). https://datacompass.lshtm.ac.uk/id/eprint/1811/ | Fails A (V) |
| 7 | CRASH-3 (freeBIRD) | RCT TXA, TBI, 2012-2019 | 12,737 (S) | 175 hospitals, 29 countries (S) | UNV (freeBIRD blocked by Cloudflare; no dictionary found) | GCS, SBP, age [推測] | none found | Registration required (S) | UNV; treat like CRASH-2 until a dictionary is read |
| 8 | HF-ACTION / PEACE / ACCORD (BioLINCC) | RCTs | not checked | not checked | ACCORD dictionary: no country/region variable (V, grep). HF-ACTION page 404 (UNV). PEACE dictionary not read (UNV) | - | - | Tier 3 | Low priority; likely North America only [推測] |
| 9 | Project Data Sphere | Oncology phase III | varies | varies | varies | varies | - | Tier 2: application, about 7 business days, free to registered researchers (S) | Comparator arms only (S): no treatment contrast |
| 10 | YODA (J&J) / Vivli | Industry phase II-IV | - | - | dataset-specific, UNV | - | - | Tier 3: proposal + DUA; YODA decision within 30 days (S). https://yoda.yale.edu/request/ ; https://vivli.org/resources/requestdata/ | Availability of PLATO / PARADIGM-HF / EMPA-REG UNV |
| 11 | Gateway to Global Aging (HRS/ELSA/SHARE/CHARLS/JSTAR) | Cohort surveys | large | many | cohort = country | BMI in harmonised list (S); SBP UNV | n/a | Tier 2 registration (SHARE about 1 week, ELSA about 1 day) (S). https://g2aging.org | SBP/BMI codebooks not checked |
| 12 | WHO NCD microdata (STEPS) | Surveys | - | many | by country | SBP, height, weight (S) | n/a | Email request, co-authorship offer, non-commercial (S). https://extranet.who.int/ncdsmicrodata | S only |
| 13 | NHANES / KNHANES | Surveys | - | US / Korea | single country each | measured BP and BMI (S) | n/a | Tier 1 public files (S). https://wwwn.cdc.gov/nchs/nhanes/ ; http://knhanes.cdc.go.kr | S only; CHNS not searched |

## 2. Detail on the leading candidates

### 2.1 TOPCAT (A yes; B yes; C partial, with a conduct confound)

Verified in the BioLINCC data dictionary (TOPCAT_2024a.pdf): table t011 has `age_entry` ("Age Entering Study") and `country` ("Country of Origin", COUNTRYF); tables t006/t013 have `SBP`, `DBP`, `weight`; a further table has `gfr` ("recalculated eGFR"); `CR_mgdL` creatinine.

Pfeffer 2015 (PubMed abstract): "an approximately 4-fold difference was identified in this composite event rate between the 1678 patients randomized from Russia and Georgia compared with the 1767 enrolled from the United States, Canada, Brazil, and Argentina"; Russia/Georgia patients "were younger ... lower left ventricular ejection fraction and creatinine but higher diastolic blood pressure". Large baseline differences exist, but the paper does not attribute the treatment-effect difference to them.

Competing explanation, de Denus 2017 NEJM ([10.1056/NEJMc1612601](https://doi.org/10.1056/NEJMc1612601), PMC5590224, full text read): "canrenone concentrations were undetectable in a higher percentage of participants from Russia than from the United States and Canada (30% vs. 3%, P<0.001)" among those reporting that they took the study drug. This is a drug-exposure explanation. A clinical slope L for age/SBP/eGFR would therefore remain illustrative.

Caveats: `country` level labels not verified; the BioLINCC ISCHEMIA page carries a notice that the repository "is under review for potential modification in compliance with Administration directives" (V on the ISCHEMIA page; not checked on the others), an access risk for every tier-3 NHLBI option.

### 2.2 IST-3 (A yes but per-country N unverified; B yes; C not regional; access by application)

Contents PDF (V) lists `country` (text), `randhosp_id`, `age`, `gender`, `randdelay`, `sbprand`, `dbprand`, `weight`, `glucose`, `nihss`, `treatdelay` ("Time (hr) from stroke to treatment"). Description PDF s1.4 (V): "Austria, Canada, Mexico and Switzerland have been grouped together as 'Other'. The remaining 8 countries had sufficiently large numbers of participants that there was no prospect of identifying individuals." That is an anonymity statement, not a statement that each country has n>=100. A search snippet gives 1,447 UK patients (S), so several of the 8 may be below 100 [推測]. A is therefore unverified until the IPD is opened.

Emberson 2014 (V, PubMed): "Treatment within 3.0 h resulted in a good outcome for 259 (32.9%) of 787 patients who received alteplase versus 176 (23.1%) of 762 who received control (OR 1.75, 95% CI 1.35-2.27) ... delay of more than 4.5 h ... OR 1.15, 95% CI 0.95-1.40". The same abstract: "Proportional treatment benefits were similar irrespective of age or stroke severity", so delay, not age or NIHSS, is the EM.

Use: L would be derived from Emberson (log-OR per hour of delay, computed from the paper, not typed from memory) and applied to country-level `treatdelay` distributions. Falsifier: if country delay distributions are nearly identical, W1 is near zero everywhere and the case adds little.

Access: DUA v2.1 (V): "bona fide research group (e.g. evidenced via CVs and the involvement of a qualified statistician)", research proposal, publication plan, authorship arrangement, reviewed by the IST-3 trials publications group; data destroyed at project end. Era: recruitment 2000-2011, so E only partly met.

### 2.3 IST-1 (A yes, tier 1; era and C weak)

Verified by fetching the CSV and variable list: 19,435 patients; `COUNTRY` with 36 codes; 24 countries have n>=100 (UK 6,257; Italy 3,437; Switzerland 1,631; Poland 759; Netherlands 728; Sweden 636; Australia 597; Argentina 545; Norway 526; Spain 478; Czech 466; New Zealand 453; Portugal 415; ...). `RSBP` has no zeros or blanks in my count. Licence string "Open Data Commons Attribution License (ODC-By) v1.0" came from the IST-1 record page (full-metadata view); the IST-3 record did not show it.

Descriptive only (exploratory): among the 13 countries with n>=400, mean age ranges 65.8 (Portugal) to 75.1 (Sweden) and mean SBP 155.4 (New Zealand) to 168.5 (Netherlands), so real EM distributions differ by country.

Weaknesses: 1991-96, no documented regional TE heterogeneity. Strengths: real country names, tier 1, large N, no SBP=0 artefact. Best use: a complement showing real-country labelling, or a clean replacement if C is dropped.

### 2.4 ISCHEMIA (A fails on public data)

`REGION4` only (V). Ikemura used 6 regions, which the public data cannot reproduce. Ikemura: "initial invasive management was associated with a consistent health status benefit across regions, with modest regional variability". The `_TRUNC` suffix on age/BMI/eGFR/weight is not explained in the dictionary I read (`IAGE_ENR_TRUNC` is labelled "Integer Age at Enrollment", so integer truncation is plausible; the others are unconfirmed). Check in the data whether discretisation or top-coding affects tails before using W1.

### 2.5 Firm negatives

CRASH-2 dictionary (V) variable list: `ientryid isource trandomised ioutcomeid isex iage ninjurytime iinjurytype isbp irr icc ihr igcseye igcsmotor igcsverbal igcs ... iboxid ipacknum`; no country. WOMAN user guide (V): "This include dates, site and country information" were removed.

## 3. Ranked shortlist (top 5)

1. IST-3 (+ Emberson 2014 for L): only candidate with country plus a literature-documented continuous EM of treatment effect (delay) plus age/SBP/NIHSS, recruited from 2000. Needs a DUA application and a per-country N check.
2. IST-1: tier 1, real countries, 24 countries with n>=100 verified; fixes anonymisation and SBP=0. Old era, no regional TE heterogeneity.
3. TOPCAT: documented large regional outcome difference and large baseline differences, `country` variable; heterogeneity partly explained by drug exposure, so L stays illustrative; tier 3 and BioLINCC policy risk.
4. ISCHEMIA: 5,179 pts, post-2010, BP/BMI/eGFR; only `REGION4`, regional effect consistent. Usable as a "baseline differs, effect consistent" contrast; weakest on A.
5. Gateway to Global Aging / NHANES + KNHANES (non-trial fallback): tier 1-2, covers the distance half of the method only; SBP/BMI codebooks unchecked.

Not recommended: CRASH-2, WOMAN (no country); Project Data Sphere (comparator arms only); PLATO (Mahaffey 2011 [10.1161/CIRCULATIONAHA.111.047498](https://doi.org/10.1161/CIRCULATIONAHA.111.047498): "only aspirin dose explained a substantial fraction of the regional interaction" and "chance alone cannot be ruled out"; a co-treatment, not a baseline continuous EM; IPD availability UNV).

## 4. ICH E17 / MRCT literature check

### 4.1 Matsushima 2024 (original PDF read: knowledge/pdfs/Matsushima_2024.pdf)

Matsushima N et al. (2024) "Summary Report of a Public Workshop: Case Studies of Multi-Regional Clinical Trial Incorporating Concept of the ICH E17 Guideline" *Clin Pharmacol Ther* 115(5):965-970. DOI: [10.1002/cpt.3163](https://doi.org/10.1002/cpt.3163).

Supports "a regional difference in binary EM distribution was observed" (PREVENT, nr-axSpA): "The characteristics of the participants in region 1, including Japan, showed a lower proportion of CRP+ patients and a higher proportion of MRI+ patients. The treatment difference in region 1 was smaller than that in the overall population."

Does not support "the Japanese inconsistency is explained by the EM imbalance": "The inconsistent results observed in the Japanese subpopulation could be due to an imbalance in treatment assignment and a small sample size (2 participants in the secukinumab arm and 7 in the placebo arm), but not due to potential effect modifiers."

KB discrepancy (not edited): `knowledge/summaries/Matsushima_2024.md` Case 1 says "Japan inconsistency driven partly by imbalance in CRP+/MRI- participants" and "After accounting for effect modifiers, ASAS40 response rates became consistent". The PDF text I read attributes the lower-CRP+/higher-MRI+ profile to region 1 (Japan among others) and attributes the Japan-specific inconsistency to assignment imbalance and small n. The trial is PREVENT, not "ASAS studies". The summary also lacks a "What this paper does NOT say" section. For Mike/Donna to decide.

IPD: PREVENT is a Novartis trial; the route is [推測] Vivli/CSDR, UNV. EMs are binary, so continuous-EM W1 does not apply.

### 4.2 Not covered

MERIT-HF, CHARM, BEAUTIFUL and any FDA/PMDA review were not individually searched; a general PubMed query on "regional heterogeneity ... explained by baseline ... effect modifier distribution" returned 0 hits. The brief's "secukinumab CRP/MRI" example was not named in the PubMed abstract; it is confirmed only in the PDF body (4.1).

## 5. Open items (not done)

1. IST-3: per-country N and `treatdelay` distributions need the IPD under the DUA; ask Edinburgh whether "no application needed" applies.
2. TOPCAT: read COUNTRYF format labels (SAS format catalogue, not in the dictionary PDF) and check for a height variable.
3. Gateway / STEPS: open harmonised codebooks and search for systolic / BMI.
4. CRASH-3, HF-ACTION, PEACE: read dictionaries once pages are reachable.
5. Dryad / Zenodo deposits of multinational RCT IPD, VISTA, Novartis/AZ/BI portals: not searched.
6. Decision for Tak (via /decide): is a case with C-by-conduct (TOPCAT) or with no regional heterogeneity (IST-1/IST-3) acceptable under "quantify, do not decide"?

## 6. Search log

Date 2026-10-12. Rachel. Knowledge base first: `knowledge/INDEX.md` grep for TOPCAT|ISCHEMIA|CRASH|IST-3|PLATO|MERIT = 0 hits; `knowledge/` grep for Matsushima|cpt.3163 = INDEX.md, pdfs/Matsushima_2024.pdf, summaries/Matsushima_2024.md, summaries/Deodhar_2020.md, summaries/ICH_E17_JP_workshops_pooling_review.md.

| Database | Verbatim query | Hits | Decision |
|---|---|---|---|
| PubMed | Pfeffer regional variation in patients and outcomes in the Treatment of Preserved Cardiac Function Heart Failure With an Aldosterone Antagonist (TOPCAT) trial | 1 (25406305) | included |
| PubMed | Matsushima multiregional clinical trial consistency secukinumab Japan effect modifier | 0 | too narrow; found by web search (38251824) |
| PubMed | Mahaffey ticagrelor effects on regional interaction PLATO aspirin maintenance dose Circulation 2011 | 1 (21709065) | included |
| PubMed | ISCHEMIA trial regional differences baseline characteristics outcomes by region (from 2019) | 227, 8 returned | not screened |
| PubMed | regional heterogeneity treatment effect multiregional trial explained by differences in baseline characteristics effect modifier distribution (from 2015) | 0 | gap not closed |
| PubMed | ISCHEMIA trial invasive versus conservative strategy by geographic region 37 countries | 0 | replaced by next |
| PubMed | International Variation in Health Status Benefits in Patients Undergoing Initial Invasive Versus Conservative Management for Chronic Coronary Disease ISCHEMIA | 1 (39301726) | included |
| PubMed | CRASH-2 tranexamic acid country income heterogeneity treatment effect by country individual patient data | 2 (33172504; 23782457) | first included |
| PubMed | TOPCAT Americas Russia Georgia spironolactone event rates differences baseline characteristics explain regional placebo event rate | 0 | replaced by next |
| PubMed | de Denus spironolactone metabolites TOPCAT new insights into regional variation | 1 (28445660) | included |
| PubMed | Emberson effect of treatment delay, age, and stroke severity on the effects of intravenous thrombolysis with alteplase Lancet 2014 | 1 (25106063) | included |
| PubMed | Sandercock third International Stroke Trial IST-3 thrombolysis alteplase within 6 h randomised controlled trial Lancet 2012 | 1 (22632908) | included |
| WebSearch | International Stroke Trial 3 IST-3 dataset Edinburgh DataShare DOI 10.7488/ds | 10 | included |
| WebSearch | freeBIRD LSHTM CRASH-2 CRASH-3 WOMAN trial data sharing registration individual patient data | 10 | partial; freeBIRD blocked |
| WebSearch | CRASH-2 trial individual patient data freeBIRD countries 40 variables country systolic blood pressure age tranexamic acid | 9 | superseded by Data Compass dictionary |
| WebSearch | IST-3 alteplase heterogeneity by country region treatment effect subgroup analysis age Lancet 2012 Sandercock | 9 | no country interaction found |
| WebSearch | ISCHEMIA trial regional differences enrolment countries North America Europe Latin America Asia outcomes BioLINCC dataset country variable | 10 | counts only |
| WebSearch | CRASH-3 tranexamic acid head injury trial 175 hospitals 29 countries individual patient data freeBIRD country variable data dictionary | 10 | design facts only |
| WebSearch | Matsushima secukinumab regional inconsistency Japan multiregional trial effect modifier CRP MRI baseline distribution ICH E17 | 9 | led to 38251824 |
| WebSearch | regional heterogeneity treatment effect multiregional clinical trial explained by baseline covariate distribution differences PLATO aspirin dose US interaction | 9 | PLATO included |
| WebSearch | Gateway to Global Aging Data harmonized HRS ELSA SHARE CHARLS JSTAR download registration systolic blood pressure BMI measured | 10 | access only |
| WebSearch | Matsushima 2024 regional differences treatment effect multi-regional clinical trial secukinumab axial spondyloarthritis CRP MRI Japan consistency assessment | 9 | DOI 10.1002/cpt.3163 |
| WebSearch | IST-3 trial 3035 patients 156 hospitals 12 countries treatment effect by country UK Poland Australia heterogeneity | 9 | no country-level TE |
| WebSearch | Project Data Sphere oncology phase 3 trials patient-level data access registration free countries variable | 9 | comparator arms only |
| WebSearch | Vivli data request process academic researchers free multinational trials country variable anonymised IPD; YODA Project data access J&J | 9 | process only |
| WebSearch | datacompass.lshtm.ac.uk CRASH-2 trial dataset tranexamic acid trauma 20,211 data sharing agreement | 9 | record + dictionary found |
| WebSearch | CRASH-3 data sharing LSHTM freeBIRD dataset DOI 10.17037/DATA individual patient data traumatic brain injury | 10 | registration required; no dictionary |
| WebSearch | KNHANES NHANES CHNS CHARLS download free public use blood pressure BMI measured; WHO STEPS microdata access request | 9 | NHANES/KNHANES only |
| WebSearch | International Stroke Trial IST 1997 Lancet 19435 patients 467 hospitals 36 countries | 10 | confirmed (also by CSV count) |
| WebSearch | Vivli PLATO ticagrelor OR PARADIGM-HF OR EMPA-REG OR RE-LY individual participant data available country variable | 9 | availability not found |
| WebSearch | WHO STEPS survey microdata access request data sharing blood pressure measured BMI measured countries repository | 10 | included (S) |
| WebSearch | Gateway to Global Aging harmonized dataset variables systolic blood pressure measured BMI harmonized HRS CHARLS ELSA SHARE codebook | 10 | variables unverified |
| WebSearch | ISCHEMIA trial outcomes by region Seattle Angina Questionnaire 37 countries 6 regions invasive vs conservative JACC 2024 Circulation | 10 | Ikemura located |
| Direct fetch | BioLINCC study pages and dictionaries (topcat, ischemia, accord, peace; hf-action 404); Edinburgh DataShare 124 and 1931 plus bitstreams; Data Compass CRASH-2 dictionary; PMC5590224; freeBIRD pages 403 (Cloudflare) | - | see above |

Gap statement: "No verified candidate meets A+B+C+D together." Falsifier: any dataset with (i) country in the public or DUA file, (ii) a continuous baseline EM, (iii) a publication attributing a regional TE difference to that EM's distribution.

## 7. References

- Pfeffer MA et al. (2015) "Regional variation in patients and outcomes in the Treatment of Preserved Cardiac Function Heart Failure With an Aldosterone Antagonist (TOPCAT) trial" *Circulation* 131(1):34-42. DOI: [10.1161/CIRCULATIONAHA.114.013255](https://doi.org/10.1161/CIRCULATIONAHA.114.013255)
- de Denus S et al. (2017) "Spironolactone Metabolites in TOPCAT - New Insights into Regional Variation" *N Engl J Med* 376(17):1690-1692. DOI: [10.1056/NEJMc1612601](https://doi.org/10.1056/NEJMc1612601)
- Sandercock P et al. (2012) "The benefits and harms of intravenous thrombolysis with recombinant tissue plasminogen activator within 6 h of acute ischaemic stroke (the third international stroke trial [IST-3]): a randomised controlled trial" *Lancet* 379(9834):2352-63. DOI: [10.1016/S0140-6736(12)60768-5](https://doi.org/10.1016/S0140-6736(12)60768-5)
- Emberson J et al. (2014) "Effect of treatment delay, age, and stroke severity on the effects of intravenous thrombolysis with alteplase for acute ischaemic stroke: a meta-analysis of individual patient data from randomised trials" *Lancet* 384(9958):1929-35. DOI: [10.1016/S0140-6736(14)60584-5](https://doi.org/10.1016/S0140-6736(14)60584-5)
- Ikemura N et al. (2024) "International Variation in Health Status Benefits in Patients Undergoing Initial Invasive Versus Conservative Management for Chronic Coronary Disease: Insights From the ISCHEMIA Trial" *Circ Cardiovasc Qual Outcomes* 17(10):e010534. DOI: [10.1161/CIRCOUTCOMES.123.010534](https://doi.org/10.1161/CIRCOUTCOMES.123.010534)
- Mahaffey KW et al. (2011) "Ticagrelor compared with clopidogrel by geographic region in the Platelet Inhibition and Patient Outcomes (PLATO) trial" *Circulation* 124(5):544-54. DOI: [10.1161/CIRCULATIONAHA.111.047498](https://doi.org/10.1161/CIRCULATIONAHA.111.047498)
- Matsushima N et al. (2024) *Clin Pharmacol Ther* 115(5):965-970. DOI: [10.1002/cpt.3163](https://doi.org/10.1002/cpt.3163)
- Brenner A et al. (2020) "Understanding the neuroprotective effect of tranexamic acid: an exploratory analysis of the CRASH-3 randomised trial" *Crit Care* 24(1):560. DOI: [10.1186/s13054-020-03243-4](https://doi.org/10.1186/s13054-020-03243-4)
- IST-1 dataset, "International Stroke Trial database (version 2)", Edinburgh DataShare. DOI: [10.7488/ds/104](https://doi.org/10.7488/ds/104)
- IST-3 dataset, "The third International Stroke Trial (IST-3), 2000-2015", Edinburgh DataShare. DOI: [10.7488/ds/1350](https://doi.org/10.7488/ds/1350)
- CRASH-2 dataset, LSHTM Data Compass. DOI 10.17037/DATA.10 (as shown on the record page; resolver not tested)
- IST Collaborative Group (1997) *Lancet* 349:1569-81. DOI 🔍 not retrieved in this session (PMID 9174558 appeared in a search result; DOI not verified).

---

## Lab addendum (2026-10-12 10:50, Donna / Mike / Harvey) — exploratory, outside any protocol

### Falsifier check on shortlist #1 (IST-3, treatment delay), data on disk `data/IST3/ist3_full_vars.csv`

Countries with n ≥ 100 (OTHER excluded), `treatdelay` in hours, W₁ against UK as anchor (exact CDF-area form, no bootstrap; scratch script `ist3_delay.R`, not a result):

| country | n | mean (h) | SD | median | W₁ vs UK (h) | age mean (SD) |
|---|---|---|---|---|---|---|
| UK | 1,447 | 4.1 | 1.2 | 4.10 | 0.0 | 78.0 (12.2) |
| Italy | 326 | 4.2 | 1.1 | 4.22 | 0.2 | 75.9 (12.2) |
| Norway | 204 | 4.3 | 1.8 | 4.18 | 0.3 | 76.1 (10.3) |
| Sweden | 297 | 3.8 | 1.3 | 3.65 | 0.3 | 81.0 (10.7) |
| Poland | 347 | 4.6 | 1.2 | 4.80 | 0.5 | 73.7 (13.1) |
| Australia | 179 | 4.6 | 1.1 | 4.75 | 0.6 | 74.7 (13.1) |

Reading: the eligibility window (≤ 6 h) homogenises delay, as PROTOCOL_real_data_survey §2 anticipated for trial IPD; between-country W₁ on delay is at most 0.6 h. Age differs more (Sweden vs Poland ≈ 7 years in means). Only 6 regions reach n ≥ 100 (GUSTO-I: 15 partners).

### Previously verified on disk (this session)
- IST-1 `data/IST/IST_corrected.csv`: N = 19,435; 36 country codes; **24 with n ≥ 100**; continuous EMs AGE / RSBP / RDELAY. Tier 1 (ODC-By).
- GUSTO-I dependency of the current manuscript: 35 of 153 registry keys, 8 R scripts (`R/gusto_*.R`, `application_all_methods.R`, `verify_study1_app_numbers.R`), 4 generated tables, Fig 3, §4 text, Discussion ¶2–¶4 sentences (R2/R9 contrast, Spearman age vs SBP, W₁ vs SMD agreement).

### Decision history (for the record)
- 2026-03-05/06: 20+ trial survey (`archives/cleanup_20260719/sim_paper/public_IPD_datasets_report.md`); IST-1 ranked ★1; TOPCAT / PLATO flagged as reserves.
- 2026-04-10 (Tak): IST → GUSTO-I. Reason recorded in SUITS: "IST はアンカー国を設定する動機が不自然だ。GUSTO は地域が匿名化されている — Region 13 をアンカーにして他 15 地域を評価する設定が自然に成立する".
- Matsushima 2024: Rachel's read of the original PDF differs from `knowledge/summaries/Matsushima_2024.md` and possibly from the Intro sentence citing it (manuscript l.75, "regional imbalance in CRP-positive/MRI-negative status contributed to apparent inconsistency") — 🔍 `/cite-check` item, not resolved here.

### Options for Tak (no decision taken; Harvey's view attached)
| | Option | Gains over GUSTO-I | Costs / risks |
|---|---|---|---|
| A | Keep GUSTO-I | — | Anonymised regions, 1990s, illustrative L (all already disclosed in §4.1 / §5) |
| B | Replace with IST-3 (on disk) | Real country names; 2000–2011; delay EM has a literature slope (Emberson 2014) so L is sourced, not illustrative | Only 6 regions ≥ 100; delay W₁ ≤ 0.6 h (homogenised by eligibility); DUA status unresolved (DataShare page says no application, DUA v2.1 says proposal); re-do of §4 + Discussion sentences, 35 registry keys, 8 scripts, referee pass on §4 void |
| C | Replace with IST-1 (on disk, tier 1) | Real country names; 24 regions; no SBP = 0 artefact | 1991–96; L illustrative as now; same re-do cost as B |
| D | Apply for TOPCAT (BioLINCC) | Textbook regional discrepancy, country variable, SBP / eGFR / BMI | Months; BioLINCC "under review" notice; discrepancy partly conduct (canrenone 30 % vs 3 %), which invites the effect-tracking question the paper deliberately does not ask (`memory/project_no_effect_tracking_sim.md`) |
| E | GUSTO-I main + IST-3 delay as second illustration | Sourced L shown once | Two-dataset problem (Louis, 2026-04) and no-supplement rule (Tak, 09-27) |

Harvey's view: the search did not find a dataset that is better on the criterion that matters for A3 (a sourced clinical slope on a continuous EM with real regions and obtainable IPD). B is the only candidate that moves A3, and its delay distances are small. Recommendation: A for this submission, with IST-3 (delay) held as the reviewer-response reserve and TOPCAT stocked as a follow-up idea. Tak decides (`/decide`).

---

## Addendum 2 (2026-10-12 11:15, Donna) — RCT Bench (Tak: 「RCT bench って使えない？」)

Source: https://bingkaiwang.github.io/RCT_Bench-main/website/ (fetched); `meta_data.xlsx`, `data-dictionary.xlsx`, `rct_bench_all_data_and_dictionaries.zip` (3.9 MB) downloaded and parsed (V). Methods paper: Shao, Lyu, Yu & Wang (2026) *J Clin Epidemiol* 112374 — DOI 🔍 not on the page.

- **What it is**: "Participant-level randomized trial benchmark" for evaluating **covariate-adjustment** methods. 125 individually randomized trials as cleaned CSV/RDS with `Treatment`, `YP_*`, `YS_*`, `X_*` columns. Direct download, no application (licence not stated on the page; users are asked to cite each trial's primary publication).
- **Size**: sample size median 119, IQR 57–293, max 6,030. 15 research areas (Cardiovascular Medicine: 5 trials). None of IST / GUSTO / CRASH / TOPCAT / ISCHEMIA / SPRINT / ACCORD is in it.
- **Geography**: among 2,913 dictionary rows, 22 baseline covariates refer to hospital / centre / site / region; **only one trial carries a country variable**: Trial 9 = Release Study (umbilical vein oxytocin for retained placenta; Weeks et al. 2010 *Lancet*, DOI 10.1016/S0140-6736(09)61752-9), N = 577, `X_country_0d` = UK 361 / Uganda 190 / Pakistan 26; continuous baseline covariates age, pulse, SBP, DBP, birth weight, gestation weeks, Hb. Two regions reach n ≥ 100.
- **Verdict**: fails criterion A (≥ 4 regions with n ≥ 100 and real names) for every trial but one, and that one has 2 usable regions; no documented EM-driven regional heterogeneity (C). Not a replacement for GUSTO-I. Possible other use (outside this paper): a pool of small two-arm trials for covariate-adjustment benchmarking — not our Question.

---

## Addendum 3 (2026-10-12 11:20) — Tak drops the per-region n ≥ 100 requirement

Tak (verbatim): 「要件として 各 n >= 100は外していい。現実的にはそこまでのデータがないことがほとんどなので。」

Criterion A becomes: IPD with a real country / region label, ≥ 4 regions, **no sample-size floor**. Re-count on disk (V):

| Dataset | regions (all) | of which n ≥ 100 | 30–99 | < 30 | notes |
|---|---|---|---|---|---|
| GUSTO-I | 16 (anonymised) | 16 (min 1,231) | 0 | 0 | current case |
| IST-1 | **36 named** | 24 | 8 | 4 | includes USA 131, Canada 117, Hong Kong 115, Singapore 140, India 229, **Japan 9**, France 2 |
| IST-3 | 8 named (+ "Other" 80) | 6 | 2 (Portugal 82, Belgium 73) | 0 | delay EM with Emberson 2014 slope |
| TOPCAT (BioLINCC) | 6 (US, Canada, Brazil, Argentina, Russia, Georgia) | [推測] all | | | tier 3; conduct confound |
| RCT Bench Trial 9 | 3 (UK 361, Uganda 190, Pakistan 26) | 2 | 0 | 1 | < 4 regions; obstetric |

What changes: nothing in the ranking. The binding constraints were never n — they are (i) whether a country variable survives anonymisation (CRASH-2, WOMAN, ISCHEMIA, Vivli-standard releases: no) and (ii) criterion C (a documented EM-driven regional heterogeneity), which no obtainable dataset meets. IST-1 gains the most from the relaxation: 36 named countries, including small ones (Japan 9) whose intervals would be read against the null floor — the situation the paper's §4.2 machinery was built for ("for a distance at or below the null floor the interval is read at its upper limit whatever the sample size"). Under the relaxed A, IST-1 is the strongest *real-name* alternative on disk; it still lacks C and is 1991–96.

Open consequence for the lab (not decided): the paper's Study 2 statement "n ≥ 100 per region for true distances of at least 0.4 SD" is an estimation criterion, not an eligibility rule — consistent with Tak's remark — and the real-data survey protocol's n ≥ 100 inclusion rule (`PROTOCOL_real_data_survey.md` §3) was a survey choice, not a method requirement.
