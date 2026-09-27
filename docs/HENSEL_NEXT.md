# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-lifting-serial`.

The source predicates, source-aligned exact-root conclusions, congruence API, concrete one-step Hensel theorem, abstract multivariate-to-univariate transfer, concrete polynomial Taylor-defect algebra, Taylor-defect divisibility bookkeeping, derivative-valuation preservation under Hensel corrections, derivative `p^k * unit` factorization, existence of a linear-cancelling correction, finite-tail congruence API, congruence-depth Cauchy proof, and metric-radius Cauchy proof for the iterate sequence are now in place.

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

The one-step Newton improvement is now proved from the source hypothesis alone, and the chosen iterate sequence has the key algebraic tail congruence and Cauchy-radius lemmas:

- `serreHenselIterateSeq_eval_dvd`;
- `serreHenselIterateSeq_derivative_valuation`;
- `serreHenselIterateSeq_congruent_add`;
- `serreHenselIterateSeq_congruent_of_le`;
- `serreHenselIterateSeq_initial_congruent`;
- `serreHenselIterateSeq_tail_congruent_of_le_depth`;
- `serrePadicCongruent_dist_le_radius`;
- `serrePadicCongruenceCauchy`;
- `serreHenselIterateSeq_congruence_cauchy`;
- `serrePadicMetricRadiusCauchy`;
- `serrePadicMetricRadiusCauchy_of_congruenceCauchy`;
- `serreHenselIterateSeq_metric_radius_cauchy`.

Next audit and implement the actual metric/completeness bridge.  In particular:

- inspect the exact `CauchySeq` or filter form required by the available `CompleteSpace` instance;
- translate `serreHenselIterateSeq_metric_radius_cauchy` into that metric Cauchy predicate;
- obtain the limit by completeness;
- prove the limit is a root by using the increasing divisibility depths of `f(y_r)` and continuity/polynomial evaluation API;
- keep the final conclusion source-shaped: exact root plus congruence to the original approximation.

Do not introduce a second p-adic metric/completeness interface if the existing project API already supplies the needed statements.  Avoid packaged Hensel theorems.
