import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOddDerivativeBridge

/-!
# Dyadic quadratic Hensel packages

This file continues Serre, Chapter 2 §2.2 Corollary 3 after the direct
`n = 3`, `k = 1` Hensel wrapper.  It keeps the source-shaped expanded gradient
condition separate from the later determinant/primitive-vector argument.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticTwo

/--
The source-shaped dyadic gradient witness: some expanded symmetric gradient
coordinate has additive valuation exactly `1`.
-/
def serreQuadraticTwoExpressionWitness
    {σ : Type*} [Fintype σ] [Fact (Nat.Prime 2)]
    (A : σ → σ → SerrePadicInt 2) (x : σ → SerrePadicInt 2) : Prop :=
  ∃ j : σ,
    serrePadicIntAddValuation 2
      (serreQuadraticSymmetricGradientExpression A x j) = (1 : ℕ∞)

/--
The expanded-gradient witness implies the Hensel-facing formal-gradient witness
when the coefficient matrix is symmetric.
-/
theorem serreQuadraticTwoGradientWitness_of_expressionWitness
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (hA : serreQuadraticMatrixSymmetric A)
    (hexpr : serreQuadraticTwoExpressionWitness A x) :
    serreQuadraticTwoGradientWitness A x := by
  rcases hexpr with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  have hbridge := serreQuadraticSymmetricGradientBridge_of_symmetric (p := 2) x hA
  simpa [hbridge j] using hj

/--
Dyadic Hensel package with the gradient written in Serre's expanded symmetric
shape rather than as a formal partial derivative.
-/
def serreQuadraticTwoExpressionHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    (A : σ → σ → SerrePadicInt 2) (a : SerrePadicInt 2)
    (x : σ → SerrePadicInt 2) : Prop :=
  serreQuadraticMatrixSymmetric A ∧
    padicDivisibilityDepth 2 3
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := 2) A) - a) ∧
      serreQuadraticTwoExpressionWitness A x

/-- Convert the source-shaped expanded-gradient package to the Hensel-facing package. -/
theorem serreQuadraticTwoHenselHypothesis_of_expression
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoExpressionHenselHypothesis A a x) :
    serreQuadraticTwoHenselHypothesis A a x := by
  rcases h with ⟨hA, hvalue, hexpr⟩
  exact ⟨hA, hvalue, serreQuadraticTwoGradientWitness_of_expressionWitness hA hexpr⟩

/-- The expanded-gradient dyadic package gives the Hensel value-lift conclusion. -/
theorem serreHenselValueLift_mod_eight_of_quadratic_two_expression_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoExpressionHenselHypothesis A a x) :
    serreHenselValueLiftConclusion 2 (serreQuadraticPolynomial (p := 2) A) a x 2 := by
  exact serreHenselValueLift_mod_eight_of_quadratic_two_hypothesis
    (serreQuadraticTwoHenselHypothesis_of_expression h)

/-- Extract the exact value root from the expanded-gradient dyadic package. -/
theorem serreQuadraticTwoExpressionHenselHypothesis.exists_value_root
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoExpressionHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt 2,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := 2) A) = a := by
  exact serreHenselValueLiftConclusion.exists_value_root
    (serreHenselValueLift_mod_eight_of_quadratic_two_expression_hypothesis h)

/-- Extract the modulo-`4` congruent lift from the expanded-gradient dyadic package. -/
theorem serreQuadraticTwoExpressionHenselHypothesis.exists_congruent_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoExpressionHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt 2,
      ∀ i, serrePadicCongruent 2 2 (x i) (y i) := by
  exact serreHenselValueLiftConclusion.exists_congruent_lift
    (serreHenselValueLift_mod_eight_of_quadratic_two_expression_hypothesis h)

/-- Extract one lift with both the exact value equation and the modulo-`4` congruence. -/
theorem serreQuadraticTwoExpressionHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoExpressionHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt 2,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := 2) A) = a ∧
        ∀ i, serrePadicCongruent 2 2 (x i) (y i) :=
  serreHenselValueLift_mod_eight_of_quadratic_two_expression_hypothesis h

end HenselQuadraticTwo

end

end SerreNumberTheoryAI
