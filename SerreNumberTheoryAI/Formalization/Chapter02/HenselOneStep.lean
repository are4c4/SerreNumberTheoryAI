import SerreNumberTheoryAI.Formalization.Chapter02.HenselTaylor

/-!
# Concrete one-step Hensel improvement

This file packages the Taylor remainder, linear cancellation, and derivative-valuation
preservation lemmas from `HenselTaylor` into the source-shaped one-step Newton
improvement used in Serre, Chapter 2, §2.2.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselOneStep

/--
Concrete one-step Newton improvement for the one-variable Hensel hypothesis.

This removes the auxiliary Taylor-factor, linear-cancellation, and derivative-preservation
hypotheses by using the polynomial Taylor theorem and the correction chosen from the
source valuation data.
-/
theorem serreHenselUnivariateStepConclusion_of_hypothesis
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serreHenselUnivariateStepConclusion p f x n k := by
  rcases serreHensel_exists_linear_cancel
      (p := p) (n := n) (k := k) (f := f) (x := x) hhyp with
    ⟨z, hlinear⟩
  exact serreHenselUnivariateStepConclusion_of_linear_cancel
    (p := p) (n := n) (k := k) (f := f) (x := x) (z := z)
    hhyp
    (serreHenselTaylorQuadraticFactor_all p f x
      ((p : SerrePadicInt p) ^ (n - k) * z))
    hlinear
    (serreHensel_derivative_valuation_add_correction
      (p := p) (n := n) (k := k) (f := f) (x := x) hhyp z)

end HenselOneStep

end

end SerreNumberTheoryAI
