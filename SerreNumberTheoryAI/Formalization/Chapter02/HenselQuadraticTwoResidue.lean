import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticTwo

/-!
# Residue bridge for dyadic quadratic Hensel lifting

This file connects the determinant/primitive-vector residue argument from the
odd-prime quadratic corollary to the dyadic inner-gradient condition.  In the
`p = 2` case the symmetric gradient is `2 * Σᵢ aᵢⱼ xᵢ`, so the residue argument
must produce nonvanishing of the inner sum before the factor `2` is attached.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticTwoResidue

/--
A nonzero coordinate of the first-residue gradient matrix is exactly a nonzero
first residue of the dyadic inner sum `Σᵢ aᵢⱼ xᵢ`.
-/
theorem serreQuadraticTwoInnerSumWitness_of_matrixCoordinateWitness
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {A : σ → σ → SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreFirstResidueMatrixCoordinateWitness
      (serreFirstResidueGradientMatrix A) x) :
    serreQuadraticTwoInnerSumWitness A x := by
  rcases h with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  rw [← serreFirstResidueGradientMatrix_mulVec (p := 2) (A := A) (x := x) (j := j)]
  exact hj

/--
The determinant/primitive-vector residue argument supplies the dyadic inner-sum
nonvanishing witness.
-/
theorem serreQuadraticTwoInnerSumWitness_of_det_ne_zero_of_primitive
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {A : σ → σ → SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (hdet : (serreFirstResidueGradientMatrix A).det ≠ 0)
    (hprim : serrePadicTuplePrimitive x) :
    serreQuadraticTwoInnerSumWitness A x := by
  exact serreQuadraticTwoInnerSumWitness_of_matrixCoordinateWitness
    (serreFirstResidueMatrixCoordinateWitness_of_det_ne_zero_of_primitive
      hdet hprim)

/--
A unit determinant of the p-adic coefficient matrix gives the dyadic inner-sum
witness after first-residue reduction.
-/
theorem serreQuadraticTwoInnerSumWitness_of_isUnit_det
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {A : σ → σ → SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (hdet : IsUnit (Matrix.det A))
    (hprim : serrePadicTuplePrimitive x) :
    serreQuadraticTwoInnerSumWitness A x := by
  exact serreQuadraticTwoInnerSumWitness_of_det_ne_zero_of_primitive
    (serreFirstResidueGradientMatrix_det_ne_zero_of_isUnit_det (p := 2) hdet)
    hprim

/--
Source-shaped dyadic Hensel package using unit determinant and primitivity to
supply the inner-sum residue witness.
-/
def serreQuadraticTwoDetHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    (A : σ → σ → SerrePadicInt 2) (a : SerrePadicInt 2)
    (x : σ → SerrePadicInt 2) : Prop :=
  serreQuadraticMatrixSymmetric A ∧
    IsUnit (Matrix.det A) ∧
      serrePadicTuplePrimitive x ∧
        padicDivisibilityDepth 2 3
          (MvPolynomial.eval x (serreQuadraticPolynomial (p := 2) A) - a)

/-- Convert the determinant-shaped dyadic package to the inner-sum package. -/
theorem serreQuadraticTwoInnerSumHenselHypothesis_of_det
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoDetHenselHypothesis A a x) :
    serreQuadraticTwoInnerSumHenselHypothesis A a x := by
  rcases h with ⟨hA, hdet, hprim, hvalue⟩
  exact ⟨hA, hvalue, serreQuadraticTwoInnerSumWitness_of_isUnit_det hdet hprim⟩

/-- The determinant-shaped dyadic package gives the Hensel value-lift conclusion. -/
theorem serreHenselValueLift_mod_eight_of_quadratic_two_det_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoDetHenselHypothesis A a x) :
    serreHenselValueLiftConclusion 2 (serreQuadraticPolynomial (p := 2) A) a x 2 := by
  exact serreHenselValueLift_mod_eight_of_quadratic_two_innerSum_hypothesis
    (serreQuadraticTwoInnerSumHenselHypothesis_of_det h)

/-- Extract one exact solution congruent modulo `4` from the determinant package. -/
theorem serreQuadraticTwoDetHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoDetHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt 2,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := 2) A) = a ∧
        ∀ i, serrePadicCongruent 2 2 (x i) (y i) :=
  serreHenselValueLift_mod_eight_of_quadratic_two_det_hypothesis h

/--
Serre's dyadic quadratic corollary in source-shaped form: a symmetric matrix
with unit determinant, a primitive solution modulo `8`, and the value congruence
produce a Hensel value-lift conclusion congruent modulo `4`.
-/
theorem serreHenselValueLift_mod_eight_of_quadratic_two
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (hA : serreQuadraticMatrixSymmetric A)
    (hdet : IsUnit (Matrix.det A))
    (hprim : serrePadicTuplePrimitive x)
    (hvalue :
      padicDivisibilityDepth 2 3
        (MvPolynomial.eval x (serreQuadraticPolynomial (p := 2) A) - a)) :
    serreHenselValueLiftConclusion 2 (serreQuadraticPolynomial (p := 2) A) a x 2 := by
  exact serreHenselValueLift_mod_eight_of_quadratic_two_det_hypothesis
    ⟨hA, hdet, hprim, hvalue⟩

/--
Source-level exact/congruent lift for Serre's dyadic quadratic corollary.
-/
theorem serreDyadicQuadratic_exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (hA : serreQuadraticMatrixSymmetric A)
    (hdet : IsUnit (Matrix.det A))
    (hprim : serrePadicTuplePrimitive x)
    (hvalue :
      padicDivisibilityDepth 2 3
        (MvPolynomial.eval x (serreQuadraticPolynomial (p := 2) A) - a)) :
    ∃ y : σ → SerrePadicInt 2,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := 2) A) = a ∧
        ∀ i, serrePadicCongruent 2 2 (x i) (y i) := by
  exact serreQuadraticTwoDetHenselHypothesis.exists_solution_lift
    ⟨hA, hdet, hprim, hvalue⟩

end HenselQuadraticTwoResidue

end

end SerreNumberTheoryAI
