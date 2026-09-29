# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-quadratic-two`.

The core Chapter 2 §2.2 Hensel lifting theorem, Corollary 1, and odd-prime quadratic Corollary 2 are already on `main`.  The current ACTIVE item is Corollary 3 for dyadic quadratic lifting (#105 / PR #148).

## Continuation rule

A user instruction such as `続けて` or `形式化を続けて` means: continue this single ACTIVE PR through the next safe Lean / Blueprint / CI / review step.  Do not stop merely because a commit or CI run has started.  Stop only for a real proof/source/API uncertainty, a CI failure that first needs diagnosis, a GitHub state conflict, or a context/time boundary.

## Current Lean result

The dyadic quadratic lifting chain now reaches the source-shaped determinant/primitivity statement.

### 1. Shared Hensel wrapper

`HenselQuadraticCorollary.lean` contains the direct `p = 2`, `n = 3`, `k = 1` value-lift wrapper:

- value congruence depth `3`, i.e. modulo `8`;
- selected derivative valuation exactly `1`;
- conclusion depth `2`, i.e. congruent modulo `4`.

The PR adds coordinate-quadratic wrappers around this boundary:

- `serreQuadraticTwoGradientWitness`;
- `serreHenselValueLift_mod_eight_of_quadratic_gradient`;
- `serreHenselValueLift_mod_eight_of_symmetric_quadratic_gradient`;
- `serreQuadraticTwoHenselHypothesis`;
- exact-root, congruent-lift, and combined lift extractors.

### 2. Expanded-gradient and inner-sum packages

`HenselQuadraticTwo.lean` exposes:

- `serrePadicIntAddValuation_two`, proving `v₂(2)=1`;
- `serreQuadraticTwoExpressionWitness` and its Hensel package;
- `serreQuadraticTwoInnerSumWitness` and its Hensel package;
- the bridge from first-residue nonvanishing of the inner sum to valuation `1` of Serre's expanded symmetric gradient;
- exact-root, congruent-lift, and combined lift extractors.

This reuses the already-proved formal derivative bridge from `HenselQuadraticOddDerivativeBridge.lean`, specialized to `p = 2`; despite the file name, the polynomial identity itself is prime-uniform.

### 3. Determinant/primitive-vector to dyadic inner sum

`HenselQuadraticTwoResidue.lean` adapts the Corollary 2 first-residue matrix API to the dyadic inner sum:

- a matrix-coordinate witness for `serreFirstResidueGradientMatrix A` is exactly nonvanishing of the first residue of `Σᵢ aᵢⱼ xᵢ`;
- nonzero determinant plus primitive tuple gives that matrix-coordinate witness;
- unit p-adic determinant gives nonzero first-residue determinant;
- `serreHenselValueLift_mod_eight_of_quadratic_two` packages the determinant-shaped value lift;
- `serreDyadicQuadratic_exists_solution_lift` is the current source-facing Corollary 3 consequence, returning one exact value solution congruent to the initial tuple modulo `4`.

### 4. Blueprint synchronization

The Hensel Blueprint now imports `HenselQuadraticTwoResidue` and retargets `henselquadraticdyadicvaluecorollary` to `SerreNumberTheoryAI.serreDyadicQuadratic_exists_solution_lift`.

## Source-boundary note

The source phrase `∂f/∂X_j(x) ≠ 0 (mod 4)` is represented in this PR through the proved symmetric-gradient decomposition.  For a symmetric dyadic quadratic form the derivative is `2 * Σᵢ aᵢⱼ xᵢ`; the Lean route proves that nonzero first residue of the inner sum gives additive valuation `1` of the derivative.  The determinant/primitivity argument supplies exactly this inner-sum first-residue nonvanishing.  This avoids inventing a second congruence predicate for arbitrary nonzero modulo `4` statements.

## Verification state

- PR #148 head `9afafcef1d6adc36be8eae00583fd57d430baea7`: CI #706 green for policy / Lean / Verso.
- PR #148 head `107ce2912344d6dbaa1db1aeedded72b287c8f06`: CI #710 green for policy / Lean / Verso.
- PR #148 head `9840ef2d1863600dc9deef232747a84f9ed380a2`: CI #715 green for policy / Lean / Verso.
- PR #148 head `f103c83fbafa65a1e06eea10a63757c35ddd5071`: CI #721 green for policy / Lean / Verso.
- Latest docs/Blueprint-sync head after this note should be checked before merge.

## Remaining work before merge

1. finish latest-head CI;
2. synchronize `FORMALIZATION_PROGRESS.md`, `docs/ACTIVE_WORK.md`, and `docs/WORK_QUEUE.md` to the completed pre-merge state;
3. update the PR body with final theorem names, proof route, and latest CI;
4. self-review statement integrity, source/copyright boundary, and theorem-strength boundary;
5. mark PR #148 ready and merge when green and blocker-free;
6. after merge, clear ACTIVE state on main before beginning §3 work.

Do not begin §3 or another work item while PR #148 remains active.
