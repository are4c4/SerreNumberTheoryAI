import SerreNumberTheoryAI.Formalization.Chapter02.HenselTaylor
import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricCompletion

/-!
# Iterating the one-step Hensel improvement

This file starts the iteration stage of Serre, Chapter 2, §2.2.  The one-step
Newton improvement is available from the Taylor-remainder and linear-cancellation
lemmas; here we package successive approximations together with the two invariants
needed to apply the same step again.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselIteration

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

/-- The data preserved after `r` Hensel improvements. -/
def serreHenselIterateState
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (n k r : ℕ) :=
  {y : SerrePadicInt p //
    padicDivisibilityDepth p (n + r) (f.eval y) ∧
      serrePadicIntAddValuation p (f.derivative.eval y) = (k : ℕ∞)}

/-- Every iterate state satisfies the source hypothesis at the current exponent. -/
theorem serreHenselIterateState_hypothesis
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) (s : serreHenselIterateState p f n k r) :
    serreHenselUnivariateHypothesis p f s.1 (n + r) k := by
  refine ⟨?_, s.2.1, s.2.2⟩
  have hineq := hhyp.two_mul_lt
  omega

/-- Advance one iterate state using the concrete one-step Hensel theorem. -/
noncomputable def serreHenselAdvance
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) (s : serreHenselIterateState p f n k r) :
    serreHenselIterateState p f n k (r + 1) := by
  let hcurrent : serreHenselUnivariateHypothesis p f s.1 (n + r) k :=
    serreHenselIterateState_hypothesis hhyp r s
  let hstep := serreHenselUnivariateStepConclusion_of_hypothesis hcurrent
  refine ⟨Classical.choose hstep, ?_, ?_⟩
  · have heval := (Classical.choose_spec hstep).2.1
    simpa [Nat.add_assoc] using heval
  · exact (Classical.choose_spec hstep).2.2

/-- One advance changes the approximation only at the source-prescribed depth. -/
theorem serreHenselAdvance_congruent
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) (s : serreHenselIterateState p f n k r) :
    serrePadicCongruent p ((n + r) - k) s.1
      (serreHenselAdvance hhyp r s).1 := by
  let hcurrent : serreHenselUnivariateHypothesis p f s.1 (n + r) k :=
    serreHenselIterateState_hypothesis hhyp r s
  let hstep := serreHenselUnivariateStepConclusion_of_hypothesis hcurrent
  change serrePadicCongruent p ((n + r) - k) s.1 (Classical.choose hstep)
  exact (Classical.choose_spec hstep).1

/-- The recursively chosen sequence of Hensel states. -/
noncomputable def serreHenselIterateStateSeq
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    (r : ℕ) → serreHenselIterateState p f n k r
  | 0 => ⟨x, hhyp.eval_dvd, hhyp.derivative_valuation⟩
  | r + 1 => serreHenselAdvance hhyp r (serreHenselIterateStateSeq hhyp r)

/-- The underlying sequence of p-adic approximations. -/
noncomputable def serreHenselIterateSeq
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    ℕ → SerrePadicInt p :=
  fun r => (serreHenselIterateStateSeq hhyp r).1

@[simp]
theorem serreHenselIterateSeq_zero
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serreHenselIterateSeq hhyp 0 = x := by
  rfl

/-- Every chosen iterate has the expected improved zero congruence depth. -/
theorem serreHenselIterateSeq_eval_dvd
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) :
    padicDivisibilityDepth p (n + r)
      (f.eval (serreHenselIterateSeq hhyp r)) :=
  (serreHenselIterateStateSeq hhyp r).2.1

/-- Every chosen iterate preserves the derivative valuation invariant. -/
theorem serreHenselIterateSeq_derivative_valuation
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) :
    serrePadicIntAddValuation p
        (f.derivative.eval (serreHenselIterateSeq hhyp r)) = (k : ℕ∞) :=
  (serreHenselIterateStateSeq hhyp r).2.2

/-- Successive approximations become congruent at strictly increasing p-power depth. -/
theorem serreHenselIterateSeq_succ_congruent
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) :
    serrePadicCongruent p ((n + r) - k)
      (serreHenselIterateSeq hhyp r)
      (serreHenselIterateSeq hhyp (r + 1)) := by
  exact serreHenselAdvance_congruent hhyp r
    (serreHenselIterateStateSeq hhyp r)

/-- A finite tail of the Hensel sequence remains congruent to its first term. -/
theorem serreHenselIterateSeq_congruent_add
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r m : ℕ) :
    serrePadicCongruent p ((n + r) - k)
      (serreHenselIterateSeq hhyp r)
      (serreHenselIterateSeq hhyp (r + m)) := by
  induction m with
  | zero =>
      simpa using
        serrePadicCongruent_refl p ((n + r) - k)
          (serreHenselIterateSeq hhyp r)
  | succ m ih =>
      have hstepDeep := serreHenselIterateSeq_succ_congruent hhyp (r + m)
      have hle : (n + r) - k ≤ (n + (r + m)) - k := by
        omega
      have hstep :
          serrePadicCongruent p ((n + r) - k)
            (serreHenselIterateSeq hhyp (r + m))
            (serreHenselIterateSeq hhyp ((r + m) + 1)) :=
        serrePadicCongruent_mono
          (p := p) (m := (n + r) - k) (n := (n + (r + m)) - k)
          hle hstepDeep
      have htrans := serrePadicCongruent_trans ih hstep
      simpa [Nat.add_assoc] using htrans

/-- Later Hensel iterates are congruent to earlier ones at the earlier depth. -/
theorem serreHenselIterateSeq_congruent_of_le
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    {r s : ℕ} (hrs : r ≤ s) :
    serrePadicCongruent p ((n + r) - k)
      (serreHenselIterateSeq hhyp r)
      (serreHenselIterateSeq hhyp s) := by
  rcases Nat.exists_eq_add_of_le hrs with ⟨m, hm⟩
  rw [hm]
  exact serreHenselIterateSeq_congruent_add hhyp r m

/-- Every Hensel iterate stays congruent to the initial approximation at depth `n-k`. -/
theorem serreHenselIterateSeq_initial_congruent
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    (r : ℕ) :
    serrePadicCongruent p (n - k) x (serreHenselIterateSeq hhyp r) := by
  have htail := serreHenselIterateSeq_congruent_add hhyp 0 r
  simpa using htail

/-- Any two sufficiently late Hensel iterates are congruent at any requested lower depth. -/
theorem serreHenselIterateSeq_tail_congruent_of_le_depth
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k)
    {R d r s : ℕ} (hr : R ≤ r) (hs : R ≤ s)
    (hd : d ≤ (n + R) - k) :
    serrePadicCongruent p d
      (serreHenselIterateSeq hhyp r)
      (serreHenselIterateSeq hhyp s) := by
  by_cases hrs : r ≤ s
  · have htail := serreHenselIterateSeq_congruent_of_le hhyp hrs
    have hmono : d ≤ (n + r) - k := by
      have hRr : (n + R) - k ≤ (n + r) - k := by
        omega
      exact hd.trans hRr
    exact serrePadicCongruent_mono
      (p := p) (m := d) (n := (n + r) - k) hmono htail
  · have hsr : s ≤ r := by omega
    have htail := serreHenselIterateSeq_congruent_of_le hhyp hsr
    have hmono : d ≤ (n + s) - k := by
      have hRs : (n + R) - k ≤ (n + s) - k := by
        omega
      exact hd.trans hRs
    exact serrePadicCongruent_symm
      (serrePadicCongruent_mono
        (p := p) (m := d) (n := (n + s) - k) hmono htail)

/-- A source congruence gives the corresponding project-local metric bound. -/
theorem serrePadicCongruent_dist_le_radius
    {p : ℕ} [Fact p.Prime] {d : ℕ} {x y : SerrePadicInt p}
    (h : serrePadicCongruent p d x y) :
    serrePadicIntDist p x y ≤ Real.exp (-(d : ℝ)) := by
  have hsym : (p : SerrePadicInt p) ^ d ∣ x - y :=
    serrePadicCongruent_symm h
  exact (serrePadicIntDist_le_radius_iff_pow_dvd p x y d).2 hsym

/-- Congruence-based Cauchy criterion for sequences in the project-local `Z_p`. -/
def serrePadicCongruenceCauchy
    (p : ℕ) [Fact p.Prime] (u : ℕ → SerrePadicInt p) : Prop :=
  ∀ d : ℕ, ∃ R : ℕ, ∀ r s : ℕ, R ≤ r → R ≤ s →
    serrePadicCongruent p d (u r) (u s)

/-- The chosen Hensel iterate sequence is Cauchy in the congruence-depth sense. -/
theorem serreHenselIterateSeq_congruence_cauchy
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serrePadicCongruenceCauchy p (serreHenselIterateSeq hhyp) := by
  intro d
  refine ⟨d + k, ?_⟩
  intro r s hr hs
  exact serreHenselIterateSeq_tail_congruent_of_le_depth
    hhyp hr hs (by omega)

/-- Radius-based metric Cauchy criterion for project-local p-adic sequences. -/
def serrePadicMetricRadiusCauchy
    (p : ℕ) [Fact p.Prime] (u : ℕ → SerrePadicInt p) : Prop :=
  ∀ d : ℕ, ∃ R : ℕ, ∀ r s : ℕ, R ≤ r → R ≤ s →
    serrePadicIntDist p (u r) (u s) ≤ Real.exp (-(d : ℝ))

/-- Congruence-depth Cauchy implies the corresponding metric-radius Cauchy statement. -/
theorem serrePadicMetricRadiusCauchy_of_congruenceCauchy
    {p : ℕ} [Fact p.Prime] {u : ℕ → SerrePadicInt p}
    (hu : serrePadicCongruenceCauchy p u) :
    serrePadicMetricRadiusCauchy p u := by
  intro d
  rcases hu d with ⟨R, hR⟩
  refine ⟨R, ?_⟩
  intro r s hr hs
  exact serrePadicCongruent_dist_le_radius (p := p) (d := d) (hR r s hr hs)

/-- The chosen Hensel iterate sequence is Cauchy in the metric-radius sense. -/
theorem serreHenselIterateSeq_metric_radius_cauchy
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p}
    (hhyp : serreHenselUnivariateHypothesis p f x n k) :
    serrePadicMetricRadiusCauchy p (serreHenselIterateSeq hhyp) :=
  serrePadicMetricRadiusCauchy_of_congruenceCauchy
    (serreHenselIterateSeq_congruence_cauchy hhyp)

end HenselIteration

end

end SerreNumberTheoryAI
