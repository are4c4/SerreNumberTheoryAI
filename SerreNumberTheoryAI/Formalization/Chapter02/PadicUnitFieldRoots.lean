import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiniteComplementLimit
import SerreNumberTheoryAI.Formalization.Chapter02.PadicField

/-!
# The (p-1)-st roots of unity in the project p-adic field

This is the corollary immediately after Proposition 7 in Serre, Chapter 2,
§3.1 (printed page 24).  It transfers the finite complement constructed in
project Z_p to its fraction field Q_p, obtaining p-1 distinct roots of one.
No packaged p-adic Teichmüller or unit-decomposition theorem is imported.
-/

namespace SerreNumberTheoryAI

section PadicUnitFieldRoots

variable (p : ℕ) [Fact p.Prime]

/-- The unit-group image of project p-adic roots in the project fraction field. -/
def serrePadicUnitRootsToField :
    serrePadicUnitRootsOfUnity p →* (SerrePadicField p)ˣ :=
  (Units.map (serrePadicIntToField p)).comp
    (serrePadicUnitRootsOfUnity p).subtype

/-- Every image is a (p-1)-st root of unity in Q_p. -/
theorem serrePadicUnitRootsToField_pow
    (u : serrePadicUnitRootsOfUnity p) :
    (serrePadicUnitRootsToField p u) ^ (p - 1) = 1 := by
  have hu : u ^ (p - 1) = 1 := by
    apply Subtype.ext
    exact u.property
  calc
    (serrePadicUnitRootsToField p u) ^ (p - 1) =
        serrePadicUnitRootsToField p (u ^ (p - 1)) := by
          rw [map_pow]
    _ = 1 := by rw [hu, map_one]

/-- Distinct project roots remain distinct in the fraction field. -/
theorem serrePadicUnitRootsToField_injective :
    Function.Injective (serrePadicUnitRootsToField p) := by
  intro u v huv
  apply Subtype.ext
  apply Units.ext
  apply serrePadicIntToField_injective p
  have hval := congrArg
    (fun z : (SerrePadicField p)ˣ => (z : SerrePadicField p)) huv
  simpa [serrePadicUnitRootsToField, Units.coe_map] using hval

/-- The first residue units parameterize pairwise distinct roots in Q_p. -/
noncomputable def serrePadicResidueUnitsToFieldRoots :
    (padicResidueRing p 0)ˣ ↪ (SerrePadicField p)ˣ where
  toFun a :=
    serrePadicUnitRootsToField p
      ((serrePadicUnitRootsReductionEquiv p).symm a)
  inj' := by
    intro a b hab
    apply (serrePadicUnitRootsReductionEquiv p).symm.injective
    exact (serrePadicUnitRootsToField_injective p) hab

/-- The roots indexed by first residue units have (p-1)-st power one. -/
theorem serrePadicResidueUnitsToFieldRoots_pow
    (a : (padicResidueRing p 0)ˣ) :
    (serrePadicResidueUnitsToFieldRoots p a) ^ (p - 1) = 1 :=
  serrePadicUnitRootsToField_pow p
    ((serrePadicUnitRootsReductionEquiv p).symm a)

/--
Serre Chapter 2, §3.1 corollary: Q_p contains at least p-1 distinct
(p-1)-st roots of unity, indexed by the p-1 elements of F_p^×.
-/
theorem serrePadicField_contains_p_sub_one_roots :
    ∃ f : (padicResidueRing p 0)ˣ ↪ (SerrePadicField p)ˣ,
      Nat.card (padicResidueRing p 0)ˣ = p - 1 ∧
        ∀ a, (f a) ^ (p - 1) = 1 := by
  refine ⟨serrePadicResidueUnitsToFieldRoots p,
    serrePadicFirstResidueUnits_card p, ?_⟩
  intro a
  exact serrePadicResidueUnitsToFieldRoots_pow p a

end PadicUnitFieldRoots

end SerreNumberTheoryAI
