# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-lifting-serial`.

The source predicates, congruence API, one-step conclusion predicates, and abstract multivariate-to-univariate transfer are in place.  The next proof step should target the one-step Newton improvement before the Cauchy-limit construction.

Likely local lemma shape:

```lean
-- If y = x + h, expand f.eval y around x and show
-- f.eval y - f.eval x - h * f.derivative.eval x is divisible by h^2.
```

Then specialize `h = (p : SerrePadicInt p)^(n-k) * z` and combine:

- `p^n ∣ f.eval x` from the source hypothesis;
- `v_p(f.derivative.eval x) = k`, so the derivative is `p^k * unit`;
- `2*k < n`, giving positivity and the needed exponent inequalities;
- a residue-level choice of `z` to cancel the normalized first-order term modulo `p`.

Useful existing APIs:

- `padicDivisibilityDepth p n a` for `p^n ∣ a`;
- `serrePadicCongruent p n x y` for `y ≡ x (mod p^n)`;
- `serrePadicCongruent_refl`, `serrePadicCongruent_symm`, `serrePadicCongruent_trans`, and `serrePadicCongruent_mono` for managing congruence chains;
- `serreHenselUnivariateStepConclusion` for the target of a single Newton step;
- `serrePadicIntAddValuation p a = (k : ℕ∞)` for exact source valuation;
- `serrePadicInt_pow_dvd_iff_le_addValuation` for converting valuation inequalities into divisibility;
- `serrePadicIntAddValuation_mul` and `serrePadicIntAddValuation_add` for algebraic valuation estimates;
- `serreHenselMultivariateConclusion_of_univariateConclusion` for the later multivariate transfer once a concrete specialization is available.

Avoid using a packaged Hensel theorem or mathlib's completed `PadicInt` result.
