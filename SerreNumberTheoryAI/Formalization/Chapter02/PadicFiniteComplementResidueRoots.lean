import SerreNumberTheoryAI.Formalization.Chapter02.PadicResidueUnitRoots
import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiniteComplementTransition

/-!
# Finite complements and first residue roots

This file compares the finite residue-unit complements with the first-residue
roots-of-unity subgroup.  It packages the complement equivalence to the first
residue-unit group together with the already-formalized identification of
first-residue roots with all first-residue units.
-/

namespace SerreNumberTheoryAI

section PadicFiniteComplementResidueRoots

variable (p : ℕ) [Fact p.Prime]

/--
Every finite residue-unit complement is canonically equivalent to the subgroup
of first-residue `(p-1)`-st roots of unity.
-/
noncomputable def serrePadicFiniteUnitComplementResidueRootsEquiv (n : ℕ) :
    serrePadicFiniteUnitComplement p n ≃* serreResidueUnitRootsOfUnity p :=
  (serrePadicFiniteUnitComplementEquiv p n).trans
    (serreResidueUnitRootsOfUnityEquivUnits p).symm

/--
The finite-complement transition maps are compatible with the equivalences to
first-residue roots.
-/
theorem serrePadicFiniteUnitComplementResidueRootsEquiv_transition
    (n : ℕ) (u : serrePadicFiniteUnitComplement p (n + 1)) :
    serrePadicFiniteUnitComplementResidueRootsEquiv p n
      (serrePadicFiniteUnitComplementTransition p n u) =
        serrePadicFiniteUnitComplementResidueRootsEquiv p (n + 1) u := by
  exact congrArg (serreResidueUnitRootsOfUnityEquivUnits p).symm
    (serrePadicFiniteUnitComplementEquiv_transition_apply p n u)

end PadicFiniteComplementResidueRoots

end SerreNumberTheoryAI
