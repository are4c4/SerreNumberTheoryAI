import Mathlib.RingTheory.RootsOfUnity.AlgebraicallyClosed
import SerreNumberTheoryAI.Formalization.Chapter01.LegendreSymbol

/-!
# The supplementary Legendre law at two

Source-shaped infrastructure for Serre, Chapter 1, §3.2, Theorem 5(iii).
The proof follows the primitive-eighth-root route rather than importing a
ready-made Legendre-symbol supplementary law.
-/

namespace SerreNumberTheoryAI

section LegendreTwo

variable (p : ℕ) [Fact p.Prime]

/-- For an odd prime `p`, the class of `8` is nonzero in `ZMod p`. -/
theorem zmod_eight_ne_zero_of_prime_ne_two (hp : p ≠ 2) :
    (8 : ZMod p) ≠ 0 := by
  change ((8 : ℕ) : ZMod p) ≠ 0
  rw [ne_eq, ZMod.natCast_eq_zero_iff]
  intro hdiv
  have hpow : p ∣ 2 ^ 3 := by
    norm_num at hdiv ⊢
    exact hdiv
  have hp2 : p ∣ 2 := (Fact.out : p.Prime).dvd_of_dvd_pow hpow
  rcases (Nat.dvd_prime Nat.prime_two).mp hp2 with hp1 | hp2eq
  · exact (Fact.out : p.Prime).ne_one hp1
  · exact hp hp2eq

/-- An odd prime has one of the four odd residue classes modulo `8`. -/
theorem odd_prime_mod_eight_cases (hp : p ≠ 2) :
    p % 8 = 1 ∨ p % 8 = 3 ∨ p % 8 = 5 ∨ p % 8 = 7 := by
  have hodd : Odd p := (Fact.out : p.Prime).odd_of_ne_two hp
  have hpmod2 : p % 2 = 1 := Nat.odd_iff.mp hodd
  have hlt : p % 8 < 8 := Nat.mod_lt p (by norm_num)
  have hmodmod : (p % 8) % 2 = p % 2 := by
    exact Nat.mod_mod_of_dvd p (by norm_num : 2 ∣ 8)
  omega

/-- In the algebraic closure of `F_p`, odd characteristic supplies a primitive eighth root. -/
theorem exists_primitive_eighth_root_algClosure (hp : p ≠ 2) :
    ∃ α : AlgebraicClosure (ZMod p), IsPrimitiveRoot α 8 := by
  letI : NeZero (8 : ZMod p) := ⟨zmod_eight_ne_zero_of_prime_ne_two p hp⟩
  exact HasEnoughRootsOfUnity.exists_primitiveRoot (AlgebraicClosure (ZMod p)) 8

/-- Powers of a primitive eighth root depend only on the exponent modulo `8`. -/
theorem primitive_eighth_root_pow_eq_pow_of_mod_eight
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8)
    (n r : ℕ) (hr : n % 8 = r) (hrlt : r < 8) :
    α ^ n = α ^ r := by
  have hfin : IsOfFinOrder α := hα.isOfFinOrder (by norm_num : (8 : ℕ) ≠ 0)
  rw [hfin.pow_eq_pow_iff_modEq, ← hα.eq_orderOf]
  change n % 8 = r % 8
  rw [hr, Nat.mod_eq_of_lt hrlt]

/-- The fourth power of a primitive eighth root is `-1`. -/
theorem primitive_eighth_root_pow_four_eq_neg_one
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8) :
    α ^ 4 = -1 := by
  have hα4 : IsPrimitiveRoot (α ^ 4) 2 := by
    convert hα.pow_of_dvd (by norm_num : 4 ≠ 0) (by norm_num : 4 ∣ 8) using 1 <;> norm_num
  exact hα4.eq_neg_one_of_two_right

/-- The seventh power of a primitive eighth root is its inverse. -/
theorem primitive_eighth_root_pow_seven_eq_inv
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8) :
    α ^ 7 = α⁻¹ := by
  apply eq_inv_of_mul_eq_one_left
  rw [← pow_succ]
  simpa using hα.pow_eq_one

/-- The third power of a primitive eighth root is minus its inverse. -/
theorem primitive_eighth_root_pow_three_eq_neg_inv
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8) :
    α ^ 3 = -α⁻¹ := by
  have hα0 : α ≠ 0 := (hα.isUnit (by norm_num : (8 : ℕ) ≠ 0)).ne_zero
  have hα4 : α ^ 4 = -1 := primitive_eighth_root_pow_four_eq_neg_one hα
  apply mul_right_cancel₀ hα0
  calc
    α ^ 3 * α = α ^ 4 := by rw [← pow_succ]
    _ = -1 := hα4
    _ = (-α⁻¹) * α := by simp [hα0]

/-- The fifth power of a primitive eighth root is minus the root itself. -/
theorem primitive_eighth_root_pow_five_eq_neg
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8) :
    α ^ 5 = -α := by
  have hα4 : α ^ 4 = -1 := primitive_eighth_root_pow_four_eq_neg_one hα
  calc
    α ^ 5 = α ^ 4 * α := by rw [show (5 : ℕ) = 4 + 1 by norm_num, pow_succ]
    _ = (-1) * α := by rw [hα4]
    _ = -α := by simp

/-- If `α` is a primitive eighth root, then the source element `α + α⁻¹` squares to `2`. -/
theorem primitive_eighth_root_add_inv_sq
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8) :
    (α + α⁻¹) ^ 2 = 2 := by
  have hα0 : α ≠ 0 := (hα.isUnit (by norm_num : (8 : ℕ) ≠ 0)).ne_zero
  have hα4 : α ^ 4 = -1 := primitive_eighth_root_pow_four_eq_neg_one hα
  have hidentity : (((α + α⁻¹) ^ 2 - 2) * α ^ 2) = α ^ 4 + 1 := by
    field_simp [hα0]
    ring
  have hz : (((α + α⁻¹) ^ 2 - 2) * α ^ 2) = 0 := by
    rw [hidentity, hα4]
    simp
  have hα2 : α ^ 2 ≠ 0 := pow_ne_zero 2 hα0
  have hdiff : (α + α⁻¹) ^ 2 - 2 = 0 :=
    (mul_eq_zero.mp hz).resolve_right hα2
  exact sub_eq_zero.mp hdiff

/-- In residue classes `1` and `7` modulo `8`, Frobenius fixes `α + α⁻¹`. -/
theorem primitive_eighth_root_add_inv_pow_prime_eq_self
    {K : Type*} [Field K] [CharP K p]
    {α : K} (hα : IsPrimitiveRoot α 8)
    (hr : p % 8 = 1 ∨ p % 8 = 7) :
    (α + α⁻¹) ^ p = α + α⁻¹ := by
  have hchar : (α + α⁻¹) ^ p = α ^ p + (α⁻¹) ^ p := by
    simpa using (add_pow_char α α⁻¹ p)
  rcases hr with hr | hr
  · have hpow : α ^ p = α := by
      simpa using primitive_eighth_root_pow_eq_pow_of_mod_eight hα p 1 hr (by norm_num)
    calc
      (α + α⁻¹) ^ p = α ^ p + (α⁻¹) ^ p := hchar
      _ = α + α⁻¹ := by rw [hpow, inv_pow, hpow]
  · have hpow : α ^ p = α⁻¹ := by
      calc
        α ^ p = α ^ 7 := primitive_eighth_root_pow_eq_pow_of_mod_eight hα p 7 hr (by norm_num)
        _ = α⁻¹ := primitive_eighth_root_pow_seven_eq_inv hα
    calc
      (α + α⁻¹) ^ p = α ^ p + (α⁻¹) ^ p := hchar
      _ = α + α⁻¹ := by rw [inv_pow, hpow]; simp [hpow]

/-- In residue classes `3` and `5` modulo `8`, Frobenius negates `α + α⁻¹`. -/
theorem primitive_eighth_root_add_inv_pow_prime_eq_neg_self
    {K : Type*} [Field K] [CharP K p]
    {α : K} (hα : IsPrimitiveRoot α 8)
    (hr : p % 8 = 3 ∨ p % 8 = 5) :
    (α + α⁻¹) ^ p = -(α + α⁻¹) := by
  have hchar : (α + α⁻¹) ^ p = α ^ p + (α⁻¹) ^ p := by
    simpa using (add_pow_char α α⁻¹ p)
  rcases hr with hr | hr
  · have hpow : α ^ p = -α⁻¹ := by
      calc
        α ^ p = α ^ 3 := primitive_eighth_root_pow_eq_pow_of_mod_eight hα p 3 hr (by norm_num)
        _ = -α⁻¹ := primitive_eighth_root_pow_three_eq_neg_inv hα
    calc
      (α + α⁻¹) ^ p = α ^ p + (α⁻¹) ^ p := hchar
      _ = -(α + α⁻¹) := by rw [inv_pow, hpow]; simp [hpow]; ring
  · have hpow : α ^ p = -α := by
      calc
        α ^ p = α ^ 5 := primitive_eighth_root_pow_eq_pow_of_mod_eight hα p 5 hr (by norm_num)
        _ = -α := primitive_eighth_root_pow_five_eq_neg hα
    calc
      (α + α⁻¹) ^ p = α ^ p + (α⁻¹) ^ p := hchar
      _ = -(α + α⁻¹) := by rw [inv_pow, hpow]; simp [hpow]; ring

end LegendreTwo

end SerreNumberTheoryAI
