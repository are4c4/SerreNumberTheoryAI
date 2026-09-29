import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltration
import Mathlib.GroupTheory.QuotientGroup.Basic

/-!
# Successive quotients for the principal-unit filtration

This file packages the coefficient-residue calculation from `PadicUnitFiltration`
as the first-isomorphism-theorem statement for the source successive quotient.
-/

namespace SerreNumberTheoryAI

section PadicUnitFiltrationQuotient

variable (p : ℕ) [Fact p.Prime]

/--
The coefficient-residue map as a homomorphism from the multiplicative
principal-unit group to the additive first residue group, encoded by
`Multiplicative`.
-/
noncomputable def serrePadicPrincipalUnitCoeffResidueHom (n : ℕ) :
    serrePadicPrincipalUnits p (n + 1) →*
      Multiplicative (padicResidueRing p 0) where
  toFun u := Multiplicative.ofAdd (serrePadicPrincipalUnitCoeffResidue p n u)
  map_one' := by
    change serrePadicPrincipalUnitCoeffResidue p n 1 = 0
    exact (serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n 1).2 (by simp)
  map_mul' u v := by
    change serrePadicPrincipalUnitCoeffResidue p n (u * v) =
      serrePadicPrincipalUnitCoeffResidue p n u +
        serrePadicPrincipalUnitCoeffResidue p n v
    exact serrePadicPrincipalUnitCoeffResidue_mul p n u v

/-- The coefficient-residue homomorphism has exactly the next filtration level as kernel. -/
theorem serrePadicPrincipalUnitCoeffResidueHom_ker (n : ℕ) :
    (serrePadicPrincipalUnitCoeffResidueHom p n).ker =
      serrePadicPrincipalUnitsNextSubgroup p n := by
  ext u
  change (serrePadicPrincipalUnitCoeffResidueHom p n) u = 1 ↔
    ((u : (SerrePadicInt p)ˣ) ∈
      serrePadicPrincipalUnits p (n + 2))
  change serrePadicPrincipalUnitCoeffResidue p n u = 0 ↔
    ((u : (SerrePadicInt p)ˣ) ∈
      serrePadicPrincipalUnits p (n + 2))
  exact serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n u

/-- The coefficient-residue homomorphism is onto the first residue ring. -/
theorem serrePadicPrincipalUnitCoeffResidueHom_surjective (n : ℕ) :
    Function.Surjective (serrePadicPrincipalUnitCoeffResidueHom p n) := by
  intro a
  obtain ⟨u, hu⟩ :=
    serrePadicPrincipalUnitCoeffResidue_surjective p n a.toAdd
  refine ⟨u, ?_⟩
  simpa [serrePadicPrincipalUnitCoeffResidueHom] using
    congrArg Multiplicative.ofAdd hu

/--
The source successive quotient:
`U_(n+1) / U_(n+2)` is the additive first residue group.
-/
noncomputable def serrePadicPrincipalUnitsSuccessiveQuotientEquiv
    (n : ℕ) :
    serrePadicPrincipalUnitsSuccessiveQuotient p n ≃*
      Multiplicative (padicResidueRing p 0) := by
  exact
    (QuotientGroup.quotientMulEquivOfEq
      (serrePadicPrincipalUnitCoeffResidueHom_ker p n).symm).trans
      (QuotientGroup.quotientKerEquivOfSurjective
        (serrePadicPrincipalUnitCoeffResidueHom p n)
        (serrePadicPrincipalUnitCoeffResidueHom_surjective p n))

end PadicUnitFiltrationQuotient

end SerreNumberTheoryAI
