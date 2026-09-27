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

end HenselIteration

end

end SerreNumberTheoryAI
