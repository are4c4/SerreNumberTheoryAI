# Unit filtration next-step notes

Current branch: `work/c2-s3-1-unit-filtration-serial`.

The Hensel and quadratic lifting chain through Chapter 2 §2.2 is already on `main`. The current ACTIVE item is Chapter 2 §3.1, the unit filtration / Proposition 7 work (#108), recovered from the parked PR #125 onto latest main.

## Continuation rule

A user instruction such as `続けて` or `形式化を続けて` means: continue this single ACTIVE PR through the next safe Lean / Blueprint / CI / review step. Do not stop merely because a commit or CI run has started. Stop only for a real proof/source/API uncertainty, a CI failure that first needs diagnosis, a GitHub state conflict, or a context/time boundary.

## Current Lean result

The recovered and extended slice defines the source-indexed filtration in the project-local `SerrePadicInt` unit group:

- `serrePadicUnitReductionLevel`: reduction of units to one finite residue-unit level;
- `serrePadicUnitReductionLevel_surjective`: every finite residue unit lifts to a project p-adic unit;
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
- `serrePadicUnitReduction`, `serrePadicUnitReduction_surjective`, and `serrePadicUnitsQuotientPrincipalOneEquiv`: the first quotient `U/U_1 ≃ (Z/pZ)^×`;
- `serrePadicUnitsQuotientPrincipalSuccEquiv`: every finite quotient `U/U_(n+1)` is the finite residue-unit group modulo `p^(n+1)`.

The roots-of-unity layer contains:

- `serrePadicUnitRootsOfUnity` and `serrePadicTeichmuellerSubgroup`;
- `serrePadicUnitRootsReduction` and `serrePadicUnitRootsReductionToResidueRoots`;
- kernel and one-fiber criteria reducing the injectivity question to membership in `U_1`;
- conditional injectivity lemmas from the pending kernel-triviality target;
- equivalences saying injectivity is exactly the same target as showing roots-of-unity elements in `U_1` are trivial.

The finite-complement layer now contains:

- `serreCoprimeKernelComplement`: the abstract finite commutative group complement cut out by `x ^ Nat.card B = 1`;
- `serreCoprimeKernelComplementEquiv`: the coprime-order splitting supplement for a surjective map of finite commutative groups;
- `serreCoprimeKernelComplement_unique_of_bijective`: uniqueness of a subgroup that maps bijectively to the quotient side;
- `serrePadicResidueUnitReductionToFirst`: finite residue-unit reduction `(Z/p^(n+1)Z)^× → (Z/pZ)^×`;
- `serrePadicFirstResidueUnits_card` and `serrePadicResidueUnits_card`: the cardinal calculations `p - 1` and `p^n * (p - 1)`;
- `serrePadicResidueUnitReductionToFirst_ker_card` and `_coprime`: the finite kernel has order `p^n` and is coprime to the first residue-unit group;
- `serrePadicFiniteUnitComplement`, `serrePadicFiniteUnitComplementEquiv`, and `serrePadicFiniteUnitComplement_unique`;
- `serrePadicFiniteUnitComplementTransition` and its compatibility with first-residue equivalences;
- `serrePadicFiniteUnitComplementResidueRootsEquiv` and its transition compatibility.

The project-roots/finite-complement comparison layer now contains:

- `serrePadicUnitRootsReductionLevelToFiniteComplement`: project `(p-1)`-st roots reduce to the distinguished finite complement at every level;
- `serrePadicUnitRootsReductionLevelToFiniteComplement_transition`: those reductions commute with adjacent finite-complement transition maps.

## CI notes

- The filtration and successive-quotient layers have repeatedly passed policy / Lean / Verso CI.
- Roots-of-unity subgroup and reduction layers are integrated.
- CI #794 validated cleanup head `49e90f8ddcc326229363cdae31ebc7ae20799987`.
- CI #796 validated the Lean conditional injectivity and injectivity-equivalence lemmas.
- CI #798 validated the Blueprint documentation of those injectivity criteria.
- CI #810 validated the finite residue-unit complement Lean layer before Blueprint/docs sync.
- CI #831 validated the finite-complement residue-roots Blueprint after the duplicate-tag fix.
- CI #835 validated the finite-complement limit Lean layer at head `474ff6bf1cdcda24b6ad349bfaa166073198fa45`.
- CI #837 validated the Blueprint inclusion for the finite-complement limit page at head `25459d3a701253f20e99b17f82a0be0d3e320a9d`.
- This docs sync should be checked against the next PR-head CI before using it as the latest validated head.

## Next proof boundary

The filtration, successive quotient, roots-reduction interfaces, finite residue-unit complement layer, residue-root comparison, and the first project-roots-to-finite-complement transition comparison are implemented. The next source-shaped boundary is to compare the project roots subgroup with the inverse-compatible finite complements strongly enough to package the finite complement `V` inside the full p-adic unit group:

1. prove kernel triviality for roots of unity lying in `U_1`;
2. package the roots subgroup → first-residue roots map as an isomorphism;
3. compare this isomorphism with the finite-complement residue-root equivalences;
4. upgrade the levelwise compatible reductions to the intended finite complement `V` picture;
5. then complete the internal product `U ≃ V × U_1` without importing a packaged p-adic unit decomposition theorem.

Keep §3.2 Proposition 8 separate.

## Verification plan

For each meaningful Lean slice:

1. run PR-head CI through policy / Lean / Verso;
2. if CI fails, inspect logs before changing direction;
3. keep Blueprint and progress docs synchronized with implemented declarations only;
4. preserve source-shaped statements without importing a packaged p-adic unit decomposition theorem;
5. if GitHub reports `mergeable_state = dirty`, treat it as a branch-state stop until the conflict state is resolved or shown to be stale by a fresh successful PR-head validation.
