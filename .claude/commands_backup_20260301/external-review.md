---
description: External review by legendary statistician homages
---

# Research Lab: External Review

Dynamically generate homage experts inspired by legendary statisticians.
These are **fictional tributes**, NOT the actual persons.

## Execution

1. **Louis**: Select 2-3 appropriate expert styles based on paper content
2. Generate fictional experts with those styles
3. Each expert reviews from their perspective
4. **Louis**: Summarize and prioritize issues
5. **Donna**: Add scene to SUITS.md

## Expert Style Pool

See `agents/statisticians.md` for full reference.

## SUITS.md Scene (add at TOP)

```markdown
### [YYYY-MM-DD HH:MM] Scene: External Review

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Louis stands at the head of the table. Three external consultants sit across from the team.*

**Louis**: （資料を配りながら）
「外部レビューを招集した。この論文には厳しい目が必要だ」

*Dr. Elena Richter (Wasserman-style) speaks first.*

**Dr. Richter**: 
「シンプルな方法で十分では？複雑さの正当化が弱い」

*Dr. Marcus Webb (Gelman-style) nods.*

**Dr. Webb**: 
「事前分布の sensitivity analysis が見当たらない。
"What does the posterior predictive check show?"」

*Mike furiously takes notes.*

**Louis**: （まとめながら）
「Critical X 件、Major Y 件。Harvey、対応を」

**Harvey**: （立ち上がって）
「分かった。Mike、まず Critical から潰せ」

---
```

## Style Selection Guide

| Paper Topic | Recommended Styles |
|-------------|-------------------|
| Bayesian borrowing | Gelman-style, Rubin-style |
| Wasserstein/OT | Villani-style, Cuturi-style |
| Clinical trials | Cox-style, Pocock-style, Senn-style |
| Proofs/theory | Rao-style, Bickel-style |
| ML methods | Tibshirani-style, Hastie-style |
