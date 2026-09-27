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

/-- A single Newton-improvement conclusion: improve the zero congruence by one power. -/
def serreHenselUnivariateStepConclusion
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x : SerrePadicInt p)
    (n k : ℕ) : Prop :=
  ∃ y : SerrePadicInt p,
    serrePadicCongruent p (n - k) x y ∧
      padicDivisibilityDepth p (n + 1) (f.eval y) ∧
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

/-- A single multivariate Newton-improvement conclusion. -/
def serreHenselMultivariateStepConclusion
    (p : ℕ) [Fact p.Prime]
    (f : MvPolynomial σ (SerrePadicInt p))
    (x : σ → SerrePadicInt p) (j : σ) (n k : ℕ) : Prop :=
  ∃ y : σ → SerrePadicInt p,
    (∀ i, serrePadicCongruent p (n - k) (x i) (y i)) ∧
      padicDivisibilityDepth p (n + 1) (MvPolynomial.eval y f) ∧
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

/-- Source congruence is reflexive. -/
theorem serrePadicCongruent_refl
    (p : ℕ) [Fact p.Prime] (n : ℕ) (x : SerrePadicInt p) :
    serrePadicCongruent p n x x := by
  show (p : SerrePadicInt p) ^ n ∣ x - x
  simp

/-- Source congruence is symmetric. -/
theorem serrePadicCongruent_symm
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x y : SerrePadicInt p}
    (h : serrePadicCongruent p n x y) :
    serrePadicCongruent p n y x := by
  rcases h with ⟨z, hz⟩
  refine ⟨-z, ?_⟩
  calc
    x - y = -(y - x) := by ring
    _ = -((p : SerrePadicInt p) ^ n * z) := by rw [hz]
    _ = (p : SerrePadicInt p) ^ n * (-z) := by ring

/-- Source congruence is transitive. -/
theorem serrePadicCongruent_trans
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x y z : SerrePadicInt p}
    (hxy : serrePadicCongruent p n x y)
    (hyz : serrePadicCongruent p n y z) :
    serrePadicCongruent p n x z := by
  rcases hxy with ⟨a, ha⟩
  rcases hyz with ⟨b, hb⟩
  refine ⟨a + b, ?_⟩
  calc
    z - x = (y - x) + (z - y) := by ring
    _ = (p : SerrePadicInt p) ^ n * a + (p : SerrePadicInt p) ^ n * b := by rw [ha, hb]
    _ = (p : SerrePadicInt p) ^ n * (a + b) := by ring

/-- A stronger modulus implies any weaker source congruence. -/
theorem serrePadicCongruent_mono
    {p : ℕ} [Fact p.Prime] {m n : ℕ} (hmn : m ≤ n)
    {x y : SerrePadicInt p}
    (h : serrePadicCongruent p n x y) :
    serrePadicCongruent p m x y := by
  show (p : SerrePadicInt p) ^ m ∣ y - x
  exact (pow_dvd_pow (p : SerrePadicInt p) hmn).trans h

/-- The correction shape `y = x + p^(n-k) z` implies the source congruence. -/
theorem serrePadicCongruent_of_eq_add_pow_mul
    (p : ℕ) [Fact p.Prime] (n k : ℕ)
    (x y z : SerrePadicInt p)
    (hy : y = x + (p : SerrePadicInt p) ^ (n - k) * z) :
    serrePadicCongruent p (n - k) x y := by
  refine ⟨z, ?_⟩
  rw [hy]
  ring

/-- Updating one coordinate preserves the congruence goal in every coordinate. -/
theorem serreHenselUpdateCoord_all_congruent [DecidableEq σ]
    {p : ℕ} [Fact p.Prime] {n : ℕ}
    (x : σ → SerrePadicInt p) (j : σ) {yj : SerrePadicInt p}
    (h : serrePadicCongruent p n (x j) yj) :
    ∀ i, serrePadicCongruent p n (x i)
        (serreHenselUpdateCoord (p := p) x j yj i) := by
  intro i
  by_cases hij : i = j
  · subst i
    simpa [serreHenselUpdateCoord] using h
  · have hsame : serreHenselUpdateCoord (p := p) x j yj i = x i := by
      simp [serreHenselUpdateCoord, hij]
    rw [hsame]
    exact serrePadicCongruent_refl p n (x i)

/-- Extract the inequality `2*k < n` from the one-variable source hypotheses. -/
theorem serreHenselUnivariateHypothesis.two_mul_lt
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateHypothesis p f x n k) :
    2 * k < n :=
  h.1

/-- The source inequality implies `k < n`. -/
theorem serreHenselUnivariateHypothesis.k_lt_n
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateHypothesis p f x n k) :
    k < n := by
  have hk := h.two_mul_lt
  omega

/-- The source correction modulus `p^(n-k)` is a positive power. -/
theorem serreHenselUnivariateHypothesis.n_sub_k_pos
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateHypothesis p f x n k) :
    0 < n - k := by
  have hk := h.two_mul_lt
  omega

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

/-- An exact Hensel conclusion also provides every one-step improvement conclusion. -/
theorem serreHenselUnivariateConclusion.to_step
    {p : ℕ} [Fact p.Prime]
    {f : Polynomial (SerrePadicInt p)} {x : SerrePadicInt p} {n k : ℕ}
    (h : serreHenselUnivariateConclusion p f x n k) :
    serreHenselUnivariateStepConclusion p f x n k := by
  rcases h with ⟨y, hyroot, hycong, hyv⟩
  refine ⟨y, hycong, ?_, hyv⟩
  show (p : SerrePadicInt p) ^ (n + 1) ∣ f.eval y
  rw [hyroot]
  exact dvd_zero _

/-- Extract the inequality `2*k < n` from the multivariate source hypotheses. -/
theorem serreHenselMultivariateHypothesis.two_mul_lt
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    2 * k < n :=
  h.1

/-- The multivariate source inequality implies `k < n`. -/
theorem serreHenselMultivariateHypothesis.k_lt_n
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    k < n := by
  have hk := h.two_mul_lt
  omega

/-- The multivariate source correction modulus `p^(n-k)` is a positive power. -/
theorem serreHenselMultivariateHypothesis.n_sub_k_pos
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    0 < n - k := by
  have hk := h.two_mul_lt
  omega

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

/-- An exact multivariate conclusion also provides every one-step improvement conclusion. -/
theorem serreHenselMultivariateConclusion.to_step
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ}
    (h : serreHenselMultivariateConclusion p f x j n k) :
    serreHenselMultivariateStepConclusion p f x j n k := by
  rcases h with ⟨y, hyroot, hycong, hyv⟩
  refine ⟨y, hycong, ?_, hyv⟩
  show (p : SerrePadicInt p) ^ (n + 1) ∣ MvPolynomial.eval y f
  rw [hyroot]
  exact dvd_zero _

/-- Transfer the multivariate source hypotheses to a chosen one-variable specialization. -/
theorem serreHenselUnivariateHypothesis_of_multivariateHypothesis
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ} {g : Polynomial (SerrePadicInt p)}
    (heval : g.eval (x j) = MvPolynomial.eval x f)
    (hderiv : g.derivative.eval (x j) =
        MvPolynomial.eval x (MvPolynomial.pderiv j f))
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    serreHenselUnivariateHypothesis p g (x j) n k := by
  refine ⟨h.1, ?_, ?_⟩
  · rw [heval]
    exact h.2.1
  · rw [hderiv]
    exact h.2.2

/--
Transfer a one-variable Hensel conclusion back to the multivariate theorem after a
coordinate specialization has been identified.
-/
theorem serreHenselMultivariateConclusion_of_univariateConclusion [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ} {g : Polynomial (SerrePadicInt p)}
    (heval : ∀ t : SerrePadicInt p,
      MvPolynomial.eval (serreHenselUpdateCoord (p := p) x j t) f = g.eval t)
    (hderiv : ∀ t : SerrePadicInt p,
      MvPolynomial.eval (serreHenselUpdateCoord (p := p) x j t)
        (MvPolynomial.pderiv j f) = g.derivative.eval t)
    (h : serreHenselUnivariateConclusion p g (x j) n k) :
    serreHenselMultivariateConclusion p f x j n k := by
  rcases h with ⟨yj, hyroot, hycong, hyv⟩
  refine ⟨serreHenselUpdateCoord (p := p) x j yj, ?_, ?_, ?_⟩
  · rw [heval yj]
    exact hyroot
  · exact serreHenselUpdateCoord_all_congruent (p := p) (n := n - k) x j hycong
  · rw [hderiv yj]
    exact hyv

/--
If the one-variable Hensel theorem is available for every specialization, then the
source-shaped multivariate theorem follows from a coordinate-specialization identity.
-/
theorem serreHenselMultivariateConclusion_of_univariateTheorem [DecidableEq σ]
    {p : ℕ} [Fact p.Prime]
    {f : MvPolynomial σ (SerrePadicInt p)} {x : σ → SerrePadicInt p}
    {j : σ} {n k : ℕ} {g : Polynomial (SerrePadicInt p)}
    (Huniv : ∀ (g₀ : Polynomial (SerrePadicInt p))
        (x₀ : SerrePadicInt p) (n₀ k₀ : ℕ),
      serreHenselUnivariateHypothesis p g₀ x₀ n₀ k₀ →
        serreHenselUnivariateConclusion p g₀ x₀ n₀ k₀)
    (heval₀ : g.eval (x j) = MvPolynomial.eval x f)
    (hderiv₀ : g.derivative.eval (x j) =
        MvPolynomial.eval x (MvPolynomial.pderiv j f))
    (heval : ∀ t : SerrePadicInt p,
      MvPolynomial.eval (serreHenselUpdateCoord (p := p) x j t) f = g.eval t)
    (hderiv : ∀ t : SerrePadicInt p,
      MvPolynomial.eval (serreHenselUpdateCoord (p := p) x j t)
        (MvPolynomial.pderiv j f) = g.derivative.eval t)
    (h : serreHenselMultivariateHypothesis p f x j n k) :
    serreHenselMultivariateConclusion p f x j n k := by
  have huni : serreHenselUnivariateHypothesis p g (x j) n k :=
    serreHenselUnivariateHypothesis_of_multivariateHypothesis
      (p := p) (f := f) (x := x) (j := j) (n := n) (k := k) (g := g)
      heval₀ hderiv₀ h
  exact serreHenselMultivariateConclusion_of_univariateConclusion
    (p := p) (f := f) (x := x) (j := j) (n := n) (k := k) (g := g)
    heval hderiv (Huniv g (x j) n k huni)

end HenselLifting

end

end SerreNumberTheoryAI
