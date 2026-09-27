import SerreNumberTheoryAI.Formalization.Chapter02.RootExistence
import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerValuationAPI

/-!
# Hensel lifting source predicates

This file starts the formalization of Serre, Chapter 2, §2.2, Theorem 1 and
Corollary 1.  The source theorem assumes a polynomial congruence modulo `p^n`,
a derivative of exact additive valuation `k`, and `2 * k < n`.  The conclusion is
an exact project-local `Z_p` zero congruent to the approximate solution modulo
`p^(n-k)`.

The definitions below package precisely these source-side hypotheses and conclusions
for later proof work.  They deliberately use the project-local `SerrePadicInt` and
`serrePadicIntAddValuation` APIs, not mathlib's completed `PadicInt` Hensel theorem.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselLifting

variable {σ : Type*}

/-- Divisibility by the source modulus `p^n`. -/
def padicDivisibilityDepth
    (p : ℕ) [Fact p.Prime] (n : ℕ) (x : SerrePadicInt p) : Prop :=
  (p : SerrePadicInt p) ^ n ∣ x

/-- Source congruence `y ≡ x (mod p^n)` in the project-local `Z_p`. -/
def serrePadicCongruent
    (p : ℕ) [Fact p.Prime] (n : ℕ)
    (x y : SerrePadicInt p) : Prop :=
  padicDivisibilityDepth p n (y - x)

/-- The one-variable hypotheses in the Newton-improvement part of the source proof. -/
def serreHenselUnivariateHypothesis
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x : SerrePadicInt p)
    (n k : ℕ) : Prop :=
  2 * k < n ∧
    padicDivisibilityDepth p n (f.eval x) ∧
      serrePadicIntAddValuation p (f.derivative.eval x) = (k : ℕ∞)

/-- The one-variable conclusion of the source Hensel theorem. -/
def serreHenselUnivariateConclusion
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x : SerrePadicInt p)
    (n k : ℕ) : Prop :=
  ∃ y : SerrePadicInt p,
    f.eval y = 0 ∧
      serrePadicCongruent p (n - k) x y ∧
        serrePadicIntAddValuation p (f.derivative.eval y) = (k : ℕ∞)

/-- The multivariate hypotheses in Serre's Theorem 1. -/
def serreHenselMultivariateHypothesis
    (p : ℕ) [Fact p.Prime]
    (f : MvPolynomial σ (SerrePadicInt p))
    (x : σ → SerrePadicInt p) (j : σ) (n k : ℕ) : Prop :=
  2 * k < n ∧
    padicDivisibilityDepth p n (MvPolynomial.eval x f) ∧
      serrePadicIntAddValuation p
          (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (k : ℕ∞)

/-- The multivariate conclusion in Serre's Theorem 1. -/
def serreHenselMultivariateConclusion
    (p : ℕ) [Fact p.Prime]
    (f : MvPolynomial σ (SerrePadicInt p))
    (x : σ → SerrePadicInt p) (j : σ) (n k : ℕ) : Prop :=
  ∃ y : σ → SerrePadicInt p,
    MvPolynomial.eval y f = 0 ∧
      (∀ i, serrePadicCongruent p (n - k) (x i) (y i)) ∧
        serrePadicIntAddValuation p
          (MvPolynomial.eval y (MvPolynomial.pderiv j f)) = (k : ℕ∞)

/-- Source one-coordinate update used to reduce the multivariate theorem to the univariate case. -/
def serreHenselUpdateCoord [DecidableEq σ]
    (x : σ → SerrePadicInt p) (j : σ) (yj : SerrePadicInt p) :
    σ → SerrePadicInt p :=
  fun i => if i = j then yj else x i

@[simp]
theorem serreHenselUpdateCoord_self [DecidableEq σ]
    (x : σ → SerrePadicInt p) (j : σ) (yj : SerrePadicInt p) :
    serreHenselUpdateCoord (p := p) x j yj j = yj := by
  simp [serreHenselUpdateCoord]

@[simp]
theorem serreHenselUpdateCoord_of_ne [DecidableEq σ]
    (x : σ → SerrePadicInt p) {i j : σ} (hij : i ≠ j)
    (yj : SerrePadicInt p) :
    serreHenselUpdateCoord (p := p) x j yj i = x i := by
  simp [serreHenselUpdateCoord, hij]

/-- The correction shape `y = x + p^(n-k) z` implies the source congruence. -/
theorem serrePadicCongruent_of_eq_add_pow_mul
    (p : ℕ) [Fact p.Prime] (n k : ℕ)
    (x y z : SerrePadicInt p)
    (hy : y = x + (p : SerrePadicInt p) ^ (n - k) * z) :
    serrePadicCongruent p (n - k) x y := by
  refine ⟨z, ?_⟩
  rw [hy]
  ring

/-- Extract the inequality `2*k < n` from the one-variable source hypotheses. -/
theorem serreHenselUnivariateHypothesis.two_mul_lt
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateHypothesis p f x n k) :
    2 * k < n :=
  h.1

/-- Extract the congruence `f(x) ≡ 0 (mod p^n)` from the one-variable hypotheses. -/
theorem serreHenselUnivariateHypothesis.eval_dvd
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateHypothesis p f x n k) :
    padicDivisibilityDepth p n (f.eval x) :=
  h.2.1

/-- Extract the derivative valuation condition from the one-variable hypotheses. -/
theorem serreHenselUnivariateHypothesis.derivative_valuation
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateHypothesis p f x n k) :
    serrePadicIntAddValuation p (f.derivative.eval x) = (k : ℕ∞) :=
  h.2.2

/-- Extract an exact root from the one-variable conclusion. -/
theorem serreHenselUnivariateConclusion.exists_root
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateConclusion p f x n k) :
    ∃ y : SerrePadicInt p, f.eval y = 0 := by
  rcases h with ⟨y, hy, _, _⟩
  exact ⟨y, hy⟩

/-- Extract the inequality `2*k < n` from the multivariate source hypotheses. -/
theorem serreHenselMultivariateHypothesis.two_mul_lt
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    2 * k < n :=
  h.1

/-- Extract the congruence `f(x) ≡ 0 (mod p^n)` from the multivariate hypotheses. -/
theorem serreHenselMultivariateHypothesis.eval_dvd
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    padicDivisibilityDepth p n (MvPolynomial.eval x f) :=
  h.2.1

/-- Extract the partial-derivative valuation condition from the multivariate hypotheses. -/
theorem serreHenselMultivariateHypothesis.pderiv_valuation
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    serrePadicIntAddValuation p
        (MvPolynomial.eval x (MvPolynomial.pderiv j f)) = (k : ℕ∞) :=
  h.2.2

/-- Extract an exact root from the multivariate conclusion. -/
theorem serreHenselMultivariateConclusion.exists_root
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateConclusion p f x j n k) :
    ∃ y : σ → SerrePadicInt p, MvPolynomial.eval y f = 0 := by
  rcases h with ⟨y, hy, _, _⟩
  exact ⟨y, hy⟩

end HenselLifting

end

end SerreNumberTheoryAI
