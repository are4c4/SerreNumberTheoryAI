# Hensel lifting progress

Work ID: `C2S2.2-HenselLifting`

Source: Serre, Chapter 2 §2.2, printed pp.20-21 / uploaded PDF pp.30-31.

## Source boundary checked in this run

The source starts with a one-variable Newton improvement lemma for
`f ∈ Z_p[X]`.  If `x ∈ Z_p`, `n,k ∈ Z`, `0 ≤ 2k < n`,
`f(x) ≡ 0 (mod p^n)`, and `v_p(f'(x)) = k`, then there is a
`y ∈ Z_p` such that

- `f(y) ≡ 0 (mod p^(n+1))`,
- `v_p(f'(y)) = k`,
- `y ≡ x (mod p^(n-k))`.

The proof takes `y = x + p^(n-k) z`, uses the Taylor expansion
`f(y) = f(x) + p^(n-k) z f'(x) + p^(2n-2k) a`, and chooses `z`
so that the first two terms cancel modulo `p^(n+1)`.

Theorem 1 then iterates this one-step improvement to obtain a Cauchy
sequence.  The multivariate case is reduced to the one-variable case by
varying only the chosen coordinate `X_j`.  Corollary 1 is the special
case `n = 1`, `k = 0`.

## Implemented in Lean so far

- project-local divisibility-depth predicate for congruences modulo `p^n`;
- one-variable and multivariate source hypothesis/conclusion predicates, with final exact-root conclusions aligned to Serre (root + congruence only);
- one-step improvement predicates, where derivative valuation is preserved as the iteration invariant;
- source congruence API: reflexivity, symmetry, transitivity, modulus monotonicity;
- one-coordinate update operation used in the multivariate-to-univariate reduction;
- proof that a one-coordinate update is congruent in every coordinate when the moved coordinate is congruent;
- helper lemmas extracting each source hypothesis/conclusion component, including `k < n` and positivity of `n-k`;
- helper lemma that a correction of the form `x + p^(n-k) z` gives the required congruence;
- transfer lemmas from the multivariate source hypotheses to a one-variable specialization;
- transfer lemmas from a one-variable Hensel conclusion back to the multivariate conclusion once the evaluation and derivative-specialization identities are supplied;
- Taylor-defect interface `f(x+h) - f(x) - h*f'(x)`;
- base cases for the quadratic Taylor-defect predicate: zero polynomial, constant polynomials, and `X`;
- constant-scaling algebra for Taylor defects and closure of the quadratic Taylor-defect predicate under multiplication by a constant polynomial;
- add/sub/neg algebra for Taylor defects and closure of the quadratic Taylor-defect predicate under addition, subtraction, and negation;
- multiplication closure for the quadratic Taylor-defect predicate;
- powers of `X` and coefficient-scaled monomials have quadratic Taylor defects;
- every polynomial has a quadratic Taylor defect, via `serreHenselTaylorQuadraticFactor_all`;
- every polynomial Taylor defect gains twice the p-power depth of the correction, via `serreHenselTaylorDefect_dvd_all`;
- moving the input by a depth-`r` correction changes polynomial values only at depth `r`;
- a Hensel correction preserves the exact derivative valuation `k` under `2*k < n`;
- exact derivative valuation gives a `p^k * unit` factorization of the derivative;
- existence of a correction `z` whose linear Taylor part cancels modulo `p^(n+1)`;
- divisibility bookkeeping showing that a quadratic Taylor defect and a correction of depth `r` imply remainder depth `r+r`;
- specialization of that bookkeeping to the Hensel correction depth `n-k`;
- packaging lemma turning linear cancellation plus Taylor-quadratic divisibility plus derivative-valuation preservation into `serreHenselUnivariateStepConclusion`;
- concrete one-step theorem `serreHenselUnivariateStepConclusion_of_hypothesis`, requiring only the source-shaped Hensel hypothesis;
- recursive iterate-state sequence for the one-variable Hensel approximation process;
- iterate invariants extracting `p^(n+r) ∣ f(y_r)` and `v_p(f'(y_r)) = k` at every stage;
- finite-tail congruence lemmas showing `y_r ≡ y_s` at the earlier available depth when `r ≤ s`;
- tail congruence API showing any two sufficiently late iterates are congruent at any prescribed lower depth;
- source congruence-to-metric radius bound `serrePadicCongruent_dist_le_radius`;
- congruence-depth Cauchy predicate `serrePadicCongruenceCauchy` and proof that the Hensel iterate sequence satisfies it;
- metric-radius Cauchy predicate `serrePadicMetricRadiusCauchy`, bridge from congruence-Cauchy to metric-radius Cauchy, and proof for the Hensel iterate sequence;
- Blueprint nodes now mirror the congruence API, Taylor-defect algebra, Taylor defect bookkeeping, one-step conclusion, iteration Cauchy API, and multivariate reduction boundary.

## Next proof target

The concrete one-step Newton improvement and the metric-radius Cauchy API are now packaged.  The next major block is to connect this source-shaped radius statement to the exact project-local metric/completeness interface:

1. inspect the exact `CauchySeq`/filter form expected by the existing `CompleteSpace` instance for `SerrePadicInt`;
2. turn `serreHenselIterateSeq_metric_radius_cauchy` into the required metric Cauchy statement;
3. use completeness to obtain a limit of the chosen approximations;
4. pass polynomial evaluation to the limit and obtain an exact root;
5. retain congruence to the original approximation modulo `p^(n-k)`.

Before proving the full metric Cauchy statement, audit the existing project metric/completeness and polynomial-continuity APIs rather than introducing a parallel topology interface.
