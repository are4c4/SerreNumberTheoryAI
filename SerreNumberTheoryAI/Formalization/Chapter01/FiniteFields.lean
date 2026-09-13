import Mathlib.Algebra.CharP.Lemmas
import Mathlib.Algebra.Field.Subfield.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.FieldTheory.Finiteness

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

end SerreNumberTheoryAI
