# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-quadratic-odd-serial`.

The core Chapter 2 §2.2 Hensel lifting stack has been merged to main.  The
current active item is the odd-prime quadratic corollary boundary (#104 / PR
#147).  The Hensel-facing value-lift wrappers are available; this branch is now
isolating the linear-algebra input needed to use them for Serre's odd-prime
quadratic-form corollary.

## 25-minute continuation mode

For this branch, a single user instruction such as `続けて` or
`形式化を続けて` should normally be treated as a continuous work budget for the
current ACTIVE item.  Do not stop after a commit or CI startup unless a stop
condition below is hit.

Use the following mini-loop until the budget is used or a stop condition is hit:

1. Check latest PR head and CI.
2. If CI failed, read the failure and fix it before adding unrelated work.
3. If CI is green or pending, continue within this PR by doing the next safe
   odd-quadratic subtask.
4. Do not stop merely because CI is pending; while waiting, do safe same-PR
   work.
5. After each meaningful Lean/Blueprint/docs commit, update the next-step notes
   or PR body if the continuation point changed.
6. Before responding, report latest head, CI state, and the next concrete proof
   slice.

Safe tasks while CI is pending:

- self-review the last Lean statements for hidden assumption strengthening;
- keep Blueprint/progress/next docs synchronized with the actual Lean boundary;
- prepare the next lemma statement, provided it does not assert an unproved
  mathematical fact as proved;
- inspect existing project APIs for primitivity, residue fields, valuation zero,
  and matrix/nondegeneracy boundaries;
- update the PR body when the continuation point or run policy changed.

Stop rather than continuing if:

- CI fails and the next step needs log-based repair;
- a GitHub write is rejected or branch state is inconsistent;
- the determinant/nondegeneracy statement would require guessing source content
  not already checked;
- the next proof would require inventing a residue-matrix API rather than first
  exposing it explicitly;
- context/time limits risk leaving unverified changes;
- the user explicitly requests a shorter run or stop.

## Current Lean boundary

The branch currently separates three layers:

- `serreQuadraticPolynomial` and `serreQuadraticPolynomial_eval` represent and
  evaluate the coordinate quadratic form `Σᵢⱼ aᵢⱼ Xᵢ Xⱼ`.
- `serreQuadraticGradientCoordinate` is the Hensel-facing formal partial
  derivative coordinate.  `serreQuadraticSymmetricGradientExpression` records
  the expanded source expression `2 * Σᵢ aᵢⱼ xᵢ`; proving equality with the
  formal derivative is deliberately left as the next algebraic bridge rather
  than hidden inside the Hensel wrapper.
- `serreQuadraticOddHenselHypothesis` packages the odd-prime boundary after the
  determinant/primitive-vector argument has already produced a valuation-zero
  gradient witness, and
  `serreHenselValueLift_mod_p_of_odd_quadratic_hypothesis` turns that package
  into an exact `Z_p` value root.

## Immediate proof/status target

First get CI green for the stabilized Hensel-facing gradient boundary.  Then the
next mathematical work is the determinant/primitive-vector side of Serre's
quadratic corollary:

- formalize the bridge between the formal partial derivative and the expanded
  symmetric expression `2 * Σᵢ aᵢⱼ xᵢ`;
- identify or introduce a clean residue-level matrix/nondegeneracy predicate;
- prove that, for odd `p`, a primitive residue vector and nondegenerate symmetric
  coefficient matrix force some gradient coordinate to be nonzero modulo `p`;
- convert nonzero first residue into project-local valuation `0`;
- connect that witness to `serreQuadraticOddHenselHypothesis` and the existing
  Hensel value-lift theorem.

Avoid packaged Hensel theorems and avoid adding non-source assumptions to final
statements.  If the matrix API is unclear, stop at explicit definitions and
notes rather than guessing the determinant proof.
