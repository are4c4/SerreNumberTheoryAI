import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiniteComplement

/-!
# Transition maps between finite p-adic unit complements

This file records that the adjacent transition maps between Serre's finite
residue-unit complements are bijections.  This is a small bridge toward the
inverse-compatible finite-complement tower used to identify the project
roots-of-unity subgroup.
-/

namespace SerreNumberTheoryAI

section PadicUnitFiniteComplementTransition

variable (p : ℕ) [Fact p.Prime]

/-- The adjacent finite-complement transition is injective. -/
theorem serrePadicFiniteUnitComplementTransition_injective (n : ℕ) :
    Function.Injective (serrePadicFiniteUnitComplementTransition p n) := by
  intro u v huv
  apply (serrePadicFiniteUnitComplementTransitionEquiv p n).injective
  simpa [serrePadicFiniteUnitComplementTransitionEquiv_apply] using huv

/-- The adjacent finite-complement transition is surjective. -/
theorem serrePadicFiniteUnitComplementTransition_surjective (n : ℕ) :
    Function.Surjective (serrePadicFiniteUnitComplementTransition p n) := by
  intro v
  obtain ⟨u, rfl⟩ :=
    (serrePadicFiniteUnitComplementTransitionEquiv p n).surjective v
  refine ⟨u, ?_⟩
  simpa [serrePadicFiniteUnitComplementTransitionEquiv_apply]

/-- The adjacent finite-complement transition is bijective. -/
theorem serrePadicFiniteUnitComplementTransition_bijective (n : ℕ) :
    Function.Bijective (serrePadicFiniteUnitComplementTransition p n) :=
  ⟨serrePadicFiniteUnitComplementTransition_injective p n,
    serrePadicFiniteUnitComplementTransition_surjective p n⟩

end PadicUnitFiniteComplementTransition

end SerreNumberTheoryAI
