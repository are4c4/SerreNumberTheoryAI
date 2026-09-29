import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitRoots
import Mathlib.FieldTheory.Finite.Basic

/-!
# Roots of unity in the first residue-unit group

At the first residue level, Fermat's little theorem says that every nonzero
residue class is a `(p-1)`-st root of unity.  This identifies the residue-root
subgroup used by the p-adic roots-of-unity map with the full residue-unit group.
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
    simpa [padicResidueRing] using
      ZMod.units_pow_card_sub_one_eq_one p a

end PadicResidueUnitRoots

end SerreNumberTheoryAI
