import SerreNumberTheoryAI.Formalization.Chapter02.HenselLimit

/-!
# One-variable Hensel conclusion packaging

This file contains the final packaging step for the one-variable Hensel theorem:
once the selected iteration limit is known to be an exact root, the retained
initial congruence already proved in `HenselLimit` gives Serre's source-shaped
conclusion.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselConclusion

/--
To finish the one-variable Hensel theorem it remains only to prove that the
selected Hensel limit is an exact root.
-/
theorem serreHenselUnivariateConclusion_of_limit_root
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (hroot : f.eval (serreHenselIterateLimit hhyp) = 0) :
    serreHenselUnivariateConclusion p f x n k := by
  exact serreHenselUnivariateConclusion_of_exact_limit_congruent
    hroot (serreHenselIterateLimit_initial_congruent hhyp)

end HenselConclusion

end

end SerreNumberTheoryAI
