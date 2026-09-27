# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-lifting-serial`.

The source predicates, congruence API, one-step conclusion predicates, abstract multivariate-to-univariate transfer, and Taylor-defect divisibility bookkeeping are in place.  The next proof step should target the one-step Newton improvement before the Cauchy-limit construction.

## 25-minute continuation mode

For this Hensel branch, a single user instruction such as `続けて` or `形式化を続けて` should normally be treated as a 25-minute continuous work budget for the current ACTIVE item.  Do not stop after a short status check unless a stop condition below is hit.

Use the following mini-loop until the 25-minute budget is used or a stop condition is hit:

1. Check latest PR head and CI.
2. If CI failed, read the failure and fix it before adding unrelated work.
3. If CI is green or pending, continue within this branch by doing the next safe Hensel subtask.
4. Do not stop merely because CI is pending; while waiting, do safe same-PR work.
5. After each meaningful Lean/Blueprint/docs commit, update the next-step notes or PR body if the continuation point changed.
6. Before responding, report latest head, CI state, and the next concrete proof slice.

Safe tasks while CI is pending:

- self-review the last Lean statements for hidden assumption strengthening;
- update Blueprint nodes to match Lean boundaries;
- update progress/next docs;
- prepare the next lemma statement, provided it does not assert an unproved mathematical fact as proved;
- inspect existing project APIs needed for valuation/divisibility/cancellation;
- update the PR body when the continuation point or run policy changed.

Stop rather than continuing if:

- the Taylor or Newton-step statement is mathematically uncertain;
- a CI failure needs log-based repair;
- a GitHub write is rejected or branch state is inconsistent;
- the next proof would require guessing source content not already checked;
- context/time limits risk leaving unverified changes;
- the user explicitly requests a shorter run or stop.

## Immediate proof target

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
- `serreHenselTaylorDefect` and `serreHenselTaylorQuadraticFactor` for the Taylor remainder interface;
- `serreHenselTaylorDefect_dvd_of_hensel_correction` for turning a quadratic Taylor remainder into the p-power depth needed by the Newton step;
- `serrePadicIntAddValuation p a = (k : ℕ∞)` for exact source valuation;
- `serrePadicInt_pow_dvd_iff_le_addValuation` for converting valuation inequalities into divisibility;
- `serrePadicIntAddValuation_mul` and `serrePadicIntAddValuation_add` for algebraic valuation estimates;
- `serreHenselMultivariateConclusion_of_univariateConclusion` for the later multivariate transfer once a concrete specialization is available.

Avoid using a packaged Hensel theorem or mathlib's completed `PadicInt` result.
