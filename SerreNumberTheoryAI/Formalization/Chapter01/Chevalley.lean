import Mathlib.FieldTheory.Finite.Basic
import SerreNumberTheoryAI.Formalization.Chapter01.PowerSums

/-!
# Chevalley–Warning over a finite field

Independent formalization of Serre, Chapter 1, §2, 2.2.

Source metadata only: Japanese edition, printed p. 7, uploaded PDF p. 17.
The two immediate source corollaries are deliberately left for separate work items.
-/

namespace SerreNumberTheoryAI

open MvPolynomial
open Function hiding eval
open Finset

section Chevalley

variable {K σ ι : Type*} [Fintype K] [Field K] [Fintype σ] [DecidableEq σ]

local notation "q" => Fintype.card K

/--
If a multivariate polynomial has total degree less than `(q - 1) * #σ`,
then its values over the full finite-field grid sum to zero.

This is the monomial/power-sum engine used in Serre's Chevalley argument.
The crucial one-variable vanishing step is supplied by the project §2.1
formalization, rather than mathlib's ready-made Chevalley helper.
-/
theorem mvPolynomial_sum_eval_eq_zero
    (f : MvPolynomial σ K)
    (h : f.totalDegree < (q - 1) * Fintype.card σ) :
    ∑ x, eval x f = 0 := by
  classical
  calc
    ∑ x, eval x f =
        ∑ x : σ → K, ∑ d ∈ f.support, f.coeff d * ∏ i, x i ^ d i := by
      simp only [eval_eq']
    _ = ∑ d ∈ f.support, ∑ x : σ → K, f.coeff d * ∏ i, x i ^ d i := sum_comm
    _ = 0 := sum_eq_zero ?_
  intro d hd
  obtain ⟨i, hi⟩ : ∃ i, d i < q - 1 := f.exists_degree_lt (q - 1) h hd
  calc
    (∑ x : σ → K, f.coeff d * ∏ i, x i ^ d i) =
        f.coeff d * ∑ x : σ → K, ∏ i, x i ^ d i := (mul_sum ..).symm
    _ = 0 := (mul_eq_zero.mpr ∘ Or.inr) ?_
  calc
    (∑ x : σ → K, ∏ i, x i ^ d i) =
        ∑ x₀ : {j // j ≠ i} → K,
          ∑ x : {x : σ → K // x ∘ ((↑) : {j // j ≠ i} → σ) = x₀},
            ∏ j, (x : σ → K) j ^ d j :=
      (Fintype.sum_fiberwise _ _).symm
    _ = 0 := Fintype.sum_eq_zero _ ?_
  intro x₀
  let e : K ≃ {x : σ → K // x ∘ ((↑) : {j // j ≠ i} → σ) = x₀} :=
    (Equiv.subtypeEquivCodomain _).symm
  calc
    (∑ x : {x : σ → K // x ∘ ((↑) : {j // j ≠ i} → σ) = x₀},
        ∏ j, (x : σ → K) j ^ d j) =
        ∑ a : K, ∏ j : σ, (e a : σ → K) j ^ d j := (e.sum_comp _).symm
    _ = ∑ a : K, (∏ j, x₀ j ^ d j) * a ^ d i := Fintype.sum_congr _ _ ?_
    _ = (∏ j, x₀ j ^ d j) * ∑ a : K, a ^ d i := by rw [mul_sum]
    _ = 0 := by
      rw [show (∑ a : K, a ^ d i) = powerSum K (d i) by rfl,
        powerSum_eq_zero_of_lt_card_sub_one K (d i) hi, mul_zero]
  intro a
  let e' : {j // j = i} ⊕ {j // j ≠ i} ≃ σ := Equiv.sumCompl _
  letI : Unique {j // j = i} :=
    { default := ⟨i, rfl⟩
      uniq := fun ⟨j, hj⟩ => Subtype.val_injective hj }
  calc
    (∏ j : σ, (e a : σ → K) j ^ d j) =
        (e a : σ → K) i ^ d i *
          ∏ j : {j // j ≠ i}, (e a : σ → K) j ^ d j := by
      rw [← e'.prod_comp, Fintype.prod_sum_type, univ_unique, prod_singleton]
      rfl
    _ = a ^ d i * ∏ j : {j // j ≠ i}, (e a : σ → K) j ^ d j := by
      rw [Equiv.subtypeEquivCodomain_symm_apply_eq]
    _ = a ^ d i * ∏ j, x₀ j ^ d j := congr_arg _ (Fintype.prod_congr _ _ ?_)
    _ = (∏ j, x₀ j ^ d j) * a ^ d i := mul_comm _ _
  rintro ⟨j, hj⟩
  change (e a : σ → K) j ^ d j = x₀ ⟨j, hj⟩ ^ d j
  rw [Equiv.subtypeEquivCodomain_symm_apply_ne]

variable [DecidableEq K] (p : ℕ) [CharP K p]

/--
Serre's Chevalley–Warning theorem: if the sum of total degrees of a finite
family of multivariate polynomials is strictly smaller than the number of
variables, then the number of their common zeros is divisible by the
characteristic.
-/
theorem serre_chevalleyWarning
    {s : Finset ι} {f : ι → MvPolynomial σ K}
    (h : (∑ i ∈ s, (f i).totalDegree) < Fintype.card σ) :
    p ∣ Fintype.card {x : σ → K // ∀ i ∈ s, eval x (f i) = 0} := by
  have hq : 0 < q - 1 := by
    rw [← Fintype.card_units, Fintype.card_pos_iff]
    exact ⟨1⟩
  let S : Finset (σ → K) := {x | ∀ i ∈ s, eval x (f i) = 0}
  have hS (x : σ → K) : x ∈ S ↔ ∀ i ∈ s, eval x (f i) = 0 := by
    simp [S]

  let P : MvPolynomial σ K := ∏ i ∈ s, (1 - f i ^ (q - 1))

  have hP : ∀ x, eval x P = if x ∈ S then 1 else 0 := by
    intro x
    calc
      eval x P = ∏ i ∈ s, eval x (1 - f i ^ (q - 1)) := eval_prod s _ x
      _ = if x ∈ S then 1 else 0 := ?_
    simp only [(eval x).map_sub, (eval x).map_pow, (eval x).map_one]
    split_ifs with hx
    · apply Finset.prod_eq_one
      intro i hi
      rw [hS] at hx
      rw [hx i hi, zero_pow hq.ne', sub_zero]
    · obtain ⟨i, hi, hxi⟩ : ∃ i ∈ s, eval x (f i) ≠ 0 := by
        simpa [hS, not_forall, Classical.not_imp] using hx
      apply Finset.prod_eq_zero hi
      rw [FiniteField.pow_card_sub_one_eq_one (eval x (f i)) hxi, sub_self]

  have hcard :
      ∑ x, eval x P = Fintype.card {x : σ → K // ∀ i ∈ s, eval x (f i) = 0} := by
    rw [Fintype.card_of_subtype S hS, card_eq_sum_ones, Nat.cast_sum, Nat.cast_one,
      ← Fintype.sum_extend_by_zero S, sum_congr rfl fun x _ => hP x]

  change p ∣ Fintype.card {x // ∀ i : ι, i ∈ s → eval x (f i) = 0}
  rw [← CharP.cast_eq_zero_iff K, ← hcard]
  change (∑ x, eval x P) = 0
  apply mvPolynomial_sum_eval_eq_zero (K := K) P
  show P.totalDegree < (q - 1) * Fintype.card σ
  calc
    P.totalDegree ≤ ∑ i ∈ s, (1 - f i ^ (q - 1)).totalDegree :=
      totalDegree_finsetProd s _
    _ ≤ ∑ i ∈ s, (q - 1) * (f i).totalDegree :=
      sum_le_sum fun i _ => ?_
    _ = (q - 1) * ∑ i ∈ s, (f i).totalDegree := (mul_sum ..).symm
    _ < (q - 1) * Fintype.card σ := by gcongr
  change (1 - f i ^ (q - 1)).totalDegree ≤ (q - 1) * (f i).totalDegree
  calc
    (1 - f i ^ (q - 1)).totalDegree ≤
        max (1 : MvPolynomial σ K).totalDegree (f i ^ (q - 1)).totalDegree :=
      totalDegree_sub _ _
    _ ≤ (f i ^ (q - 1)).totalDegree := by simp
    _ ≤ (q - 1) * (f i).totalDegree := totalDegree_pow _ _

end Chevalley

end SerreNumberTheoryAI
