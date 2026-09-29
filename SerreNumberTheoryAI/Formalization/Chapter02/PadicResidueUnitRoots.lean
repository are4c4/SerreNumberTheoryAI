import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiniteComplement
import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitRoots

/-!
# Roots of unity in the first residue-unit group

At the first residue level, every unit is a `(p-1)`-st root of unity because
the residue-unit group has cardinality `p - 1`.  This identifies the
residue-root subgroup used by the p-adic roots-of-unity map with the full
residue-unit group.
-/

namespace SerreNumberTheoryAI

section PadicResidueUnitRoots

variable (p : ℕ) [Fact p.Prime]

/-- In the prime residue field, every unit is a `(p-1)`-st root of unity. -/
theorem serreResidueUnitRootsOfUnity_eq_top :
    serreResidueUnitRootsOfUnity p = ⊤ := by
  ext a
  constructor
  · intro _
    trivial
  · intro _
    change a ^ (p - 1) = 1
    rw [← serrePadicFirstResidueUnits_card p]
    exact pow_card_eq_one'

/-- The first-residue root subgroup is canonically the full residue-unit group. -/
noncomputable def serreResidueUnitRootsOfUnityEquivUnits :
    serreResidueUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  (MulEquiv.subgroupCongr (serreResidueUnitRootsOfUnity_eq_top p)).trans
    Subgroup.topEquiv

/--
If the p-adic roots reduction is bijective onto residue roots, then it is an
isomorphism onto all first residue units.
-/
noncomputable def serrePadicUnitRootsReductionEquivResidueUnitsOfBijective
    (hbij : Function.Bijective (serrePadicUnitRootsReductionToResidueRoots p)) :
    serrePadicUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  (MulEquiv.ofBijective (serrePadicUnitRootsReductionToResidueRoots p) hbij).trans
    (serreResidueUnitRootsOfUnityEquivUnits p)

/--
A source-shaped conditional packaging of the finite complement map: kernel
triviality plus surjectivity onto residue roots gives an isomorphism onto all
first residue units.
-/
noncomputable def serrePadicUnitRootsReductionEquivResidueUnitsOfPrincipalOneTrivial
    (htriv : ∀ u : serrePadicUnitRootsOfUnity p,
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1)
    (hsurj : Function.Surjective (serrePadicUnitRootsReductionToResidueRoots p)) :
    serrePadicUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  serrePadicUnitRootsReductionEquivResidueUnitsOfBijective p
    ⟨serrePadicUnitRootsReductionToResidueRoots_injective_of_principal_one_trivial p htriv,
      hsurj⟩

end PadicResidueUnitRoots

end SerreNumberTheoryAI
