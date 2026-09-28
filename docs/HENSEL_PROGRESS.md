# Hensel lifting progress

Work ID: `C2S2.2-HenselLifting`

Source: Serre, Chapter 2 §2.2, printed pp.20-22 / uploaded PDF pp.30-32.

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

The source then states quadratic-form corollaries.  For odd `p`, a
primitive solution of a nondegenerate quadratic congruence mod `p` lifts
to a `Z_p`-solution.  For `p = 2`, a solution mod `8` with a selected
partial derivative nonzero mod `4` lifts.  In Lean, this run formalizes
the Hensel-facing value-lift part once the required derivative valuation
has already been supplied; the determinant/primitive-vector argument that
produces such a coordinate is left as a separate linear-algebra boundary.

## Implemented in Lean so far

- project-local divisibility-depth predicate for congruences modulo `p^n`;
- one-variable and multivariate source hypothesis/conclusion predicates, with final exact-root conclusions aligned to Serre (root + congruence only);
- one-step improvement predicates, where derivative valuation is preserved as the iteration invariant;
- source congruence API: reflexivity, symmetry, transitivity, modulus monotonicity;
- one-coordinate update operation and a proof that updating by the existing coordinate value gives the original tuple;
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
- coordinate specialization `serreHenselCoordinateSpecialization`, its evaluation identity, and its derivative identity with the selected partial derivative;
- multivariate source theorem boundary `serreHenselMultivariateConclusion_of_hypothesis`;
- one-variable and multivariate simple-root corollary packages for `n = 1`, `k = 0`;
- Hensel-facing value-lift packages for the quadratic corollaries: odd-prime simple-derivative lifting modulo `p`, and the `p = 2`, mod `8` to mod `4` lifting with derivative valuation `1`;
- existential-coordinate wrappers for those value-lift packages, matching the source's formulation where the matrix argument supplies some coordinate `j`;
- Blueprint nodes now mirror the congruence API, Taylor-defect algebra, Taylor defect bookkeeping, one-step conclusion, iteration Cauchy/completeness API, exact-root bridge, one-variable theorem boundary, multivariate reduction boundary, simple-root corollary, and quadratic value-lift boundary.

## Next proof target

The source-shaped one-variable theorem, multivariate theorem boundary, simple-root corollary packages, and the Hensel-facing parts of the quadratic corollaries are now implemented.

The next mathematical boundary is the remaining linear algebra in Serre's quadratic corollaries:

1. represent the symmetric coefficient matrix and the associated quadratic polynomial in the current project API;
2. formalize the primitive-vector/nondegenerate-matrix argument that some partial derivative has the required valuation;
3. connect that derivative-existence result to `serreHenselValueLift_mod_p_of_exists_simple_derivative` and `serreHenselValueLift_mod_eight_of_exists_derivative_valuation_one`.

Stop before attempting this if the matrix/quadratic-form API is not clear.  Keep the proof project-local and avoid packaged Hensel theorems or non-source assumptions.
