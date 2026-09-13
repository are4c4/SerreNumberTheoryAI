import Mathlib.RingTheory.MvPolynomial.Homogeneous
import SerreNumberTheoryAI.Formalization.Chapter01.ChevalleyNontrivialZero

/-!
# Quadratic-form corollary of Chevalley–Warning

Independent formalization of the second corollary following Serre's
Chevalley–Warning theorem in Chapter 1, §2, 2.2.

Source metadata only: Japanese edition, printed p. 7, uploaded PDF p. 17.
-/

namespace SerreNumberTheoryAI

open MvPolynomial

section ChevalleyQuadraticForm

/--
A homogeneous quadratic polynomial over a finite field in at least three
variables has a nonzero zero.

The proof is the source-shaped specialization of the first Chevalley–Warning
corollary to the singleton family containing the quadratic form.
-/
theorem serre_quadraticForm_exists_nontrivial_zero
    {K σ : Type*} [Field K] [Fintype K] [Fintype σ] [DecidableEq σ]
    (f : MvPolynomial σ K)
    (hf : f.IsHomogeneous 2)
    (hvars : 3 ≤ Fintype.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ eval x f = 0 := by
  classical
  letI : CharP K (ringChar K) := ringChar.charP K

  have hdeg : f.totalDegree < Fintype.card σ := by
    calc
      f.totalDegree ≤ 2 := hf.totalDegree_le
      _ < Fintype.card σ := by omega

  have hzero : eval (0 : σ → K) f = 0 := by
    rw [MvPolynomial.eval_zero]
    rw [MvPolynomial.constantCoeff_eq]
    exact hf.coeff_eq_zero (by simp)

  obtain ⟨x, hx, hxzero⟩ :=
    serre_chevalleyWarning_exists_nontrivial_zero
      (K := K) (σ := σ) (ι := Unit) (ringChar K)
      (s := {()}) (f := fun _ : Unit => f)
      (by simpa using hdeg)
      (by
        intro i hi
        simpa using hzero)

  refine ⟨x, hx, ?_⟩
  exact hxzero () (by simp)

end ChevalleyQuadraticForm

end SerreNumberTheoryAI
