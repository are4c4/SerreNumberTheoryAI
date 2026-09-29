import SerreNumberTheoryAI.Formalization.Chapter02.PadicFiniteComplementResidueRoots

/-!
# Project roots and the finite complement tower

This file records the first inverse-system comparison between the project
roots-of-unity subgroup and the finite residue-unit complements.  A project
`(p-1)`-st root reduces to the distinguished finite complement at every level,
and these reductions commute with the adjacent finite-complement transitions.
-/

namespace SerreNumberTheoryAI

section PadicUnitFiniteComplementLimit

variable (p : ℕ) [Fact p.Prime]

/--
Reduction of a project `(p-1)`-st root of unity to the finite complement at
level `n`.
-/
def serrePadicUnitRootsReductionLevelToFiniteComplement (n : ℕ) :
    serrePadicUnitRootsOfUnity p →*
      serrePadicFiniteUnitComplement p n where
  toFun u := by
    refine ⟨serrePadicUnitReductionLevel p n (u : (SerrePadicInt p)ˣ), ?_⟩
    change
      (serrePadicUnitReductionLevel p n (u : (SerrePadicInt p)ˣ)) ^
        Nat.card (padicResidueRing p 0)ˣ = 1
    rw [serrePadicFirstResidueUnits_card p]
    simpa using congrArg (serrePadicUnitReductionLevel p n) u.property
  map_one' := by
    ext
    simp [serrePadicUnitReductionLevel]
  map_mul' u v := by
    ext
    simp [serrePadicUnitReductionLevel]

@[simp]
theorem serrePadicUnitRootsReductionLevelToFiniteComplement_apply
    (n : ℕ) (u : serrePadicUnitRootsOfUnity p) :
    (serrePadicUnitRootsReductionLevelToFiniteComplement p n u :
      (padicResidueRing p n)ˣ) =
        serrePadicUnitReductionLevel p n (u : (SerrePadicInt p)ˣ) :=
  rfl

/--
The finite-complement transition maps commute with reduction of project roots.
-/
theorem serrePadicUnitRootsReductionLevelToFiniteComplement_transition
    (n : ℕ) (u : serrePadicUnitRootsOfUnity p) :
    serrePadicFiniteUnitComplementTransition p n
        (serrePadicUnitRootsReductionLevelToFiniteComplement p (n + 1) u) =
      serrePadicUnitRootsReductionLevelToFiniteComplement p n u := by
  ext
  change serrePadicResidueUnitTransition p n
      (serrePadicUnitReductionLevel p (n + 1) (u : (SerrePadicInt p)ˣ)) =
    serrePadicUnitReductionLevel p n (u : (SerrePadicInt p)ˣ)
  apply Units.ext
  change ZMod.castHom
      (show p ^ (n + 1) ∣ p ^ ((n + 1) + 1) from
        pow_dvd_pow p (Nat.le_succ (n + 1)))
      (padicResidueRing p n)
      (serrePadicIntProj p (n + 1) (u : SerrePadicInt p)) =
    serrePadicIntProj p n (u : SerrePadicInt p)
  simpa [serrePadicResidueUnitTransition, serrePadicUnitReductionLevel] using
    serrePadicIntProj_cast_of_le p (u : SerrePadicInt p)
      (m := n) (n := n + 1) (Nat.le_succ n)

end PadicUnitFiniteComplementLimit

end SerreNumberTheoryAI
