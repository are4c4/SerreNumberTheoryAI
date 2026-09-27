# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-lifting-serial`.

The source predicates, congruence API, one-step conclusion predicates, abstract multivariate-to-univariate transfer, concrete polynomial Taylor-defect algebra, Taylor-defect divisibility bookkeeping, derivative-valuation preservation under Hensel corrections, derivative `p^k * unit` factorization, and existence of a linear-cancelling correction are now in place.

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

Current local one-step ingredients now include:

- `serreHenselTaylorQuadraticFactor_all` for arbitrary polynomials;
- `serreHenselTaylorDefect_dvd_all` for turning correction depth into quadratic-remainder depth;
- `serreHensel_eval_sub_dvd_of_correction_depth` for controlling value changes under deep corrections;
- `serreHensel_derivative_valuation_add_correction` for preserving the derivative valuation under the Hensel correction;
- `serreHensel_derivative_eq_pow_mul_isUnit` for factoring the derivative as `p^k` times a unit;
- `serreHensel_exists_linear_cancel` for choosing a correction whose linear Taylor part cancels modulo `p^(n+1)`;
- `serreHenselUnivariateStepConclusion_of_linear_cancel` for packaging congruence, improved evaluation, and derivative valuation into the one-step conclusion.

Next likely local lemma shape:

```lean
-- Concrete one-step Newton improvement, with no external Taylor or cancellation hypotheses.
theorem serreHenselUnivariateStepConclusion_of_hypothesis
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serreHenselUnivariateStepConclusion p f x n k := by
  ...
```

The proof should choose `z` from `serreHensel_exists_linear_cancel`, use `serreHenselTaylorQuadraticFactor_all` for the Taylor remainder, and use `serreHensel_derivative_valuation_add_correction` for the derivative valuation.

After that, the next major block is the Cauchy-sequence iteration from one-step improvement to an exact root.

Avoid using a packaged Hensel theorem or mathlib's completed `PadicInt` result.
