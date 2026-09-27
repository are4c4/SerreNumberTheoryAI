# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-lifting-serial`.

The source predicates and Blueprint boundary are in place.  The next proof step should target the one-step Newton improvement before the Cauchy-limit construction.

Likely local lemma shape:

```lean
-- If y = x + p^(n-k) * z, expand f.eval y around x and show the
-- remainder term is divisible by p^(2*n - 2*k).
```

Useful existing APIs:

- `padicDivisibilityDepth p n a` for `p^n ∣ a`;
- `serrePadicCongruent p n x y` for `y ≡ x (mod p^n)`;
- `serrePadicIntAddValuation p a = (k : ℕ∞)` for exact source valuation;
- `serrePadicInt_pow_dvd_iff_le_addValuation` for converting valuation inequalities into divisibility;
- `serrePadicIntAddValuation_mul` and `serrePadicIntAddValuation_add` for algebraic valuation estimates.

Avoid using a packaged Hensel theorem or mathlib's completed `PadicInt` result.
