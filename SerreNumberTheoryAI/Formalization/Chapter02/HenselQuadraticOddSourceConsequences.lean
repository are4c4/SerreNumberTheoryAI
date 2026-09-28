import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOddResidueExtractors
import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOddDerivativeBridge

/-!
# Source-level consequences for odd-prime quadratic Hensel lifting

This file exposes direct source-shaped corollaries for the odd-prime quadratic
pipeline.  The lower-level files keep the determinant/nonzero-coordinate and
formal-derivative bridges explicit; once those assumptions are supplied, these
lemmas assemble the corresponding Hensel package and immediately return the
value-lift conclusion or a single exact/congruent lift.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticOddSourceConsequences

/-- Assemble the matrix-coordinate Hensel package directly from source-shaped assumptions. -/
theorem serreQuadraticOddMatrixCoordinateHenselHypothesis_of_assumptions
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hA : serreQuadraticMatrixSymmetric A)
    (hprim : serrePadicTuplePrimitive x)
    (hvalue : padicDivisibilityDepth p 1
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hcoord : serreFirstResidueMatrixCoordinateWitness
      (serreFirstResidueGradientMatrix A) x) :
    serreQuadraticOddMatrixCoordinateHenselHypothesis A a x := by
  exact ⟨hp2, hA, hprim, hvalue,
    serreQuadraticSymmetricGradientBridge_of_symmetric x hA, hcoord⟩

/-- Assemble the determinant-boundary Hensel package directly from source-shaped assumptions. -/
theorem serreQuadraticOddDetBoundaryHenselHypothesis_of_assumptions
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hA : serreQuadraticMatrixSymmetric A)
    (hprim : serrePadicTuplePrimitive x)
    (hvalue : padicDivisibilityDepth p 1
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hdet : (serreFirstResidueGradientMatrix A).det ≠ 0) :
    serreQuadraticOddDetBoundaryHenselHypothesis A a x := by
  exact ⟨hp2, hA, hprim, hvalue,
    serreQuadraticSymmetricGradientBridge_of_symmetric x hA, hdet,
    serreFirstResidueMatrixDetNonzeroPrimitiveBoundary_proved
      (serreFirstResidueGradientMatrix A) x⟩

/-- Matrix-coordinate source data gives the Hensel value-lift conclusion. -/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hA : serreQuadraticMatrixSymmetric A)
    (hprim : serrePadicTuplePrimitive x)
    (hvalue : padicDivisibilityDepth p 1
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hcoord : serreFirstResidueMatrixCoordinateWitness
      (serreFirstResidueGradientMatrix A) x) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis
    (serreQuadraticOddMatrixCoordinateHenselHypothesis_of_assumptions
      hp2 hA hprim hvalue hcoord)

/-- Determinant-boundary source data gives the Hensel value-lift conclusion. -/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hA : serreQuadraticMatrixSymmetric A)
    (hprim : serrePadicTuplePrimitive x)
    (hvalue : padicDivisibilityDepth p 1
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hdet : (serreFirstResidueGradientMatrix A).det ≠ 0) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis
    (serreQuadraticOddDetBoundaryHenselHypothesis_of_assumptions
      hp2 hA hprim hvalue hdet)

/-- Matrix-coordinate source data produces one lift with both the value equation and congruence. -/
theorem serreOddQuadratic_exists_solution_lift_of_matrixCoordinate
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hA : serreQuadraticMatrixSymmetric A)
    (hprim : serrePadicTuplePrimitive x)
    (hvalue : padicDivisibilityDepth p 1
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hcoord : serreFirstResidueMatrixCoordinateWitness
      (serreFirstResidueGradientMatrix A) x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact (serreQuadraticOddMatrixCoordinateHenselHypothesis_of_assumptions
    hp2 hA hprim hvalue hcoord).exists_solution_lift

/-- Determinant-boundary source data produces one lift with both the value equation and congruence. -/
theorem serreOddQuadratic_exists_solution_lift_of_detBoundary
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hA : serreQuadraticMatrixSymmetric A)
    (hprim : serrePadicTuplePrimitive x)
    (hvalue : padicDivisibilityDepth p 1
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hdet : (serreFirstResidueGradientMatrix A).det ≠ 0) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact (serreQuadraticOddDetBoundaryHenselHypothesis_of_assumptions
    hp2 hA hprim hvalue hdet).exists_solution_lift

end HenselQuadraticOddSourceConsequences

end

end SerreNumberTheoryAI
