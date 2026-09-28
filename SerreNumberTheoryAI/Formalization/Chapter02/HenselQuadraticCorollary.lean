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

/--
Evaluating a partial derivative of `∑ᵢⱼ aᵢⱼ Xᵢ Xⱼ` gives the sum of the
corresponding row and column linear forms.
-/
theorem serreQuadraticPolynomial_pderiv_eval
    {σ : Type*} [Fintype σ] [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (k : σ) :
    MvPolynomial.eval x
        (MvPolynomial.pderiv k (serreQuadraticPolynomial (p := p) A)) =
      (∑ j : σ, A k j * x j) + (∑ i : σ, A i k * x i) := by
  classical
  simp [serreQuadraticPolynomial, MvPolynomial.pderiv_sum, MvPolynomial.pderiv_mul,
    Finset.sum_add_distrib, mul_assoc, mul_left_comm, mul_comm]

/--
For a symmetric coefficient matrix, the selected partial derivative evaluates to
`2 * ∑ᵢ aⱼᵢ xᵢ`, matching the formula used in Serre's proof.
-/
theorem serreQuadraticPolynomial_pderiv_eval_of_symm
    {σ : Type*} [Fintype σ] [DecidableEq σ] {p : ℕ} [Fact p.Prime]
    (A : σ → σ → SerrePadicInt p) (x : σ → SerrePadicInt p) (k : σ)
    (hA : ∀ i j, A i j = A j i) :
    MvPolynomial.eval x
        (MvPolynomial.pderiv k (serreQuadraticPolynomial (p := p) A)) =
      (2 : SerrePadicInt p) * (∑ i : σ, A k i * x i) := by
  classical
  rw [serreQuadraticPolynomial_pderiv_eval (p := p) A x k]
  have hsum : (∑ i : σ, A i k * x i) = ∑ i : σ, A k i * x i := by
    apply Finset.sum_congr rfl
    intro i _
    rw [hA i k]
  rw [hsum]
  ring

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
