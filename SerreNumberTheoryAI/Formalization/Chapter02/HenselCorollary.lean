import SerreNumberTheoryAI.Formalization.Chapter02.HenselLimitRoot

/-!
# Hensel simple-root corollaries

This file packages the `n = 1`, `k = 0` special case of the source-shaped
Hensel theorem.  In Serre's §2.2 this is Corollary 1: a simple zero modulo `p`
lifts to an actual zero in `Z_p`.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselCorollary

/-- One-variable simple-root hypothesis: zero modulo `p` and unit derivative. -/
def serreHenselUnivariateSimpleRootHypothesis
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x : SerrePadicInt p) : Prop :=
  padicDivisibilityDepth p 1 (f.eval x) ∧
    serrePadicIntAddValuation p (f.derivative.eval x) = (0 : ℕ∞)

/-- One-variable simple-root conclusion: an exact root congruent modulo `p`. -/
def serreHenselUnivariateSimpleRootConclusion
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x : SerrePadicInt p) : Prop :=
  ∃ y : SerrePadicInt p,
    f.eval y = 0 ∧ serrePadicCongruent p 1 x y

/-- Serre's one-variable simple-root corollary, packaged as `n = 1`, `k = 0`. -/
theorem serreHenselUnivariateSimpleRootConclusion_of_hypothesis
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (h : serreHenselUnivariateSimpleRootHypothesis p f x) :
    serreHenselUnivariateSimpleRootConclusion p f x := by
  have hhyp : serreHenselUnivariateHypothesis p f x 1 0 := by
    refine ⟨by norm_num, h.1, ?_⟩
    simpa using h.2
  rcases serreHenselUnivariateConclusion_of_hypothesis hhyp with ⟨y, hyroot, hycong⟩
  exact ⟨y, hyroot, by simpa using hycong⟩

/-- Multivariate simple-root hypothesis at a chosen coordinate. -/
def serreHenselMultivariateSimpleRootHypothesis
    {σ : Type*} (p : ℕ) [Fact p.Prime]
    (f : MvPolynomial σ (SerrePadicInt p))
    (x : σ → SerrePadicInt p) (j : σ) : Prop :=
  padicDivisibilityDepth p 1 (MvPolynomial.eval x f) ∧
    serrePadicIntAddValuation p
      (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (0 : ℕ∞)

/-- Multivariate simple-root conclusion: an exact root congruent modulo `p` in every coordinate. -/
def serreHenselMultivariateSimpleRootConclusion
    {σ : Type*} (p : ℕ) [Fact p.Prime]
    (f : MvPolynomial σ (SerrePadicInt p))
    (x : σ → SerrePadicInt p) : Prop :=
  ∃ y : σ → SerrePadicInt p,
    MvPolynomial.eval y f = 0 ∧
      ∀ i, serrePadicCongruent p 1 (x i) (y i)

/-- Serre's multivariate simple-root corollary, packaged as `n = 1`, `k = 0`. -/
theorem serreHenselMultivariateSimpleRootConclusion_of_hypothesis
    {σ : Type*} [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)}
    {x : σ → SerrePadicInt p} {j : σ}
    (h : serreHenselMultivariateSimpleRootHypothesis p f x j) :
    serreHenselMultivariateSimpleRootConclusion p f x := by
  have hhyp : serreHenselMultivariateHypothesis p f x j 1 0 := by
    refine ⟨by norm_num, h.1, ?_⟩
    simpa using h.2
  rcases serreHenselMultivariateConclusion_of_hypothesis hhyp with ⟨y, hyroot, hycong⟩
  exact ⟨y, hyroot, by simpa using hycong⟩

end HenselCorollary

end

end SerreNumberTheoryAI
