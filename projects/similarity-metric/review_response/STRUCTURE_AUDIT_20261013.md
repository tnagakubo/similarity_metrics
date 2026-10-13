# Structure audit — per_em_W1_wiley.tex

structure_audit: per_em_W1_wiley.tex — main text 11097 words (1.8× venue upper), abstract 250/250, floats 15 (0 placement issues), evidence-outside-Results paragraphs 3, duplicate sentence pairs 0, sections over budget 5

## 1. Word budget — prose words per section (floats, captions, listings excluded; inline math = 1 word)

Venue profile: **Statistics in Medicine (research article)**

| Section | role | words | venue-typical | ratio |
|---|---|---:|---|---:|
| Introduction | introduction | 1246 | 500–800 | 1.6× ⚠ |
| Methods | methods | 3173 | 1000–2000 | 1.6× ⚠ |
| Simulation Studies | results | 3253 | 1000–1500 | 2.2× ⚠ |
| Application: Hypothetical Thrombolytic MRCT Usin | results | 1658 | 1000–1500 | 1.1× ⚠ |
| Discussion | discussion | 1767 | 600–1000 | 1.8× ⚠ |
| **Total (main text)** | | **11097** | 4000–6000 | 1.8× |

## 2. Abstract — 250 words (limit 250) ✅

## 3. Float placement — first citation vs definition

| float | label | defined L | first \ref L | drift | status |
|---|---|---:|---:|---:|---|
| figure | fig:nabcd_definition | 150 | 148 | -2 | ✅ |
| figure | fig:study2_auc | 310 | 304 | -6 | ✅ |
| table | tab:study2_required_n_mc | 328 | 297 | -31 | ✅ |
| table | tab:scenarios | 369 | 367 | -2 | ✅ |
| table | tab:bias | 407 | 405 | -2 | ✅ |
| figure | fig:simulation | 421 | 418 | -3 | ✅ |
| table | tab:coverage | 441 | 428 | -13 | ✅ |
| table | tab:study2_intervals | 451 | 428 | -23 | ✅ |
| table | tab:study2_ext | 463 | 461 | -2 | ✅ |
| table | tab:precision | 477 | 475 | -2 | ✅ |
| table | tab:gusto_r8 | 525 | 522 | -3 | ✅ |
| table | tab:operability | 541 | 538 | -3 | ✅ |
| table | tab:gusto_nabcd | 565 | 555 | -10 | ✅ |
| figure | fig:gusto_forest | 575 | 563 | -12 | ✅ |
| table | tab:gusto_lstar_joint | 607 | 602 | -5 | ✅ |

## 4. Evidence placement — numeric tokens per paragraph (threshold outside Results: 6)

Paragraphs analysed: 87; numeric tokens per paragraph mean 4.5, SD 7.1.

Paragraphs in Introduction / Discussion carrying more numbers than the threshold (evidence outside Results?):

| section | L | numbers | words | opens with |
|---|---:|---:|---:|---|
| Discussion | 627 | 21 | 392 | Of the limitations set out in Section , the location-only limitation o… |
| Discussion | 619 | 14 | 232 | This paper answers the requirements set out in Section and characteriz… |
| Discussion | 623 | 8 | 109 | These implications also bear on the cluster analysis of regions that K… |

Densest five paragraphs overall (for reference):

| section | L | numbers | words |
|---|---:|---:|---:|
| Selection: Required Sample Siz | 319 | 44 | 338 |
| Results | 416 | 29 | 197 |
| Scenario Design and Effect Mod | 519 | 22 | 211 |
| Discussion | 627 | 21 | 392 |
| Design | 284 | 17 | 288 |

## 5. Duplication — sentence pairs in different sections with content-word Jaccard ≥ 0.6

None ✅

## 6. Supplements — letters cited in the text vs files on disk

No supplement letters cited.
Files beside the manuscript: supplement_L_clinical_lit.md, supplement_normalizer_comparison.tex, supplement_path_alpha.pdf, supplement_path_alpha.tex, supplement_real_data_survey.pdf, supplement_real_data_survey.tex
