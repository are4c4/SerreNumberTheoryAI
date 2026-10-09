import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteInverseLimit

/-!
# Finite principal-unit quotients and residue projections

We relate the source's finite quotients U_(n+1)/U_(n+k+2) to the
project-local projection of p-adic units to Z/p^(n+k+2)Z.
This is an explicit bridge for the inverse-limit reconstruction.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitResidueQuotient

variable (p : ℕ) [Fact p.Prime]

/-- Residue projection of the source principal-unit subgroup at a deeper level. -/
def serrePadicPrincipalUnitResidueHom (n k : ℕ) :
    serrePadicPrincipalUnits p (n + 1) →*
      (padicResidueRing p (n + k + 1))ˣ :=
  (serrePadicUnitReductionLevel p (n + k + 1)).comp
    (serrePadicPrincipalUnits p (n + 1)).subtype

/-- Its kernel is precisely the subgroup defining the corresponding finite quotient. -/
theorem serrePadicPrincipalUnitResidueHom_ker (n k : ℕ) :
    (serrePadicPrincipalUnitResidueHom p n k).ker =
      serrePadicPrincipalUnitDeepSubgroup p n (k + 1) := by
  ext u
  rfl

/--
Two source principal units have the same finite residue if and only if
they represent the same class in the corresponding finite quotient.
-/
theorem serrePadicPrincipalUnitFiniteQuotient_mk_eq_iff_residue_eq
    (n k : ℕ) (u v : serrePadicPrincipalUnits p (n + 1)) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) v ↔
      serrePadicPrincipalUnitResidueHom p n k u =
        serrePadicPrincipalUnitResidueHom p n k v := by
  rw [QuotientGroup.eq_iff_div_mem]
  rw [← serrePadicPrincipalUnitResidueHom_ker p n k]
  change serrePadicPrincipalUnitResidueHom p n k (u / v) = 1 ↔ _
  rw [map_div]
  exact div_eq_one_iff_eq

end PadicPrincipalUnitResidueQuotient

end SerreNumberTheoryAI
