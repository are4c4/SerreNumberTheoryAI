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

/--
The inverse-compatible tower of finite complements, expressed as a subgroup of
all levelwise finite-complement choices.
-/
def serrePadicFiniteUnitComplementTowerSubgroup :
    Subgroup (∀ n : ℕ, serrePadicFiniteUnitComplement p n) where
  carrier := {x | ∀ n : ℕ,
    serrePadicFiniteUnitComplementTransition p n (x (n + 1)) = x n}
  one_mem' := by
    intro n
    simp [serrePadicFiniteUnitComplementTransition]
  mul_mem' := by
    intro x y hx hy n
    change serrePadicFiniteUnitComplementTransition p n
        (x (n + 1) * y (n + 1)) = x n * y n
    rw [map_mul, hx n, hy n]
  inv_mem' := by
    intro x hx n
    change serrePadicFiniteUnitComplementTransition p n
        ((x (n + 1))⁻¹) = (x n)⁻¹
    rw [map_inv, hx n]

/-- The type of compatible finite-complement towers. -/
abbrev serrePadicFiniteUnitComplementTower : Type :=
  serrePadicFiniteUnitComplementTowerSubgroup p

/-- Projection from a compatible finite-complement tower to level `n`. -/
def serrePadicFiniteUnitComplementTowerProj (n : ℕ) :
    serrePadicFiniteUnitComplementTower p →* serrePadicFiniteUnitComplement p n where
  toFun x := (x : ∀ n : ℕ, serrePadicFiniteUnitComplement p n) n
  map_one' := rfl
  map_mul' _ _ := rfl

@[simp]
theorem serrePadicFiniteUnitComplementTowerProj_apply
    (n : ℕ) (x : serrePadicFiniteUnitComplementTower p) :
    serrePadicFiniteUnitComplementTowerProj p n x =
      (x : ∀ n : ℕ, serrePadicFiniteUnitComplement p n) n :=
  rfl

/-- Project roots of unity determine a compatible finite-complement tower. -/
def serrePadicUnitRootsToFiniteComplementTower :
    serrePadicUnitRootsOfUnity p →* serrePadicFiniteUnitComplementTower p where
  toFun u :=
    ⟨fun n => serrePadicUnitRootsReductionLevelToFiniteComplement p n u,
      fun n => serrePadicUnitRootsReductionLevelToFiniteComplement_transition p n u⟩
  map_one' := by
    apply Subtype.ext
    funext n
    ext
    simp [serrePadicUnitRootsReductionLevelToFiniteComplement]
  map_mul' u v := by
    apply Subtype.ext
    funext n
    ext
    simp [serrePadicUnitRootsReductionLevelToFiniteComplement]

@[simp]
theorem serrePadicUnitRootsToFiniteComplementTower_proj
    (n : ℕ) (u : serrePadicUnitRootsOfUnity p) :
    serrePadicFiniteUnitComplementTowerProj p n
        (serrePadicUnitRootsToFiniteComplementTower p u) =
      serrePadicUnitRootsReductionLevelToFiniteComplement p n u :=
  rfl

/-- The residue-root value of a compatible finite-complement tower is independent of level. -/
theorem serrePadicFiniteUnitComplementTower_residueRoots_eq_zero
    (x : serrePadicFiniteUnitComplementTower p) (n : ℕ) :
    serrePadicFiniteUnitComplementResidueRootsEquiv p n
        (serrePadicFiniteUnitComplementTowerProj p n x) =
      serrePadicFiniteUnitComplementResidueRootsEquiv p 0
        (serrePadicFiniteUnitComplementTowerProj p 0 x) := by
  induction n with
  | zero => rfl
  | succ n ih =>
      have htrans :=
        serrePadicFiniteUnitComplementResidueRootsEquiv_transition p n
          (serrePadicFiniteUnitComplementTowerProj p (n + 1) x)
      have hx := x.property n
      change serrePadicFiniteUnitComplementTransition p n
          (serrePadicFiniteUnitComplementTowerProj p (n + 1) x) =
        serrePadicFiniteUnitComplementTowerProj p n x at hx
      rw [hx] at htrans
      rw [← htrans, ih]

/-- A compatible finite-complement tower has a well-defined first-residue-root value. -/
noncomputable def serrePadicFiniteUnitComplementTowerToResidueRoots :
    serrePadicFiniteUnitComplementTower p →* serreResidueUnitRootsOfUnity p where
  toFun x := serrePadicFiniteUnitComplementResidueRootsEquiv p 0
    (serrePadicFiniteUnitComplementTowerProj p 0 x)
  map_one' := by
    simp [serrePadicFiniteUnitComplementTowerProj]
  map_mul' x y := by
    simp [serrePadicFiniteUnitComplementTowerProj]

/-- Every first-residue root determines a compatible finite-complement tower. -/
theorem serrePadicFiniteUnitComplementTowerToResidueRoots_surjective :
    Function.Surjective (serrePadicFiniteUnitComplementTowerToResidueRoots p) := by
  intro r
  refine ⟨⟨fun n =>
      (serrePadicFiniteUnitComplementResidueRootsEquiv p n).symm r, ?_⟩, ?_⟩
  · intro n
    apply (serrePadicFiniteUnitComplementResidueRootsEquiv p n).injective
    rw [serrePadicFiniteUnitComplementResidueRootsEquiv_transition]
    simp
  · simp [serrePadicFiniteUnitComplementTowerToResidueRoots,
      serrePadicFiniteUnitComplementTowerProj]

/-- The first-residue-root value separates compatible finite-complement towers. -/
theorem serrePadicFiniteUnitComplementTowerToResidueRoots_injective :
    Function.Injective (serrePadicFiniteUnitComplementTowerToResidueRoots p) := by
  intro x y hxy
  apply Subtype.ext
  funext n
  apply (serrePadicFiniteUnitComplementResidueRootsEquiv p n).injective
  change serrePadicFiniteUnitComplementResidueRootsEquiv p n
      (serrePadicFiniteUnitComplementTowerProj p n x) =
    serrePadicFiniteUnitComplementResidueRootsEquiv p n
      (serrePadicFiniteUnitComplementTowerProj p n y)
  rw [serrePadicFiniteUnitComplementTower_residueRoots_eq_zero p x n,
    serrePadicFiniteUnitComplementTower_residueRoots_eq_zero p y n]
  exact hxy

/-- The inverse-compatible finite-complement tower is canonically the first-residue roots. -/
noncomputable def serrePadicFiniteUnitComplementTowerEquivResidueRoots :
    serrePadicFiniteUnitComplementTower p ≃* serreResidueUnitRootsOfUnity p :=
  MulEquiv.ofBijective (serrePadicFiniteUnitComplementTowerToResidueRoots p)
    ⟨serrePadicFiniteUnitComplementTowerToResidueRoots_injective p,
      serrePadicFiniteUnitComplementTowerToResidueRoots_surjective p⟩

/--
The map from project roots to the compatible finite-complement tower is
injective.  Thus the remaining inverse-limit step is only surjectivity.
-/
theorem serrePadicUnitRootsToFiniteComplementTower_injective :
    Function.Injective (serrePadicUnitRootsToFiniteComplementTower p) := by
  intro u v huv
  apply Subtype.ext
  apply Units.ext
  apply serrePadicInt_ext p
  intro n
  have hlevel :=
    congrArg (serrePadicFiniteUnitComplementTowerProj p n) huv
  have hunit := congrArg
    (fun z : serrePadicFiniteUnitComplement p n =>
      (z : (padicResidueRing p n)ˣ)) hlevel
  have hval := congrArg
    (fun z : (padicResidueRing p n)ˣ => (z : padicResidueRing p n)) hunit
  simpa [serrePadicUnitRootsToFiniteComplementTower_proj,
    serrePadicUnitRootsReductionLevelToFiniteComplement_apply,
    serrePadicUnitReductionLevel] using hval

/--
A surjectivity proof for the project-roots-to-tower map upgrades it to an
isomorphism with the compatible finite-complement tower.
-/
noncomputable def serrePadicUnitRootsEquivFiniteComplementTowerOfSurjective
    (hsurj : Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p)) :
    serrePadicUnitRootsOfUnity p ≃* serrePadicFiniteUnitComplementTower p :=
  MulEquiv.ofBijective (serrePadicUnitRootsToFiniteComplementTower p)
    ⟨serrePadicUnitRootsToFiniteComplementTower_injective p, hsurj⟩

/--
Surjectivity onto the compatible finite-complement tower gives a canonical
isomorphism from project roots to first-residue roots.
-/
noncomputable def serrePadicUnitRootsEquivResidueRootsOfTowerSurjective
    (hsurj : Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p)) :
    serrePadicUnitRootsOfUnity p ≃* serreResidueUnitRootsOfUnity p :=
  (serrePadicUnitRootsEquivFiniteComplementTowerOfSurjective p hsurj).trans
    (serrePadicFiniteUnitComplementTowerEquivResidueRoots p)

/--
Surjectivity onto the compatible finite-complement tower gives the source-shaped
finite complement equivalence `V ≃ (Z/pZ)^×`.
-/
noncomputable def serrePadicUnitRootsEquivResidueUnitsOfTowerSurjective
    (hsurj : Function.Surjective (serrePadicUnitRootsToFiniteComplementTower p)) :
    serrePadicUnitRootsOfUnity p ≃* (padicResidueRing p 0)ˣ :=
  (serrePadicUnitRootsEquivResidueRootsOfTowerSurjective p hsurj).trans
    (serreResidueUnitRootsOfUnityEquivUnits p)

end PadicUnitFiniteComplementLimit

end SerreNumberTheoryAI