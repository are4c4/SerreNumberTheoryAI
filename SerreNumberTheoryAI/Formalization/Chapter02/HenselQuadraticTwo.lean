import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOddDerivativeBridge
import SerreNumberTheoryAI.Formalization.Chapter02.HenselQuadraticOddResidue

/-!
# Dyadic quadratic Hensel packages

This file continues Serre, Chapter 2 §2.2 Corollary 3 after the direct
`n = 3`, `k = 1` Hensel wrapper.  It keeps the source-shaped expanded gradient
condition separate from the later determinant/primitive-vector argument.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticTwo

/-- The element `2 ∈ Z₂` has additive valuation exactly `1`. -/
theorem serrePadicIntAddValuation_two :
    serrePadicIntAddValuation 2 (2 : SerrePadicInt 2) = (1 : ℕ∞) := by
  change emultiplicity (2 : SerrePadicInt 2) (2 : SerrePadicInt 2) = (1 : ℕ∞)
  exact emultiplicity_eq_of_dvd_of_not_dvd
    (by simp)
    (serrePadicInt_pow_succ_not_dvd_of_eq_pow_mul_isUnit
      (p := 2) (n := 1) (x := (2 : SerrePadicInt 2)) (u := 1)
      isUnit_one (by simp))

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
A dyadic inner-gradient coordinate whose first residue is nonzero.  Since the
expanded symmetric gradient is `2` times this inner sum, this is the residue
input that should produce valuation `1`.
-/
def serreQuadraticTwoInnerSumWitness
    {σ : Type*} [Fintype σ]
    (A : σ → σ → SerrePadicInt 2) (x : σ → SerrePadicInt 2) : Prop :=
  ∃ j : σ,
    serrePadicIntProj 2 0 (∑ i : σ, A i j * x i) ≠ 0

/--
A nonzero first residue of the inner sum makes the expanded dyadic gradient have
valuation exactly `1`, because the source gradient is `2` times that sum.
-/
theorem serreQuadraticTwoExpressionWitness_of_innerSumWitness
    {σ : Type*} [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoInnerSumWitness A x) :
    serreQuadraticTwoExpressionWitness A x := by
  rcases h with ⟨j, hj⟩
  refine ⟨j, ?_⟩
  rw [serreQuadraticSymmetricGradientExpression,
    serrePadicIntAddValuation_mul]
  have hinner :
      serrePadicIntAddValuation 2 (∑ i : σ, A i j * x i) = (0 : ℕ∞) :=
    serrePadicIntAddValuation_eq_zero_of_firstResidue_ne_zero hj
  simp [serrePadicIntAddValuation_two, hinner]

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

/--
Dyadic Hensel package in which the gradient condition is supplied by first
residue nonvanishing of the inner sum `Σᵢ aᵢⱼxᵢ`.
-/
def serreQuadraticTwoInnerSumHenselHypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    (A : σ → σ → SerrePadicInt 2) (a : SerrePadicInt 2)
    (x : σ → SerrePadicInt 2) : Prop :=
  serreQuadraticMatrixSymmetric A ∧
    padicDivisibilityDepth 2 3
      (MvPolynomial.eval x (serreQuadraticPolynomial (p := 2) A) - a) ∧
      serreQuadraticTwoInnerSumWitness A x

/-- Convert the inner-sum residue package to the expanded-gradient package. -/
theorem serreQuadraticTwoExpressionHenselHypothesis_of_innerSum
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoInnerSumHenselHypothesis A a x) :
    serreQuadraticTwoExpressionHenselHypothesis A a x := by
  rcases h with ⟨hA, hvalue, hinner⟩
  exact ⟨hA, hvalue, serreQuadraticTwoExpressionWitness_of_innerSumWitness hinner⟩

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

/-- The inner-sum residue dyadic package gives the Hensel value-lift conclusion. -/
theorem serreHenselValueLift_mod_eight_of_quadratic_two_innerSum_hypothesis
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoInnerSumHenselHypothesis A a x) :
    serreHenselValueLiftConclusion 2 (serreQuadraticPolynomial (p := 2) A) a x 2 := by
  exact serreHenselValueLift_mod_eight_of_quadratic_two_expression_hypothesis
    (serreQuadraticTwoExpressionHenselHypothesis_of_innerSum h)

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

/-- Extract one lift with both exact value and modulo-`4` congruence from the inner-sum package. -/
theorem serreQuadraticTwoInnerSumHenselHypothesis.exists_solution_lift
    {σ : Type*} [DecidableEq σ] [Fintype σ] [Fact (Nat.Prime 2)]
    {A : σ → σ → SerrePadicInt 2}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (h : serreQuadraticTwoInnerSumHenselHypothesis A a x) :
    ∃ y : σ → SerrePadicInt 2,
      MvPolynomial.eval y (serreQuadraticPolynomial (p := 2) A) = a ∧
        ∀ i, serrePadicCongruent 2 2 (x i) (y i) :=
  serreHenselValueLift_mod_eight_of_quadratic_two_innerSum_hypothesis h

end HenselQuadraticTwo

end

end SerreNumberTheoryAI
