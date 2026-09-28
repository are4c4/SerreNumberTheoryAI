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

end HenselQuadraticOdd

end

end SerreNumberTheoryAI
