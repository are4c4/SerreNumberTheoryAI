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
    simpa [P] using (Units.ne_zero (∏ s : ↥S, s.1))
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

/--
A source-shaped half-system of nonzero residues: exactly half of the units are chosen,
every unit occurs in the chosen half or as the negative of one, and the two halves are disjoint.
-/
structure GaussHalfSystem (p : ℕ) where
  carrier : Finset (ZMod p)ˣ
  card_eq : carrier.card = (p - 1) / 2
  mem_or_neg_mem : ∀ u : (ZMod p)ˣ, u ∈ carrier ∨ -u ∈ carrier
  neg_not_mem : ∀ u : (ZMod p)ˣ, u ∈ carrier → -u ∉ carrier

/-- The chosen representative of `a*s` in the half-system, after forgetting its sign. -/
def gaussRepresentative {p : ℕ}
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) (s : ↥H.carrier) : ↥H.carrier := by
  classical
  by_cases h : a * s.1 ∈ H.carrier
  · exact ⟨a * s.1, h⟩
  · exact ⟨-(a * s.1), (H.mem_or_neg_mem (a * s.1)).resolve_left h⟩

/-- The sign needed to return `a*s` to the chosen half-system. -/
def gaussSign {p : ℕ}
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) (s : ↥H.carrier) : ℤ := by
  classical
  exact if a * s.1 ∈ H.carrier then 1 else -1

@[simp]
theorem gaussSign_eq_one_or_neg_one {p : ℕ}
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) (s : ↥H.carrier) :
    gaussSign H a s = 1 ∨ gaussSign H a s = -1 := by
  classical
  by_cases h : a * s.1 ∈ H.carrier
  · left
    simp [gaussSign, h]
  · right
    simp [gaussSign, h]

/-- The representative and sign satisfy the defining signed-decomposition identity. -/
theorem gaussSign_mul_representative {p : ℕ}
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) (s : ↥H.carrier) :
    (a : ZMod p) * (s.1 : ZMod p) =
      ((gaussSign H a s : ℤ) : ZMod p) *
        ((gaussRepresentative H a s).1 : ZMod p) := by
  classical
  by_cases h : a * s.1 ∈ H.carrier
  · simp [gaussSign, gaussRepresentative, h]
  · simp [gaussSign, gaussRepresentative, h]

/-- Multiplication followed by returning to the chosen half-system is injective. -/
theorem gaussRepresentative_injective {p : ℕ}
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) :
    Function.Injective (gaussRepresentative H a) := by
  classical
  intro s t hst
  by_cases hs : a * s.1 ∈ H.carrier
  · by_cases ht : a * t.1 ∈ H.carrier
    · have hmul : a * s.1 = a * t.1 := by
        simpa [gaussRepresentative, hs, ht] using
          congrArg (fun x : ↥H.carrier => x.1) hst
      have hst' : s.1 = t.1 := mul_left_cancel hmul
      exact Subtype.ext hst'
    · have hmul : a * s.1 = -(a * t.1) := by
        simpa [gaussRepresentative, hs, ht] using
          congrArg (fun x : ↥H.carrier => x.1) hst
      have hst' : s.1 = -t.1 := by
        apply mul_left_cancel (a := a)
        simpa using hmul
      have hnegmem : -t.1 ∈ H.carrier := by
        rw [← hst']
        exact s.2
      exact False.elim ((H.neg_not_mem t.1 t.2) hnegmem)
  · by_cases ht : a * t.1 ∈ H.carrier
    · have hmul : -(a * s.1) = a * t.1 := by
        simpa [gaussRepresentative, hs, ht] using
          congrArg (fun x : ↥H.carrier => x.1) hst
      have hst' : t.1 = -s.1 := by
        apply mul_left_cancel (a := a)
        simpa using hmul.symm
      have hnegmem : -s.1 ∈ H.carrier := by
        rw [← hst']
        exact t.2
      exact False.elim ((H.neg_not_mem s.1 s.2) hnegmem)
    · have hmul : -(a * s.1) = -(a * t.1) := by
        simpa [gaussRepresentative, hs, ht] using
          congrArg (fun x : ↥H.carrier => x.1) hst
      have hmul' : a * s.1 = a * t.1 := by
        simpa using congrArg (fun u : (ZMod p)ˣ => -u) hmul
      have hst' : s.1 = t.1 := mul_left_cancel hmul'
      exact Subtype.ext hst'

/-- On the finite half-system, the representative map is therefore a permutation. -/
theorem gaussRepresentative_bijective {p : ℕ}
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) :
    Function.Bijective (gaussRepresentative H a) := by
  have hinj := gaussRepresentative_injective H a
  exact ⟨hinj, Finite.injective_iff_surjective.mp hinj⟩

/--
Gauss's lemma in source form: the Legendre sign of `a` is the product of the signs obtained
when multiplication by `a` is returned to a chosen half-system of nonzero residue classes.
-/
theorem serre_gaussLemma
    (p : ℕ) [Fact p.Prime] (hp : p ≠ 2)
    (H : GaussHalfSystem p) (a : (ZMod p)ˣ) :
    legendreSign p (a : ZMod p) =
      ∏ s : ↥H.carrier, gaussSign H a s := by
  exact gaussSignedPermutation_legendreSign
    p hp H.carrier a (gaussSign H a) (gaussRepresentative H a)
    (gaussSign_eq_one_or_neg_one H a)
    (gaussRepresentative_bijective H a)
    (gaussSign_mul_representative H a)
    H.card_eq

end GaussLemma

end SerreNumberTheoryAI
