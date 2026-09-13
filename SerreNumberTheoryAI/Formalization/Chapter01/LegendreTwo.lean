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
  rw [ne_eq, ZMod.natCast_eq_zero_iff]
  intro hdiv
  have hpow : p ∣ 2 ^ 3 := by
    norm_num at hdiv ⊢
    exact hdiv
  have hp2 : p ∣ 2 := (Fact.out : p.Prime).dvd_of_dvd_pow hpow
  exact hp ((Nat.dvd_prime Nat.prime_two).mp hp2)

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

end LegendreTwo

end SerreNumberTheoryAI
