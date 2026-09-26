import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricCompletion
import Mathlib.RingTheory.Localization.FractionRing

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
Every nonzero project p-adic field element is an integral power of `p` times the image
of a project p-adic unit.
-/
theorem serrePadicField_exists_unit_smul_zpow
    {x : SerrePadicField p} (hx : x ≠ 0) :
    ∃ (n : ℤ) (u : (SerrePadicInt p)ˣ),
      x = u • (serrePadicFieldPrime p) ^ n := by
  obtain ⟨a, b, hb, rfl⟩ :=
    IsFractionRing.div_surjective (A := SerrePadicInt p) x
  have ha : a ≠ 0 := by
    intro ha
    subst a
    simp at hx
  have hb0 : b ≠ 0 := nonZeroDivisors.ne_zero hb
  obtain ⟨na, ua, hua, ha_repr⟩ :=
    exists_pow_mul_isUnit_of_ne_zero p ha
  obtain ⟨nb, ub, hub, hb_repr⟩ :=
    exists_pow_mul_isUnit_of_ne_zero p hb0
  let u : (SerrePadicInt p)ˣ := hua.unit
  let v : (SerrePadicInt p)ˣ := hub.unit
  have hu : (u : SerrePadicInt p) = ua := IsUnit.unit_spec hua
  have hv : (v : SerrePadicInt p) = ub := IsUnit.unit_spec hub
  have ha_repr' : a = (u : SerrePadicInt p) * (p : SerrePadicInt p) ^ na := by
    rw [ha_repr, ← hu]
    ac_rfl
  have hb_repr' : b = (v : SerrePadicInt p) * (p : SerrePadicInt p) ^ nb := by
    rw [hb_repr, ← hv]
    ac_rfl
  rw [ha_repr', hb_repr']
  have hpZ : (p : SerrePadicInt p) ≠ 0 := by
    simpa using serrePadicInt_p_pow_ne_zero p 1
  have hp : serrePadicFieldPrime p ≠ 0 := by
    intro h
    apply hpZ
    apply serrePadicIntToField_injective p
    simpa [serrePadicFieldPrime, serrePadicIntToField] using h
  refine ⟨(na : ℤ) - (nb : ℤ), u / v, ?_⟩
  simp [serrePadicFieldPrime, serrePadicIntToField, hp, zpow_sub₀,
    div_smul_div_comm, Units.smul_def, Algebra.smul_def]

end PadicField

end SerreNumberTheoryAI
