# LITERATURE_SEARCH_LOG - similarity-metric

**Owner**: Rachel. Append-only. Rule 2.6: DOI for every included paper. KB searched first.

## 1. Search log

| date | database | query (verbatim) | filters | hits | screened | included | excluded (reason) | by |
|---|---|---|---|---|---|---|---|---|
| 2026-10-12 | KB (`knowledge/pdfs/Song_2025.pdf`, pdftotext + grep) | `PREVENT\|cluster\|pooling\|distance` | -- | p.362 passage | read in full | song2025 (cluster analysis on EM-endpoint correlation distances; no distance defined or evaluated) | -- | Rachel |
| 2026-10-12 | KB (`knowledge/pdfs/e639.txt` = Singh 2024, DOI 10.1007/s43441-024-00639-0) | `similarity\|cluster\|distance\|wasserstein\|pooling` | -- | 17 pooling lines | pooling section read | not cited; no distance on EM distributions | -- | Rachel |
| 2026-10-12 | PubMed | `Predictors of 30-day mortality in the era of reperfusion for acute myocardial infarction 41,021 patients` | max 3 | 12 total; Lee 1995 not in the 3 returned | titles only | -- | irrelevant top hits | Rachel |
| 2026-10-12 | Web (arXiv) | fetch arxiv.org/pdf/1404.3763 | -- | Fang & Santos, arXiv v2 | read | fang2019 (arXiv v2 only) | -- | Rachel |
| 2026-10-12 | Web | `Andrews "Inconsistency of the bootstrap when a parameter is on the boundary of the parameter space" Cowles Foundation discussion paper pdf` | standard | no accessible full text; Cowles DP 1157 is a different paper | -- | -- | not used as substitute | Rachel |
| 2026-10-12 | Web (AHA journals) | fetch ahajournals.org/doi/10.1161/01.CIR.91.6.1659 | -- | HTTP 403 | -- | -- | not retrievable | Rachel |

## 3. Gap statement (as of 2026-10-12)

To our knowledge no distance between regional effect modifier distributions has been proposed and evaluated for pooling of regions in MRCTs. Evidence on disk: Song 2025 p.362, Komiyama Ch.4 s.4.6.1.1 and Singh 2024 describe correlation-weighted distances on representative values, or pooling at principle level, only.

**Falsifier**: a peer-reviewed paper (or Matsushima 2024 Data S1/Table S1 for PREVENT) that defines a distance on the full distributions of an effect modifier across regions and reports an evaluation of it. Matsushima Data S1 is not yet read (Paper Request #2 in `review_response/CITATION_AUDIT_20261012.md`).

## 4. Over-reading guard

| source | claim we draw | verbatim (page) | what the source does NOT say |
|---|---|---|---|
| Song 2025 | pooling strategy ambiguous; cluster analysis on EM-endpoint-correlation distances | p.359 abstract; p.362 "The correlation between these EMs and endpoints can be used to define the distances between different populations." | no distance formula, no weighting, no evaluation, no Lasso; the PREVENT sentence cites Matsushima and gives no similarity measure |
| Komiyama Ch.4 | cluster analysis introduced as one approach on representative values; distance choice is a key decision | s.4.6.1 / 4.6.1.1 (md transcription, no pagination) | no evaluation, no comparison, not a recommended method; one representative value per EM |
| Matsushima 2024 | post hoc PREVENT pooling into five regions; Japanese inconsistency | p.966 Case 1 | does NOT attribute the Japanese inconsistency to effect modifiers ("but not due to potential effect modifiers") |

## 5. /ground entries, 2026-10-12 (Rachel; Paper Requests #1, #2 in `review_response/CITATION_AUDIT_20261012.md` section 4)

| task | database / query (verbatim) | result | verdict |
|---|---|---|---|
| Lee 1995 age gradient (ms l.231) | PubMed `lookup_article_by_citation` {Circulation, 1995, vol 91, p 1659, Lee} -> PMID 7882472; `get_article_metadata` 7882472. WebFetch ahajournals.org/doi/10.1161/01.CIR.91.6.1659 and /doi/pdf/... -> HTTP 403 | Abstract only (no table; not in PMC). Abstract verbatim: "age as the most significant factor influencing 30-day mortality, with rates of 1.1% in the youngest decile (< 45 years) and 20.5% in patients > 75". DOI 10.1161/01.cir.91.6.1659 confirmed. Age bands <65/65-74/>=75 NOT obtained. | OPEN for the 6e-3/yr figure (Request #1 stays open). Abstract-only arithmetic: 0.205-0.011 = 0.194 over an unspecified midpoint gap (open-ended bands); a 40-y gap gives 4.9e-3, 45-y gives 4.3e-3, 35-y gives 5.5e-3. So ~6e-3 does not follow from the abstract; [推測] only. Not a ledger source. |
| Matsushima Data S1/Table S1 | Europe PMC REST `DOI:"10.1002/cpt.3163"`: isOpenAccess N, inPMC N, hasSuppl N. WebFetch onlinelibrary.wiley.com/doi/10.1002/cpt.3163 -> HTTP 403. KB: `pdftotext Matsushima_2024.pdf` grep `Data S1\|Table S1\|similar distribution\|cluster` -> only p.965-966 sentence (l.121-122) | Supplement not retrievable; method of "similar distribution" unknown. Main text only: "countries with a similar distribution of effect modifiers were clustered into five pooled regions (Data S1, Table S1)". | OPEN (Request #2 stays open). Novelty claim status unchanged: "not contradicted by anything on disk", not "verified absent". |
| IST bib entry | PubMed `get_article_metadata` PMID 9174558; KB `knowledge/pdfs/IST_1997.pdf` p.1 header | PubMed: Lancet 1997 May 31;349(9065):1569-81, title "...among 19435 patients...". PDF title and abstract: "19 435 patients". DOI 10.1016/S0140-6736(97)04011-7 (pii S0140673697040117) is consistent. | GROUNDED. Bib title says 19{,}185: wrong. Year 1997/vol/pages correct; key `ist1_2000` is only a misnomer. |

## 6. Positioning references for Proposition 1 (2026-10-12, Rachel; output `review_response/LIT_POSITIONING_20261012.md`; trigger: EXTERNAL_REVIEW_20261012 M1, M4)

| database | query (verbatim) | result | verdict |
|---|---|---|---|
| KB | `grep -il "tipton\|stuart\|dahabreh\|munk\|redko\|bickel" knowledge/summaries/* knowledge/INDEX.md` | Bickel-Freedman 1981, Bickel-Rosenblatt 1973, Sommerfeld & Munk 2018 (name matches only) | none of the nine on disk |
| Crossref | `works/<DOI>` for 10.1007/978-3-319-71246-8_45, 10.1609/aaai.v32i1.11784, 10.1111/j.1467-985X.2010.00673.x, 10.1002/sim.8426, 10.1198/016214508000000274 | titles, volume, pages match | DOIs confirmed |
| Crossref | recalled DOIs 10.3102/1076998613509405, 10.1111/1467-9868.00124, 10.1016/j.jeconom.2018.06.012 | resolved to Lockwood & McCaffrey, Aitkin, Chen & Wang (wrong papers) | rejected; bibliographic queries gave 10.3102/1076998614558486, 10.1111/1467-9868.00121, 10.1016/j.jeconom.2018.06.007 |
| Crossref | `query.bibliographic=Resampling fewer than n observations: gains, losses, and remedies for losses Bickel Gotze van Zwet` and `... Statistica Sinica 1997` | no DOI for the original; reprint 10.1007/978-1-4614-1314-1_17 | no DOI invented |
| arXiv | pdf 1610.04420 (Redko), 1707.01217 (Shen), 1805.00550 (Dahabreh) | Redko, Shen full text read; Dahabreh abstract page only | Redko, Shen GROUNDED (preprint) |
| Berkeley | stat.berkeley.edu/sites/default/files/tech-reports/419.pdf | BGvZ preprint, abstract + intro read | GROUNDED (preprint) |
| Europe PMC | `DOI:"10.1111/j.1467-985X.2010.00673.x"`, `DOI:"10.1002/sim.8426"` (resultType=core); Tipton, Munk-Czado, JASA 2008, Hong-Li DOIs: no record | abstracts for Stuart (PMC4051511), Dahabreh | ABSTRACT |
| PubMed | free-text title queries for Tipton, Stuart; `Dahabreh Extending inferences from a randomized trial to a new target population` | Tipton 0, Stuart 0, Dahabreh 3 (not opened) | not used |
| Web | `Tipton 2014 "How generalizable is your experiment" index comparing experimental samples populations Bhattacharyya coefficient abstract` | Crossref abstract; Bhattacharyya form only in Degtiar & Rose arXiv:2102.11904 (review) | Tipton ABSTRACT-ONLY |
| Web | fetch ideas.repec.org (Munk-Czado, Hong-Li); tandfonline, journals.sagepub (HTTP 403) | Munk-Czado abstract, Hong-Li abstract summary | ABSTRACT-ONLY |
| Web | `Alvarez-Esteban del Barrio Cuesta-Albertos Matran "Trimmed comparison of distributions" abstract impartial trimming Wasserstein` and a second query on tandfonline/researchgate/jstor | bibliographic data only | OPEN |

**Gap statement (positioning, as of 2026-10-12)**: the bound itself is not novel; Shen et al. 2018 eq. (13) is the same Kantorovich-Rubinstein step. The remaining claim, that W1 on effect-modifier distributions combined with a clinical slope L and its inversion L* has not been proposed for regional pooling in MRCTs, was not contradicted by the nine sources, but the generalizability / transportability literature was searched only through the reviewer's named works, not systematically. **Falsifier**: a paper that bounds a difference of population-average effects by L times a Wasserstein distance between covariate distributions of trial populations.
| PubMed (get_article_metadata) | PMID 8204123 (GUSTO 1993) and PMID 7882472 (Lee 1995), 2026-10-12 evening | abstracts: arms 7.2 / 7.4 / 6.3 / 7.0%; age bands 1.1% (<45) and 20.5% (>75) | Lee GROUNDED; GUSTO 7.3% INFERRED (not in abstract); see CITATION_AUDIT_20261012 sect. 6 |
