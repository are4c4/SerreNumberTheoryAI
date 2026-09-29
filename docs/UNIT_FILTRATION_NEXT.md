# Unit filtration next-step notes

Current branch: `work/c2-s3-1-unit-filtration-serial`.

The Hensel and quadratic lifting chain through Chapter 2 §2.2 is already on `main`.  The current ACTIVE item is Chapter 2 §3.1, the unit filtration / Proposition 7 work (#108), recovered from the parked PR #125 onto latest main.

## Continuation rule

A user instruction such as `続けて` or `形式化を続けて` means: continue this single ACTIVE PR through the next safe Lean / Blueprint / CI / review step.  Do not stop merely because a commit or CI run has started.  Stop only for a real proof/source/API uncertainty, a CI failure that first needs diagnosis, a GitHub state conflict, or a context/time boundary.

## Current Lean result

The recovered and extended slice defines the source-indexed filtration in the project-local `SerrePadicInt` unit group:

- `serrePadicUnitReductionLevel`: reduction of units to one finite residue-unit level;
- `serrePadicPrincipalUnits`: `U_0 = U`, and `U_(n+1)` as the kernel of reduction modulo `p^(n+1)`;
- `mem_serrePadicPrincipalUnits_succ_iff_pow_dvd`: `u ∈ U_(n+1)` iff `p^(n+1)` divides `u - 1`;
- `serrePadicPrincipalUnits_succ_succ_le_succ`: `U_(n+2) ≤ U_(n+1)` for consecutive positive levels;
- `serrePadicPrincipalUnitsNextSubgroup`: `U_(n+2)` regarded as a subgroup of `U_(n+1)`;
- `serrePadicPrincipalUnitsSuccessiveQuotient`: the quotient carrier `U_(n+1)/U_(n+2)`;
- `serrePadicPrincipalUnitCoeff` and `serrePadicPrincipalUnitCoeffResidue`: the coefficient of `u - 1` after dividing by `p^(n+1)` and its first residue;
- `serrePadicPrincipalUnitOfCoeff`: source-shaped elements `1 + p^(n+1) x` as principal units;
- `serrePadicPrincipalUnitCoeffResidue_surjective`: every first residue appears as a coefficient residue;
- `serrePadicPrincipalUnitCoeffResidue_eq_zero_iff`: the coefficient residue is zero exactly on `U_(n+2)`;
- `serrePadicPrincipalUnitCoeffResidue_mul`: coefficient residues add under multiplication of principal units;
- `serrePadicPrincipalUnitCoeffResidueHom`: the coefficient residue as a homomorphism to the additive first residue group, encoded by `Multiplicative`;
- `serrePadicPrincipalUnitCoeffResidueHom_ker` and `serrePadicPrincipalUnitCoeffResidueHom_surjective`;
- `serrePadicPrincipalUnitsSuccessiveQuotientEquiv`: `U_(n+1)/U_(n+2)` is the additive first residue group;
- `serrePadicUnitReduction`, `serrePadicUnitReduction_surjective`, and `serrePadicUnitsQuotientPrincipalOneEquiv`: the first quotient `U/U_1 ≃ (Z/pZ)^×`.

## CI notes

- The filtration and successive-quotient layers have repeatedly passed policy / Lean / Verso CI.
- Roots-of-unity subgroup and reduction layers are now integrated.
- Head `721f7120ce88e682419ceed98a33e90558a95684` passed CI #786.
- The newest one-criterion lemmas make kernel-triviality the next focused mathematical boundary.

## Next proof boundary

The filtration, successive quotient, and roots-reduction interfaces are implemented and CI-valid. The next source-shaped boundary is proving that a `(p-1)`-st root lying in `U_1` is `1`, then using that to construct the finite complement subgroup `V` in Proposition 7:

1. prove kernel triviality for the roots-of-unity reduction;
2. package the roots subgroup → first-residue roots map as an isomorphism;
3. identify the residue-root subgroup with all first-residue units;
4. use that isomorphism as the project-local finite complement `V`;
5. then complete the internal product `U ≃ V × U_1` without importing a packaged p-adic unit decomposition theorem.

Keep §3.2 Proposition 8 separate.

## Verification plan

For each meaningful Lean slice:

1. run PR-head CI through policy / Lean / Verso;
2. if CI fails, inspect logs before changing direction;
3. keep Blueprint and progress docs synchronized with implemented declarations only;
4. preserve source-shaped statements without importing a packaged p-adic unit decomposition theorem.
