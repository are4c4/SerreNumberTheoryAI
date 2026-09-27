import SerreNumberTheoryAI.Formalization.Chapter02.HenselConclusion

/-!
# Exact-root bridge for the Hensel iteration limit

This file starts the final one-variable Hensel step: passing the increasing
finite-level divisibility statements for the iterates to the selected limit.
The proof remains project-local; it uses residue projections and the already
constructed iterate limit, not a packaged Hensel theorem.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselLimitRoot

/-- Evaluating a one-variable polynomial commutes with finite residue projection. -/
theorem serrePadicIntProj_polynomial_eval
    (p : ℕ) [Fact p.Prime] (d : ℕ)
    (f : Polynomial (SerrePadicInt p)) (x : SerrePadicInt p) :
    serrePadicIntProj p d (f.eval x) =
      (Polynomial.map (serrePadicIntProj p d) f).eval
        (serrePadicIntProj p d x) := by
  refine Polynomial.induction_on f ?_ ?_ ?_
  · intro a
    simp
  · intro f g hf hg
    calc
      serrePadicIntProj p d ((f + g).eval x) =
          serrePadicIntProj p d (f.eval x + g.eval x) := by
        simp [Polynomial.eval_add]
      _ = serrePadicIntProj p d (f.eval x) +
            serrePadicIntProj p d (g.eval x) := by
        exact map_add (serrePadicIntProj p d) (f.eval x) (g.eval x)
      _ = (Polynomial.map (serrePadicIntProj p d) f).eval
            (serrePadicIntProj p d x) +
          (Polynomial.map (serrePadicIntProj p d) g).eval
            (serrePadicIntProj p d x) := by
        rw [hf, hg]
      _ = (Polynomial.map (serrePadicIntProj p d) (f + g)).eval
            (serrePadicIntProj p d x) := by
        simp [Polynomial.eval_add]
  · intro n a _
    simp

/-- Polynomial evaluation at a finite residue level only depends on the input at that level. -/
theorem serrePadicIntProj_polynomial_eval_eq_of_proj_eq
    {p : ℕ} [Fact p.Prime] {d : ℕ}
    {x y : SerrePadicInt p} (f : Polynomial (SerrePadicInt p))
    (hxy : serrePadicIntProj p d x = serrePadicIntProj p d y) :
    serrePadicIntProj p d (f.eval x) =
      serrePadicIntProj p d (f.eval y) := by
  rw [serrePadicIntProj_polynomial_eval p d f x,
    serrePadicIntProj_polynomial_eval p d f y, hxy]

/-- The selected Hensel limit inherits every finite divisibility depth of the values. -/
theorem serreHenselIterateLimit_eval_dvd
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) (d : ℕ) :
    padicDivisibilityDepth p d (f.eval (serreHenselIterateLimit hhyp)) := by
  cases d with
  | zero =>
      simpa [padicDivisibilityDepth]
  | succ m =>
      letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
      have heventually :
          ∀ᶠ r in Filter.atTop,
            serreHenselIterateSeq hhyp r ∈
              serrePadicIntProjFiber p (serreHenselIterateLimit hhyp) m :=
        (serreHenselIterateSeq_tendsto_limit hhyp).eventually
          ((isOpen_serrePadicIntProjFiber p (serreHenselIterateLimit hhyp) m).mem_nhds
            (self_mem_serrePadicIntProjFiber p (serreHenselIterateLimit hhyp) m))
      obtain ⟨N, hN⟩ := Filter.eventually_atTop.1 heventually
      let r : ℕ := max N (m + 1)
      have hrN : N ≤ r := by
        exact le_max_left N (m + 1)
      have hproj_arg :
          serrePadicIntProj p m (serreHenselIterateSeq hhyp r) =
            serrePadicIntProj p m (serreHenselIterateLimit hhyp) := by
        exact hN r hrN
      have hdepth : m + 1 ≤ n + r := by
        have hm : m + 1 ≤ r := le_max_right N (m + 1)
        omega
      have hdvd_seq :
          padicDivisibilityDepth p (m + 1)
            (f.eval (serreHenselIterateSeq hhyp r)) :=
        padicDivisibilityDepth_mono
          (p := p) (m := m + 1) (n := n + r) hdepth
          (serreHenselIterateSeq_eval_dvd hhyp r)
      have hproj_eval_seq :
          serrePadicIntProj p m (f.eval (serreHenselIterateSeq hhyp r)) = 0 :=
        (pow_dvd_serrePadicInt_iff_proj_zero p m
          (f.eval (serreHenselIterateSeq hhyp r))).1 hdvd_seq
      have hproj_eval_eq :
          serrePadicIntProj p m (f.eval (serreHenselIterateSeq hhyp r)) =
            serrePadicIntProj p m (f.eval (serreHenselIterateLimit hhyp)) :=
        serrePadicIntProj_polynomial_eval_eq_of_proj_eq f hproj_arg
      have hproj_eval_limit :
          serrePadicIntProj p m (f.eval (serreHenselIterateLimit hhyp)) = 0 := by
        rw [← hproj_eval_eq]
        exact hproj_eval_seq
      exact (pow_dvd_serrePadicInt_iff_proj_zero p m
        (f.eval (serreHenselIterateLimit hhyp))).2 hproj_eval_limit

/-- The selected Hensel iteration limit is an exact root. -/
theorem serreHenselIterateLimit_is_root
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    f.eval (serreHenselIterateLimit hhyp) = 0 := by
  apply serrePadicInt_ext p
  intro m
  change serrePadicIntProj p m (f.eval (serreHenselIterateLimit hhyp)) =
    serrePadicIntProj p m 0
  rw [map_zero]
  exact (pow_dvd_serrePadicInt_iff_proj_zero p m
    (f.eval (serreHenselIterateLimit hhyp))).1
    (serreHenselIterateLimit_eval_dvd hhyp (m + 1))

/-- The one-variable Hensel conclusion follows from the source-shaped hypothesis. -/
theorem serreHenselUnivariateConclusion_of_hypothesis
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serreHenselUnivariateConclusion p f x n k :=
  serreHenselUnivariateConclusion_of_iterateLimit_root hhyp
    (serreHenselIterateLimit_is_root hhyp)

end HenselLimitRoot

end

end SerreNumberTheoryAI
