import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricCompletion
import Mathlib.RingTheory.Localization.FractionRing
import Mathlib.RingTheory.DiscreteValuationRing.Basic

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

end PadicField

end SerreNumberTheoryAI
