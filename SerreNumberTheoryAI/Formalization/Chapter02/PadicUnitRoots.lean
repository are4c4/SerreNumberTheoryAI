import SerreNumberTheoryAI.Formalization.Chapter02.PadicUnitFiltrationQuotient

/-!
# Roots of unity inside the project p-adic unit group

This file starts the next source-shaped layer of Serre Chapter 2, §3.1 after
the principal-unit filtration and successive quotients.  It isolates the
candidate finite complement `V`: the subgroup of units satisfying
`u^(p-1) = 1`, together with its first-residue reduction map.
-/

namespace SerreNumberTheoryAI

section PadicUnitRoots

variable (p : ℕ) [Fact p.Prime]

/--
The source candidate for the finite complement `V`: the subgroup of p-adic
units whose `(p-1)`-st power is one.
-/
def serrePadicUnitRootsOfUnity : Subgroup (SerrePadicInt p)ˣ where
  carrier := {u | u ^ (p - 1) = 1}
  one_mem' := by simp
  mul_mem' := by
    intro u v hu hv
    change u ^ (p - 1) = 1 at hu
    change v ^ (p - 1) = 1 at hv
    calc
      (u * v) ^ (p - 1) = u ^ (p - 1) * v ^ (p - 1) := by
        rw [mul_pow]
      _ = 1 := by rw [hu, hv, one_mul]
  inv_mem' := by
    intro u hu
    change u ^ (p - 1) = 1 at hu
    calc
      u⁻¹ ^ (p - 1) = (u ^ (p - 1))⁻¹ := by
        rw [inv_pow]
      _ = 1 := by rw [hu, inv_one]

@[simp]
theorem mem_serrePadicUnitRootsOfUnity
    (u : (SerrePadicInt p)ˣ) :
    u ∈ serrePadicUnitRootsOfUnity p ↔ u ^ (p - 1) = 1 :=
  Iff.rfl

/-- A source-name alias for the roots-of-unity subgroup used as `V`. -/
abbrev serrePadicTeichmuellerSubgroup : Subgroup (SerrePadicInt p)ˣ :=
  serrePadicUnitRootsOfUnity p

/-- Reduction of the candidate finite complement to the first residue units. -/
def serrePadicUnitRootsReduction :
    serrePadicUnitRootsOfUnity p →* (padicResidueRing p 0)ˣ :=
  (serrePadicUnitReduction p).comp (serrePadicUnitRootsOfUnity p).subtype

@[simp]
theorem serrePadicUnitRootsReduction_apply
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicUnitRootsReduction p u =
      serrePadicUnitReduction p (u : (SerrePadicInt p)ˣ) :=
  rfl

/-- The reduction of a `(p-1)`-st root of unity is again a `(p-1)`-st root. -/
theorem serrePadicUnitRootsReduction_pow
    (u : serrePadicUnitRootsOfUnity p) :
    (serrePadicUnitRootsReduction p u) ^ (p - 1) = 1 := by
  change (serrePadicUnitReduction p (u : (SerrePadicInt p)ˣ)) ^ (p - 1) = 1
  rw [← map_pow]
  simpa using congrArg (serrePadicUnitReduction p) u.property

/--
The kernel of the roots-of-unity reduction is its intersection with the first
principal-unit subgroup.  Proving this kernel is trivial is the next source
step toward showing that `V` maps isomorphically to the first residue units.
-/
theorem serrePadicUnitRootsReduction_ker :
    (serrePadicUnitRootsReduction p).ker =
      (serrePadicPrincipalUnits p 1).comap
        (serrePadicUnitRootsOfUnity p).subtype := by
  ext u
  change serrePadicUnitReduction p (u : (SerrePadicInt p)ˣ) = 1 ↔
    (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1
  rfl

@[simp]
theorem mem_serrePadicUnitRootsReduction_ker
    (u : serrePadicUnitRootsOfUnity p) :
    u ∈ (serrePadicUnitRootsReduction p).ker ↔
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 := by
  change serrePadicUnitReduction p (u : (SerrePadicInt p)ˣ) = 1 ↔
    (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1
  rfl

end PadicUnitRoots

end SerreNumberTheoryAI
