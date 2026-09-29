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
  apply Subtype.ext
  apply Units.ext
  change ZMod.castHom
      (show p ^ (n + 1) ∣ p ^ ((n + 1) + 1) from
        pow_dvd_pow p (Nat.le_succ (n + 1)))
      (padicResidueRing p n)
      (serrePadicIntProj p (n + 1)
        ((u : (SerrePadicInt p)ˣ) : SerrePadicInt p)) =
    serrePadicIntProj p n
      ((u : (SerrePadicInt p)ˣ) : SerrePadicInt p)
  simpa [serrePadicResidueUnitTransition, serrePadicUnitReductionLevel] using
    serrePadicIntProj_cast_of_le p
      ((u : (SerrePadicInt p)ˣ) : SerrePadicInt p)
      (m := n) (n := n + 1) (Nat.le_succ n)

/--
If the finite-complement reductions of a project root are all one, then the
project root itself is one.
-/
theorem serrePadicUnitRoots_eq_one_of_reductions_eq_one
    (u : serrePadicUnitRootsOfUnity p)
    (hred : ∀ n : ℕ,
      serrePadicUnitRootsReductionLevelToFiniteComplement p n u = 1) :
    u = 1 := by
  apply Subtype.ext
  apply Units.ext
  apply serrePadicInt_ext p
  intro n
  have hunit :
      serrePadicUnitReductionLevel p n (u : (SerrePadicInt p)ˣ) = 1 := by
    have h := congrArg
      (fun v : serrePadicFiniteUnitComplement p n =>
        (v : (padicResidueRing p n)ˣ)) (hred n)
    simpa [serrePadicUnitRootsReductionLevelToFiniteComplement_apply] using h
  have hval := congrArg
    (fun z : (padicResidueRing p n)ˣ => (z : padicResidueRing p n)) hunit
  simpa [serrePadicUnitReductionLevel] using hval

/--
If the level-zero finite-complement reduction of a project root is one, then
all finite-complement reductions are one.
-/
theorem serrePadicUnitRootsReductionLevelToFiniteComplement_eq_one_of_zero
    (u : serrePadicUnitRootsOfUnity p)
    (h0 : serrePadicUnitRootsReductionLevelToFiniteComplement p 0 u = 1) :
    ∀ n : ℕ, serrePadicUnitRootsReductionLevelToFiniteComplement p n u = 1 := by
  intro n
  induction n with
  | zero => exact h0
  | succ n ih =>
      apply serrePadicFiniteUnitComplementTransition_injective p n
      rw [serrePadicUnitRootsReductionLevelToFiniteComplement_transition, ih]
      simp

/--
A project `(p-1)`-st root of unity lying in the first principal-unit subgroup
is trivial.
-/
theorem serrePadicUnitRoots_principal_one_trivial :
    ∀ u : serrePadicUnitRootsOfUnity p,
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1 := by
  intro u hu
  have hred0 : serrePadicUnitRootsReduction p u = 1 :=
    (serrePadicUnitRootsReduction_eq_one_iff p u).2 hu
  have h0 :
      serrePadicUnitRootsReductionLevelToFiniteComplement p 0 u = 1 := by
    apply Subtype.ext
    change serrePadicUnitReductionLevel p 0 (u : (SerrePadicInt p)ˣ) = 1
    simpa [serrePadicUnitRootsReduction, serrePadicUnitReduction] using hred0
  exact serrePadicUnitRoots_eq_one_of_reductions_eq_one p u
    (serrePadicUnitRootsReductionLevelToFiniteComplement_eq_one_of_zero p u h0)

/-- The roots-of-unity reduction to first residue units is injective. -/
theorem serrePadicUnitRootsReduction_injective :
    Function.Injective (serrePadicUnitRootsReduction p) :=
  serrePadicUnitRootsReduction_injective_of_principal_one_trivial p
    (serrePadicUnitRoots_principal_one_trivial p)

/-- The roots-of-unity reduction to first-residue roots is injective. -/
theorem serrePadicUnitRootsReductionToResidueRoots_injective :
    Function.Injective (serrePadicUnitRootsReductionToResidueRoots p) :=
  serrePadicUnitRootsReductionToResidueRoots_injective_of_principal_one_trivial p
    (serrePadicUnitRoots_principal_one_trivial p)

/-- The ordinary roots-of-unity reduction has trivial one-fiber. -/
theorem serrePadicUnitRootsReduction_eq_one_iff_eq_one
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicUnitRootsReduction p u = 1 ↔ u = 1 := by
  constructor
  · intro hred
    exact serrePadicUnitRoots_principal_one_trivial p u
      ((serrePadicUnitRootsReduction_eq_one_iff p u).1 hred)
  · intro hu
    rw [hu, map_one]

/-- The narrowed roots-of-unity reduction has trivial one-fiber. -/
theorem serrePadicUnitRootsReductionToResidueRoots_eq_one_iff_eq_one
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicUnitRootsReductionToResidueRoots p u = 1 ↔ u = 1 := by
  constructor
  · intro hred
    exact serrePadicUnitRoots_principal_one_trivial p u
      ((serrePadicUnitRootsReductionToResidueRoots_eq_one_iff p u).1 hred)
  · intro hu
    rw [hu, map_one]

/-- The ordinary roots-of-unity reduction has trivial kernel. -/
theorem serrePadicUnitRootsReduction_ker_eq_bot :
    (serrePadicUnitRootsReduction p).ker = ⊥ := by
  ext u
  change serrePadicUnitRootsReduction p u = 1 ↔ u = 1
  exact serrePadicUnitRootsReduction_eq_one_iff_eq_one p u

/-- The narrowed roots-of-unity reduction has trivial kernel. -/
theorem serrePadicUnitRootsReductionToResidueRoots_ker_eq_bot :
    (serrePadicUnitRootsReductionToResidueRoots p).ker = ⊥ := by
  ext u
  change serrePadicUnitRootsReductionToResidueRoots p u = 1 ↔ u = 1
  exact serrePadicUnitRootsReductionToResidueRoots_eq_one_iff_eq_one p u

/--
If the narrowed reduction is onto first-residue roots, then it is an
isomorphism onto that subgroup.
-/
noncomputable def serrePadicUnitRootsReductionToResidueRootsEquivOfSurjective
    (hsurj : Function.Surjective (serrePadicUnitRootsReductionToResidueRoots p)) :
    serrePadicUnitRootsOfUnity p ≃* serreResidueUnitRootsOfUnity p :=
  MulEquiv.ofBijective (serrePadicUnitRootsReductionToResidueRoots p)
    ⟨serrePadicUnitRootsReductionToResidueRoots_injective p, hsurj⟩

/--
A surjectivity proof for the narrowed reduction upgrades the roots subgroup to
an isomorphism with all first residue units.
-/
noncomputable def serrePadicUnitRootsReductionEquivResidueUnitsOfSurjective
    (hsurj : Function.Surjective (serrePadicUnitRootsReductionToResidueRoots p)) :
    serrePadicUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  (serrePadicUnitRootsReductionToResidueRootsEquivOfSurjective p hsurj).trans
    (serreResidueUnitRootsOfUnityEquivUnits p)

end PadicUnitFiniteComplementLimit

end SerreNumberTheoryAI
