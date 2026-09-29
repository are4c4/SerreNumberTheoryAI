# Unit filtration next-step notes

Current branch: `work/c2-s3-1-unit-filtration-serial`.

The Hensel and quadratic lifting chain through Chapter 2 §2.2 is already on `main`.  The current ACTIVE item is Chapter 2 §3.1, the unit filtration / Proposition 7 work (#108), recovered from the parked PR #125 onto latest main.

## Continuation rule

A user instruction such as `続けて` or `形式化を続けて` means: continue this single ACTIVE PR through the next safe Lean / Blueprint / CI / review step.  Do not stop merely because a commit or CI run has started.  Stop only for a real proof/source/API uncertainty, a CI failure that first needs diagnosis, a GitHub state conflict, or a context/time boundary.

## Current Lean result

The first recovered slice defines the source-indexed filtration in the project-local `SerrePadicInt` unit group:

- `serrePadicUnitReductionLevel`: reduction of units to one finite residue-unit level;
- `serrePadicPrincipalUnits`: `U_0 = U`, and `U_(n+1)` as the kernel of reduction modulo `p^(n+1)`;
- `mem_serrePadicPrincipalUnits_succ_iff_pow_dvd`: `u ∈ U_(n+1)` iff `p^(n+1)` divides `u - 1`;
- `serrePadicUnitReduction`: first reduction `U → (Z/pZ)^×`;
- `serrePadicUnitReduction_surjective`: every first-residue unit lifts to a p-adic unit;
- `serrePadicUnitsQuotientPrincipalOneEquiv`: first quotient `U/U_1 ≃ (Z/pZ)^×`.

## Next proof boundary

The next mathematical boundary is the source layer for successive quotients.  The safe target is a theorem/definition package expressing the map from `U_(n+1)` to the additive first residue of `(u - 1) / p^(n+1)`, with kernel `U_(n+2)`, eventually yielding `U_(n+1)/U_(n+2) ≃ Z/pZ`.

Do not jump directly to the finite complement subgroup `V` or `U = V × U_1` until the successive quotient layer has been validated.

## Verification plan

For each meaningful Lean slice:

1. run PR-head CI through policy / Lean / Verso;
2. if CI fails, inspect logs before changing direction;
3. keep Blueprint and progress docs synchronized with implemented declarations only;
4. preserve source-shaped statements without importing a packaged p-adic unit decomposition theorem.
