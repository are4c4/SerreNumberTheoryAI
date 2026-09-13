import Mathlib.RingTheory.RootsOfUnity.PrimitiveRoots
import SerreNumberTheoryAI.Formalization.Chapter01.FiniteFields
import SerreNumberTheoryAI.Formalization.Chapter01.MultiplicativeGroup

/-!
# Square elements in finite fields

Independent formalization of Serre, Chapter 1, §3.1, Theorem 4.

Source metadata only: Japanese edition, printed p. 8, uploaded PDF p. 18.
-/

namespace SerreNumberTheoryAI

section QuadraticElements

variable (K : Type*) [Field K] [Fintype K]

/-- The subgroup of nonzero squares in a finite field. -/
def finiteFieldNonzeroSquares : Subgroup Kˣ :=
  (powMonoidHom (α := Kˣ) 2).range

/-- The half-power map on the multiplicative group. -/
noncomputable def finiteFieldHalfPowerCharacter : Kˣ →* Kˣ :=
  powMonoidHom (Nat.card Kˣ / 2)

@[simp]
theorem finiteFieldHalfPowerCharacter_apply (x : Kˣ) :
    finiteFieldHalfPowerCharacter K x = x ^ (Nat.card Kˣ / 2) :=
  rfl

/-- In characteristic two, every finite-field element is a square. -/
theorem finiteField_isSquare_of_char_two [CharP K 2] (x : K) : IsSquare x := by
  letI : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  have hsurj : Function.Surjective (frobeniusPowerMap K 2) := by
    rw [← Finite.injective_iff_surjective]
    exact RingHom.injective (frobeniusPowerMap K 2)
  obtain ⟨y, hy⟩ := hsurj x
  refine ⟨y, ?_⟩
  simpa [frobeniusPowerMap_apply, pow_two] using hy.symm

/-- In odd characteristic, the multiplicative group has even order. -/
theorem finiteField_units_card_even_of_char_ne_two
    (p : ℕ) [CharP K p] (hp : p ≠ 2) :
    2 ∣ Nat.card Kˣ := by
  have horder : orderOf (-1 : Kˣ) = 2 := by
    rw [← orderOf_units, Units.coe_neg_one]
    exact (IsPrimitiveRoot.neg_one p hp).eq_orderOf.symm
  rw [← horder]
  exact orderOf_dvd_natCard (-1 : Kˣ)

/-- In odd characteristic, the subgroup of nonzero squares has index two. -/
theorem finiteFieldNonzeroSquares_index
    (p : ℕ) [CharP K p] (hp : p ≠ 2) :
    (finiteFieldNonzeroSquares K).index = 2 := by
  letI : IsCyclic Kˣ := finiteField_units_isCyclic K
  rw [finiteFieldNonzeroSquares, IsCyclic.index_powMonoidHom_range,
    Nat.gcd_eq_right_iff_dvd]
  exact finiteField_units_card_even_of_char_ne_two K p hp

/-- Every square unit is killed by the half-power character in odd characteristic. -/
theorem finiteFieldNonzeroSquares_le_halfPowerCharacter_ker
    (p : ℕ) [CharP K p] (hp : p ≠ 2) :
    finiteFieldNonzeroSquares K ≤ (finiteFieldHalfPowerCharacter K).ker := by
  have htwo : 2 ∣ Nat.card Kˣ :=
    finiteField_units_card_even_of_char_ne_two K p hp
  rintro x ⟨y, rfl⟩
  change (y ^ 2) ^ (Nat.card Kˣ / 2) = 1
  rw [← pow_mul, Nat.mul_div_cancel' htwo, pow_card_eq_one']

/-- In odd characteristic, the nonzero-square subgroup is exactly the kernel of the half-power map. -/
theorem finiteFieldNonzeroSquares_eq_ker_halfPowerCharacter
    (p : ℕ) [CharP K p] (hp : p ≠ 2) :
    finiteFieldNonzeroSquares K = (finiteFieldHalfPowerCharacter K).ker := by
  letI : IsCyclic Kˣ := finiteField_units_isCyclic K
  have htwo : 2 ∣ Nat.card Kˣ :=
    finiteField_units_card_even_of_char_ne_two K p hp
  apply Subgroup.eq_of_le_of_card_ge
    (finiteFieldNonzeroSquares_le_halfPowerCharacter_ker K p hp)
  change Nat.card (powMonoidHom (Nat.card Kˣ / 2) : Kˣ →* Kˣ).ker ≤
    Nat.card (powMonoidHom 2 : Kˣ →* Kˣ).range
  rw [IsCyclic.card_powMonoidHom_ker, IsCyclic.card_powMonoidHom_range,
    Nat.gcd_eq_right (Nat.div_dvd_of_dvd htwo), Nat.gcd_eq_right htwo]

/-- The half-power character takes only the values `1` and `-1` in odd characteristic. -/
theorem finiteFieldHalfPowerCharacter_eq_one_or_neg_one
    (p : ℕ) [CharP K p] (hp : p ≠ 2) (x : Kˣ) :
    finiteFieldHalfPowerCharacter K x = 1 ∨
      finiteFieldHalfPowerCharacter K x = -1 := by
  have htwo : 2 ∣ Nat.card Kˣ :=
    finiteField_units_card_even_of_char_ne_two K p hp
  have hsqU : (finiteFieldHalfPowerCharacter K x) ^ 2 = 1 := by
    change (x ^ (Nat.card Kˣ / 2)) ^ 2 = 1
    rw [← pow_mul, Nat.div_mul_cancel htwo, pow_card_eq_one']
  have hsqK : ((finiteFieldHalfPowerCharacter K x : Kˣ) : K) ^ 2 = 1 := by
    simpa using congrArg ((↑) : Kˣ → K) hsqU
  rcases (sq_eq_one_iff.mp hsqK) with h | h
  · exact Or.inl (Units.ext h)
  · exact Or.inr (Units.ext h)

/-- A nonzero element is a square exactly when its half-power value is `1`. -/
theorem mem_finiteFieldNonzeroSquares_iff_halfPowerCharacter_eq_one
    (p : ℕ) [CharP K p] (hp : p ≠ 2) (x : Kˣ) :
    x ∈ finiteFieldNonzeroSquares K ↔ finiteFieldHalfPowerCharacter K x = 1 := by
  rw [finiteFieldNonzeroSquares_eq_ker_halfPowerCharacter K p hp]
  exact MonoidHom.mem_ker

/-- Serre's Theorem 4(a), the characteristic-two case. -/
theorem serre_theorem4_char_two [CharP K 2] :
    ∀ x : K, IsSquare x :=
  finiteField_isSquare_of_char_two K

/-- Serre's Theorem 4(b), the odd-characteristic case. -/
theorem serre_theorem4_odd
    (p : ℕ) [CharP K p] (hp : p ≠ 2) :
    (finiteFieldNonzeroSquares K).index = 2 ∧
      finiteFieldNonzeroSquares K = (finiteFieldHalfPowerCharacter K).ker ∧
      ∀ x : Kˣ,
        finiteFieldHalfPowerCharacter K x = 1 ∨
          finiteFieldHalfPowerCharacter K x = -1 := by
  exact ⟨finiteFieldNonzeroSquares_index K p hp,
    finiteFieldNonzeroSquares_eq_ker_halfPowerCharacter K p hp,
    finiteFieldHalfPowerCharacter_eq_one_or_neg_one K p hp⟩

end QuadraticElements

end SerreNumberTheoryAI
