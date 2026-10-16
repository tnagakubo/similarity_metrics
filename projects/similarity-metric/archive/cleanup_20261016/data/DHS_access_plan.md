# Data Access Plan: DHS, HRS Family, and WHO STEPS

**Purpose**: Obtain multi-country individual-level biomarker data for the nABCD similarity metric paper.
**Target**: Demonstrate nABCD on real-world effect modifier distributions across regions.
**Date prepared**: 2026-03-10

---

## Part 1: DHS Program (dhsprogram.com)

### 1.1 Step-by-Step Registration

1. **Go to** https://dhsprogram.com/data/new-user-registration.cfm
   - Use a desktop/laptop browser (mobile not supported)
   - Do NOT use browser translation tools during registration

2. **Fill in user information** (all fields in English):
   - Email address (this becomes your username)
   - Password (8--15 characters)
   - First name, Last name
   - Organization: `International University of Health and Welfare` (full name, no acronyms)
   - Organization type: `University Faculty`
   - Country: `Japan`
   - Phone number with country code (+81)
   - Subscribe to newsletter + dataset alerts (recommended for tracking new releases)

3. **Create a project** (after account confirmation):
   - Project title (see Section 1.2 below)
   - Project description (see Section 1.2 below)
   - Co-researchers (optional)

4. **Select country datasets** to request:
   - Select all countries listed in Section 1.3 below
   - Access is granted per country -- approval covers all unrestricted survey datasets for that country

5. **Submit and wait**:
   - Review takes **24--48 hours** (Monday--Friday)
   - You will receive email notification of approval or a request for more information

6. **After approval**:
   - Log in at https://dhsprogram.com/data/dataset_admin/login_main.cfm
   - Select survey -> select dataset files -> download as ZIP
   - Use the **Download Manager** for bulk downloads across multiple surveys

### 1.2 Project Description (Tailored for nABCD Paper)

**Project Title:**
> Quantifying Effect Modifier Similarity Across Regions for Multi-Regional Clinical Trial Design

**Project Description (paste this):**
> This project develops and validates a statistical metric for quantifying the similarity of
> effect modifier distributions across geographic regions, with applications to multi-regional
> clinical trial (MRCT) design under ICH E17 guidelines. We use publicly available DHS survey
> data to obtain nationally representative distributions of key biomarkers (blood pressure,
> BMI, hemoglobin, anthropometric measures) across multiple countries. These distributions
> serve as real-world examples of how effect modifier profiles vary across regions, which is
> critical for decisions about regional pooling strategies in global drug development.
>
> The analysis is purely methodological -- we do not study health outcomes in DHS populations
> directly, but use the biomarker distributions to illustrate and validate our proposed
> similarity metric. Results will be published in a peer-reviewed statistics journal.
>
> Principal Investigator: [Tak's full name], International University of Health and Welfare, Japan.

### 1.3 Datasets to Request (Priority Order)

#### Tier 1: Asian Countries with Blood Pressure Data (highest priority)

| Country | Survey | Year | DHS Phase | BP Data | Notes |
|---------|--------|------|-----------|---------|-------|
| **India** | NFHS-5 | 2019--21 | DHS-VII | Yes | Largest sample; BP on women 15+ and men 15+ |
| **Bangladesh** | BDHS | 2017--18 | DHS-VII | Yes | BP + glucose on adults 18+ in 1/4 HH subsample |
| **Nepal** | NDHS | 2022 | DHS-VIII | Yes | BP on 15+; 96% women, 92% men measured |

#### Tier 2: Other Asian Countries (for regional diversity)

| Country | Survey | Year | DHS Phase | BP Data | Notes |
|---------|--------|------|-----------|---------|-------|
| **Indonesia** | IDHS | 2017 | DHS-VII | Limited | Check biomarker module availability |
| **Cambodia** | CDHS | 2021--22 | DHS-VIII | Check | Recent survey; verify BP module |
| **Philippines** | PDHS | 2022 | DHS-VIII | Check | Recent survey; verify BP module |
| **Myanmar** | MDHS | 2015--16 | DHS-VII | Check | May have BP data |

#### Tier 3: African Countries (for cross-region contrast)

| Country | Survey | Year | Notes |
|---------|--------|------|-------|
| **Nigeria** | NDHS | 2018 | Largest African DHS; likely has BP |
| **Kenya** | KDHS | 2022 | Recent, good quality |
| **Ethiopia** | EDHS | 2019 | Large sample |
| **Tanzania** | TDHS | 2022 | Recent |

#### Tier 4: Latin American Countries (additional contrast)

| Country | Survey | Year | Notes |
|---------|--------|------|-------|
| **Peru** | ENDES | 2021--22 | Continuous DHS; likely has BP |
| **Colombia** | CDHS | 2015--16 | Check for biomarker module |

### 1.4 File Types to Download

**Primary**: Individual Recode (IR) files -- one record per woman interviewed
- Contains demographic, anthropometric, and biomarker data
- File naming: `xxIR7yFL` where `xx` = country code, `7` = DHS-VII recode, `y` = release letter

**Also download**: Male Recode (MR) files for BP data on men
- File naming: `xxMR7yFL`

**Format**: Stata (.DTA) files
- Select "Stata dataset (.dta)" when downloading
- Directly readable in R via `haven::read_dta()`

### 1.5 Key Variable Names (DHS Standard Recode)

#### Always Available (IR file)
| Variable | Description | Notes |
|----------|-------------|-------|
| `v012` | Age (current, in years) | |
| `v437` | Weight (kg, 1 decimal) | Respondent's weight |
| `v438` | Height (cm, 1 decimal) | Respondent's height |
| `v445` | BMI | Body mass index (weight/height^2 x 100) |
| `v456` | Hemoglobin (adjusted for altitude) | g/dL x 10 |
| `v190` | Wealth index quintile | 1=poorest to 5=richest |
| `v025` | Type of residence | 1=urban, 2=rural |
| `v106` | Education level | 0=none, 1=primary, 2=secondary, 3=higher |
| `v024` | Region | Country-specific region code |

#### Blood Pressure Variables (country-specific, check recode map)
| Variable | Description | Notes |
|----------|-------------|-------|
| `sb16s` / `sb16d` | Systolic / Diastolic BP, 1st reading | Country-specific prefix may vary |
| `sb18s` / `sb18d` | Systolic / Diastolic BP, 2nd reading | |
| `sb20s` / `sb20d` | Systolic / Diastolic BP, 3rd reading | |

**Important**: BP variable names are NOT fully standardized across countries. After downloading:
1. Open the `.DO` (Stata do-file) or `.MAP` file included in the ZIP
2. Search for "blood pressure" or "systolic" to find exact variable names
3. The convention is typically 3 readings; use average of readings 2 and 3

### 1.6 Alternative: IPUMS-DHS (idhsdata.org)

**Advantage**: Harmonized variable names across all countries and survey years.
**Disadvantage**: Requires DHS Program registration first (same login); may not include all biomarker variables; currently not reviewing new user applications.

**Process**:
1. First register at dhsprogram.com (same as above)
2. After DHS approval, log in at https://www.idhsdata.org using DHS credentials
3. Select samples (countries/years) -> select variables -> create extract -> download

**Key IPUMS-DHS harmonized variable names**:
| Variable | Description |
|----------|-------------|
| `BMIRESPONDENT` | BMI of respondent |
| `HEIGHTRESPONDENT` | Height in cm |
| `WEIGHTRESPONDENT` | Weight in kg |
| `HEMESSION` | Hemoglobin level |
| `AGE` | Age in years |
| `WEALTHQ` | Wealth quintile |

**Note**: IPUMS-DHS may not yet include BP variables in their harmonized set. Check availability after login. If BP is not harmonized, use direct DHS files for BP and IPUMS for other variables.

### 1.7 Estimated Timeline

| Step | Time |
|------|------|
| Registration + project submission | 15 min |
| Approval | 24--48 hours (weekdays) |
| Download all datasets (12+ countries) | 1--2 hours (using Download Manager) |
| Initial data exploration in R | 2--3 hours |
| **Total to first analysis** | **~2--3 days** |

---

## Part 2: HRS Family Studies (CHARLS, KLoSA, LASI)

These are part of the international HRS (Health and Retirement Study) family -- harmonized longitudinal studies of aging populations. All include blood pressure, BMI, and extensive health biomarkers.

### 2.1 CHARLS -- China Health and Retirement Longitudinal Study

| Item | Details |
|------|---------|
| **URL** | https://charls.pku.edu.cn/en |
| **Population** | Adults 45+, nationally representative |
| **Sample** | ~10,000 households, ~17,000 individuals |
| **Waves** | 2011, 2013, 2015, 2018 (+ later waves) |
| **BP data** | Yes -- 3 seated readings with OMRON monitor |
| **Other biomarkers** | BMI, grip strength, lung function, blood samples |

**Registration process:**
1. Go to https://charls.pku.edu.cn/en
2. Click "Data" -> register for an account
3. Fill in researcher information and institutional affiliation
4. Agree to data use terms
5. Download approved -- typically immediate after registration
6. Data available in Stata (.dta) format

**Key variables**: `qa007_s_1` (systolic 1st), `qa007_d_1` (diastolic 1st), etc. Check codebook.

### 2.2 KLoSA -- Korean Longitudinal Study of Ageing

| Item | Details |
|------|---------|
| **URL** | https://survey.keis.or.kr/eng/klosa/klosa01.jsp |
| **Population** | Adults 45+, nationally representative |
| **Waves** | 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020 |
| **BP data** | Self-reported hypertension; measured BP in some waves |
| **Other biomarkers** | Grip strength, self-rated health |

**Registration process:**
1. Go to https://survey.keis.or.kr (Korea Employment Information Service)
2. Register as member (may need Korean language navigation; try English page)
3. After member registration, download data directly
4. Data format: Stata (.dta) or SPSS (.sav)

**Note**: KLoSA's biomarker data is less extensive than CHARLS/LASI. Self-reported BP status is available in all waves; measured BP may require checking specific wave documentation.

### 2.3 LASI -- Longitudinal Ageing Study in India

| Item | Details |
|------|---------|
| **URL** | https://www.iipsindia.ac.in/lasi |
| **Alt URL** | https://lasi-india.org |
| **Population** | Adults 45+, nationally representative across all Indian states |
| **Sample** | 73,396 adults (Wave 1) |
| **Wave 1** | 2017--2018 (Sikkim: 2020--21) |
| **BP data** | Yes -- multiple readings with standardized protocol |
| **Other biomarkers** | BMI, grip strength, lung function, blood biomarkers |

**Registration process:**
1. Go to https://www.iipsindia.ac.in/content/LASI-data
2. Download the data request form
3. Fill in researcher information + project description
4. **Attach valid ID** (institutional ID or equivalent) -- mandatory
5. Submit request and wait for approval
6. Alternative: data also available at https://www.data.gov.in (search "LASI")

**Also available via Gateway to Global Aging Data (g2aging.org)**:
- Harmonized versions of CHARLS, KLoSA, LASI, HRS, ELSA, SHARE
- URL: https://g2aging.org
- Provides cross-study harmonized variables (recommended for cross-country comparison)

### 2.4 HRS Family Summary

| Study | Country | BP Measured | Registration | Approval Time |
|-------|---------|-------------|--------------|---------------|
| CHARLS | China | Yes (3 readings) | Online form | Immediate--few days |
| KLoSA | Korea | Some waves | Member registration | Immediate |
| LASI | India | Yes (multiple) | Form + ID | Days--weeks |
| **HRS** | USA | Yes | https://hrs.isr.umich.edu | Immediate (public) |
| **ELSA** | UK | Yes | https://ukdataservice.ac.uk | Registration required |

**Estimated total timeline**: 1--2 weeks to get all HRS family datasets.

---

## Part 3: WHO STEPS Surveys

### 3.1 Overview

WHO STEPS (STEPwise approach to NCD risk factor Surveillance) collects standardized data on:
- Step 1: Behavioral risk factors (tobacco, alcohol, diet, physical activity)
- Step 2: Physical measurements (**BP**, height, weight, waist circumference)
- Step 3: Biochemical measurements (blood glucose, cholesterol)

### 3.2 Registration and Access

| Item | Details |
|------|---------|
| **URL** | https://extranet.who.int/ncdsmicrodata/index.php/catalog/STEPS |
| **Registration** | Create account on the NCD Microdata Repository |
| **Approval** | Most datasets publicly available after registration |
| **Format** | Stata (.dta) or CSV |

**Process:**
1. Go to https://extranet.who.int/ncdsmicrodata
2. Browse the STEPS catalog: https://extranet.who.int/ncdsmicrodata/index.php/catalog/STEPS
3. Register for an account
4. Select a country survey -> click "Get Microdata"
5. Agree to terms of use:
   - Acknowledge data source in publications
   - Share planned publications with WHO before publication
   - Offer co-authorship to survey coordinator
   - Non-commercial use only
6. Download dataset

### 3.3 Priority STEPS Datasets

| Country | Year | Region | BP | Notes |
|---------|------|--------|-----|-------|
| **Bhutan** | 2019 | South Asia | Yes | Small country, good contrast |
| **Sri Lanka** | 2021 | South Asia | Yes | |
| **Mongolia** | 2019 | East Asia | Yes | |
| **Fiji** | 2021 | Pacific | Yes | |
| **Georgia** | 2016 | Caucasus | Yes | |
| **Rwanda** | 2021 | Africa | Yes | |
| **Solomon Islands** | 2015 | Pacific | Yes | |
| **Timor-Leste** | 2014 | SE Asia | Yes | |

### 3.4 Key STEPS Variable Names

| Variable | Description |
|----------|-------------|
| `M4a` | Systolic BP, reading 1 |
| `M4b` | Diastolic BP, reading 1 |
| `M5a` | Systolic BP, reading 2 |
| `M5b` | Diastolic BP, reading 2 |
| `M6a` | Systolic BP, reading 3 |
| `M6b` | Diastolic BP, reading 3 |
| `M11` | Height (cm) |
| `M12` | Weight (kg) |
| `M13` | Waist circumference (cm) |
| `M14` | Hip circumference (cm) |
| `C1` | Age (years) |
| `C3` | Sex |

**Estimated timeline**: Registration same-day; downloads immediate for most countries.

---

## Part 4: Recommended Action Sequence

### Week 1 (Immediate)
- [ ] **Day 1**: Register at dhsprogram.com with the project description above
- [ ] **Day 1**: Register at extranet.who.int/ncdsmicrodata (likely instant access)
- [ ] **Day 1**: Register at charls.pku.edu.cn
- [ ] **Day 2**: Download available WHO STEPS datasets (no wait)
- [ ] **Day 2**: Download CHARLS data (if registration is instant)
- [ ] **Day 2--3**: DHS approval arrives -> download all country IR/MR files

### Week 2
- [ ] **Day 4--5**: Submit LASI data request (may take longer)
- [ ] **Day 4--5**: Register at KLoSA (survey.keis.or.kr)
- [ ] **Day 5--7**: Initial data exploration in R:
  - Check BP variable names per country
  - Confirm sample sizes for biomarker subsample
  - Compute basic summaries (mean, SD, distribution shape)

### Week 3
- [ ] Run nABCD on real distributions (BP, BMI, hemoglobin)
- [ ] Compare nABCD values across Asian vs African vs Latin American country pairs
- [ ] Generate figures for the paper

---

## Part 5: Quick Reference -- R Code Snippet

```r
library(haven)
library(dplyr)

# Read DHS Stata file
india <- read_dta("IAIR7DFL/IAIR7DFL.DTA")

# Key variables
india_bio <- india %>%
  select(
    caseid,
    age = v012,
    bmi = v445,        # BMI x 100
    hb  = v456,        # hemoglobin adjusted, g/dL x 10
    wt  = v437,        # weight in kg (1 decimal)
    ht  = v438,        # height in cm (1 decimal)
    wealth = v190,
    region = v024,
    urban = v025
  ) %>%
  mutate(
    bmi = bmi / 100,   # convert to standard BMI
    hb  = hb / 10      # convert to g/dL
  )

# For BP: check variable names in the .MAP or .DO file first
# Then add e.g.: sbp = sb16s, dbp = sb16d
```

---

*Document prepared for the nABCD similarity metric project.*
*See also: `projects/similarity-metric/paper/latex/nABCD_wiley.tex` for the manuscript.*
