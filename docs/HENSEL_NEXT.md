# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-quadratic-odd-serial`.

The core Chapter 2 §2.2 Hensel lifting theorem and Corollary 1 are already on
main.  The current ACTIVE item is Corollary 2 for odd-prime nondegenerate
quadratic forms (#104 / PR #147).

## Continuation rule

A user instruction such as `続けて` or `形式化を続けて` means: continue this
single ACTIVE PR through the next safe Lean / Blueprint / CI / review step.
Do not stop merely because a commit or CI run has started.  Stop only for a
real proof/source/API uncertainty, a CI failure that first needs diagnosis, a
GitHub state conflict, or a context/time boundary.

## Current Lean result

The two proof boundaries that previously remained explicit are now discharged.

### 1. Formal derivative bridge

`HenselQuadraticOddDerivativeBridge.lean` proves:

- `serreQuadraticTerm_pderiv_eval`: the evaluated partial derivative of one
  quadratic monomial;
- `serreQuadraticGradientCoordinate_eq_row_add_column`: the formal derivative
  is the sum of the selected row and selected column contributions;
- `serreQuadraticGradientCoordinate_eq_symmetricExpression`: symmetry turns
  those two sums into `2 * ∑ i, A i j * x i`;
- `serreQuadraticSymmetricGradientBridge_of_symmetric`: symmetry alone
  supplies the previously explicit Hensel-facing bridge.

### 2. Determinant / primitive-vector bridge

`HenselQuadraticOdd.lean` now proves the determinant-to-coordinate step over
a commutative ring with no zero divisors, using the adjugate/determinant matrix
API rather than constructing a Field instance for the first residue ring.
Consequently:

- nonzero determinant + nonzero vector gives a nonzero matrix-vector
  coordinate;
- a primitive p-adic tuple gives a nonzero first-residue vector;
- `serreFirstResidueMatrixDetNonzeroPrimitiveBoundary_proved` discharges the
  previously named first-residue boundary.

This route avoids the earlier deterministic `whnf` timeout and residue-field
typeclass mismatch.

### 3. Coefficient determinant to first residue

`HenselQuadraticOddResidue.lean` identifies the determinant of the
first-residue gradient matrix with the first projection of the determinant of
the p-adic coefficient matrix.  Therefore a unit p-adic determinant has
nonzero first-residue determinant.

### 4. Source-shaped Corollary 2

`HenselQuadraticOddSourceConsequences.lean` exposes:

- `serreHenselValueLift_mod_p_of_odd_quadratic`;
- `serreOddQuadratic_exists_solution_lift`.

Their hypotheses are the source-shaped data for Corollary 2: odd prime,
symmetric coefficient matrix, unit determinant, primitive mod-`p` starting
tuple, and the value congruence modulo `p`.  The conclusion is an exact
`Z_p` value solution, with the constructed lift also congruent to the
starting tuple modulo `p`.

## Verification state

The derivative bridge and no-zero-divisors determinant bridge were already
accepted by PR-head Lean/CI before the final source-level assembly.  The current
head should be checked for the final policy / Lean / Verso Blueprint CI after
the Blueprint and progress synchronization commits in this run.

## Remaining work before merge

1. finish the latest PR-head CI;
2. synchronize `FORMALIZATION_PROGRESS.md`, `docs/WORK_QUEUE.md`, and
   `docs/ACTIVE_WORK.md` with the completed Corollary 2 proof;
3. self-review statement integrity, dependency integrity, source/copyright
   boundary, and near-target mathlib usage;
4. update the PR body with the final proof strategy and CI;
5. merge PR #147 when green and blocker-free;
6. after merge, clear ACTIVE state on main before beginning Corollary 3.

Do not begin the dyadic item (#105) while PR #147 remains active.
