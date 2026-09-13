import SerreNumberTheoryAI.Formalization.Chapter01.ChevalleyNontrivialZero
import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Quadratic-form corollary of Chevalley–Warning

Independent formalization of Serre, Chapter 1, §2.2, Corollary 2.

Source metadata only: Japanese edition, printed p. 7, uploaded PDF p. 17.
-/

namespace SerreNumberTheoryAI

open MvPolynomial

section ChevalleyQuadraticForm

variable {K σ : Type*} [Fintype K] [Field K] [Fintype σ]

/--
Serre's second corollary to Chevalley–Warning: a quadratic form over a finite
field in at least three variables has a nonzero zero.

A quadratic form is represented here by a homogeneous multivariate polynomial
of degree `2`. No nonsingularity or nondegeneracy assumption is imposed.
-/
theorem serre_chevalleyWarning_quadraticForm_exists_nontrivial_zero
    (p : ℕ) [CharP K p]
    (f : MvPolynomial σ K)
    (hhom : f.IsHomogeneous 2)
    (hvars : 3 ≤ Fintype.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ eval x f = 0 := by
  classical
  have hdegree : f.totalDegree < Fintype.card σ :=
    lt_of_le_of_lt hhom.totalDegree_le (by omega)
  have hzero : eval (0 : σ → K) f = 0 := by
    rw [MvPolynomial.eval_zero]
    change f.coeff 0 = 0
    exact hhom.coeff_eq_zero (by simp)
  obtain ⟨x, hx, hfx⟩ :=
    serre_chevalleyWarning_exists_nontrivial_zero
      (K := K) (σ := σ) (ι := Unit) p
      (s := Finset.univ) (f := fun _ => f)
      (by simpa using hdegree)
      (by
        intro i hi
        simpa using hzero)
  refine ⟨x, hx, ?_⟩
  simpa using hfx () (Finset.mem_univ ())

end ChevalleyQuadraticForm

end SerreNumberTheoryAI
