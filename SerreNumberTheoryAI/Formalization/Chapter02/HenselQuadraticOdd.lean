import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticCorollary
import SerreNumberTheoryAI.Formalization.Chapter02.PrimitiveHomogeneousZeros

/-!
# Odd-prime quadratic Hensel lifting boundary

This file keeps the next source boundary for Serre, Chapter 2, §2.2,
Corollary 2 explicit.  Once the linear-algebra part supplies a coordinate whose
symmetric quadratic gradient has valuation zero, the Hensel-facing value-lift
wrapper from `HenselQuadraticCorollary` immediately produces an exact
`Z_p`-solution.

The remaining determinant/primitive-vector step is not hidden here.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticOdd

/--
Residue linear algebra boundary: an invertible coordinate matrix over a field
cannot send a nonzero vector to zero.
-/
theorem serreResidueMatrix_mulVec_ne_zero_of_isUnit
    {ι K : Type*} [Fintype ι] [DecidableEq ι] [Field K]
    {A : Matrix ι ι K} {x : ι → K}
    (hA : IsUnit A) (hx : x ≠ 0) :
    A.mulVec x ≠ 0 := by
  intro hzero
  have hinj : Function.Injective A.mulVec :=
    (Matrix.mulVec_injective_iff_isUnit (A := A)).2 hA
  exact hx (hinj (by simpa using hzero))

/--
If an invertible residue matrix acts on a nonzero vector, some output coordinate
is nonzero.  This is the residue-level shape needed before translating the
coordinate into a p-adic gradient unit.
-/
theorem serreResidueMatrix_exists_nonzero_mulVec_coordinate_of_isUnit
    {ι K : Type*} [Fintype ι] [DecidableEq ι] [Field K]
    {A : Matrix ι ι K} {x : ι → K}
    (hA : IsUnit A) (hx : x ≠ 0) :
    ∃ j : ι, A.mulVec x j ≠ 0 := by
  by_contra hnone
  apply serreResidueMatrix_mulVec_ne_zero_of_isUnit hA hx
  funext j
  by_contra hj
  exact hnone ⟨j, hj⟩

/--
The determinant form of the same residue boundary over a field.  Specializing
this to the first residue ring is left as the next API/performance boundary.
-/
theorem serreResidueMatrix_exists_nonzero_mulVec_coordinate_of_det_ne_zero
    {ι K : Type*} [Fintype ι] [DecidableEq ι] [Field K]
    {A : Matrix ι ι K} {x : ι → K}
    (hdet : A.det ≠ 0) (hx : x ≠ 0) :
    ∃ j : ι, A.mulVec x j ≠ 0 := by
  have hA : IsUnit A :=
    (Matrix.isUnit_iff_isUnit_det A).2 (isUnit_iff_ne_zero.2 hdet)
  exact serreResidueMatrix_exists_nonzero_mulVec_coordinate_of_isUnit hA hx

/-- The first residue projection of a primitive p-adic tuple is nonzero. -/
theorem serrePadicTuplePrimitive_firstProj_ne_zero
    {σ : Type*} {p : ℕ} [Fact p.Prime] {x : σ → SerrePadicInt p}
    (hprim : serrePadicTuplePrimitive x) :
    (fun s => serrePadicIntProj p 0 (x s)) ≠ 0 :=
  (serrePadicTuplePrimitive_iff_firstProj_ne_zero p x).1 hprim

/-- The first residue vector attached to a p-adic tuple. -/
abbrev serreFirstResidueVector
    {σ : Type*} (p : ℕ) [Fact p.Prime] (x : σ → SerrePadicInt p) :
    σ → padicResidueRing p 0 :=
  fun s => serrePadicIntProj p 0 (x s)

/-- A primitive p-adic tuple has a nonzero first residue vector. -/
theorem serreFirstResidueVector_ne_zero_of_primitive
    {σ : Type*} {p : ℕ} [Fact p.Prime] {x : σ → SerrePadicInt p}
    (hprim : serrePadicTuplePrimitive x) :
    serreFirstResidueVector p x ≠ 0 := by
  intro hzero
  apply (serrePadicTuplePrimitive_firstProj_ne_zero (p := p) hprim)
  funext s
  have hs := congrFun hzero s
  simpa [serreFirstResidueVector] using hs

/--
A lightweight first-residue matrix-vector boundary.  This deliberately avoids
using the field instance for `padicResidueRing p 0`; the next proof slice can
connect this predicate to the generic field-level determinant lemma without
retriggering the earlier elaboration timeout.
-/
def serreFirstResidueMatrixCoordinateWitness
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    (B : Matrix σ σ (padicResidueRing p 0)) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ, B.mulVec (serreFirstResidueVector p x) j ≠ 0

/-- Unpack the first-residue matrix-coordinate witness. -/
theorem serreFirstResidueMatrixCoordinateWitness.exists_coordinate
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {B : Matrix σ σ (padicResidueRing p 0)} {x : σ → SerrePadicInt p}
    (h : serreFirstResidueMatrixCoordinateWitness B x) :
    ∃ j : σ, B.mulVec (serreFirstResidueVector p x) j ≠ 0 :=
  h

/--
Explicit first-residue determinant boundary.  This names the exact point where
the generic field-level determinant lemma should later be specialized to the
first residue ring, without forcing that specialization during this API pass.
-/
def serreFirstResidueMatrixDetNonzeroPrimitiveBoundary
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    (B : Matrix σ σ (padicResidueRing p 0)) (x : σ → SerrePadicInt p) : Prop :=
  B.det ≠ 0 →
    serrePadicTuplePrimitive x →
      serreFirstResidueMatrixCoordinateWitness B x


/--
Over a commutative ring without zero divisors, nonzero determinant already
forces a nonzero vector to have some nonzero image coordinate.  This avoids
requiring a field instance and is therefore suitable for the first residue
ring, where the earlier field specialization caused elaboration trouble.
-/
theorem serreResidueMatrix_exists_nonzero_mulVec_coordinate_of_det_ne_zero_of_noZeroDivisors
    {ι R : Type*} [Fintype ι] [DecidableEq ι]
    [CommRing R] [NoZeroDivisors R] [Nontrivial R]
    {A : Matrix ι ι R} {x : ι → R}
    (hdet : A.det ≠ 0) (hx : x ≠ 0) :
    ∃ j : ι, A.mulVec x j ≠ 0 := by
  by_contra hnone
  have hzero : A.mulVec x = 0 := by
    funext j
    by_contra hj
    exact hnone ⟨j, hj⟩
  have hxi : ∃ i : ι, x i ≠ 0 := by
    by_contra hnone
    apply hx
    funext i
    by_contra hi
    exact hnone ⟨i, hi⟩
  rcases hxi with ⟨i, hi⟩
  apply hdet
  exact Matrix.det_eq_zero_of_mulVec_eq_zero_of_mem_nonZeroDivisors
    hzero (mem_nonZeroDivisors_iff_ne_zero.mpr hi)

/--
The determinant/nonzero-vector argument now specializes to the first residue
ring without constructing a field instance.
-/
theorem serreFirstResidueMatrixCoordinateWitness_of_det_ne_zero_of_primitive
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {B : Matrix σ σ (padicResidueRing p 0)} {x : σ → SerrePadicInt p}
    (hdet : B.det ≠ 0) (hprim : serrePadicTuplePrimitive x) :
    serreFirstResidueMatrixCoordinateWitness B x := by
  haveI : Fact (Nat.Prime (p ^ 1)) := ⟨by simpa using (Fact.out : p.Prime)⟩
  haveI : NoZeroDivisors (padicResidueRing p 0) := by
    simpa [padicResidueRing] using
      (inferInstance : NoZeroDivisors (ZMod (p ^ 1)))
  haveI : Nontrivial (padicResidueRing p 0) := by
    simpa [padicResidueRing] using
      (inferInstance : Nontrivial (ZMod (p ^ 1)))
  exact
    serreResidueMatrix_exists_nonzero_mulVec_coordinate_of_det_ne_zero_of_noZeroDivisors
      hdet (serreFirstResidueVector_ne_zero_of_primitive hprim)

/--
The previously explicit determinant/primitive boundary is therefore discharged
by the dedicated no-zero-divisors argument.
-/
theorem serreFirstResidueMatrixDetNonzeroPrimitiveBoundary_proved
    {σ : Type*} [Fintype σ] [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    (B : Matrix σ σ (padicResidueRing p 0)) (x : σ → SerrePadicInt p) :
    serreFirstResidueMatrixDetNonzeroPrimitiveBoundary B x := by
  intro hdet hprim
  exact serreFirstResidueMatrixCoordinateWitness_of_det_ne_zero_of_primitive hdet hprim

/--
The current odd-prime quadratic boundary after the Hensel step: a primitive
quadratic congruence should supply a coordinate where the symmetric Serre
gradient is a unit.  This predicate records only that gradient witness.
-/
def serreQuadraticOddGradientWitness
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ,
    serrePadicIntAddValuation p
      (serreQuadraticSymmetricGradientCoordinate A x j) = (0 : ℕ∞)

/--
The expanded-expression version of the same witness.  This is the target shape
for the residue linear-algebra proof, because Serre writes the symmetric
derivative as `2 * Σᵢ aᵢⱼ xᵢ` for odd `p`.
-/
def serreQuadraticOddExpressionWitness
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∃ j : σ,
    serrePadicIntAddValuation p
      (serreQuadraticSymmetricGradientExpression A x j) = (0 : ℕ∞)

/--
An explicit bridge hypothesis from the Hensel-facing formal derivative coordinate
to the expanded symmetric expression.  Proving this bridge from polynomial
algebra is a separate, visible boundary.
-/
def serreQuadraticSymmetricGradientBridge
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) : Prop :=
  ∀ j : σ,
    serreQuadraticSymmetricGradientCoordinate A x j =
      serreQuadraticSymmetricGradientExpression A x j

/-- An expanded-expression witness gives the Hensel-facing witness once the bridge is known. -/
theorem serreQuadraticOddGradientWitness_of_expressionWitness
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hbridge : serreQuadraticSymmetricGradientBridge A x)
    (hexpr : serreQuadraticOddExpressionWitness A x) :
    serreQuadraticOddGradientWitness A x := by
  rcases hexpr with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  simpa [hbridge j] using hj

/--
Source-shaped package for the odd-prime quadratic Hensel boundary, stopping
exactly at the point where the determinant/primitive-vector argument has
already produced a nonzero gradient coordinate.
-/
def serreQuadraticOddHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (a : SerrePadicInt p)
    (x : σ → SerrePadicInt p) : Prop :=
  p ≠ 2 ∧
    serreQuadraticMatrixSymmetric A ∧
      serrePadicTuplePrimitive x ∧
        padicDivisibilityDepth p 1
          (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a) ∧
          serreQuadraticOddGradientWitness A x

/--
A source-facing variant of the odd-prime Hensel package in which the gradient
witness is provided in the expanded expression shape.
-/
def serreQuadraticOddExpressionHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (a : SerrePadicInt p)
    (x : σ → SerrePadicInt p) : Prop :=
  p ≠ 2 ∧
    serreQuadraticMatrixSymmetric A ∧
      serrePadicTuplePrimitive x ∧
        padicDivisibilityDepth p 1
          (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a) ∧
          serreQuadraticSymmetricGradientBridge A x ∧
            serreQuadraticOddExpressionWitness A x

/-- The expression-shaped package implies the Hensel-facing package once the bridge is included. -/
theorem serreQuadraticOddHenselHypothesis_of_expression
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddExpressionHenselHypothesis A a x) :
    serreQuadraticOddHenselHypothesis A a x := by
  rcases h with ⟨hpodd, hA, hprim, hvalue, hbridge, hexpr⟩
  exact ⟨hpodd, hA, hprim, hvalue,
    serreQuadraticOddGradientWitness_of_expressionWitness hbridge hexpr⟩

/--
Once the odd-prime linear-algebra boundary supplies a symmetric gradient
witness, the Hensel value-lift package gives an exact value root.
-/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddHenselHypothesis A a x) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  rcases h with ⟨_hpodd, hA, _hprim, hvalue, hgrad⟩
  rcases hgrad with ⟨j, hj⟩
  exact serreHenselValueLift_mod_p_of_symmetric_quadratic_gradient
    (p := p) (A := A) (a := a) (x := x) (j := j) hA hvalue hj

/--
Source-facing expression package followed by the Hensel value-lift package.
-/
theorem serreHenselValueLift_mod_p_of_odd_quadratic_expression_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddExpressionHenselHypothesis A a x) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_odd_quadratic_hypothesis
    (serreQuadraticOddHenselHypothesis_of_expression h)

/-- Extract the exact `Z_p` value root from the odd-prime quadratic Hensel package. -/
theorem serreQuadraticOddHenselHypothesis.exists_value_root
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a := by
  exact serreHenselValueLiftConclusion.exists_value_root
    (serreHenselValueLift_mod_p_of_odd_quadratic_hypothesis h)

/-- Extract the congruent lift from the odd-prime quadratic Hensel package. -/
theorem serreQuadraticOddHenselHypothesis.exists_congruent_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p, ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLiftConclusion.exists_congruent_lift
    (serreHenselValueLift_mod_p_of_odd_quadratic_hypothesis h)

/-- Extract the exact value root from the expression-shaped odd-prime package. -/
theorem serreQuadraticOddExpressionHenselHypothesis.exists_value_root
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddExpressionHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := p) A) = a := by
  exact serreHenselValueLiftConclusion.exists_value_root
    (serreHenselValueLift_mod_p_of_odd_quadratic_expression_hypothesis h)

/-- Extract the congruent lift from the expression-shaped odd-prime package. -/
theorem serreQuadraticOddExpressionHenselHypothesis.exists_congruent_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreQuadraticOddExpressionHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt p, ∀ i, serrePadicCongruent p 1 (x i) (y i) := by
  exact serreHenselValueLiftConclusion.exists_congruent_lift
    (serreHenselValueLift_mod_p_of_odd_quadratic_expression_hypothesis h)

end HenselQuadraticOdd

end

end SerreNumberTheoryAI