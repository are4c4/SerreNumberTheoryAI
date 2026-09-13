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
      simp [legendreSign, hx, hne, h]

end OddPrime

end LegendreSymbol

end SerreNumberTheoryAI
