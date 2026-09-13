import Mathlib.Algebra.Group.Even
import Mathlib.Data.ZMod.Basic
import SerreNumberTheoryAI.Formalization.Chapter01.QuadraticElements

/-!
# Legendre symbol over a prime field

Independent formalization of Serre, Chapter 1, §3.2, beginning with the
source's half-power definition of the Legendre value.

Source metadata only: Japanese edition, printed pp. 8–9, uploaded PDF pp. 18–19.
-/

namespace SerreNumberTheoryAI

section LegendreSymbol

/-- The field-valued Legendre value used in the source: `x^((p-1)/2)` in `ZMod p`. -/
def legendreValue (p : ℕ) (x : ZMod p) : ZMod p :=
  x ^ ((p - 1) / 2)

/-- Integer input transported to the prime field before taking the Legendre value. -/
def legendreValueInt (p : ℕ) (a : ℤ) : ZMod p :=
  legendreValue p (a : ZMod p)

@[simp]
theorem legendreValue_one (p : ℕ) : legendreValue p 1 = 1 := by
  simp [legendreValue]

@[simp]
theorem legendreValue_mul (p : ℕ) (x y : ZMod p) :
    legendreValue p (x * y) = legendreValue p x * legendreValue p y := by
  simp [legendreValue, mul_pow]

section OddPrime

variable (p : ℕ) [Fact p.Prime]

/-- The source half-power exponent agrees with the exponent in the §3.1 unit-group character. -/
theorem legendreValue_eq_halfPowerCharacter_coe
    (x : ZMod p) (hx : x ≠ 0) :
    legendreValue p x =
      ((finiteFieldHalfPowerCharacter (ZMod p) (Units.mk0 x hx) : (ZMod p)ˣ) : ZMod p) := by
  change x ^ ((p - 1) / 2) = x ^ (Nat.card (ZMod p)ˣ / 2)
  rw [finiteField_units_natCard (ZMod p), Nat.card_zmod]

/-- In odd characteristic, every nonzero source Legendre value is `1` or `-1`. -/
theorem legendreValue_eq_one_or_neg_one_of_ne_zero
    (hp : p ≠ 2) (x : ZMod p) (hx : x ≠ 0) :
    legendreValue p x = 1 ∨ legendreValue p x = -1 := by
  have h := finiteFieldHalfPowerCharacter_eq_one_or_neg_one
    (ZMod p) p hp (Units.mk0 x hx)
  rcases h with h | h
  · left
    rw [legendreValue_eq_halfPowerCharacter_coe p x hx]
    simpa using congrArg (fun u : (ZMod p)ˣ => (u : ZMod p)) h
  · right
    rw [legendreValue_eq_halfPowerCharacter_coe p x hx]
    simpa using congrArg (fun u : (ZMod p)ˣ => (u : ZMod p)) h

/-- A nonzero prime-field element represents a unit square exactly when it is a square in the field. -/
theorem unitsMk0_mem_finiteFieldNonzeroSquares_iff_isSquare
    (x : ZMod p) (hx : x ≠ 0) :
    Units.mk0 x hx ∈ finiteFieldNonzeroSquares (ZMod p) ↔ IsSquare x := by
  constructor
  · intro h
    change Units.mk0 x hx ∈ (powMonoidHom (α := (ZMod p)ˣ) 2).range at h
    rcases h with ⟨y, hy⟩
    rw [isSquare_iff_exists_sq]
    refine ⟨(y : ZMod p), ?_⟩
    have hv := congrArg (fun u : (ZMod p)ˣ => (u : ZMod p)) hy
    simpa using hv.symm
  · intro h
    rw [isSquare_iff_exists_sq] at h
    rcases h with ⟨y, hy⟩
    have hy0 : y ≠ 0 := by
      intro hyzero
      apply hx
      rw [hy, hyzero]
      simp
    change Units.mk0 x hx ∈ (powMonoidHom (α := (ZMod p)ˣ) 2).range
    refine ⟨Units.mk0 y hy0, ?_⟩
    apply Units.ext
    simpa using hy.symm

/-- For a nonzero element, Legendre value `1` is equivalent to being a square. -/
theorem legendreValue_eq_one_iff_isSquare_of_ne_zero
    (hp : p ≠ 2) (x : ZMod p) (hx : x ≠ 0) :
    legendreValue p x = 1 ↔ IsSquare x := by
  let u : (ZMod p)ˣ := Units.mk0 x hx
  have hu : u ∈ finiteFieldNonzeroSquares (ZMod p) ↔
      finiteFieldHalfPowerCharacter (ZMod p) u = 1 :=
    mem_finiteFieldNonzeroSquares_iff_halfPowerCharacter_eq_one (ZMod p) p hp u
  have hsquare : u ∈ finiteFieldNonzeroSquares (ZMod p) ↔ IsSquare x := by
    simpa [u] using unitsMk0_mem_finiteFieldNonzeroSquares_iff_isSquare p x hx
  have hbridge : legendreValue p x =
      ((finiteFieldHalfPowerCharacter (ZMod p) u : (ZMod p)ˣ) : ZMod p) := by
    simpa [u] using legendreValue_eq_halfPowerCharacter_coe p x hx
  constructor
  · intro hval
    apply hsquare.mp
    apply hu.mpr
    apply Units.ext
    rw [← hbridge]
    simpa using hval
  · intro hs
    have hchar : finiteFieldHalfPowerCharacter (ZMod p) u = 1 := hu.mp (hsquare.mpr hs)
    rw [hbridge]
    simpa using congrArg (fun v : (ZMod p)ˣ => (v : ZMod p)) hchar

/-- At zero the Legendre value is zero for an odd prime. -/
@[simp]
theorem legendreValue_zero (hp : p ≠ 2) : legendreValue p (0 : ZMod p) = 0 := by
  have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
  have hp3 : 3 ≤ p := by omega
  have hexp : 0 < (p - 1) / 2 := by omega
  simp [legendreValue, hexp.ne']

/-- The characteristic-independent sign representative of the Legendre value. -/
def legendreSign (x : ZMod p) : ℤ :=
  if x = 0 then 0 else if legendreValue p x = 1 then 1 else -1

/-- Integer input transported to `ZMod p` before taking the sign representative. -/
def legendreSignInt (a : ℤ) : ℤ :=
  legendreSign p (a : ZMod p)

@[simp]
theorem legendreSign_zero : legendreSign p (0 : ZMod p) = 0 := by
  simp [legendreSign]

@[simp]
theorem legendreSign_one : legendreSign p (1 : ZMod p) = 1 := by
  simp [legendreSign]

/-- A nonzero Legendre sign is always one of the two signs. -/
theorem legendreSign_eq_one_or_neg_one_of_ne_zero
    (x : ZMod p) (hx : x ≠ 0) :
    legendreSign p x = 1 ∨ legendreSign p x = -1 := by
  by_cases h : legendreValue p x = 1
  · left
    simp [legendreSign, hx, h]
  · right
    simp [legendreSign, hx, h]

/-- Casting the sign representative back to the prime field recovers the source Legendre value. -/
theorem intCast_legendreSign_eq_legendreValue
    (hp : p ≠ 2) (x : ZMod p) :
    ((legendreSign p x : ℤ) : ZMod p) = legendreValue p x := by
  by_cases hx : x = 0
  · subst x
    simp [legendreSign, legendreValue_zero p hp]
  · rcases legendreValue_eq_one_or_neg_one_of_ne_zero p hp x hx with h | h
    · simp [legendreSign, hx, h]
    · have hp3 : 3 ≤ p := by
        have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
        omega
      letI : Fact (2 < p) := ⟨by omega⟩
      have hne : legendreValue p x ≠ 1 := by
        intro h1
        exact ZMod.neg_one_ne_one (h.symm.trans h1)
      have hsign : legendreSign p x = -1 := by
        simp only [legendreSign, if_neg hx, if_neg hne]
      rw [hsign, h]
      norm_num

/-- The characteristic-independent sign layer is multiplicative. -/
theorem legendreSign_mul
    (hp : p ≠ 2) (x y : ZMod p) :
    legendreSign p (x * y) = legendreSign p x * legendreSign p y := by
  by_cases hx : x = 0
  · subst x
    simp [legendreSign]
  by_cases hy : y = 0
  · subst y
    simp [legendreSign]
  have hxy : x * y ≠ 0 := mul_ne_zero hx hy
  have hp3 : 3 ≤ p := by
    have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
    omega
  letI : Fact (2 < p) := ⟨by omega⟩
  have hneg : (-1 : ZMod p) ≠ 1 := ZMod.neg_one_ne_one
  have hsignOne (z : ZMod p) (hz : z ≠ 0)
      (hv : legendreValue p z = 1) : legendreSign p z = 1 := by
    simp [legendreSign, hz, hv]
  have hsignNeg (z : ZMod p) (hz : z ≠ 0)
      (hv : legendreValue p z = -1) : legendreSign p z = -1 := by
    have hv1 : legendreValue p z ≠ 1 := by
      rw [hv]
      exact hneg
    simp [legendreSign, hz, hv1]
  rcases legendreValue_eq_one_or_neg_one_of_ne_zero p hp x hx with hx1 | hxneg
  · rcases legendreValue_eq_one_or_neg_one_of_ne_zero p hp y hy with hy1 | hyneg
    · have hxy1 : legendreValue p (x * y) = 1 := by
        rw [legendreValue_mul, hx1, hy1]
        simp
      rw [hsignOne (x * y) hxy hxy1, hsignOne x hx hx1, hsignOne y hy hy1]
      norm_num
    · have hxyneg : legendreValue p (x * y) = -1 := by
        rw [legendreValue_mul, hx1, hyneg]
        simp
      rw [hsignNeg (x * y) hxy hxyneg, hsignOne x hx hx1, hsignNeg y hy hyneg]
      norm_num
  · rcases legendreValue_eq_one_or_neg_one_of_ne_zero p hp y hy with hy1 | hyneg
    · have hxyneg : legendreValue p (x * y) = -1 := by
        rw [legendreValue_mul, hxneg, hy1]
        simp
      rw [hsignNeg (x * y) hxy hxyneg, hsignNeg x hx hxneg, hsignOne y hy hy1]
      norm_num
    · have hxy1 : legendreValue p (x * y) = 1 := by
        rw [legendreValue_mul, hxneg, hyneg]
        simp
      rw [hsignOne (x * y) hxy hxy1, hsignNeg x hx hxneg, hsignNeg y hy hyneg]
      norm_num

/-- Multiplicativity after transporting integer inputs into the prime field. -/
theorem legendreSignInt_mul
    (hp : p ≠ 2) (a b : ℤ) :
    legendreSignInt p (a * b) = legendreSignInt p a * legendreSignInt p b := by
  simpa [legendreSignInt] using
    legendreSign_mul p hp (a : ZMod p) (b : ZMod p)

/-- Serre's Theorem 5(i): the Legendre sign of `1` is `1`. -/
theorem serre_theorem5_i : legendreSignInt p 1 = 1 := by
  simp [legendreSignInt]

/-- Serre's Theorem 5(ii): the value at `-1` is governed by `(p-1)/2` parity. -/
theorem serre_theorem5_ii
    (hp : p ≠ 2) :
    legendreSignInt p (-1) = (-1 : ℤ) ^ ((p - 1) / 2) := by
  have hp3 : 3 ≤ p := by
    have hp2 : 2 ≤ p := (Fact.out : p.Prime).two_le
    omega
  letI : Fact (2 < p) := ⟨by omega⟩
  have hneg0 : (-1 : ZMod p) ≠ 0 := by simp
  rcases Nat.even_or_odd ((p - 1) / 2) with hn | hn
  · have hval : legendreValue p (-1 : ZMod p) = 1 := by
      change (-1 : ZMod p) ^ ((p - 1) / 2) = 1
      exact hn.neg_one_pow
    calc
      legendreSignInt p (-1) = 1 := by
        simp [legendreSignInt, legendreSign, hneg0, hval]
      _ = (-1 : ℤ) ^ ((p - 1) / 2) := hn.neg_one_pow.symm
  · have hval : legendreValue p (-1 : ZMod p) = -1 := by
      change (-1 : ZMod p) ^ ((p - 1) / 2) = -1
      exact hn.neg_one_pow
    have hval1 : legendreValue p (-1 : ZMod p) ≠ 1 := by
      rw [hval]
      exact ZMod.neg_one_ne_one
    calc
      legendreSignInt p (-1) = -1 := by
        simp [legendreSignInt, legendreSign, hneg0, hval1]
      _ = (-1 : ℤ) ^ ((p - 1) / 2) := hn.neg_one_pow.symm

end OddPrime

end LegendreSymbol

end SerreNumberTheoryAI
