import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOddResidue

/-!
# Extractors for the odd-prime quadratic first-residue bridge

This file keeps the end-user consequences of the first-residue odd-quadratic
packages separate from the lower-level residue API.  The hard determinant and
formal-derivative bridges remain explicit assumptions elsewhere; once those
packages are available, these lemmas expose the final exact root together with
its congruence data.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticOddResidueExtractors

/--
A nonzero first-residue matrix coordinate already gives the valuation-zero
expanded-expression witness when `p` is odd.
-/
theorem serreQuadraticOddExpressionWitness_of_matrixCoordinateWitness
    {σ : Type*} [Fintype σ] [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hcoord : serreFirstResidueMatrixCoordinateWitness (serreFirstResidueGradientMatrix A) x) :
    serreQuadraticOddExpressionWitness A x := by
  exact serreQuadraticOddExpressionWitness_of_firstResidueGradientWitness
    (serreQuadraticOddFirstResidueGradientWitness_of_matrixCoordinateWitness hp2 hcoord)

/--
The explicit determinant/primitive first-residue boundary gives the
valuation-zero expanded-expression witness when `p` is odd.
-/
theorem serreQuadraticOddExpressionWitness_of_detBoundary
    {σ : Type*} [Fintype σ] [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (hdet : (serreFirstResidueGradientMatrix A).det ≠ 0)
    (hprim : serrePadicTuplePrimitive x)
    (hboundary : serreFirstResidueMatrixDetNonzeroPrimitiveBoundary
      (serreFirstResidueGradientMatrix A) x) :
    serreQuadraticOddExpressionWitness A x := by
  exact serreQuadraticOddExpressionWitness_of_matrixCoordinateWitness hp2
    (hboundary hdet hprim)

/--
Attempted direct specialization of the generic determinant/nonzero-vector lemma
to the first residue field.  This keeps the specialization isolated from the
source-facing Hensel packages so the previous heartbeat-sensitive boundary stays
visible if the API changes.
-/
set_option maxHeartbeats 800000 in
theorem serreFirstResidueMatrixCoordinateWitness_of_det_ne_zero
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {B : Matrix σ σ (padicResidueRing p 0)} {x : σ → SerrePadicInt p}
    (hdet : B.det ≠ 0) (hprim : serrePadicTuplePrimitive x) :
    serreFirstResidueMatrixCoordinateWitness B x := by
  change ∃ j : σ, B.mulVec (serreFirstResidueVector p x) j ≠ 0
  have hx : serreFirstResidueVector p x ≠ 0 :=
    serreFirstResidueVector_ne_zero_of_primitive (p := p) hprim
  haveI : Fact (Nat.Prime (p ^ 1)) := ⟨by simpa using (Fact.out : p.Prime)⟩
  haveI : Field (padicResidueRing p 0) := by
    simpa [padicResidueRing] using
      (inferInstance : Field (ZMod (p ^ 1)))
  exact serreResidueMatrix_exists_nonzero_mulVec_coordinate_of_det_ne_zero
    (A := B) (x := serreFirstResidueVector p x) hdet hx

/--
The matrix-coordinate Hensel package directly gives the expanded-expression
Hensel package.
-/
theorem serreQuadraticOddExpressionHenselHypothesis_of_matrixCoordinate
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddMatrixCoordinateHenselHypothesis A a x) :
    serreQuadraticOddExpressionHenselHypothesis A a x := by
  exact serreQuadraticOddExpressionHenselHypothesis_of_firstResidueGradient
    (serreQuadraticOddFirstResidueGradientHenselHypothesis_of_matrixCoordinate h)

/--
The determinant-boundary Hensel package directly gives the first-residue
gradient Hensel package.
-/
theorem serreQuadraticOddFirstResidueGradientHenselHypothesis_of_detBoundary
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    serreQuadraticOddFirstResidueGradientHenselHypothesis A a x := by
  exact serreQuadraticOddFirstResidueGradientHenselHypothesis_of_matrixCoordinate
    (serreQuadraticOddMatrixCoordinateHenselHypothesis_of_detBoundary h)

/--
The determinant-boundary Hensel package directly gives the expanded-expression
Hensel package.
-/
theorem serreQuadraticOddExpressionHenselHypothesis_of_detBoundary
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    serreQuadraticOddExpressionHenselHypothesis A a x := by
  exact serreQuadraticOddExpressionHenselHypothesis_of_matrixCoordinate
    (serreQuadraticOddMatrixCoordinateHenselHypothesis_of_detBoundary h)

/-- Extract the exact root together with the congruence lift from the odd-prime package. -/
theorem serreQuadraticOddHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_hypothesis h

/-- Extract the exact root together with the congruence lift from the expression package. -/
theorem serreQuadraticOddExpressionHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddExpressionHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_expression_hypothesis h

/-- Extract the exact root together with the congruence lift from the first-residue package. -/
theorem serreQuadraticOddFirstResidueGradientHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_firstResidueGradient_hypothesis h

/-- Extract the exact root together with the congruence lift from the matrix-coordinate package. -/
theorem serreQuadraticOddMatrixCoordinateHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddMatrixCoordinateHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis h

/-- Extract the exact root together with the congruence lift from the determinant-boundary package. -/
theorem serreQuadraticOddDetBoundaryHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a ∧
        ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis h

end HenselQuadraticOddResidueExtractors

end

end SerreNumberTheoryAI