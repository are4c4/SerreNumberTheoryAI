import SerreNumberTheoryAI.Formalization.Chapter02.HenselIteration

/-!
# Limit bookkeeping for the Hensel iterate sequence

This file isolates the first limit-facing consequences of the iterative Hensel
construction.  The exact-root theorem is not proved here yet; instead we name the
chosen limit supplied by completeness and record the metric estimates that will be
used to pass the zero congruences and the initial congruence to that limit.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselLimit

/-- The limit selected from completeness for the chosen Hensel iterate sequence. -/
noncomputable def serreHenselIterateLimit
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    SerrePadicInt p := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  exact Classical.choose (serreHenselIterateSeq_exists_tendsto hhyp)

/-- The selected Hensel limit is indeed the limit of the iterate sequence. -/
theorem serreHenselIterateSeq_tendsto_limit
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
    Filter.Tendsto (serreHenselIterateSeq hhyp) Filter.atTop
      (nhds (serreHenselIterateLimit hhyp)) := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  exact Classical.choose_spec (serreHenselIterateSeq_exists_tendsto hhyp)

/-- The polynomial values along the Hensel sequence satisfy shrinking zero-radius estimates. -/
theorem serreHenselIterateSeq_eval_dist_zero_le_radius
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) (r : ℕ) :
    serrePadicIntDist p (f.eval (serreHenselIterateSeq hhyp r)) 0 ≤
      Real.exp (-((n + r : ℕ) : ℝ)) := by
  have hdvd :
      padicDivisibilityDepth p (n + r)
        (f.eval (serreHenselIterateSeq hhyp r)) :=
    serreHenselIterateSeq_eval_dvd hhyp r
  exact (serrePadicIntDist_le_radius_iff_pow_dvd p
    (f.eval (serreHenselIterateSeq hhyp r)) 0 (n + r)).2 (by
      simpa [padicDivisibilityDepth] using hdvd)

/-- Every Hensel iterate remains within the final source congruence radius of the start. -/
theorem serreHenselIterateSeq_initial_dist_le_radius
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) (r : ℕ) :
    serrePadicIntDist p x (serreHenselIterateSeq hhyp r) ≤
      Real.exp (-((n - k : ℕ) : ℝ)) := by
  exact serrePadicCongruent_dist_le_radius
    (serreHenselIterateSeq_initial_congruent hhyp r)

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
  refine ⟨serreHenselIterateLimit hhyp,
    serreHenselIterateSeq_tendsto_limit hhyp, ?_, ?_, ?_⟩
  · intro r
    exact serreHenselIterateSeq_eval_dvd hhyp r
  · intro r
    exact serreHenselIterateSeq_derivative_valuation hhyp r
  · intro r
    exact serreHenselIterateSeq_initial_congruent hhyp r

/-- Package the selected limit together with the metric estimates currently available. -/
theorem serreHenselIterateLimit_metric_package
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
    Filter.Tendsto (serreHenselIterateSeq hhyp) Filter.atTop
        (nhds (serreHenselIterateLimit hhyp)) ∧
      (∀ r : ℕ,
        serrePadicIntDist p (f.eval (serreHenselIterateSeq hhyp r)) 0 ≤
          Real.exp (-((n + r : ℕ) : ℝ))) ∧
        ∀ r : ℕ,
          serrePadicIntDist p x (serreHenselIterateSeq hhyp r) ≤
            Real.exp (-((n - k : ℕ) : ℝ)) := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  refine ⟨serreHenselIterateSeq_tendsto_limit hhyp, ?_, ?_⟩
  · exact serreHenselIterateSeq_eval_dist_zero_le_radius hhyp
  · exact serreHenselIterateSeq_initial_dist_le_radius hhyp

/-- The selected Hensel limit retains the source congruence to the initial approximation. -/
theorem serreHenselIterateLimit_initial_congruent
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serrePadicCongruent p (n - k) x (serreHenselIterateLimit hhyp) := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  let R : ℝ := Real.exp (-((n - k : ℕ) : ℝ))
  have hclosed : IsClosed (Metric.closedBall x R) := Metric.isClosed_closedBall
  have heventually :
      ∀ᶠ r in Filter.atTop,
        serreHenselIterateSeq hhyp r ∈ Metric.closedBall x R :=
    Filter.Eventually.of_forall (fun r => by
      rw [Metric.mem_closedBall]
      have hdist := serreHenselIterateSeq_initial_dist_le_radius hhyp r
      have hdist' : dist x (serreHenselIterateSeq hhyp r) ≤ R := by
        change serrePadicIntDist p x (serreHenselIterateSeq hhyp r) ≤ R
        exact hdist
      simpa [dist_comm] using hdist')
  have hlimit_mem : serreHenselIterateLimit hhyp ∈ Metric.closedBall x R :=
    hclosed.mem_of_tendsto (serreHenselIterateSeq_tendsto_limit hhyp) heventually
  have hdist_ball : dist (serreHenselIterateLimit hhyp) x ≤ R := by
    simpa [R, Metric.mem_closedBall] using hlimit_mem
  have hdist_metric : dist x (serreHenselIterateLimit hhyp) ≤ R := by
    simpa [dist_comm] using hdist_ball
  have hdist : serrePadicIntDist p x (serreHenselIterateLimit hhyp) ≤ R := by
    change serrePadicIntDist p x (serreHenselIterateLimit hhyp) ≤ R at hdist_metric
    exact hdist_metric
  have hyx : serrePadicCongruent p (n - k) (serreHenselIterateLimit hhyp) x :=
    (serrePadicIntDist_le_radius_iff_pow_dvd p x
      (serreHenselIterateLimit hhyp) (n - k)).1 hdist
  exact serrePadicCongruent_symm hyx

/-- A project-local p-adic integer lying in every radius around zero is zero. -/
theorem serrePadicInt_eq_zero_of_dist_le_all_radius
    {p : ℕ} [Fact p.Prime] {a : SerrePadicInt p}
    (ha : ∀ d : ℕ, serrePadicIntDist p a 0 ≤ Real.exp (-(d : ℝ))) :
    a = 0 := by
  apply serrePadicInt_ext p
  intro n
  change serrePadicIntProj p n a = serrePadicIntProj p n 0
  exact (serrePadicIntDist_le_radius_succ_iff_proj_eq p a 0 n).1 (by
    simpa using ha (n + 1))

/--
A radius estimate at every finite level for the limit value implies the
source-shaped one-variable Hensel conclusion.
-/
theorem serreHenselUnivariateConclusion_of_iterateLimit_eval_dist
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (hdist : ∀ d : ℕ,
      serrePadicIntDist p (f.eval (serreHenselIterateLimit hhyp)) 0 ≤
        Real.exp (-(d : ℝ))) :
    serreHenselUnivariateConclusion p f x n k := by
  exact ⟨serreHenselIterateLimit hhyp,
    serrePadicInt_eq_zero_of_dist_le_all_radius (p := p) hdist,
    serreHenselIterateLimit_initial_congruent hhyp⟩

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

/--
After the limit has been shown to be an exact root, the one-variable Hensel
conclusion follows from the retained initial congruence already proved above.
-/
theorem serreHenselUnivariateConclusion_of_iterateLimit_root
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (hroot : f.eval (serreHenselIterateLimit hhyp) = 0) :
    serreHenselUnivariateConclusion p f x n k := by
  exact serreHenselUnivariateConclusion_of_exact_limit_congruent hroot
    (serreHenselIterateLimit_initial_congruent hhyp)

end HenselLimit

end

end SerreNumberTheoryAI
