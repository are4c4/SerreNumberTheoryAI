import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitFiniteQuotient
import Mathlib.GroupTheory.Index
import Mathlib.Algebra.Group.Subgroup.Finite

/-!
# Cardinalities and cyclicity of finite principal-unit quotients

Serre Chapter 2, §3.2 constructs cyclic quotients of the source-indexed
principal-unit filtration. Each successive quotient has p elements.
The relative-index multiplication theorem then gives p^k elements in
U_(n+1)/U_(n+k+1). The sharp power-step theorem identifies a generator.

This is a source-shaped argument using the already-proved successive
quotient equivalence rather than a prepackaged p-adic unit structure theorem.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitFiniteQuotientCard

variable (p : ℕ) [Fact p.Prime]

/-- Each adjacent principal-unit layer has index p. -/
theorem serrePadicPrincipalUnits_adjacent_relIndex (n : ℕ) :
    (serrePadicPrincipalUnits p (n + 2)).relIndex
      (serrePadicPrincipalUnits p (n + 1)) = p := by
  change Nat.card (serrePadicPrincipalUnitsSuccessiveQuotient p n) = p
  calc
    Nat.card (serrePadicPrincipalUnitsSuccessiveQuotient p n) =
        Nat.card (Multiplicative (padicResidueRing p 0)) :=
      Nat.card_congr (serrePadicPrincipalUnitsSuccessiveQuotientEquiv p n).toEquiv
    _ = p := by
      simp [padicResidueRing, Nat.card_eq_fintype_card, ZMod.card]

/-- The source filtration is descending across any finite number of steps. -/
theorem serrePadicPrincipalUnits_deep_le (n k : ℕ) :
    serrePadicPrincipalUnits p (n + k + 1) ≤
      serrePadicPrincipalUnits p (n + 1) := by
  induction k with
  | zero =>
      simpa only [Nat.add_zero] using (le_refl (serrePadicPrincipalUnits p (n + 1)))
  | succ k ih =>
      have hstep :
          serrePadicPrincipalUnits p (n + (k + 1) + 1) ≤
            serrePadicPrincipalUnits p (n + k + 1) := by
        simpa only [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
          (serrePadicPrincipalUnits_succ_succ_le_succ p (n + k))
      exact hstep.trans ih

/--
Multiplicativity of relative indices in the source filtration:
U_(n+k+1) has relative index p^k in U_(n+1).
-/
theorem serrePadicPrincipalUnits_deep_relIndex (n k : ℕ) :
    (serrePadicPrincipalUnits p (n + k + 1)).relIndex
      (serrePadicPrincipalUnits p (n + 1)) = p ^ k := by
  induction k with
  | zero =>
      simp only [Nat.add_zero, pow_zero]
      exact Subgroup.relIndex_self _
  | succ k ih =>
      have hfirst :=
        serrePadicPrincipalUnits_succ_succ_le_succ p (n + k)
      have hsecond := serrePadicPrincipalUnits_deep_le p n k
      have hrel :=
        Subgroup.relIndex_mul_relIndex
          (H := serrePadicPrincipalUnits p (n + k + 2))
          (K := serrePadicPrincipalUnits p (n + k + 1))
          (L := serrePadicPrincipalUnits p (n + 1))
          hfirst hsecond
      calc
        (serrePadicPrincipalUnits p (n + (k + 1) + 1)).relIndex
            (serrePadicPrincipalUnits p (n + 1)) =
          (serrePadicPrincipalUnits p (n + k + 2)).relIndex
            (serrePadicPrincipalUnits p (n + 1)) := by
              congr 1
        _ = (serrePadicPrincipalUnits p (n + k + 2)).relIndex
                (serrePadicPrincipalUnits p (n + k + 1)) *
              (serrePadicPrincipalUnits p (n + k + 1)).relIndex
                (serrePadicPrincipalUnits p (n + 1)) := hrel.symm
        _ = p * p ^ k := by
          rw [serrePadicPrincipalUnits_adjacent_relIndex p (n + k), ih]
        _ = p ^ (k + 1) := by
          rw [pow_succ]
          ac_rfl

/-- The finite quotient U_(n+1)/U_(n+k+1) contains exactly p^k classes. -/
theorem serrePadicPrincipalUnitFiniteQuotient_card
    (n k : ℕ) :
    Nat.card (serrePadicPrincipalUnitFiniteQuotient p n k) = p ^ k := by
  change (serrePadicPrincipalUnits p (n + k + 1)).relIndex
    (serrePadicPrincipalUnits p (n + 1)) = p ^ k
  exact serrePadicPrincipalUnits_deep_relIndex p n k

/--
The candidate first-layer unit generates the *entire* finite quotient
in the range of the source p-power lemma. Its cyclic subgroup and the
whole quotient both have cardinal p^(k+1).
-/
theorem serrePadicPrincipalUnitFiniteQuotient_generator_zpowers_eq_top
    (n k : ℕ) (hsource : p ≠ 2 ∨ 1 ≤ n)
    (u : serrePadicPrincipalUnits p (n + 1))
    (hnot : (u : (SerrePadicInt p)ˣ) ∉
      serrePadicPrincipalUnits p (n + 2)) :
    Subgroup.zpowers
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u) = ⊤ := by
  let q : serrePadicPrincipalUnitFiniteQuotient p n (k + 1) :=
    ((QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1))) u)
  have hcard :
      Nat.card (Subgroup.zpowers q) =
        Nat.card (serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) := by
    calc
      Nat.card (Subgroup.zpowers q) = orderOf q := Nat.card_zpowers q
      _ = p ^ (k + 1) :=
        serrePadicPrincipalUnitFiniteQuotient_exact_order p n k hsource u hnot
      _ = Nat.card (serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) :=
        (serrePadicPrincipalUnitFiniteQuotient_card p n (k + 1)).symm
  have hpositive :
      0 < Nat.card (Subgroup.zpowers q) := by
    rw [hcard, serrePadicPrincipalUnitFiniteQuotient_card]
    exact pow_pos (Fact.out : p.Prime).pos _
  letI : Finite (Subgroup.zpowers q) :=
    Nat.finite_of_card_ne_zero (Nat.ne_of_gt hpositive)
  exact Subgroup.eq_top_of_card_eq _ hcard

/-- In odd residue characteristic, the class of 1+p generates U₁/U_(k+2). -/
theorem serrePadicPrincipalUnitFiniteQuotient_odd_generator_zpowers_eq_top
    (hpodd : p ≠ 2) (k : ℕ) :
    Subgroup.zpowers
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p 0 (k + 1)))
        (serrePadicPrincipalUnitOfCoeff p 0 1)) = ⊤ :=
  serrePadicPrincipalUnitFiniteQuotient_generator_zpowers_eq_top
    p 0 k (Or.inl hpodd) (serrePadicPrincipalUnitOfCoeff p 0 1)
    (serrePadicPrincipalUnitOfCoeff_one_exactLayer p 0)

/-- The class of 1+p² generates U₂/U_(k+3), including the dyadic case. -/
theorem serrePadicPrincipalUnitFiniteQuotient_levelTwo_generator_zpowers_eq_top
    (k : ℕ) :
    Subgroup.zpowers
      ((QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p 1 (k + 1)))
        (serrePadicPrincipalUnitOfCoeff p 1 1)) = ⊤ :=
  serrePadicPrincipalUnitFiniteQuotient_generator_zpowers_eq_top
    p 1 k (Or.inr (by omega)) (serrePadicPrincipalUnitOfCoeff p 1 1)
    (serrePadicPrincipalUnitOfCoeff_one_exactLayer p 1)

end PadicPrincipalUnitFiniteQuotientCard

end SerreNumberTheoryAI
