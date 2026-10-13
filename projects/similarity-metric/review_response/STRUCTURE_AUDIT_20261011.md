# Structure audit — per_em_W1_wiley.tex

structure_audit: per_em_W1_wiley.tex — main text 9160 words (1.5× venue upper), abstract 246/250, floats 14 (0 placement issues), evidence-outside-Results paragraphs 1, duplicate sentence pairs 0, sections over budget 4

## 1. Word budget — prose words per section (floats, captions, listings excluded; inline math = 1 word)

Venue profile: **Statistics in Medicine (research article)**

| Section | role | words | venue-typical | ratio |
|---|---|---:|---|---:|
| Introduction | introduction | 990 | 500–800 | 1.2× ⚠ |
| Methods | methods | 2474 | 1000–2000 | 1.2× ⚠ |
| Simulation Studies | results | 2672 | 1000–1500 | 1.8× ⚠ |
| Application: Hypothetical Thrombolytic MRCT Usin | results | 1333 | 1000–1500 | 0.9× |
| Discussion | discussion | 1691 | 600–1000 | 1.7× ⚠ |
| **Total (main text)** | | **9160** | 4000–6000 | 1.5× |

## 2. Abstract — 246 words (limit 250) ✅

## 3. Float placement — first citation vs definition

| float | label | defined L | first \ref L | drift | status |
|---|---|---:|---:|---:|---|
| figure | fig:nabcd_definition | 140 | 138 | -2 | ✅ |
| figure | fig:study2_auc | 275 | 271 | -4 | ✅ |
| table | tab:study2_required_n | 288 | 285 | -3 | ✅ |
| table | tab:study2_required_n_mc | 298 | 266 | -32 | ✅ |
| table | tab:scenarios | 334 | 332 | -2 | ✅ |
| table | tab:bias | 369 | 367 | -2 | ✅ |
| figure | fig:simulation | 380 | 361 | -19 | ✅ |
| table | tab:coverage | 393 | 361 | -32 | ✅ |
| table | tab:precision | 406 | 404 | -2 | ✅ |
| table | tab:gusto_r8 | 450 | 448 | -2 | ✅ |
| table | tab:operability | 464 | 462 | -2 | ✅ |
| table | tab:gusto_nabcd | 483 | 476 | -7 | ✅ |
| figure | fig:gusto_forest | 492 | 481 | -11 | ✅ |
| table | tab:gusto_lstar_joint | 522 | 518 | -4 | ✅ |

## 4. Evidence placement — numeric tokens per paragraph (threshold outside Results: 6)

Paragraphs analysed: 81; numeric tokens per paragraph mean 3.1, SD 4.1.

Paragraphs in Introduction / Discussion carrying more numbers than the threshold (evidence outside Results?):

| section | L | numbers | words | opens with |
|---|---:|---:|---:|---|
| Discussion | 540 | 7 | 352 | Section set out the limitations of the existing measures: SMD captures… |

Densest five paragraphs overall (for reference):

| section | L | numbers | words |
|---|---:|---:|---:|
| Selection: Required Sample Siz | 288 | 19 | 161 |
| Selection: Required Sample Siz | 284 | 17 | 222 |
| Design | 257 | 15 | 202 |
| Design | 333 | 11 | 160 |
| Distributional Assessment: Per | 484 | 11 | 127 |

## 5. Duplication — sentence pairs in different sections with content-word Jaccard ≥ 0.6

None ✅

## 6. Supplements — letters cited in the text vs files on disk

No supplement letters cited.
Files beside the manuscript: supplement_L_clinical_lit.md, supplement_normalizer_comparison.tex, supplement_path_alpha.pdf, supplement_path_alpha.tex, supplement_real_data_survey.pdf, supplement_real_data_survey.tex
