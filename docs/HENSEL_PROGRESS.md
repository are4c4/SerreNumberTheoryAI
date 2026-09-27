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
- one-variable and multivariate source hypothesis/conclusion predicates;
- one-step improvement predicates, separated from exact-root conclusions;
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
- divisibility bookkeeping showing that a quadratic Taylor defect and a correction of depth `r` imply remainder depth `r+r`;
- specialization of that bookkeeping to the Hensel correction depth `n-k`;
- packaging lemma turning linear cancellation plus Taylor-quadratic divisibility plus derivative-valuation preservation into `serreHenselUnivariateStepConclusion`;
- Blueprint nodes now mirror the congruence API, additive Taylor-defect algebra, Taylor defect bookkeeping, one-step conclusion, and multivariate reduction boundary.

## Next proof target

Extend the Taylor algebra to monomials.  A likely next slice is either:

- prove `serreHenselTaylorQuadraticFactor` for `Polynomial.C c * Polynomial.X ^ m` using the new constant-scaling lemma; or
- prove closure of `serreHenselTaylorQuadraticFactor` under polynomial multiplication.

After that, assemble arbitrary polynomials from finite sums of monomials and combine the concrete Taylor identity with the existing p-power bookkeeping to obtain the source `p^((n-k)+(n-k))` remainder estimate used in the Newton step.