import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricCompletion
import Mathlib.RingTheory.Localization.FractionRing
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.RingTheory.OrderOfVanishing.Noetherian

/-!
# The project p-adic field

Independent formalization of the algebraic construction in Serre, Chapter 2, §1.3.

The field is the ordinary fraction field of the project-local inverse-limit ring
`SerrePadicInt p`.  This file deliberately does not identify it with mathlib's completed
`Padic` type.
-/

namespace SerreNumberTheoryAI

section PadicField

variable (p : ℕ) [Fact p.Prime]

/-- The project p-adic field, defined source-faithfully as the fraction field of project `ℤ_p`. -/
abbrev SerrePadicField := FractionRing (SerrePadicInt p)

/-- The canonical embedding of the project p-adic integers into their fraction field. -/
def serrePadicIntToField : SerrePadicInt p →+* SerrePadicField p :=
  algebraMap (SerrePadicInt p) (SerrePadicField p)

/-- The canonical map `ℤ_p → Q_p` is injective. -/
theorem serrePadicIntToField_injective :
    Function.Injective (serrePadicIntToField p) := by
  exact IsFractionRing.injective (SerrePadicInt p) (SerrePadicField p)

/-- The distinguished prime element viewed in the project p-adic field. -/
def serrePadicFieldPrime : SerrePadicField p :=
  serrePadicIntToField p (p : SerrePadicInt p)

/--
The project-local p-adic integer ring is a discrete valuation ring.

This is derived from the already formalized source factorization of every nonzero
project p-adic integer as a power of `p` times a unit.  No completed p-adic
number implementation from mathlib is used here.
-/
noncomputable instance serrePadicInt_isDiscreteValuationRing :
    IsDiscreteValuationRing (SerrePadicInt p) :=
  IsDiscreteValuationRing.ofHasUnitMulPowIrreducibleFactorization (by
    refine ⟨(p : SerrePadicInt p), (serrePadicInt_p_prime p).irreducible, ?_⟩
    intro x hx
    obtain ⟨n, u, hu, hxu⟩ := exists_pow_mul_isUnit_of_ne_zero p hx
    refine ⟨n, ?_⟩
    rw [hxu]
    exact (associated_mul_unit_left _ _ hu).symm)

/--
Every nonzero project p-adic field element is an integral power of `p` times the image
of a project p-adic unit.
-/
theorem serrePadicField_exists_unit_smul_zpow
    {x : SerrePadicField p} (hx : x ≠ 0) :
    ∃ (n : ℤ) (u : (SerrePadicInt p)ˣ),
      x = u • (serrePadicFieldPrime p) ^ n := by
  simpa [serrePadicFieldPrime, serrePadicIntToField] using
    (IsDiscreteValuationRing.exists_units_eq_smul_zpow_of_irreducible
      (R := SerrePadicInt p) (K := SerrePadicField p)
      (serrePadicInt_p_prime p).irreducible hx)

/--
The order of vanishing on the project fraction field.  This is the multiplicative
`ℤᵐ⁰` encoding of the integer-valued p-adic valuation: `p` has order `1`,
units have order `0`, and `0` maps to the distinguished zero element.
-/
noncomputable def serrePadicFieldOrder :
    SerrePadicField p →*₀ ℤₘ₀ :=
  Ring.ordFrac (SerrePadicInt p)

/-- The distinguished prime has p-adic order one. -/
@[simp] theorem serrePadicFieldOrder_prime :
    serrePadicFieldOrder p (serrePadicFieldPrime p) = WithZero.exp 1 := by
  simpa [serrePadicFieldOrder, serrePadicFieldPrime, serrePadicIntToField] using
    (Ring.ordFrac_irreducible
      (R := SerrePadicInt p) (K := SerrePadicField p)
      (serrePadicInt_p_prime p).irreducible)

/-- The image of every project p-adic integer unit has p-adic order zero. -/
@[simp] theorem serrePadicFieldOrder_unit (u : (SerrePadicInt p)ˣ) :
    serrePadicFieldOrder p
        (algebraMap (SerrePadicInt p) (SerrePadicField p) (u : SerrePadicInt p)) = 1 := by
  simpa [serrePadicFieldOrder] using
    (Ring.ordFrac_of_isUnit
      (R := SerrePadicInt p) (K := SerrePadicField p) u.isUnit)

/-- A unit times `p^n` has p-adic order `n`. -/
@[simp] theorem serrePadicFieldOrder_unit_smul_zpow
    (u : (SerrePadicInt p)ˣ) (n : ℤ) :
    serrePadicFieldOrder p (u • (serrePadicFieldPrime p) ^ n) =
      WithZero.exp n := by
  simp [serrePadicFieldOrder, serrePadicFieldPrime, serrePadicIntToField,
    Units.smul_def, Algebra.smul_def,
    Ring.ordFrac_of_isUnit, Ring.ordFrac_irreducible, map_zpow₀]

/-- The exponent in the source decomposition `x = u p^n` is unique. -/
theorem serrePadicField_zpow_exponent_unique
    {u v : (SerrePadicInt p)ˣ} {m n : ℤ}
    (h : u • (serrePadicFieldPrime p) ^ m =
      v • (serrePadicFieldPrime p) ^ n) :
    m = n := by
  have horder := congrArg (serrePadicFieldOrder p) h
  have hmn : WithZero.exp m = WithZero.exp n := by
    simpa only [serrePadicFieldOrder_unit_smul_zpow] using horder
  exact WithZero.exp_injective hmn

end PadicField

end SerreNumberTheoryAI
