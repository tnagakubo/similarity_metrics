# VanderWeele & Knol (2014) - A Tutorial on Interaction

## Citation
VanderWeele, T. J. & Knol, M. J. (2014). "A Tutorial on Interaction." *Epidemiologic Methods*, 3(1): 33-72.
DOI: [10.1515/em-2013-0005](https://doi.org/10.1515/em-2013-0005)

## Overview

This comprehensive 40-page tutorial provides a thorough introduction to the topic of **interaction** (also called **effect modification**) between exposures. It covers both additive and multiplicative scales, statistical models, confounding issues, qualitative interactions, mechanistic interpretations, and practical analysis methods. This is arguably the most complete single reference on interaction analysis in epidemiology.

## Structure

**Part I: Fundamental Concepts and Approaches for Interaction**
- 1.1 Motivations for assessing interaction
- 1.2 Measures of interaction and scale of interaction
- 1.3 Statistical interactions and statistical inference
- 1.4 Inference for additive interaction
- 1.5 Additive versus multiplicative interaction
- 1.6 Confounding and the interpretation of interaction
- 1.7 Presenting interaction analyses
- 1.8 Qualitative interaction
- 1.9 Synergism and mechanistic interactions

**Part II: Limitations, Extensions, Study Design, and Properties**
- 2.1 Limits of inference concerning biology
- 2.2 Attributing effects to interactions
- 2.3 Case-only designs for interaction
- 2.4 Interaction for continuous outcomes
- 2.5 Identifying subgroups using multiple covariates
- 2.6 Robustness of interaction to unmeasured confounding
- 2.7 Power and sample size calculations for interaction

## Key Definitions

### Effect Modification vs. Interaction
- **Effect modification**: The effect of exposure *E* on outcome *D* varies across strata defined by factor *G*
- **Interaction**: The joint effect of *G* and *E* differs from expected under some model (additive or multiplicative)
- These terms are often used interchangeably, but there are subtle distinctions (Section 1.6)

### Notation
- $p_{ge} = P(D = 1 | G = g, E = e)$: probability of outcome given exposure levels
- $p_{00}$: baseline risk (both factors absent)
- $p_{10}, p_{01}$: risk with one factor present
- $p_{11}$: risk with both factors present

## Key Measures of Interaction

### Additive Scale

**Interaction Contrast (IC)**:
$$\text{IC} = p_{11} - p_{10} - p_{01} + p_{00}$$

- IC > 0: **super-additive** interaction (synergy)
- IC < 0: **sub-additive** interaction (antagonism)
- IC = 0: no additive interaction

**Relative Excess Risk due to Interaction (RERI)**:
$$\text{RERI}_{RR} = RR_{11} - RR_{10} - RR_{01} + 1$$

where $RR_{ge} = p_{ge}/p_{00}$ are relative risks.

**Synergy Index**:
$$S = \frac{RR_{11} - 1}{(RR_{10} - 1) + (RR_{01} - 1)}$$

- S > 1: positive additive interaction
- S < 1: negative additive interaction

**Attributable Proportion (AP)**:
$$AP = \frac{RR_{11} - RR_{10} - RR_{01} + 1}{RR_{11}}$$

Measures the proportion of risk in the doubly exposed group that is due to interaction.

### Multiplicative Scale

**Ratio of Risk Ratios**:
$$\frac{RR_{11}}{RR_{10} \cdot RR_{01}} = \frac{p_{11} p_{00}}{p_{10} p_{01}}$$

- Ratio > 1: **positive multiplicative** interaction
- Ratio < 1: **negative multiplicative** interaction
- Ratio = 1: no multiplicative interaction

**For Odds Ratios**:
$$\frac{OR_{11}}{OR_{10} \cdot OR_{01}}$$

## Statistical Models

### Linear Model (Additive Interaction)
$$P(D = 1 | G = g, E = e) = \alpha_0 + \alpha_1 g + \alpha_2 e + \alpha_3 ge$$

- $\alpha_3 = p_{11} - p_{10} - p_{01} + p_{00}$ is the additive interaction
- $\alpha_3 > 0$: super-additive; $\alpha_3 < 0$: sub-additive

### Log-Linear Model (Multiplicative Interaction for RR)
$$\log\{P(D = 1 | G = g, E = e)\} = \beta_0 + \beta_1 g + \beta_2 e + \beta_3 ge$$

- $e^{\beta_3} = RR_{11}/(RR_{10} \cdot RR_{01})$

### Logistic Model (Multiplicative Interaction for OR)
$$\text{logit}\{P(D = 1 | G = g, E = e)\} = \gamma_0 + \gamma_1 g + \gamma_2 e + \gamma_3 ge$$

- $e^{\gamma_3} = OR_{11}/(OR_{10} \cdot OR_{01})$

### With Covariates C
$$\text{logit}\{P(D = 1 | G = g, E = e, C = c)\} = \gamma_0 + \gamma_1 g + \gamma_2 e + \gamma_3 ge + \gamma_4' c$$

## Key Concepts

### Scale Dependence (Section 1.2, 1.5)
- **Critical insight**: Interaction can be present on one scale but absent on another
- Example (Table 3): Positive additive interaction (IC = 0.03) but NO multiplicative interaction (ratio = 1)
- Both scales should generally be reported

### Qualitative Interaction (Section 1.8)
- Also called "crossover" interaction
- Treatment beneficial for one subgroup but harmful for another
- Does NOT depend on scale choice
- Critical for treatment decisions: "In the presence of qualitative interaction, we do not want to treat all subgroups"

### Confounding in Interaction (Section 1.6)
Two sets of confounding factors:
1. Confounders for the *G*-*D* relationship
2. Confounders for the *E*-*D* relationship

**Effect heterogeneity** vs **causal interaction**:
- Effect heterogeneity: only control for E-D confounders needed
- Causal interaction: control for both sets needed

### Mechanistic Interaction (Section 1.9)
- **Sufficient cause interaction**: Outcome occurs if and only if both exposures present
- **Synergism**: Component causes that are part of the same sufficient cause
- Positive additive interaction implies sufficient cause interaction under monotonicity

## Attributing Effects to Interactions (Section 2.2)

Decomposition of joint effect:
$$p_{11} - p_{00} = (p_{10} - p_{00}) + (p_{01} - p_{00}) + (p_{11} - p_{10} - p_{01} + p_{00})$$

Three components:
1. Effect due to *G* alone
2. Effect due to *E* alone
3. Effect due to interaction

On the ratio scale:
$$RR_{11} - 1 = (RR_{10} - 1) + (RR_{01} - 1) + \text{RERI}_{RR}$$

## Sample Size and Power (Section 2.7)

- Interaction tests have **lower power** than main effect tests
- Larger sample sizes needed to detect interaction
- For positive main effects: test for additive interaction is generally more powerful than for multiplicative
- Software: QUANTO (Windows), SAS/Stata code in Appendix

## Relevance to SEMD Project

### Direct Connection to Effect Modification

SEMD measures the **distribution** of effect modifiers. VanderWeele & Knol explain **why effect modifiers matter**:

1. **Treatment targeting**: "identify the subgroups of individuals in which the intervention or treatment is likely to have the largest effect" (Section 1.1)

2. **Mechanism insight**: Effect modification can reveal underlying biological mechanisms

3. **Scale matters**: Depending on additive vs multiplicative scale, conclusions about heterogeneity differ

### Key Quotes for SEMD Paper

**On the importance of effect modifiers** (p.34):
> "It may not be possible to intervene on or treat an entire population. Resources may only be sufficient to treat a small fraction. If this is the case, then it may be important to identify the subgroups of individuals in which the intervention or treatment is likely to have the largest effect."

**On presentation** (p.48):
> "effect modification analyses be presented for each stratum separately using separate reference groups"

**On both scales** (p.44):
> "it is almost always best to present both additive and multiplicative measures of interaction"

### Connection to ICH E17

ICH E17 defines effect modifiers as **intrinsic/extrinsic factors that modulate treatment response across regions**. VanderWeele & Knol provide:
- Formal definitions of effect modification
- Methods to quantify interaction magnitude
- Framework for understanding when factor distributions matter

### SEMD Interpretation

If SEMD is small between regions:
- Effect modifier distributions are similar
- Additive interactions (if present) will be similarly distributed
- Regional treatment effect heterogeneity will be minimal

## Key Tables

| Table | Content |
|-------|---------|
| Table 1 | Lung cancer risk by smoking × asbestos (classic example) |
| Table 2-3 | Examples of additive vs multiplicative interaction |
| Table 6 | Informative presentation with common reference |
| Table 7 | Relations between RERI, monotonicity, and mechanistic interaction |

## Appendix: Software Code

- **SAS**: Code for RERI estimation using logistic regression (delta method)
- **Stata**: Code for RERI, synergy index, attributable proportion
- **Excel**: Spreadsheet for manual calculation

## References (Selected)

- Rothman, K. J. (1976). Causes. *American Journal of Epidemiology*, 104:587-592.
- Rothman, K. J., Greenland, S., & Walker, A. M. (1980). Concepts of interaction. *American Journal of Epidemiology*, 112:467-470.
- VanderWeele, T. J. (2009a). On the distinction between interaction and effect modification. *Epidemiology*, 20:863-871.
- Greenland, S., Lash, T. L., & Rothman, K. J. (2008). Concepts of interaction. In: *Modern Epidemiology*, 3rd ed.

## Tags
effect modification, interaction, additive interaction, multiplicative interaction, RERI, synergy index, qualitative interaction, confounding, epidemiology, causal inference, treatment heterogeneity

---
*Processed by Rachel | 2026-02-02*
*Key reference for SEMD paper - provides formal framework for effect modification and why distribution similarity matters*
