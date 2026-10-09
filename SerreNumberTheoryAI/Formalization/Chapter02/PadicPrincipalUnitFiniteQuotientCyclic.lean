import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotientCard
import Mathlib.GroupTheory.SpecificGroups.Cyclic

/-!
# Cyclic presentations of the finite principal-unit quotients

After proving the cardinal of U_(n+1)/U_(n+k+2) is p^(k+1), and that
the residue class of an exact first-layer element generates it, we obtain
an explicit equivalence with the additive cyclic group Z/p^(k+1)Z,
tagged as a multiplicative group.

Compatibility of these finite equivalences with the reduction transitions
and the inverse-limit passage to the source Z_p are the next tasks.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitFiniteQuotientCyclic

variable (p : ℕ) [Fact p.Prime]

/--
The source-compatible finite cyclic presentation of U_(n+1)/U_(n+k+2),
using a generator in its first nontrivial layer.
-/
noncomputable def serrePadicPrincipalUnitFiniteQuotientCyclicEquiv
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    Multiplicative (ZMod (p ^ (k + 1))) ≃*
      serrePadicPrincipalUnitFiniteQuotient p n (k + 1) := by
  let q : serrePadicPrincipalUnitFiniteQuotient p n (k + 1) :=
    ((QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u)
  refine zmodMulEquivOfGenerator (g := q) ?_ ?_
  · intro x
    have htop :=
      serrePadicPrincipalUnitFiniteQuotient_generator_zpowers_eq_top
        p n k hsource u hnot
    change x ∈ Subgroup.zpowers q
    rw [htop]
    trivial
  · exact serrePadicPrincipalUnitFiniteQuotient_card p n (k + 1)

/-- For odd p, U₁/U_(k+2) is a cyclic group of order p^(k+1). -/
noncomputable def serrePadicPrincipalUnitFiniteQuotientOddCyclicEquiv
    (hpodd : p ≠ 2) (k : ℕ) :
    Multiplicative (ZMod (p ^ (k + 1))) ≃*
      serrePadicPrincipalUnitFiniteQuotient p 0 (k + 1) :=
  serrePadicPrincipalUnitFiniteQuotientCyclicEquiv p 0 k
    (Or.inl hpodd) (serrePadicPrincipalUnitOfCoeff p 0 1)
    (serrePadicPrincipalUnitOfCoeff_one_exactLayer p 0)

/-- For p=2, U₂/U_(k+3) is a cyclic group of order 2^(k+1). -/
noncomputable def serrePadicPrincipalUnitFiniteQuotientDyadicCyclicEquiv
    (k : ℕ) :
    Multiplicative (ZMod (2 ^ (k + 1))) ≃*
      serrePadicPrincipalUnitFiniteQuotient 2 1 (k + 1) := by
  letI : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  exact serrePadicPrincipalUnitFiniteQuotientCyclicEquiv 2 1 k
    (Or.inr (by omega)) (serrePadicPrincipalUnitOfCoeff 2 1 1)
    (serrePadicPrincipalUnitOfCoeff_one_exactLayer 2 1)

end PadicPrincipalUnitFiniteQuotientCyclic

end SerreNumberTheoryAI
