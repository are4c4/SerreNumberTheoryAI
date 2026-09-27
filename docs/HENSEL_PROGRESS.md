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
- helper lemmas extracting source-hypothesis inequalities, divisibility, and valuation components;
- transfer lemmas from multivariate hypotheses to a chosen one-variable specialization;
- transfer lemmas from a one-variable Hensel conclusion back to the multivariate conclusion;
- Taylor-defect interface `f(x+h) - f(x) - h*f'(x)`;
- concrete Taylor-defect algebra for zero, constants, `X`, constant scaling, addition, negation, subtraction, multiplication, powers of `X`, coefficient-scaled monomials, and all polynomials;
- Taylor-defect divisibility bookkeeping for Hensel corrections;
- derivative-valuation preservation under Hensel corrections;
- exact derivative valuation factorization by `p^k` with a unit quotient;
- existence of a correction `z` whose linear Taylor part cancels modulo `p^(n+1)`;
- concrete one-step theorem `serreHenselUnivariateStepConclusion_of_hypothesis`, requiring only the source-shaped Hensel hypothesis;
- recursive iterate-state sequence for the one-variable Hensel approximation process;
- iterate invariants extracting `p^(n+r) ∣ f(y_r)` and `v_p(f'(y_r)) = k` at every stage;
- finite-tail congruence lemmas and tail congruence at any prescribed lower depth;
- congruence-to-metric radius bridge, metric-radius Cauchy bridge, `CauchySeq` bridge, and completeness-based limit existence;
- selected limit `serreHenselIterateLimit` and convergence theorem for the iterate sequence;
- proof that the selected limit remains congruent to the initial approximation modulo `p^(n-k)`;
- finite-residue compatibility for one-variable polynomial evaluation, via `serrePadicIntProj_polynomial_eval`;
- proof that the selected limit inherits every finite divisibility depth of `f(y_r)`, via `serreHenselIterateLimit_eval_dvd`;
- exact-root theorem `serreHenselIterateLimit_is_root`;
- one-variable source theorem boundary `serreHenselUnivariateConclusion_of_hypothesis`;
- multivariate packaging theorem `serreHenselMultivariateConclusion_of_specialization`, reducing the multivariate conclusion to a supplied one-variable specialization and derivative identity;
- Blueprint nodes now mirror the congruence API, Taylor-defect algebra, Taylor defect bookkeeping, one-step conclusion, iteration Cauchy/completeness API, exact-root bridge, one-variable theorem boundary, and multivariate reduction boundary.

## Next proof target

The one-variable Hensel theorem boundary is now proved from the source-shaped one-variable hypothesis.  The next major block is the multivariate theorem boundary:

1. build or package the one-variable specialization `g` obtained by freezing all coordinates except `X_j`;
2. prove the evaluation identity `g(t) = f(x with X_j := t)` and the derivative identity at `x_j`;
3. apply `serreHenselMultivariateConclusion_of_specialization`;
4. then add Corollary 1 as the case `n = 1`, `k = 0`.

Keep the final source conclusions exact-root plus congruence only, and avoid packaged Hensel theorems or non-source assumptions.
