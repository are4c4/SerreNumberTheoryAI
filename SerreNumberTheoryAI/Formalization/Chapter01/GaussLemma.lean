import Mathlib
import SerreNumberTheoryAI.Formalization.Chapter01.LegendreSymbol

/-!
# Gauss's lemma for the project Legendre sign

Independent formalization of the Gauss-lemma part of the Chapter 1 supplement.

Source metadata only: Japanese edition, printed pp. 12–13, uploaded PDF pp. 22–23.
The core argument multiplies the signed permutation identities on a half-system of
nonzero residue classes. It does not use quadratic reciprocity or a ready-made Gauss lemma.
-/

namespace SerreNumberTheoryAI

open scoped BigOperators

section GaussLemma

/--
The multiplicative core of Gauss's lemma. If multiplication by `a` carries the chosen
half-system `S` to a signed permutation of itself, then the source half-power Legendre
value is the product of those signs after casting to the prime field.
-/
theorem gaussSignedPermutation_legendreValue
    (p : ℕ) [Fact p.Prime]
    (S : Finset (ZMod p)ˣ)
    (a : (ZMod p)ˣ)
    (ε : ↥S → ℤ)
    (τ : ↥S → ↥S)
    (hτ : Function.Bijective τ)
    (hdecomp : ∀ s,
      (a : ZMod p) * (s.1 : ZMod p) =
        ((ε s : ℤ) : ZMod p) * ((τ s).1 : ZMod p))
    (hcard : S.card = (p - 1) / 2) :
    legendreValue p (a : ZMod p) =
      (((∏ s : ↥S, ε s) : ℤ) : ZMod p) := by
  classical
  let P : ZMod p := ∏ s : ↥S, (s.1 : ZMod p)
  have hP : P ≠ 0 := by
    dsimp [P]
    apply Finset.prod_ne_zero
    intro s _
    exact Units.ne_zero s.1
  have hprod :
      (∏ s : ↥S, (a : ZMod p) * (s.1 : ZMod p)) =
        ∏ s : ↥S, ((ε s : ℤ) : ZMod p) * ((τ s).1 : ZMod p) := by
    apply Finset.prod_congr rfl
    intro s _
    exact hdecomp s
  have hleft :
      (∏ s : ↥S, (a : ZMod p) * (s.1 : ZMod p)) =
        (a : ZMod p) ^ S.card * P := by
    simp [P, Finset.prod_mul_distrib]
  let e : ↥S ≃ ↥S := Equiv.ofBijective τ hτ
  have hperm :
      (∏ s : ↥S, ((τ s).1 : ZMod p)) = P := by
    have h := Fintype.prod_equiv e
      (fun s : ↥S => ((τ s).1 : ZMod p))
      (fun s : ↥S => (s.1 : ZMod p))
      (fun _ => rfl)
    simpa [P, e] using h
  have hright :
      (∏ s : ↥S, ((ε s : ℤ) : ZMod p) * ((τ s).1 : ZMod p)) =
        (∏ s : ↥S, ((ε s : ℤ) : ZMod p)) * P := by
    rw [Finset.prod_mul_distrib, hperm]
  have hmul :
      (a : ZMod p) ^ S.card * P =
        (∏ s : ↥S, ((ε s : ℤ) : ZMod p)) * P := by
    calc
      (a : ZMod p) ^ S.card * P =
          ∏ s : ↥S, (a : ZMod p) * (s.1 : ZMod p) := hleft.symm
      _ = ∏ s : ↥S, ((ε s : ℤ) : ZMod p) * ((τ s).1 : ZMod p) := hprod
      _ = (∏ s : ↥S, ((ε s : ℤ) : ZMod p)) * P := hright
  have hpow :
      (a : ZMod p) ^ S.card =
        ∏ s : ↥S, ((ε s : ℤ) : ZMod p) :=
    mul_right_cancel₀ hP hmul
  rw [legendreValue, ← hcard]
  simpa using hpow

private theorem intProduct_eq_one_or_neg_one_of_terms
    {α : Type*} [Fintype α]
    (ε : α → ℤ)
    (hε : ∀ x, ε x = 1 ∨ ε x = -1) :
    (∏ x, ε x) = 1 ∨ (∏ x, ε x) = -1 := by
  classical
  apply (sq_eq_one_iff).mp
  rw [← Finset.prod_pow]
  apply Finset.prod_eq_one
  intro x _
  rcases hε x with hx | hx <;> simp [hx]

/--
Integer-sign form of the signed-permutation core. Under the actual Gauss decomposition,
where every multiplier is `1` or `-1`, the project Legendre sign is their integer product.
-/
theorem gaussSignedPermutation_legendreSign
    (p : ℕ) [Fact p.Prime]
    (hp : p ≠ 2)
    (S : Finset (ZMod p)ˣ)
    (a : (ZMod p)ˣ)
    (ε : ↥S → ℤ)
    (τ : ↥S → ↥S)
    (hε : ∀ s, ε s = 1 ∨ ε s = -1)
    (hτ : Function.Bijective τ)
    (hdecomp : ∀ s,
      (a : ZMod p) * (s.1 : ZMod p) =
        ((ε s : ℤ) : ZMod p) * ((τ s).1 : ZMod p))
    (hcard : S.card = (p - 1) / 2) :
    legendreSign p (a : ZMod p) = ∏ s : ↥S, ε s := by
  classical
  have hfield :=
    gaussSignedPermutation_legendreValue p S a ε τ hτ hdecomp hcard
  have hcast :
      ((legendreSign p (a : ZMod p) : ℤ) : ZMod p) =
        (((∏ s : ↥S, ε s) : ℤ) : ZMod p) :=
    (intCast_legendreSign_eq_legendreValue p hp (a : ZMod p)).trans hfield
  have ha0 : (a : ZMod p) ≠ 0 := Units.ne_zero a
  have hleft := legendreSign_eq_one_or_neg_one_of_ne_zero p (a : ZMod p) ha0
  have hright := intProduct_eq_one_or_neg_one_of_terms ε hε
  have hp3 : 3 ≤ p := by
    have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
    omega
  letI : Fact (2 < p) := ⟨by omega⟩
  rcases hleft with hleft | hleft <;> rcases hright with hright | hright
  · rw [hleft, hright]
  · have hcast' := hcast
    simp only [hleft, Int.cast_one] at hcast'
    have hrightCast := congrArg (fun z : ℤ => (z : ZMod p)) hright
    have hbad : (1 : ZMod p) = -1 := by
      calc
        (1 : ZMod p) = (((∏ s : ↥S, ε s) : ℤ) : ZMod p) := hcast'
        _ = -1 := by simpa using hrightCast
    exact False.elim (ZMod.neg_one_ne_one hbad.symm)
  · have hcast' := hcast
    simp only [hleft, Int.cast_neg, Int.cast_one] at hcast'
    have hrightCast := congrArg (fun z : ℤ => (z : ZMod p)) hright
    have hbad : (-1 : ZMod p) = 1 := by
      calc
        (-1 : ZMod p) = (((∏ s : ↥S, ε s) : ℤ) : ZMod p) := hcast'
        _ = 1 := by simpa using hrightCast
    exact False.elim (ZMod.neg_one_ne_one hbad)
  · rw [hleft, hright]

end GaussLemma

end SerreNumberTheoryAI
