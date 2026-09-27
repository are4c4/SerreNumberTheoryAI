import SerreNumberTheoryAI.Formalization.Chapter02.HenselIteration

/-!
# Limit package for the Hensel iteration

This file isolates the final-limit interface for Serre, Chapter 2, §2.2.  The
iteration file constructs a Cauchy sequence and obtains a limit by project-local
completeness; here we package that limit together with the pointwise invariants
that still have to be passed to the limit in order to finish the exact-root
conclusion.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselLimit

/--
The limit supplied by completeness, packaged together with all pointwise invariants
currently available before passing to the limit.
-/
theorem serreHenselIterateSeq_exists_limit_with_invariants
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
    ∃ y : SerrePadicInt p,
      Filter.Tendsto (serreHenselIterateSeq hhyp) Filter.atTop (nhds y) ∧
        (∀ r : ℕ,
          padicDivisibilityDepth p (n + r)
            (f.eval (serreHenselIterateSeq hhyp r))) ∧
          (∀ r : ℕ,
            serrePadicIntAddValuation p
                (f.derivative.eval (serreHenselIterateSeq hhyp r)) = (k : ℕ∞)) ∧
            (∀ r : ℕ,
              serrePadicCongruent p (n - k) x (serreHenselIterateSeq hhyp r)) := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  rcases serreHenselIterateSeq_exists_tendsto hhyp with ⟨y, hy⟩
  refine ⟨y, hy, ?_, ?_, ?_⟩
  · intro r
    exact serreHenselIterateSeq_eval_dvd hhyp r
  · intro r
    exact serreHenselIterateSeq_derivative_valuation hhyp r
  · intro r
    exact serreHenselIterateSeq_initial_congruent hhyp r

/--
Once the Hensel-iteration limit is known to be an exact root and to retain the
initial congruence, it gives Serre's source-shaped one-variable conclusion.
-/
theorem serreHenselUnivariateConclusion_of_exact_limit_congruent
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x y : SerrePadicInt p}
    (hyroot : f.eval y = 0)
    (hycong : serrePadicCongruent p (n - k) x y) :
    serreHenselUnivariateConclusion p f x n k := by
  exact ⟨y, hyroot, hycong⟩

end HenselLimit

end

end SerreNumberTheoryAI
