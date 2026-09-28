import SerreNumberTheoryAI.Formalization.Chapter02.HenselCorollary

/-!
# Quadratic-form lift packages after Hensel's lemma

Serre, Chapter 2, §2.2 derives two quadratic-form lifting corollaries after
Hensel's theorem.  This file records the Hensel-facing part of those corollaries:
once a quadratic congruence has a coordinate whose derivative has the required
valuation, the solution lifts to an actual `Z_p`-solution.

The determinant/primitive-vector argument that produces such a coordinate is a
separate linear-algebra boundary and is intentionally not smuggled into these
statements.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselQuadraticCorollary

/--
A lift conclusion for an equation `f(y) = a`, keeping the Serre congruence
modulus explicit.
-/
def serreHenselValueLiftConclusion
    {σ : Type*} (p : ℕ) [Fact p.Prime]
    (f : MvPolynomial σ (SerrePadicInt p))
    (a : SerrePadicInt p) (x : σ → SerrePadicInt p) (depth : ℕ) : Prop :=
  ∃ y : σ → SerrePadicInt p,
    MvPolynomial.eval y f = a ∧
      ∀ i, serrePadicCongruent p depth (x i) (y i)

/-- Extract the exact value solution from a value-lift conclusion. -/
theorem serreHenselValueLiftConclusion.exists_value_root
    {σ : Type*} {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p} {depth : ℕ}
    (h : serreHenselValueLiftConclusion p f a x depth) :
    ∃ y : σ → SerrePadicInt p, MvPolynomial.eval y f = a := by
  rcases h with ⟨y, hyroot, _⟩
  exact ⟨y, hyroot⟩

/-- Extract a lift that is congruent to the original approximate point. -/
theorem serreHenselValueLiftConclusion.exists_congruent_lift
    {σ : Type*} {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p} {depth : ℕ}
    (h : serreHenselValueLiftConclusion p f a x depth) :
    ∃ y : σ → SerrePadicInt p, ∀ i, serrePadicCongruent p depth (x i) (y i) := by
  rcases h with ⟨y, _, hycong⟩
  exact ⟨y, hycong⟩

/-- A solution that is already exact gives a value-lift conclusion at every depth. -/
theorem serreHenselValueLiftConclusion_of_exact
    {σ : Type*} (p : ℕ) [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p} {depth : ℕ}
    (hroot : MvPolynomial.eval x f = a) :
    serreHenselValueLiftConclusion p f a x depth := by
  refine ⟨x, hroot, ?_⟩
  intro i
  exact serrePadicCongruent_refl p depth (x i)

/-- A value-lift conclusion modulo a stronger depth also gives one modulo any weaker depth. -/
theorem serreHenselValueLiftConclusion.mono
    {σ : Type*} {p : ℕ} [Fact p.Prime]
    {m n : ℕ} (hmn : m ≤ n)
    {f : MvPolynomial σ (SerrePadicInt p)}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (h : serreHenselValueLiftConclusion p f a x n) :
    serreHenselValueLiftConclusion p f a x m := by
  rcases h with ⟨y, hyroot, hycong⟩
  refine ⟨y, hyroot, ?_⟩
  intro i
  exact serrePadicCongruent_mono hmn (hycong i)

/--
The coordinate-matrix quadratic polynomial `∑ᵢⱼ aᵢⱼ Xᵢ Xⱼ` used in Serre's
quadratic corollaries.
-/
def serreQuadraticPolynomial
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) : MvPolynomial σ (SerrePadicInt p) :=
  ∑ i : σ, ∑ j : σ,
    MvPolynomial.C (A i j) * MvPolynomial.X i * MvPolynomial.X j

/-- Evaluation of the coordinate-matrix quadratic polynomial. -/
theorem serreQuadraticPolynomial_eval
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) :
    MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) =
      ∑ i : σ, ∑ j : σ, A i j * x i * x j := by
  classical
  simp [serreQuadraticPolynomial, mul_assoc]

/-- Symmetry of the coordinate matrix of Serre's quadratic form. -/
def serreQuadraticMatrixSymmetric
    {σ : Type*} {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) : Prop :=
  ∀ i j : σ, A i j = A j i

/--
The formal gradient coordinate for `∑ᵢⱼ aᵢⱼ Xᵢ Xⱼ`: before imposing symmetry,
the `j`-th partial derivative has coefficients `a_{j i} + a_{i j}`.
-/
def serreQuadraticGradientCoordinate
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    SerrePadicInt p :=
  ∑ i : σ, (A j i + A i j) * x i

/--
The symmetric-form version of the same gradient coordinate, written in the
source shape `2 * ∑ᵢ aᵢⱼ xᵢ`.
-/
def serreQuadraticSymmetricGradientCoordinate
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    SerrePadicInt p :=
  (2 : SerrePadicInt p) * ∑ i : σ, A i j * x i

/-- The evaluated partial derivative of the coordinate quadratic polynomial is the gradient coordinate. -/
theorem serreQuadraticPolynomial_pderiv_eval
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (j : σ) :
    MvPolynomial.eval x
        (MvPolynomial.pderiv j (serreQuadraticPolynomial (p := p) A)) =
      serreQuadraticGradientCoordinate A x j := by
  classical
  simp [serreQuadraticPolynomial, serreQuadraticGradientCoordinate,
    Finset.sum_add_distrib, mul_add, add_mul, mul_assoc, mul_left_comm, mul_comm]

/-- Under symmetry, the gradient coordinate has Serre's `2 * ∑ᵢ aᵢⱼ xᵢ` shape. -/
theorem serreQuadraticGradientCoordinate_eq_symmetric
    {σ : Type*} [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p} {j : σ}
    (hA : serreQuadraticMatrixSymmetric A) :
    serreQuadraticGradientCoordinate A x j =
      serreQuadraticSymmetricGradientCoordinate A x j := by
  classical
  have hsym : ∀ i : σ, A j i = A i j := fun i => hA j i
  simp [serreQuadraticGradientCoordinate, serreQuadraticSymmetricGradientCoordinate,
    hsym, two_mul, Finset.sum_add_distrib, Finset.mul_sum, add_mul, mul_assoc,
    mul_left_comm, mul_comm]

/-- The evaluated partial derivative of a symmetric coordinate quadratic polynomial has source shape. -/
theorem serreQuadraticPolynomial_pderiv_eval_of_symmetric
    {σ : Type*} [DecidableEq σ] [Fintype σ] {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p} {x : σ → SerrePadicInt p} {j : σ}
    (hA : serreQuadraticMatrixSymmetric A) :
    MvPolynomial.eval x
        (MvPolynomial.pderiv j (serreQuadraticPolynomial (p := p) A)) =
      serreQuadraticSymmetricGradientCoordinate A x j := by
  rw [serreQuadraticPolynomial_pderiv_eval]
  exact serreQuadraticGradientCoordinate_eq_symmetric hA

/--
The Hensel-facing form of Serre's odd-prime quadratic lifting corollary: if
`f(x) ≡ a (mod p)` and some selected derivative is a unit, then the congruence
lifts to an exact equation over `Z_p`.
-/
theorem serreHenselValueLift_mod_p_of_simple_derivative
    {σ : Type*} [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p} {j : σ}
    (hvalue : padicDivisibilityDepth p 1 (MvPolynomial.eval x f - a))
    (hderiv :
      serrePadicIntAddValuation p
        (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (0 : ℕ∞)) :
    serreHenselValueLiftConclusion p f a x 1 := by
  have hsimple :
      serreHenselMultivariateSimpleRootHypothesis p
        (f - (MvPolynomial.C a : MvPolynomial σ (SerrePadicInt p))) x j := by
    refine ⟨?_, ?_⟩
    · simpa using hvalue
    · simpa using hderiv
  rcases serreHenselMultivariateSimpleRootConclusion_of_hypothesis hsimple with
    ⟨y, hyroot, hycong⟩
  refine ⟨y, ?_, hycong⟩
  have hsub : MvPolynomial.eval y f - a = 0 := by
    simpa using hyroot
  exact sub_eq_zero.mp hsub

/--
Hensel value lifting for the coordinate quadratic polynomial, stated using the
formal gradient coordinate.  The separate matrix/primitive argument is precisely
the step that supplies a coordinate where this gradient has valuation zero.
-/
theorem serreHenselValueLift_mod_p_of_quadratic_gradient
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p} {j : σ}
    (hvalue :
      padicDivisibilityDepth p 1
        (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hgrad :
      serrePadicIntAddValuation p
        (serreQuadraticGradientCoordinate A x j) = (0 : ℕ∞)) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_simple_derivative
    (p := p) (f := serreQuadraticPolynomial (p := p) A) (a := a) (x := x) (j := j)
    hvalue (by simpa [serreQuadraticPolynomial_pderiv_eval] using hgrad)

/-- The same Hensel-facing lift package using the symmetric Serre gradient expression. -/
theorem serreHenselValueLift_mod_p_of_symmetric_quadratic_gradient
    {σ : Type*} [DecidableEq σ] [Fintype σ]
    {p : ℕ} [Fact p.Prime]
    {A : σ → σ → SerrePadicInt p}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p} {j : σ}
    (hA : serreQuadraticMatrixSymmetric A)
    (hvalue :
      padicDivisibilityDepth p 1
        (MvPolynomial.eval x (serreQuadraticPolynomial (p := p) A) - a))
    (hgrad :
      serrePadicIntAddValuation p
        (serreQuadraticSymmetricGradientCoordinate A x j) = (0 : ℕ∞)) :
    serreHenselValueLiftConclusion p (serreQuadraticPolynomial (p := p) A) a x 1 := by
  exact serreHenselValueLift_mod_p_of_simple_derivative
    (p := p) (f := serreQuadraticPolynomial (p := p) A) (a := a) (x := x) (j := j)
    hvalue (by simpa [serreQuadraticPolynomial_pderiv_eval_of_symmetric hA] using hgrad)

/--
The same odd-prime value-lift package with the derivative coordinate expressed
existentially, matching the way Serre obtains the coordinate from primitivity
and nondegeneracy of the quadratic matrix.
-/
theorem serreHenselValueLift_mod_p_of_exists_simple_derivative
    {σ : Type*} [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)}
    {a : SerrePadicInt p} {x : σ → SerrePadicInt p}
    (hvalue : padicDivisibilityDepth p 1 (MvPolynomial.eval x f - a))
    (hderiv :
      ∃ j : σ,
        serrePadicIntAddValuation p
          (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (0 : ℕ∞)) :
    serreHenselValueLiftConclusion p f a x 1 := by
  rcases hderiv with ⟨j, hj⟩
  exact serreHenselValueLift_mod_p_of_simple_derivative
    (p := p) (f := f) (a := a) (x := x) (j := j) hvalue hj

/--
The Hensel-facing form of Serre's `p = 2` quadratic lifting corollary: a
solution modulo `8` with a selected derivative of valuation `1` lifts to an
actual solution, congruent modulo `4`.
-/
theorem serreHenselValueLift_mod_eight_of_derivative_valuation_one
    {σ : Type*} [DecidableEq σ]
    [Fact (Nat.Prime 2)]
    {f : MvPolynomial σ (SerrePadicInt 2)}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2} {j : σ}
    (hvalue : padicDivisibilityDepth 2 3 (MvPolynomial.eval x f - a))
    (hderiv :
      serrePadicIntAddValuation 2
        (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (1 : ℕ∞)) :
    serreHenselValueLiftConclusion 2 f a x 2 := by
  have hhyp :
      serreHenselMultivariateHypothesis 2
        (f - (MvPolynomial.C a : MvPolynomial σ (SerrePadicInt 2))) x j 3 1 := by
    refine ⟨by norm_num, ?_, ?_⟩
    · simpa using hvalue
    · simpa using hderiv
  rcases serreHenselMultivariateConclusion_of_hypothesis hhyp with
    ⟨y, hyroot, hycong⟩
  refine ⟨y, ?_, ?_⟩
  · have hsub : MvPolynomial.eval y f - a = 0 := by
      simpa using hyroot
    exact sub_eq_zero.mp hsub
  · intro i
    simpa using hycong i

/--
The same dyadic value-lift package with the derivative coordinate expressed
existentially, matching the statement of Serre's Corollary 3 before the
matrix argument supplies such a coordinate.
-/
theorem serreHenselValueLift_mod_eight_of_exists_derivative_valuation_one
    {σ : Type*} [DecidableEq σ]
    [Fact (Nat.Prime 2)]
    {f : MvPolynomial σ (SerrePadicInt 2)}
    {a : SerrePadicInt 2} {x : σ → SerrePadicInt 2}
    (hvalue : padicDivisibilityDepth 2 3 (MvPolynomial.eval x f - a))
    (hderiv :
      ∃ j : σ,
        serrePadicIntAddValuation 2
          (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (1 : ℕ∞)) :
    serreHenselValueLiftConclusion 2 f a x 2 := by
  rcases hderiv with ⟨j, hj⟩
  exact serreHenselValueLift_mod_eight_of_derivative_valuation_one
    (f := f) (a := a) (x := x) (j := j) hvalue hj

end HenselQuadraticCorollary

end

end SerreNumberTheoryAI
