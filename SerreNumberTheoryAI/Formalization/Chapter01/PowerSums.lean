import Mathlib.FieldTheory.Finite.Basic
import SerreNumberTheoryAI.Formalization.Chapter01.MultiplicativeGroup

/-!
# Power sums over finite fields

Independent formalization of Serre, Chapter 1, §2, 2.1.

Source metadata only: Japanese edition, printed p. 6, uploaded PDF p. 16.
-/

namespace SerreNumberTheoryAI

open Finset

section PowerSums

variable (K : Type*) [Field K] [Fintype K]

/-- The sum of the `u`-th powers of all elements of a finite field. -/
def powerSum (u : ℕ) : K :=
  ∑ x : K, x ^ u

/-- The exponent `u` kills every unit exactly when the order of `Kˣ` divides `u`.

The cyclicity input comes from the project formalization of Serre's Theorem 2,
not from mathlib's finite-field power-sum package. -/
theorem finiteField_units_forall_pow_eq_one_iff (u : ℕ) :
    (∀ x : Kˣ, x ^ u = 1) ↔ Fintype.card K - 1 ∣ u := by
  classical
  letI : IsCyclic Kˣ := finiteField_units_isCyclic K
  obtain ⟨x, hx⟩ := IsCyclic.exists_generator (α := Kˣ)
  rw [← Nat.card_eq_fintype_card, ← Nat.card_units,
    ← orderOf_eq_card_of_forall_mem_zpowers hx, orderOf_dvd_iff_pow_eq_one]
  constructor
  · intro h
    exact h x
  · intro h y
    simp_rw [← mem_powers_iff_mem_zpowers] at hx
    rcases hx y with ⟨j, rfl⟩
    rw [← pow_mul, mul_comm, pow_mul, h, one_pow]

/-- The power sum over the unit group is `-1` in the divisible case and `0` otherwise. -/
theorem finiteField_unitPowerSum [DecidableEq K] (u : ℕ) :
    (∑ x : Kˣ, (x ^ u : K)) =
      if Fintype.card K - 1 ∣ u then -1 else 0 := by
  let φ : Kˣ →* K :=
    { toFun := fun x => x ^ u
      map_one' := by simp
      map_mul' := by simp [mul_pow] }
  have : Decidable (φ = 1) := by classical infer_instance
  calc
    (∑ x : Kˣ, φ x) = if φ = 1 then Fintype.card Kˣ else 0 := sum_hom_units φ
    _ = if Fintype.card K - 1 ∣ u then -1 else 0 := by
      suffices Fintype.card K - 1 ∣ u ↔ φ = 1 by
        simp only [this]
        split_ifs
        · rw [Fintype.card_units, Nat.cast_sub,
            FiniteField.cast_card_eq_zero K, Nat.cast_one, zero_sub]
          show 1 ≤ Fintype.card K
          exact Fintype.card_pos_iff.mpr ⟨0⟩
        · exact Nat.cast_zero
      rw [← finiteField_units_forall_pow_eq_one_iff K u, DFunLike.ext_iff]
      apply forall_congr'
      intro x
      simp [φ, Units.ext_iff]

/-- For positive exponent, summing over the field is the same as summing over its units. -/
theorem powerSum_eq_unitPowerSum [DecidableEq K] (u : ℕ) (hu : u ≠ 0) :
    powerSum K u = ∑ x : Kˣ, (x ^ u : K) := by
  classical
  let φ : Kˣ ↪ K := ⟨fun x ↦ x, Units.val_injective⟩
  have hφ : univ.map φ = univ \ {0} := by
    ext x
    simpa only [mem_map, mem_univ, Function.Embedding.coeFn_mk, true_and, mem_sdiff,
      mem_singleton, φ] using! isUnit_iff_ne_zero
  calc
    powerSum K u = ∑ x : K, x ^ u := rfl
    _ = ∑ x ∈ univ \ {(0 : K)}, x ^ u := by
      rw [← sum_sdiff ({0} : Finset K).subset_univ, sum_singleton, zero_pow hu, add_zero]
    _ = ∑ x : Kˣ, (x ^ u : K) := by
      simp [φ, ← hφ, univ.sum_map φ]

/-- The zeroth power sum vanishes in a finite field because its cardinality is zero in the field. -/
@[simp]
theorem powerSum_zero : powerSum K 0 = 0 := by
  simp [powerSum, FiniteField.cast_card_eq_zero]

/-- Serre's finite-field power-sum formula, including the `u = 0` case. -/
theorem serre_powerSum_formula (u : ℕ) :
    powerSum K u =
      if u = 0 then 0
      else if Fintype.card K - 1 ∣ u then -1 else 0 := by
  classical
  by_cases hu : u = 0
  · simp [hu]
  · rw [if_neg hu, powerSum_eq_unitPowerSum K u hu, finiteField_unitPowerSum K u]

/-- Positive exponents divisible by `#K - 1` have power sum `-1`. -/
theorem powerSum_eq_neg_one_of_dvd (u : ℕ) (hu : u ≠ 0)
    (hdiv : Fintype.card K - 1 ∣ u) :
    powerSum K u = -1 := by
  rw [serre_powerSum_formula K u]
  simp [hu, hdiv]

/-- Positive exponents not divisible by `#K - 1` have power sum `0`. -/
theorem powerSum_eq_zero_of_not_dvd (u : ℕ) (hu : u ≠ 0)
    (hdiv : ¬ Fintype.card K - 1 ∣ u) :
    powerSum K u = 0 := by
  rw [serre_powerSum_formula K u]
  simp [hu, hdiv]

/-- The low-exponent vanishing corollary used by the Chevalley argument. -/
theorem powerSum_eq_zero_of_lt_card_sub_one (u : ℕ)
    (hu : u < Fintype.card K - 1) :
    powerSum K u = 0 := by
  by_cases hzero : u = 0
  · simpa [hzero] using powerSum_zero K
  · have hndiv : ¬ Fintype.card K - 1 ∣ u := by
      intro hdiv
      exact (not_lt_of_ge (Nat.le_of_dvd (Nat.pos_of_ne_zero hzero) hdiv)) hu
    exact powerSum_eq_zero_of_not_dvd K u hzero hndiv

end PowerSums

end SerreNumberTheoryAI
