# Hensel next-step notes

Current branch: `work/c2-s2-2-hensel-quadratic-two`.

The core Chapter 2 §2.2 Hensel lifting theorem, Corollary 1, and odd-prime
quadratic Corollary 2 are already on `main`.  The current ACTIVE item is
Corollary 3 for dyadic quadratic lifting (#105 / PR #148).

## Continuation rule

A user instruction such as `続けて` or `形式化を続けて` means: continue this
single ACTIVE PR through the next safe Lean / Blueprint / CI / review step.
Do not stop merely because a commit or CI run has started.  Stop only for a
real proof/source/API uncertainty, a CI failure that first needs diagnosis, a
GitHub state conflict, or a context/time boundary.

## Current Lean result

The direct Hensel-facing dyadic package is in place and the determinant/primitive
residue route now reaches the inner-gradient witness.

### 1. Shared Hensel wrapper

`HenselQuadraticCorollary.lean` already contains the direct `p = 2`, `n = 3`,
`k = 1` value-lift wrapper:

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
- the bridge from first-residue nonvanishing of the inner sum to valuation `1`
  of Serre's expanded symmetric gradient;
- exact-root, congruent-lift, and combined lift extractors.

This reuses the already-proved formal derivative bridge from
`HenselQuadraticOddDerivativeBridge.lean`, specialized to `p = 2`; despite the
file name, the polynomial identity itself is prime-uniform.

### 3. Determinant/primitive-vector to inner sum

`HenselQuadraticTwoResidue.lean` adapts the Corollary 2 first-residue matrix
API to the dyadic inner sum:

- a matrix-coordinate witness for `serreFirstResidueGradientMatrix A` is exactly
  nonvanishing of the first residue of `Σᵢ aᵢⱼ xᵢ`;
- nonzero determinant plus primitive tuple gives that matrix-coordinate witness;
- unit p-adic determinant gives nonzero first-residue determinant;
- `serreQuadraticTwoDetHenselHypothesis.exists_solution_lift` packages the
  determinant-shaped dyadic value lift.

### 4. Blueprint synchronization

The Hensel Blueprint imports `HenselQuadraticTwo` and records a separate
`henselquadraticdyadicvaluecorollary` node.  This node currently cites the
expanded-gradient package; the next docs pass can retarget it to the determinant
package now that `HenselQuadraticTwoResidue.lean` is green.

## Remaining proof boundary

The main remaining source-facing bridge is to relate the source phrase
`∂f/∂X_j(x) ≠ 0 (mod 4)` to the project-local package now used in Lean.  For a
symmetric dyadic quadratic form the derivative is `2 * Σᵢ aᵢⱼ xᵢ`, so the safe
route is to express nonzero modulo `4` as nonzero first residue of the inner sum,
not as an arbitrary nonzero-mod-`4` fact about an unrelated p-adic integer.

## Verification state

- PR #148 head `9afafcef1d6adc36be8eae00583fd57d430baea7`: CI #706 green
  for policy / Lean / Verso.
- PR #148 head `107ce2912344d6dbaa1db1aeedded72b287c8f06`: CI #710 green
  for policy / Lean / Verso.  This includes `HenselQuadraticTwo.lean`, the
  formalization-root import, the dyadic Blueprint node, and notes sync.
- PR #148 head `9840ef2d1863600dc9deef232747a84f9ed380a2`: CI #715 green
  for policy / Lean / Verso.  This includes `HenselQuadraticTwoResidue.lean`
  and the determinant/primitive-vector to inner-sum bridge.

Do not begin §3 or another work item while PR #148 remains active.
