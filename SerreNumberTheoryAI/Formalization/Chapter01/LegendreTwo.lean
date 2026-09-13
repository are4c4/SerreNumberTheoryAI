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

/-- In the algebraic closure of `F_p`, odd characteristic supplies a primitive eighth root. -/
theorem exists_primitive_eighth_root_algClosure (hp : p ≠ 2) :
    ∃ α : AlgebraicClosure (ZMod p), IsPrimitiveRoot α 8 := by
  letI : NeZero (8 : ZMod p) := ⟨zmod_eight_ne_zero_of_prime_ne_two p hp⟩
  exact HasEnoughRootsOfUnity.exists_primitiveRoot (AlgebraicClosure (ZMod p)) 8

/-- The fourth power of a primitive eighth root is `-1`. -/
theorem primitive_eighth_root_pow_four_eq_neg_one
    {K : Type*} [Field K] {α : K} (hα : IsPrimitiveRoot α 8) :
    α ^ 4 = -1 := by
  have hα4 : IsPrimitiveRoot (α ^ 4) 2 := by
    convert hα.pow_of_dvd (by norm_num : 4 ≠ 0) (by norm_num : 4 ∣ 8) using 1 <;> norm_num
  exact hα4.eq_neg_one_of_two_right

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

end LegendreTwo

end SerreNumberTheoryAI
