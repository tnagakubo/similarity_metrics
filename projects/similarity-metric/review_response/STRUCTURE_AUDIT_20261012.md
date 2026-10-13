# Structure audit — per_em_W1_wiley.tex

structure_audit: per_em_W1_wiley.tex — main text 10473 words (1.7× venue upper), abstract 248/250, floats 14 (0 placement issues), evidence-outside-Results paragraphs 3, duplicate sentence pairs 0, sections over budget 5

## 1. Word budget — prose words per section (floats, captions, listings excluded; inline math = 1 word)

Venue profile: **Statistics in Medicine (research article)**

| Section | role | words | venue-typical | ratio |
|---|---|---:|---|---:|
| Introduction | introduction | 1225 | 500–800 | 1.5× ⚠ |
| Methods | methods | 3121 | 1000–2000 | 1.6× ⚠ |
| Simulation Studies | results | 2781 | 1000–1500 | 1.9× ⚠ |
| Application: Hypothetical Thrombolytic MRCT Usin | results | 1622 | 1000–1500 | 1.1× ⚠ |
| Discussion | discussion | 1724 | 600–1000 | 1.7× ⚠ |
| **Total (main text)** | | **10473** | 4000–6000 | 1.7× |

## 2. Abstract — 248 words (limit 250) ✅

## 3. Float placement — first citation vs definition

| float | label | defined L | first \ref L | drift | status |
|---|---|---:|---:|---:|---|
| figure | fig:nabcd_definition | 150 | 148 | -2 | ✅ |
| figure | fig:study2_auc | 310 | 304 | -6 | ✅ |
| table | tab:study2_required_n_mc | 327 | 297 | -30 | ✅ |
| table | tab:scenarios | 368 | 366 | -2 | ✅ |
| table | tab:bias | 406 | 404 | -2 | ✅ |
| figure | fig:simulation | 420 | 417 | -3 | ✅ |
| table | tab:study2_intervals | 439 | 427 | -12 | ✅ |
| table | tab:coverage | 448 | 427 | -21 | ✅ |
| table | tab:precision | 463 | 461 | -2 | ✅ |
| table | tab:gusto_r8 | 511 | 508 | -3 | ✅ |
| table | tab:operability | 527 | 524 | -3 | ✅ |
| table | tab:gusto_nabcd | 550 | 541 | -9 | ✅ |
| figure | fig:gusto_forest | 560 | 548 | -12 | ✅ |
| table | tab:gusto_lstar_joint | 592 | 587 | -5 | ✅ |

## 4. Evidence placement — numeric tokens per paragraph (threshold outside Results: 6)

Paragraphs analysed: 84; numeric tokens per paragraph mean 3.9, SD 6.5.

Paragraphs in Introduction / Discussion carrying more numbers than the threshold (evidence outside Results?):

| section | L | numbers | words | opens with |
|---|---:|---:|---:|---|
| Discussion | 612 | 21 | 390 | Of the limitations set out in Section , the location-only limitation o… |
| Discussion | 604 | 14 | 232 | This paper answers the requirements set out in Section and characteriz… |
| Discussion | 608 | 8 | 109 | These implications also bear on the cluster analysis of regions that K… |

Densest five paragraphs overall (for reference):

| section | L | numbers | words |
|---|---:|---:|---:|
| Selection: Required Sample Siz | 319 | 44 | 329 |
| Discussion | 612 | 21 | 390 |
| Scenario Design and Effect Mod | 505 | 20 | 190 |
| Design | 284 | 17 | 288 |
| Results | 407 | 15 | 146 |

## 5. Duplication — sentence pairs in different sections with content-word Jaccard ≥ 0.6

None ✅

## 6. Supplements — letters cited in the text vs files on disk

No supplement letters cited.
Files beside the manuscript: supplement_L_clinical_lit.md, supplement_normalizer_comparison.tex, supplement_path_alpha.pdf, supplement_path_alpha.tex, supplement_real_data_survey.pdf, supplement_real_data_survey.tex
