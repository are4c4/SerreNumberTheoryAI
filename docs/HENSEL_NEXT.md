# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-lifting-serial`.

The source predicates, source-aligned exact-root conclusions, congruence API, concrete one-step Hensel theorem, abstract multivariate-to-univariate transfer, concrete polynomial Taylor-defect algebra, Taylor-defect divisibility bookkeeping, derivative-valuation preservation under Hensel corrections, derivative `p^k * unit` factorization, existence of a linear-cancelling correction, finite-tail congruence API, congruence-depth Cauchy proof, metric-radius Cauchy proof, the `CauchySeq` bridge, completeness-based limit existence, retained initial congruence for the limit, finite-residue polynomial evaluation compatibility, exact-root proof for the selected limit, the one-variable source conclusion from the source hypothesis, the coordinate specialization for the multivariate reduction, the multivariate source conclusion from its source hypothesis, the `n = 1`, `k = 0` simple-root corollary packages, and the Hensel-facing value-lift packages for Serre's quadratic corollaries are now in place.

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

## Immediate proof/status target

The current source-shaped Hensel stack now includes the core boundary lemmas:

- `serreHenselUnivariateStepConclusion_of_hypothesis`;
- `serreHenselIterateSeq_cauchySeq`;
- `serreHenselIterateSeq_exists_tendsto`;
- `serreHenselIterateLimit_initial_congruent`;
- `serreHenselIterateLimit_is_root`;
- `serreHenselUnivariateConclusion_of_hypothesis`;
- `serreHenselCoordinateSpecialization`;
- `serreHenselCoordinateSpecialization_eval`;
- `serreHenselCoordinateSpecialization_derivative_eval`;
- `serreHenselMultivariateConclusion_of_hypothesis`;
- `serreHenselUnivariateSimpleRootConclusion_of_hypothesis`;
- `serreHenselMultivariateSimpleRootConclusion_of_hypothesis`;
- `serreHenselValueLift_mod_p_of_simple_derivative`;
- `serreHenselValueLift_mod_eight_of_derivative_valuation_one`.

The next mathematical work is the determinant/primitive-vector side of Serre's quadratic corollaries:

- define or identify the project API for symmetric coefficient matrices and the quadratic polynomial `Σ a_ij X_i X_j`;
- prove, for odd `p`, that a primitive solution and an invertible coefficient matrix force some partial derivative to have valuation `0`;
- prove, for `p = 2`, the corresponding derivative-valuation-one boundary from the mod `8`/mod `4` assumptions;
- then connect those derivative-existence lemmas to the value-lift theorems above.

This is a genuine new linear-algebra boundary.  Stop before implementing it if the available matrix/quadratic-form API is unclear or if the source statement would need to be guessed.

Avoid packaged Hensel theorems and avoid adding non-source assumptions to the final statements.
