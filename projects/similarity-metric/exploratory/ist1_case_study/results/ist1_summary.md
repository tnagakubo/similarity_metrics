# IST-1 exploratory application - script-written summary (no number typed)

seed 20261012; alpha 0.05 one-sided; Delta_clin 0.01; N = 19435; countries = 36

## Anchor USA (n = 131; partners 35; B_ci 2000, B_null 2000, B_rank 1000)

| EM | resolved / partners | median W1 | min-max W1 | median CI width | median null q95 | sd ratio range |
|---|---|---|---|---|---|---|
| age (years) | 23 / 35 | 5.46 | 1.12-17.66 | 4.59 | 3.03 | 0.23-1.14 |
| sbp (mmHg) | 12 / 35 | 6.56 | 2.94-23.30 | 7.17 | 6.71 | 0.71-1.32 |
| delay (hours) | 25 / 35 | 5.33 | 1.22-11.75 | 4.50 | 2.64 | 0.82-1.89 |

Partners resolved on all three EMs (10): UK, ITAL, SWIT, POLA, NETH, ARGE, CZEC, BELG, INDI, SLOK
Partners resolved on none (4): FINL, SRI, ROMA, JAPA

Spearman between EM orderings (patient bootstrap interval):
- age vs sbp: 0.04 [-0.09, 0.26]
- age vs delay: 0.06 [-0.09, 0.22]
- sbp vs delay: 0.15 [-0.09, 0.38]

Spearman W1 vs |SMD| per EM:
- age: 0.98 [0.89, 0.99]
- sbp: 0.81 [0.62, 0.96]
- delay: 0.91 [0.85, 0.99]

Mean rank-interval width (hi - lo): age 12.5; sbp 17.7; delay 13.5

Top-5 closest partners by W1 per EM (n, W1, CI; unresolved flagged):
- age: SING n=140 W1=1.12 [1.19, 3.59] (unresolved); BRAS n=83 W1=1.83 [1.49, 5.29] (unresolved); PORT n=415 W1=1.96 [1.26, 4.31] (unresolved); SRI n=20 W1=2.02 [2.22, 7.50] (unresolved); SOUT n=69 W1=2.17 [1.93, 5.17] (unresolved)
- sbp: AUSL n=597 W1=2.94 [2.57, 7.19] (unresolved); AUST n=230 W1=3.03 [2.96, 8.74] (unresolved); NEW n=453 W1=3.08 [2.74, 7.44] (unresolved); FINL n=85 W1=3.21 [2.83, 9.19] (unresolved); ISRA n=114 W1=3.43 [2.72, 8.88] (unresolved)
- delay: NEW n=453 W1=1.22 [1.00, 3.05] (unresolved); HONG n=115 W1=1.58 [1.24, 3.60] (unresolved); FINL n=85 W1=1.88 [1.23, 4.39] (unresolved); NORW n=526 W1=1.97 [1.14, 4.15] (unresolved); SWED n=636 W1=2.06 [1.28, 4.16] (unresolved)

Top-5 most distant partners by W1 per EM:
- age: FRAN n=2 W1=17.66 [15.05, 20.92]; EIRE n=58 W1=11.62 [8.37, 15.11]; SWED n=636 W1=10.43 [8.11, 12.71]; SWIT n=1631 W1=9.34 [7.22, 11.54]; UK n=6257 W1=8.82 [6.83, 10.95]
- sbp: FRAN n=2 W1=23.30 [18.45, 40.83]; SLOK n=86 W1=18.03 [10.99, 26.07]; NETH n=728 W1=14.72 [10.73, 19.66]; CZEC n=466 W1=13.53 [9.37, 18.38]; SWED n=636 W1=13.12 [9.25, 17.58]
- delay: SLOV n=53 W1=11.75 [8.39, 15.02]; AUST n=230 W1=11.19 [8.82, 13.64]; NETH n=728 W1=9.45 [7.37, 11.60]; BELG n=305 W1=9.14 [6.92, 11.46]; SWIT n=1631 W1=9.13 [7.13, 11.05]

## Anchor JAPA (n = 9; partners 35; B_ci 500, B_null 500, B_rank 0)

| EM | resolved / partners | median W1 | min-max W1 | median CI width | median null q95 | sd ratio range |
|---|---|---|---|---|---|---|
| age (years) | 2 / 35 | 3.92 | 2.49-13.22 | 8.11 | 7.65 | 0.24-1.18 |
| sbp (mmHg) | 0 / 35 | 7.73 | 6.17-22.11 | 20.89 | 21.26 | 0.56-1.04 |
| delay (hours) | 15 / 35 | 8.37 | 2.47-14.79 | 12.67 | 8.61 | 0.68-1.57 |

Partners resolved on all three EMs (0): 
Partners resolved on none (18): UK, SWED, ARGE, NORW, NEW, PORT, GREE, SING, USA, HONG, ISRA, HUNG, SLOK, CHIL, EIRE, SRI, ROMA, FRAN

## Anchor UK (n = 6257; partners 35; B_ci 500, B_null 500, B_rank 0)

| EM | resolved / partners | median W1 | min-max W1 | median CI width | median null q95 | sd ratio range |
|---|---|---|---|---|---|---|
| age (years) | 29 / 35 | 4.44 | 0.72-16.94 | 3.49 | 2.06 | 0.25-1.28 |
| sbp (mmHg) | 15 / 35 | 5.49 | 1.57-20.42 | 5.06 | 5.12 | 0.68-1.26 |
| delay (hours) | 23 / 35 | 3.06 | 0.91-11.31 | 2.70 | 2.17 | 0.71-1.65 |

Partners resolved on all three EMs (10): ITAL, SWIT, POLA, NETH, SWED, AUSL, NORW, NEW, USA, HONG
Partners resolved on none (2): JAPA, FRAN

## GUSTO-I vs IST-1 on the same descriptors

| case | partners | n range | resolved age | resolved SBP | resolved delay | mean rank width age / SBP | rho(age, SBP) [CI] |
|---|---|---|---|---|---|---|---|
| GUSTO-I (anchor R8) | 15 | 1231-4352 | 9 | 14 | - | 6.7 / 5.0 | -0.30 [-0.51, 0.02] |
| IST-1 (anchor USA) | 35 | 2-6257 | 23 | 12 | 25 | 12.5 / 17.7 | 0.04 [-0.09, 0.26] |
