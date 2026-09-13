import Mathlib.Algebra.CharP.Lemmas
import Mathlib.Algebra.Field.Subfield.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Set.Card
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.FieldTheory.Finiteness
import Mathlib.FieldTheory.IsAlgClosed.Basic
import Mathlib.FieldTheory.Separable

/-!
# Finite-field foundations

This module starts the independent formalization of Serre, Chapter 1, §1, 1.1.

Source metadata only (the book text is not reproduced here): Japanese edition,
printed pp. 3–4, uploaded PDF pp. 13–14.
-/

namespace SerreNumberTheoryAI

section Frobenius

variable (K : Type*) [Field K] (p : ℕ) [ExpChar K p]

/--
The characteristic-`p` power map, constructed directly from the elementary
power identities used in Serre's opening Frobenius argument.
-/
def frobeniusPowerMap : K →+* K where
  toFun := fun x => x ^ p
  map_zero' := zero_pow (expChar_ne_zero K p)
  map_one' := one_pow p
  map_add' := by
    intro x y
    exact add_pow_expChar x y p
  map_mul' := by
    intro x y
    exact mul_pow x y p

@[simp]
theorem frobeniusPowerMap_apply (x : K) : frobeniusPowerMap K p x = x ^ p := rfl

/-- The subfield consisting of `p`-th powers, realized as the field range. -/
def frobeniusImage : Subfield K := (frobeniusPowerMap K p).fieldRange

/--
The Frobenius power map identifies a field of positive exponent characteristic
with its image subfield. This is the Lean counterpart of Serre's `K ≃ K^p`
observation.
-/
noncomputable def frobeniusEquivImage : K ≃+* frobeniusImage K p :=
  (frobeniusPowerMap K p).rangeRestrictFieldEquiv

end Frobenius

section FiniteFieldCardinality

variable (K : Type*) [Field K] [Fintype K]

/-- A finite field cannot have characteristic zero, hence its characteristic is prime. -/
theorem finiteField_characteristic_prime (p : ℕ) [CharP K p] : Nat.Prime p := by
  exact
    (CharP.char_is_prime_or_zero K p).resolve_right
      (CharP.char_ne_zero_of_finite K p)

/--
If a finite field has characteristic `p`, its cardinality is `p^f` for some
positive integer `f`.

The proof deliberately does not use `FiniteField.card`, which is essentially
the target result. Instead it regards the field as a finite-dimensional vector
space over `ZMod p` and counts vectors.
-/
theorem finiteField_cardinality_prime_power (p : ℕ) [CharP K p] :
    ∃ f : ℕ, 0 < f ∧ Fintype.card K = p ^ f := by
  have hp : Nat.Prime p := finiteField_characteristic_prime K p
  letI : Fact p.Prime := ⟨hp⟩
  letI : Module (ZMod p) K :=
    { (ZMod.castHom dvd_rfl K : ZMod p →+* K).toModule with }
  let f := Module.finrank (ZMod p) K
  have hcard : Fintype.card K = p ^ f := by
    simpa [f] using (Module.card_eq_pow_finrank (K := ZMod p) (V := K))
  have hf : 0 < f := by
    apply Nat.pos_of_ne_zero
    intro hf0
    apply not_subsingleton K
    apply Fintype.card_le_one_iff_subsingleton.mp
    simpa [hf0] using hcard.le
  exact ⟨f, hf, hcard⟩

end FiniteFieldCardinality

section PrimePowerSubfield

open Polynomial

variable (Ω : Type*) [Field Ω] [IsAlgClosed Ω]
variable (p f : ℕ) [CharP Ω p]

/-- The polynomial whose roots are the candidates for the `p^f`-element subfield. -/
noncomputable def primePowerPolynomial : Ω[X] := X ^ (p ^ f) - X

/--
The elements fixed by the `p^f`-power Frobenius form a subfield.
This is constructed directly from the characteristic-`p` power identities.
-/
noncomputable def primePowerFixedSubfield (hp : Nat.Prime p) : Subfield Ω := by
  letI : Fact p.Prime := ⟨hp⟩
  let S : Subring Ω :=
    { carrier := {x : Ω | x ^ (p ^ f) = x}
      zero_mem' := by
        change (0 : Ω) ^ (p ^ f) = 0
        exact zero_pow (pow_ne_zero f hp.ne_zero)
      add_mem' := by
        intro x y hx hy
        change x ^ (p ^ f) = x at hx
        change y ^ (p ^ f) = y at hy
        change (x + y) ^ (p ^ f) = x + y
        rw [add_pow_char_pow x y p f, hx, hy]
      one_mem' := by
        change (1 : Ω) ^ (p ^ f) = 1
        exact one_pow (p ^ f)
      mul_mem' := by
        intro x y hx hy
        change x ^ (p ^ f) = x at hx
        change y ^ (p ^ f) = y at hy
        change (x * y) ^ (p ^ f) = x * y
        rw [mul_pow, hx, hy]
      neg_mem' := by
        intro x hx
        change x ^ (p ^ f) = x at hx
        change (-x) ^ (p ^ f) = -x
        simpa [hx, zero_pow (pow_ne_zero f hp.ne_zero)] using
          (sub_pow_char_pow (0 : Ω) x f (p := p)) }
  exact
    { S with
      inv_mem' := by
        intro x hx
        change x ^ (p ^ f) = x at hx
        change (x⁻¹) ^ (p ^ f) = x⁻¹
        rw [inv_pow, hx] }

@[simp]
theorem mem_primePowerFixedSubfield (hp : Nat.Prime p) (x : Ω) :
    x ∈ primePowerFixedSubfield Ω p f hp ↔ x ^ (p ^ f) = x :=
  Iff.rfl

/-- The defining polynomial has degree exactly `p^f`. -/
theorem primePowerPolynomial_natDegree (hp : Nat.Prime p) (hf : 0 < f) :
    (primePowerPolynomial Ω p f).natDegree = p ^ f := by
  unfold primePowerPolynomial
  rw [natDegree_sub_eq_left_of_natDegree_lt]
  · simp
  · simpa using Nat.one_lt_pow (Nat.ne_of_gt hf) hp.one_lt

/-- In particular, the defining polynomial is nonzero. -/
theorem primePowerPolynomial_ne_zero (hp : Nat.Prime p) (hf : 0 < f) :
    primePowerPolynomial Ω p f ≠ 0 := by
  intro hzero
  have hdeg := congrArg Polynomial.natDegree hzero
  rw [primePowerPolynomial_natDegree Ω p f hp hf] at hdeg
  simp only [natDegree_zero] at hdeg
  exact (pow_ne_zero f hp.ne_zero) hdeg

/--
`X^(p^f) - X` has no repeated roots. The proof computes its derivative in
characteristic `p`, where the coefficient `p^f` vanishes.
-/
theorem primePowerPolynomial_separable (hf : 0 < f) :
    (primePowerPolynomial Ω p f).Separable := by
  have hdiv : p ∣ p ^ f := dvd_pow_self p (Nat.ne_of_gt hf)
  have hcast : (((p ^ f : ℕ) : Ω)) = 0 :=
    (CharP.cast_eq_zero_iff Ω p (p ^ f)).2 hdiv
  rw [Polynomial.separable_def]
  convert! isCoprime_one_right.neg_right (R := Ω[X]) using 1
  rw [primePowerPolynomial, Polynomial.derivative_sub, Polynomial.derivative_X,
    Polynomial.derivative_X_pow, hcast, C_0, zero_mul, zero_sub]

/--
The fixed-point description agrees exactly with the roots of `X^(p^f) - X`
in the ambient algebraically closed field.
-/
theorem coe_primePowerFixedSubfield_eq_rootSet (hp : Nat.Prime p) (hf : 0 < f) :
    ((primePowerFixedSubfield Ω p f hp : Subfield Ω) : Set Ω) =
      (primePowerPolynomial Ω p f).rootSet Ω := by
  ext x
  change x ^ (p ^ f) = x ↔ x ∈ (primePowerPolynomial Ω p f).rootSet Ω
  rw [Polynomial.mem_rootSet_of_ne (primePowerPolynomial_ne_zero Ω p f hp hf)]
  simp [primePowerPolynomial]

/-- The defining polynomial has exactly `p^f` distinct roots in `Ω`. -/
theorem primePowerPolynomial_rootSet_card (hp : Nat.Prime p) (hf : 0 < f) :
    Fintype.card ((primePowerPolynomial Ω p f).rootSet Ω) = p ^ f := by
  have hsplit :
      ((primePowerPolynomial Ω p f).map (algebraMap Ω Ω)).Splits := by
    simpa using (IsAlgClosed.splits (primePowerPolynomial Ω p f))
  have hcard :=
    Polynomial.card_rootSet_eq_natDegree
      (primePowerPolynomial_separable Ω p f hf) hsplit
  simpa [primePowerPolynomial_natDegree Ω p f hp hf] using hcard

/-- The fixed-point subfield has exactly `p^f` elements. -/
theorem primePowerFixedSubfield_natCard (hp : Nat.Prime p) (hf : 0 < f) :
    Nat.card (primePowerFixedSubfield Ω p f hp) = p ^ f := by
  calc
    Nat.card (primePowerFixedSubfield Ω p f hp) =
        ((primePowerFixedSubfield Ω p f hp : Subfield Ω) : Set Ω).ncard := by
      simpa using
        (Nat.card_coe_set_eq
          ((primePowerFixedSubfield Ω p f hp : Subfield Ω) : Set Ω))
    _ = ((primePowerPolynomial Ω p f).rootSet Ω).ncard := by
      rw [coe_primePowerFixedSubfield_eq_rootSet Ω p f hp hf]
    _ = Nat.card ((primePowerPolynomial Ω p f).rootSet Ω) := by
      symm
      exact Nat.card_coe_set_eq ((primePowerPolynomial Ω p f).rootSet Ω)
    _ = Fintype.card ((primePowerPolynomial Ω p f).rootSet Ω) :=
      Nat.card_eq_fintype_card
    _ = p ^ f := primePowerPolynomial_rootSet_card Ω p f hp hf

/--
Any subfield of `Ω` with `p^f` elements is contained in the fixed-point
subfield: every element of a finite field satisfies `x^(#F) = x`.
-/
theorem subfield_le_primePowerFixedSubfield_of_natCard
    (hp : Nat.Prime p) (hf : 0 < f)
    (E : Subfield Ω) (hcard : Nat.card E = p ^ f) :
    E ≤ primePowerFixedSubfield Ω p f hp := by
  have hcard_pos : 0 < Nat.card E := by
    rw [hcard]
    exact pow_pos hp.pos f
  letI : Finite E := (Nat.card_pos_iff.mp hcard_pos).2
  letI : Fintype E := Fintype.ofFinite E
  have hcard' : Fintype.card E = p ^ f := by
    rw [← Nat.card_eq_fintype_card]
    exact hcard
  intro x hx
  have hxpow := FiniteField.pow_card (⟨x, hx⟩ : E)
  have hxpow' : x ^ Fintype.card E = x := by
    simpa using congrArg ((↑) : E → Ω) hxpow
  rw [hcard'] at hxpow'
  exact hxpow'

/--
Consequently, the `p^f`-element subfield inside the fixed algebraically closed
ambient field is unique.
-/
theorem subfield_eq_primePowerFixedSubfield_of_natCard
    (hp : Nat.Prime p) (hf : 0 < f)
    (E : Subfield Ω) (hcard : Nat.card E = p ^ f) :
    E = primePowerFixedSubfield Ω p f hp := by
  apply SetLike.ext'
  apply Set.eq_of_subset_of_ncard_le
  · exact subfield_le_primePowerFixedSubfield_of_natCard Ω p f hp hf E hcard
  · have hEcard : (E : Set Ω).ncard = p ^ f := by
      rw [← Nat.card_coe_set_eq]
      exact hcard
    have hFcard :
        ((primePowerFixedSubfield Ω p f hp : Subfield Ω) : Set Ω).ncard = p ^ f := by
      rw [← Nat.card_coe_set_eq]
      exact primePowerFixedSubfield_natCard Ω p f hp hf
    rw [hEcard, hFcard]
  · rw [coe_primePowerFixedSubfield_eq_rootSet Ω p f hp hf]
    exact (primePowerPolynomial Ω p f).rootSet_finite Ω

/--
Serre, Chapter 1, §1.1, Theorem 1(ii): in a fixed algebraically closed field of
characteristic `p`, there is exactly one subfield with `p^f` elements (`f > 0`),
and its elements are precisely the roots of `X^(p^f) - X`, equivalently the
solutions of `x^(p^f) = x`.
-/
theorem serre_theorem1_ii (hp : Nat.Prime p) (hf : 0 < f) :
    (∃! F : Subfield Ω, Nat.card F = p ^ f) ∧
      (((primePowerFixedSubfield Ω p f hp : Subfield Ω) : Set Ω) =
        {x : Ω | x ^ (p ^ f) = x}) ∧
      (((primePowerFixedSubfield Ω p f hp : Subfield Ω) : Set Ω) =
        (primePowerPolynomial Ω p f).rootSet Ω) := by
  constructor
  · refine ⟨primePowerFixedSubfield Ω p f hp, ?_, ?_⟩
    · exact primePowerFixedSubfield_natCard Ω p f hp hf
    · intro E hE
      exact subfield_eq_primePowerFixedSubfield_of_natCard Ω p f hp hf E hE
  · constructor
    · rfl
    · exact coe_primePowerFixedSubfield_eq_rootSet Ω p f hp hf

end PrimePowerSubfield

end SerreNumberTheoryAI
