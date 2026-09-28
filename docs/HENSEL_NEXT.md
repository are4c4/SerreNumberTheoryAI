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

The direct Hensel-facing dyadic package is in place.

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

### 2. Expanded-gradient package

`HenselQuadraticTwo.lean` exposes the source-shaped expanded-gradient version:

- `serreQuadraticTwoExpressionWitness`;
- `serreQuadraticTwoExpressionHenselHypothesis`;
- `serreQuadraticTwoHenselHypothesis_of_expression`;
- `serreHenselValueLift_mod_eight_of_quadratic_two_expression_hypothesis`;
- exact-root, congruent-lift, and combined lift extractors.

This reuses the already-proved formal derivative bridge from
`HenselQuadraticOddDerivativeBridge.lean`, specialized to `p = 2`; despite the
file name, the polynomial identity itself is prime-uniform.

### 3. Blueprint synchronization

The Hensel Blueprint now imports `HenselQuadraticTwo` and records a separate
`henselquadraticdyadicvaluecorollary` node.  This node states only the current
Hensel-facing result: value congruence mod `8` plus expanded-gradient valuation
`1` gives an exact lift congruent mod `4`.

## Remaining proof boundaries

Two source-facing bridges remain, and neither should be hidden by strengthening
hypotheses silently.

1. Bridge the source condition `∂f/∂X_j(x) ≠ 0 (mod 4)` to the project-local
   additive valuation equation `v₂(∂f/∂X_j(x)) = 1`.
2. Adapt the determinant/primitive-vector argument from Corollary 2 to the
   dyadic situation.  Because the symmetric gradient is `2 * Σ_i a_ij x_i`, the
   first-residue nonvanishing should apply to the inner sum, and then the factor
   `2` must raise valuation from `0` to `1`.

## Verification state

- PR #148 head `9afafcef1d6adc36be8eae00583fd57d430baea7`: CI #706 green
  for policy / Lean / Verso.
- Later commits add `HenselQuadraticTwo.lean`, import it from the formalization
  root, and synchronize the Blueprint.  Check the latest PR-head CI before
  moving to the next source bridge.

Do not begin §3 or another work item while PR #148 remains active.
