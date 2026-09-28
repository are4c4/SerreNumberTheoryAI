import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOdd

/-!
# First-residue bridge for odd-prime quadratic Hensel lifting

This file adds the next lightweight bridge after `HenselQuadraticOdd`: nonzero
first residue of a gradient expression gives valuation zero, and the first
residue of Serre's expanded symmetric gradient is expressed as a matrix-vector
coordinate over the first residue ring.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticOddResidue

/-- A nonzero first residue is exactly the valuation-zero input needed by Hensel. -/
theorem serrePadicIntAddValuation_eq_zero_of_firstResidue_ne_zero
    {p : ℕ} [Fact p.Prime] {z : SerrePadicInt p}
    (hz : serrePadicIntProj p 0 z ≠ 0) :
    serrePadicIntAddValuation p z = (0 : ℕ∞) := by
  have hz0 : z ≠ 0 := by
    intro hzero
    apply hz
    rw [hzero, map_zero]
  have horder : serrePadicIntOrder p z hz0 = 0 := by
    unfold serrePadicIntOrder
    exact (Nat.find_eq_zero _).2 hz
  simpa [horder] using serrePadicIntAddValuation_eq_order (p := p) hz0

/-- For odd prime `p`, the source factor `2` is nonzero in the first residue ring. -/
theorem serreFirstResidue_two_ne_zero_of_ne_two
    {p : ℕ} [Fact p.Prime] (hp2 : p ≠ 2) :
    (2 : padicResidueRing p 0) ≠ 0 := by
  intro hzero
  have hpowdvd : p ^ (0 + 1) ∣ 2 := by
    exact (ZMod.natCast_eq_zero_iff 2 (p ^ (0 + 1))).1
      (by simpa [padicResidueRing] using hzero)
  have hpdvd : p ∣ 2 := by
    simpa using hpowdvd
  exact hp2 ((Nat.prime_dvd_prime_iff_eq (Fact.out : p.Prime) Nat.prime_two).1 hpdvd)

/-- The first projection of the p-adic integer `2` is the residue class `2`. -/
theorem serrePadicIntProj_two
    (p : ℕ) :
    serrePadicIntProj p 0 (2 : SerrePadicInt p) = (2 : padicResidueRing p 0) := by
  rfl

/-- For odd prime `p`, the projected p-adic integer `2` is nonzero. -/
theorem serrePadicIntProj_two_ne_zero_of_ne_two
    {p : ℕ} [Fact p.Prime] (hp2 : p ≠ 2) :
    serrePadicIntProj p 0 (2 : SerrePadicInt p) ≠ 0 := by
  rw [serrePadicIntProj_two]
  exact serreFirstResidue_two_ne_zero_of_ne_two (p := p) hp2

/--
The first-residue matrix whose `j`-th row is the first residue of the `j`-th
Serre gradient column `i ↦ aᵢⱼ`.
-/
abbrev serreFirstResidueGradientMatrix
    {σ : Type*} {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) :
    Matrix σ σ (padicResidueRing p 0) :=
  fun j i => serrePadicIntProj p 0 (A i j)

/--
The matrix-vector coordinate of the first-residue gradient matrix is the first
residue of `Σᵢ aᵢⱼ xᵢ`.
-/
theorem serreFirstResidueGradientMatrix_mulVec
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    (serreFirstResidueGradientMatrix A).mulVec (serreFirstResidueVector p x) j =
      serrePadicIntProj p 0 (∑ i : σ, A i j * x i) := by
  rw [Matrix.mulVec]
  change (∑ i : σ, serrePadicIntProj p 0 (A i j) *
      serrePadicIntProj p 0 (x i)) =
    serrePadicIntProj p 0 (∑ i : σ, A i j * x i)
  simp [map_sum, map_mul]

/-- First residue of Serre's expanded symmetric gradient expression. -/
theorem serreQuadraticSymmetricGradientExpression_firstResidue
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    serrePadicIntProj p 0 (serreQuadraticSymmetricGradientExpression A x j) =
      serrePadicIntProj p 0 (2 : SerrePadicInt p) *
        (serreFirstResidueGradientMatrix A).mulVec (serreFirstResidueVector p x) j := by
  rw [serreQuadraticSymmetricGradientExpression, map_mul,
    ← serreFirstResidueGradientMatrix_mulVec (A := A) (x := x) (j := j)]

/--
A first-residue nonvanishing witness for the expanded symmetric gradient itself.
This is one step before proving that odd `p` makes the factor `2` harmless.
-/
def serreQuadraticOddFirstResidueExpressionWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ,
    serrePadicIntProj p 0 (serreQuadraticSymmetricGradientExpression A x j) ≠ 0

/--
A matrix-shaped first-residue witness for the expanded symmetric gradient,
including the source factor `2`.
-/
def serreQuadraticOddFirstResidueGradientWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ,
    serrePadicIntProj p 0 (2 : SerrePadicInt p) *
      (serreFirstResidueGradientMatrix A).mulVec (serreFirstResidueVector p x) j ≠ 0

/--
A nonzero matrix-vector coordinate gives the matrix-shaped gradient witness when
`p` is odd.
-/
theorem serreQuadraticOddFirstResidueGradientWitness_of_matrixCoordinateWitness
    {σ : Type*} [Fintype σ] [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hp2 : p ≠ 2)
    (h : serreFirstResidueMatrixCoordinateWitness (serreFirstResidueGradientMatrix A) x) :
    serreQuadraticOddFirstResidueGradientWitness A x := by
  rcases h with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  haveI : Fact (Nat.Prime (p ^ 1)) := ⟨by simpa using (Fact.out : p.Prime)⟩
  haveI : NoZeroDivisors (padicResidueRing p 0) := by
    simpa [padicResidueRing] using (inferInstance : NoZeroDivisors (ZMod (p ^ 1)))
  exact mul_ne_zero (serrePadicIntProj_two_ne_zero_of_ne_two (p := p) hp2) hj

/-- The matrix-shaped first-residue witness gives the expression nonvanishing witness. -/
theorem serreQuadraticOddFirstResidueExpressionWitness_of_gradientWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientWitness A x) :
    serreQuadraticOddFirstResidueExpressionWitness A x := by
  rcases h with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  rw [serreQuadraticSymmetricGradientExpression_firstResidue]
  exact hj

/-- A nonzero first-residue expression gives the valuation-zero expression witness. -/
theorem serreQuadraticOddExpressionWitness_of_firstResidueExpressionWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueExpressionWitness A x) :
    serreQuadraticOddExpressionWitness A x := by
  rcases h with ⟨j, hj⟩
  exact ⟨j, serrePadicIntAddValuation_eq_zero_of_firstResidue_ne_zero hj⟩

/-- Matrix-shaped first-residue nonvanishing gives the valuation-zero expression witness. -/
theorem serreQuadraticOddExpressionWitness_of_firstResidueGradientWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientWitness A x) :
    serreQuadraticOddExpressionWitness A x :=
  serreQuadraticOddExpressionWitness_of_firstResidueExpressionWitness
    (serreQuadraticOddFirstResidueExpressionWitness_of_gradientWitness h)


/--
The determinant of the first-residue gradient matrix is the first projection of
the determinant of the p-adic coefficient matrix.  The transpose appears
because the gradient matrix stores the column \`i ↦ aᵢⱼ\` as its \`j\`-th row.
-/
theorem serreFirstResidueGradientMatrix_det_eq_proj_det
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) :
    (serreFirstResidueGradientMatrix A).det =
      serrePadicIntProj p 0 (Matrix.det A) := by
  classical
  have hmatrix :
      serreFirstResidueGradientMatrix A =
        (serrePadicIntProj p 0).mapMatrix (Aᵀ) := by
    ext i j
    rfl
  rw [hmatrix, ← RingHom.map_det, Matrix.det_transpose]

/--
If the p-adic coefficient determinant is a unit, its first residue is nonzero,
hence the first-residue gradient matrix has nonzero determinant.
-/
theorem serreFirstResidueGradientMatrix_det_ne_zero_of_isUnit_det
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    (hdet : IsUnit (Matrix.det A)) :
    (serreFirstResidueGradientMatrix A).det ≠ 0 := by
  rw [serreFirstResidueGradientMatrix_det_eq_proj_det]
  haveI : Fact (Nat.Prime (p ^ 1)) := ⟨by simpa using (Fact.out : p.Prime)⟩
  haveI : Nontrivial (padicResidueRing p 0) := by
    simpa [padicResidueRing] using
      (inferInstance : Nontrivial (ZMod (p ^ 1)))
  exact (hdet.map (serrePadicIntProj p 0)).ne_zero

/--
Source-facing Hensel package in which the expanded gradient witness is supplied
by first-residue nonvanishing of the gradient matrix-vector coordinate.
-/
def serreQuadraticOddFirstResidueGradientHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (a : SerrePadicInt p)
    (x : σ → SerrePadicInt p) : Prop :=
  p ≠ 2 ∧
    serreQuadraticMatrixSymmetric A ∧
      serrePadicTuplePrimitive x ∧
        padicDivisibilityDepth p 1
          (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a) ∧
          serreQuadraticSymmetricGradientBridge A x ∧
            serreQuadraticOddFirstResidueGradientWitness A x

/--
Source-facing Hensel package in which residue linear algebra supplies the
nonzero matrix-vector coordinate before the explicit factor `2` is attached.
-/
def serreQuadraticOddMatrixCoordinateHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (a : SerrePadicInt p)
    (x : σ → SerrePadicInt p) : Prop :=
  p ≠ 2 ∧
    serreQuadraticMatrixSymmetric A ∧
      serrePadicTuplePrimitive x ∧
        padicDivisibilityDepth p 1
          (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a) ∧
          serreQuadraticSymmetricGradientBridge A x ∧
            serreFirstResidueMatrixCoordinateWitness (serreFirstResidueGradientMatrix A) x

/--
Source-facing Hensel package in which the determinant/nonzero-vector argument is
kept as the explicit first-residue boundary predicate.
-/
def serreQuadraticOddDetBoundaryHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (a : SerrePadicInt p)
    (x : σ → SerrePadicInt p) : Prop :=
  p ≠ 2 ∧
    serreQuadraticMatrixSymmetric A ∧
      serrePadicTuplePrimitive x ∧
        padicDivisibilityDepth p 1
          (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a) ∧
          serreQuadraticSymmetricGradientBridge A x ∧
            (serreFirstResidueGradientMatrix A).det ≠ 0 ∧
              serreFirstResidueMatrixDetNonzeroPrimitiveBoundary
                (serreFirstResidueGradientMatrix A) x

/-- The first-residue gradient package implies the expanded-expression Hensel package. -/
theorem serreQuadraticOddExpressionHenselHypothesis_of_firstResidueGradient
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientHenselHypothesis A a x) :
    serreQuadraticOddExpressionHenselHypothesis A a x := by
  rcases h with ⟨hpodd, hA, hprim, hvalue, hbridge, hgrad⟩
  exact ⟨hpodd, hA, hprim, hvalue, hbridge,
    serreQuadraticOddExpressionWitness_of_firstResidueGradientWitness hgrad⟩

/-- The matrix-coordinate package implies the first-residue gradient Hensel package. -/
theorem serreQuadraticOddFirstResidueGradientHenselHypothesis_of_matrixCoordinate
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddMatrixCoordinateHenselHypothesis A a x) :
    serreQuadraticOddFirstResidueGradientHenselHypothesis A a x := by
  rcases h with ⟨hpodd, hA, hprim, hvalue, hbridge, hcoord⟩
  exact ⟨hpodd, hA, hprim, hvalue, hbridge,
    serreQuadraticOddFirstResidueGradientWitness_of_matrixCoordinateWitness hpodd hcoord⟩

/-- The determinant-boundary package implies the matrix-coordinate Hensel package. -/
theorem serreQuadraticOddMatrixCoordinateHenselHypothesis_of_detBoundary
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    serreQuadraticOddMatrixCoordinateHenselHypothesis A a x := by
  rcases h with ⟨hpodd, hA, hprim, hvalue, hbridge, hdet, hboundary⟩
  exact ⟨hpodd, hA, hprim, hvalue, hbridge, hboundary hdet hprim⟩

/-- First-residue gradient data followed by the Hensel value-lift package. -/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_firstResidueGradient_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientHenselHypothesis A a x) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_expression_hypothesis
    (serreQuadraticOddExpressionHenselHypothesis_of_firstResidueGradient h)

/-- Matrix-coordinate data followed by the Hensel value-lift package. -/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddMatrixCoordinateHenselHypothesis A a x) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_firstResidueGradient_hypothesis
    (serreQuadraticOddFirstResidueGradientHenselHypothesis_of_matrixCoordinate h)

/-- Determinant-boundary data followed by the Hensel value-lift package. -/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis
    (serreQuadraticOddMatrixCoordinateHenselHypothesis_of_detBoundary h)

/-- Extract the exact value root from the first-residue gradient package. -/
theorem serreQuadraticOddFirstResidueGradientHenselHypothesis.exists_value_root
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a := by
  exact serreHenselValueLiftConclusion.exists_value_root
    (serreHenselValueLift_mod_p_of_odd_quadratic_firstResidueGradient_hypothesis h)

/-- Extract the congruent lift from the first-residue gradient package. -/
theorem serreQuadraticOddFirstResidueGradientHenselHypothesis.exists_congruent_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddFirstResidueGradientHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p, ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLiftConclusion.exists_congruent_lift
    (serreHenselValueLift_mod_p_of_odd_quadratic_firstResidueGradient_hypothesis h)

/-- Extract the exact value root from the matrix-coordinate package. -/
theorem serreQuadraticOddMatrixCoordinateHenselHypothesis.exists_value_root
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddMatrixCoordinateHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a := by
  exact serreHenselValueLiftConclusion.exists_value_root
    (serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis h)

/-- Extract the congruent lift from the matrix-coordinate package. -/
theorem serreQuadraticOddMatrixCoordinateHenselHypothesis.exists_congruent_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddMatrixCoordinateHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p, ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLiftConclusion.exists_congruent_lift
    (serreHenselValueLift_mod_p_of_odd_quadratic_matrixCoordinate_hypothesis h)

/-- Extract the exact value root from the determinant-boundary package. -/
theorem serreQuadraticOddDetBoundaryHenselHypothesis.exists_value_root
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a := by
  exact serreHenselValueLiftConclusion.exists_value_root
    (serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis h)

/-- Extract the congruent lift from the determinant-boundary package. -/
theorem serreQuadraticOddDetBoundaryHenselHypothesis.exists_congruent_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddDetBoundaryHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p, ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLiftConclusion.exists_congruent_lift
    (serreHenselValueLift_mod_p_of_odd_quadratic_detBoundary_hypothesis h)

end HenselQuadraticOddResidue

end

end SerreNumberTheoryAI
