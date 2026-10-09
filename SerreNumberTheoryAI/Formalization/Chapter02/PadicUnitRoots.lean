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
The first-residue analogue of the source roots-of-unity subgroup: units of the
prime residue ring satisfying the same `(p-1)`-st root equation.
-/
def serreResidueUnitRootsOfUnity : Subgroup (padicResidueRing p 0)ˣ where
  carrier := {a | a ^ (p - 1) = 1}
  one_mem' := by simp
  mul_mem' := by
    intro a b ha hb
    change a ^ (p - 1) = 1 at ha
    change b ^ (p - 1) = 1 at hb
    calc
      (a * b) ^ (p - 1) = a ^ (p - 1) * b ^ (p - 1) := by
        rw [mul_pow]
      _ = 1 := by rw [ha, hb, one_mul]
  inv_mem' := by
    intro a ha
    change a ^ (p - 1) = 1 at ha
    calc
      a⁻¹ ^ (p - 1) = (a ^ (p - 1))⁻¹ := by
        rw [inv_pow]
      _ = 1 := by rw [ha, inv_one]

@[simp]
theorem mem_serreResidueUnitRootsOfUnity
    (a : (padicResidueRing p 0)ˣ) :
    a ∈ serreResidueUnitRootsOfUnity p ↔ a ^ (p - 1) = 1 :=
  Iff.rfl

/-- The same reduction map, with codomain narrowed to residue roots of unity. -/
def serrePadicUnitRootsReductionToResidueRoots :
    serrePadicUnitRootsOfUnity p →* serreResidueUnitRootsOfUnity p where
  toFun u :=
    ⟨serrePadicUnitRootsReduction p u, serrePadicUnitRootsReduction_pow p u⟩
  map_one' := by
    ext
    simp [serrePadicUnitRootsReduction]
  map_mul' u v := by
    ext
    simp [serrePadicUnitRootsReduction]

@[simp]
theorem serrePadicUnitRootsReductionToResidueRoots_apply
    (u : serrePadicUnitRootsOfUnity p) :
    (serrePadicUnitRootsReductionToResidueRoots p u : (padicResidueRing p 0)ˣ) =
      serrePadicUnitRootsReduction p u :=
  rfl

/-- Narrowing the codomain to residue roots does not change the kernel. -/
theorem serrePadicUnitRootsReductionToResidueRoots_ker :
    (serrePadicUnitRootsReductionToResidueRoots p).ker =
      (serrePadicUnitRootsReduction p).ker := by
  ext u
  constructor
  · intro hu
    change (serrePadicUnitRootsReductionToResidueRoots p) u = 1 at hu
    simpa using congrArg
      (fun a : serreResidueUnitRootsOfUnity p =>
        (a : (padicResidueRing p 0)ˣ)) hu
  · intro hu
    change serrePadicUnitRootsReduction p u = 1 at hu
    exact Subtype.ext hu

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

/-- Kernel identification for the narrowed codomain version of reduction. -/
theorem serrePadicUnitRootsReductionToResidueRoots_ker_principal :
    (serrePadicUnitRootsReductionToResidueRoots p).ker =
      (serrePadicPrincipalUnits p 1).comap
        (serrePadicUnitRootsOfUnity p).subtype := by
  rw [serrePadicUnitRootsReductionToResidueRoots_ker,
    serrePadicUnitRootsReduction_ker]

@[simp]
theorem mem_serrePadicUnitRootsReduction_ker
    (u : serrePadicUnitRootsOfUnity p) :
    u ∈ (serrePadicUnitRootsReduction p).ker ↔
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 := by
  change serrePadicUnitReduction p (u : (SerrePadicInt p)ˣ) = 1 ↔
    (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1
  rfl

@[simp]
theorem mem_serrePadicUnitRootsReductionToResidueRoots_ker
    (u : serrePadicUnitRootsOfUnity p) :
    u ∈ (serrePadicUnitRootsReductionToResidueRoots p).ker ↔
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 := by
  rw [serrePadicUnitRootsReductionToResidueRoots_ker,
    mem_serrePadicUnitRootsReduction_ker]

@[simp]
theorem serrePadicUnitRootsReduction_eq_one_iff
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicUnitRootsReduction p u = 1 ↔
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 := by
  change u ∈ (serrePadicUnitRootsReduction p).ker ↔
    (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1
  exact mem_serrePadicUnitRootsReduction_ker p u

@[simp]
theorem serrePadicUnitRootsReductionToResidueRoots_eq_one_iff
    (u : serrePadicUnitRootsOfUnity p) :
    serrePadicUnitRootsReductionToResidueRoots p u = 1 ↔
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 := by
  change u ∈ (serrePadicUnitRootsReductionToResidueRoots p).ker ↔
    (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1
  exact mem_serrePadicUnitRootsReductionToResidueRoots_ker p u

/--
The ordinary reduction and the codomain-narrowed reduction have the same
injectivity content.
-/
theorem serrePadicUnitRootsReductionToResidueRoots_injective_iff :
    Function.Injective (serrePadicUnitRootsReductionToResidueRoots p) ↔
      Function.Injective (serrePadicUnitRootsReduction p) := by
  constructor
  · intro hinj u v hred
    apply hinj
    exact Subtype.ext hred
  · intro hinj u v hred
    apply hinj
    simpa [serrePadicUnitRootsReductionToResidueRoots_apply] using congrArg
      (fun a : serreResidueUnitRootsOfUnity p =>
        (a : (padicResidueRing p 0)ˣ)) hred

/--
A conditional injectivity criterion: once the intersection of roots of unity
with `U_1` is proved trivial, the reduction to residue units is injective.
-/
theorem serrePadicUnitRootsReduction_injective_of_principal_one_trivial
    (htriv : ∀ u : serrePadicUnitRootsOfUnity p,
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1) :
    Function.Injective (serrePadicUnitRootsReduction p) := by
  intro u v hred
  have hker : serrePadicUnitRootsReduction p (u * v⁻¹) = 1 := by
    rw [map_mul, map_inv, hred, mul_inv_cancel]
  have hprincipal :
      ((u * v⁻¹ : serrePadicUnitRootsOfUnity p) : (SerrePadicInt p)ˣ) ∈
        serrePadicPrincipalUnits p 1 :=
    (serrePadicUnitRootsReduction_eq_one_iff p (u * v⁻¹)).1 hker
  have hmul : u * v⁻¹ = 1 := htriv (u * v⁻¹) hprincipal
  calc
    u = u * 1 := by rw [mul_one]
    _ = u * (v⁻¹ * v) := by rw [inv_mul_cancel]
    _ = (u * v⁻¹) * v := by rw [mul_assoc]
    _ = 1 * v := by rw [hmul]
    _ = v := by rw [one_mul]

/--
The injectivity target is exactly the pending kernel-triviality target, stated
without proving that target yet.
-/
theorem serrePadicUnitRootsReduction_injective_iff_principal_one_trivial :
    Function.Injective (serrePadicUnitRootsReduction p) ↔
      ∀ u : serrePadicUnitRootsOfUnity p,
        (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1 := by
  constructor
  · intro hinj u hu
    apply hinj
    simpa using (serrePadicUnitRootsReduction_eq_one_iff p u).2 hu
  · intro htriv
    exact serrePadicUnitRootsReduction_injective_of_principal_one_trivial p htriv

/-- The same conditional injectivity criterion for the narrowed codomain. -/
theorem serrePadicUnitRootsReductionToResidueRoots_injective_of_principal_one_trivial
    (htriv : ∀ u : serrePadicUnitRootsOfUnity p,
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1) :
    Function.Injective (serrePadicUnitRootsReductionToResidueRoots p) := by
  have hred := serrePadicUnitRootsReduction_injective_of_principal_one_trivial p htriv
  exact (serrePadicUnitRootsReductionToResidueRoots_injective_iff p).2 hred

/--
For the narrowed codomain, injectivity is again equivalent to the same pending
kernel-triviality target.
-/
theorem serrePadicUnitRootsReductionToResidueRoots_injective_iff_principal_one_trivial :
    Function.Injective (serrePadicUnitRootsReductionToResidueRoots p) ↔
      ∀ u : serrePadicUnitRootsOfUnity p,
        (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p 1 → u = 1 := by
  rw [serrePadicUnitRootsReductionToResidueRoots_injective_iff,
    serrePadicUnitRootsReduction_injective_iff_principal_one_trivial]

end PadicUnitRoots

end SerreNumberTheoryAI
