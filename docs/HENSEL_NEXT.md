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

The branch currently separates nine layers:

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
- The residue linear-algebra side has generic field-level nonvanishing lemmas:
  an invertible matrix, or a matrix with nonzero determinant, sends a nonzero
  vector to a vector with some nonzero coordinate.
- The first-residue side names the lightweight project-specific API:
  `serreFirstResidueVector`,
  `serreFirstResidueVector_ne_zero_of_primitive`,
  `serreFirstResidueMatrixCoordinateWitness`, and
  `serreFirstResidueMatrixDetNonzeroPrimitiveBoundary`.
- `HenselQuadraticOddResidue.lean` adds the first-residue gradient bridge:
  nonzero first residue implies `serrePadicIntAddValuation = 0`, the expanded
  symmetric gradient projects to the first-residue gradient matrix-vector
  coordinate with the explicit source factor `2`, oddness of `p` makes that
  projected factor nonzero, and a matrix-coordinate witness yields the
  valuation-zero expression witness.
- The same file packages these first-residue witnesses back into the Hensel
  value-lift API via
  `serreQuadraticOddFirstResidueGradientHenselHypothesis`,
  `serreQuadraticOddMatrixCoordinateHenselHypothesis`, and their exact-root /
  congruent-lift extractors.
- It also threads the named determinant boundary through the same API via
  `serreQuadraticOddDetBoundaryHenselHypothesis`,
  `serreQuadraticOddMatrixCoordinateHenselHypothesis_of_detBoundary`,
  `serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis`, and
  determinant-boundary exact-root / congruent-lift extractors.
- `HenselQuadraticOddResidueExtractors.lean` exposes composite convenience
  consequences: matrix-coordinate / determinant-boundary data directly produce
  the expanded-expression witness, and each odd-quadratic Hensel package has a
  combined `exists_solution_lift` extractor returning one lift with both the
  exact value equation and the congruence data.

## Immediate proof/status target

The current stable boundary keeps the direct specialization of the generic
field-level determinant lemma out of the first-residue theorem path.  A direct
proof of the determinant-to-coordinate witness over `padicResidueRing p 0`
reproduced the earlier deterministic `whnf` heartbeat timeout, so the active
boundary is now named explicitly as
`serreFirstResidueMatrixDetNonzeroPrimitiveBoundary` rather than hidden in a
slow proof.

The first-residue valuation and Hensel bridge now consists of:

- `serrePadicIntAddValuation_eq_zero_of_firstResidue_ne_zero`;
- `serreFirstResidue_two_ne_zero_of_ne_two`, `serrePadicIntProj_two`, and
  `serrePadicIntProj_two_ne_zero_of_ne_two`;
- `serreFirstResidueGradientMatrix` and
  `serreFirstResidueGradientMatrix_mulVec`;
- `serreQuadraticSymmetricGradientExpression_firstResidue`;
- `serreQuadraticOddFirstResidueExpressionWitness` and
  `serreQuadraticOddFirstResidueGradientWitness`;
- `serreQuadraticOddFirstResidueGradientWitness_of_matrixCoordinateWitness`;
- `serreQuadraticOddExpressionWitness_of_firstResidueGradientWitness`;
- `serreQuadraticOddExpressionWitness_of_matrixCoordinateWitness`;
- `serreQuadraticOddExpressionWitness_of_detBoundary`;
- `serreQuadraticOddExpressionHenselHypothesis_of_firstResidueGradient`;
- `serreQuadraticOddFirstResidueGradientHenselHypothesis_of_matrixCoordinate`;
- `serreQuadraticOddMatrixCoordinateHenselHypothesis_of_detBoundary`;
- `serreHenselValueLift_mod_p_of_odd_quadratic_firstResidueGradient_hypothesis`;
- `serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis`;
- `serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis`;
- combined `exists_solution_lift` extractors for the Hensel, expression,
  first-residue, matrix-coordinate, and determinant-boundary packages.

Latest verified Lean status:

- PR head `90f98ac48633cc47bf565745868305e1b5298981` passed CI #659: policy,
  Lean build, and Verso Blueprint build.

Next safe slices:

- identify a lighter representation or existing API for the first residue ring
  before reintroducing the determinant-to-coordinate proof;
- keep the determinant/nonzero-vector bridge as a separate lemma rather than
  expanding it inside the odd-quadratic Hensel package;
- formalize the bridge between the formal partial derivative and the expanded
  symmetric expression `2 * Σᵢ aᵢⱼ xᵢ`;
- once the derivative bridge is proved, reduce the remaining source boundary to
  determinant/nonzero-vector plus primitive first-residue nonvanishing.

Avoid packaged Hensel theorems and avoid adding non-source assumptions to final
statements.  If the matrix API is unclear, stop at explicit definitions and
notes rather than guessing the determinant proof.
