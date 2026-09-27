import SerreNumberTheoryAI.Formalization.Chapter02.HenselLifting

/-!
# Taylor-remainder interface for Hensel lifting

This file isolates the divisibility bookkeeping around the Taylor-remainder step in
Serre, Chapter 2, §2.2.  The hard polynomial identity
`f(x+h) - f(x) - h*f'(x)` being divisible by `h^2` is packaged as a source-shaped
predicate; this file proves the p-power divisibility consequences needed for the
Newton step once that identity is available.
-/

namespace SerreNumberTheoryAI

noncomputable section

section HenselTaylor

/-- The additive Taylor defect `f(x+h) - f(x) - h*f'(x)`. -/
def serreHenselTaylorDefect
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x h : SerrePadicInt p) :
    SerrePadicInt p :=
  f.eval (x + h) - f.eval x - h * f.derivative.eval x

/-- Source-shaped Taylor-remainder property: the Taylor defect has a quadratic factor `h^2`. -/
def serreHenselTaylorQuadraticFactor
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x h : SerrePadicInt p) : Prop :=
  ∃ a : SerrePadicInt p, serreHenselTaylorDefect p f x h = h ^ 2 * a

/-- Reassemble the linear Taylor part and the defect into the shifted evaluation. -/
theorem serreHenselTaylor_linear_add_defect
    (p : ℕ) [Fact p.Prime]
    (f : Polynomial (SerrePadicInt p)) (x h : SerrePadicInt p) :
    f.eval x + h * f.derivative.eval x + serreHenselTaylorDefect p f x h =
      f.eval (x + h) := by
  unfold serreHenselTaylorDefect
  ring

/-- Zero is divisible to every p-power depth. -/
theorem padicDivisibilityDepth_zero
    (p : ℕ) [Fact p.Prime] (n : ℕ) :
    padicDivisibilityDepth p n (0 : SerrePadicInt p) := by
  exact dvd_zero _

/-- A stronger p-power depth implies any weaker p-power depth. -/
theorem padicDivisibilityDepth_mono
    {p : ℕ} [Fact p.Prime] {m n : ℕ} (hmn : m ≤ n)
    {x : SerrePadicInt p} (hx : padicDivisibilityDepth p n x) :
    padicDivisibilityDepth p m x := by
  exact (pow_dvd_pow (p : SerrePadicInt p) hmn).trans hx

/-- Divisibility to a p-power depth is preserved by multiplying on the right. -/
theorem padicDivisibilityDepth_mul_right
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) (y : SerrePadicInt p) :
    padicDivisibilityDepth p n (x * y) := by
  rcases hx with ⟨a, ha⟩
  refine ⟨a * y, ?_⟩
  rw [ha]
  ring

/-- Divisibility to a p-power depth is preserved by multiplying on the left. -/
theorem padicDivisibilityDepth_mul_left
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) (y : SerrePadicInt p) :
    padicDivisibilityDepth p n (y * x) := by
  simpa [mul_comm] using padicDivisibilityDepth_mul_right (p := p) (n := n) hx y

/-- Divisibility to the same p-power depth is closed under addition. -/
theorem padicDivisibilityDepth_add
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x y : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) (hy : padicDivisibilityDepth p n y) :
    padicDivisibilityDepth p n (x + y) := by
  rcases hx with ⟨a, ha⟩
  rcases hy with ⟨b, hb⟩
  refine ⟨a + b, ?_⟩
  rw [ha, hb]
  ring

/-- Divisibility to a p-power depth is preserved by negation. -/
theorem padicDivisibilityDepth_neg
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) :
    padicDivisibilityDepth p n (-x) := by
  rcases hx with ⟨a, ha⟩
  refine ⟨-a, ?_⟩
  rw [ha]
  ring

/-- Divisibility to the same p-power depth is closed under subtraction. -/
theorem padicDivisibilityDepth_sub
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x y : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) (hy : padicDivisibilityDepth p n y) :
    padicDivisibilityDepth p n (x - y) := by
  simpa [sub_eq_add_neg] using
    padicDivisibilityDepth_add (p := p) (n := n) hx
      (padicDivisibilityDepth_neg (p := p) (n := n) hy)

/-- Multiplying terms of depths `m` and `n` gives depth `m+n`. -/
theorem padicDivisibilityDepth_mul_depth
    {p : ℕ} [Fact p.Prime] {m n : ℕ} {x y : SerrePadicInt p}
    (hx : padicDivisibilityDepth p m x) (hy : padicDivisibilityDepth p n y) :
    padicDivisibilityDepth p (m + n) (x * y) := by
  rcases hx with ⟨a, ha⟩
  rcases hy with ⟨b, hb⟩
  refine ⟨a * b, ?_⟩
  rw [ha, hb, pow_add]
  ring

/-- Squaring a term of depth `n` gives depth `n+n`. -/
theorem padicDivisibilityDepth_sq
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) :
    padicDivisibilityDepth p (n + n) (x ^ 2) := by
  simpa [pow_two] using
    padicDivisibilityDepth_mul_depth (p := p) (m := n) (n := n) hx hx

/-- Squaring a term of depth `n` gives depth `2*n`. -/
theorem padicDivisibilityDepth_sq_two_mul
    {p : ℕ} [Fact p.Prime] {n : ℕ} {x : SerrePadicInt p}
    (hx : padicDivisibilityDepth p n x) :
    padicDivisibilityDepth p (2 * n) (x ^ 2) := by
  simpa [two_mul] using padicDivisibilityDepth_sq (p := p) (n := n) hx

/-- The source correction `p^r*z` has depth `r`. -/
theorem serreHenselCorrection_depth
    (p : ℕ) [Fact p.Prime] (r : ℕ) (z : SerrePadicInt p) :
    padicDivisibilityDepth p r ((p : SerrePadicInt p) ^ r * z) := by
  exact ⟨z, rfl⟩

/-- If the Taylor defect is quadratic in a correction of depth `r`, it has depth `r+r`. -/
theorem serreHenselTaylorDefect_dvd_of_quadratic_factor
    {p : ℕ} [Fact p.Prime] {r : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x h : SerrePadicInt p}
    (hquad : serreHenselTaylorQuadraticFactor p f x h)
    (hh : padicDivisibilityDepth p r h) :
    padicDivisibilityDepth p (r + r) (serreHenselTaylorDefect p f x h) := by
  rcases hquad with ⟨a, hdef⟩
  rw [hdef]
  exact padicDivisibilityDepth_mul_right
    (p := p) (n := r + r) (x := h ^ 2)
    (padicDivisibilityDepth_sq (p := p) (n := r) hh) a

/-- A Taylor defect for a source correction `p^r*z` is divisible to depth `r+r`. -/
theorem serreHenselTaylorDefect_dvd_of_source_correction
    {p : ℕ} [Fact p.Prime] {r : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x z : SerrePadicInt p}
    (hquad :
      serreHenselTaylorQuadraticFactor p f x
        ((p : SerrePadicInt p) ^ r * z)) :
    padicDivisibilityDepth p (r + r)
      (serreHenselTaylorDefect p f x ((p : SerrePadicInt p) ^ r * z)) := by
  exact serreHenselTaylorDefect_dvd_of_quadratic_factor
    (p := p) (r := r) hquad (serreHenselCorrection_depth p r z)

/-- The same source-correction estimate specialized to the Hensel exponent `n-k`. -/
theorem serreHenselTaylorDefect_dvd_of_hensel_correction
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x z : SerrePadicInt p}
    (hquad :
      serreHenselTaylorQuadraticFactor p f x
        ((p : SerrePadicInt p) ^ (n - k) * z)) :
    padicDivisibilityDepth p ((n - k) + (n - k))
      (serreHenselTaylorDefect p f x
        ((p : SerrePadicInt p) ^ (n - k) * z)) := by
  exact serreHenselTaylorDefect_dvd_of_source_correction
    (p := p) (r := n - k) hquad

/-- Serre's inequality implies that the quadratic Taylor defect reaches depth `n+1`. -/
theorem serreHenselTaylorDefect_dvd_target_of_hensel_correction
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x z : SerrePadicInt p}
    (hineq : 2 * k < n)
    (hquad :
      serreHenselTaylorQuadraticFactor p f x
        ((p : SerrePadicInt p) ^ (n - k) * z)) :
    padicDivisibilityDepth p (n + 1)
      (serreHenselTaylorDefect p f x
        ((p : SerrePadicInt p) ^ (n - k) * z)) := by
  have hdepth :=
    serreHenselTaylorDefect_dvd_of_hensel_correction
      (p := p) (n := n) (k := k) (f := f) (x := x) (z := z) hquad
  have hle : n + 1 ≤ (n - k) + (n - k) := by
    omega
  exact padicDivisibilityDepth_mono (p := p) (m := n + 1)
    (n := (n - k) + (n - k)) hle hdepth

/--
If the linear Taylor part is already cancelled modulo `p^(n+1)` and the quadratic
Taylor defect is available, then the shifted value is also zero modulo `p^(n+1)`.
-/
theorem serreHensel_eval_add_correction_dvd_of_linear_cancel
    {p : ℕ} [Fact p.Prime] {n k : ℕ}
    {f : Polynomial (SerrePadicInt p)} {x z : SerrePadicInt p}
    (hineq : 2 * k < n)
    (hquad :
      serreHenselTaylorQuadraticFactor p f x
        ((p : SerrePadicInt p) ^ (n - k) * z))
    (hlinear :
      padicDivisibilityDepth p (n + 1)
        (f.eval x + ((p : SerrePadicInt p) ^ (n - k) * z) * f.derivative.eval x)) :
    padicDivisibilityDepth p (n + 1)
      (f.eval (x + (p : SerrePadicInt p) ^ (n - k) * z)) := by
  let h : SerrePadicInt p := (p : SerrePadicInt p) ^ (n - k) * z
  have hlinear' :
      padicDivisibilityDepth p (n + 1) (f.eval x + h * f.derivative.eval x) := by
    simpa [h] using hlinear
  have hdef : padicDivisibilityDepth p (n + 1) (serreHenselTaylorDefect p f x h) := by
    simpa [h] using
      (serreHenselTaylorDefect_dvd_target_of_hensel_correction
        (p := p) (n := n) (k := k) (f := f) (x := x) (z := z) hineq hquad)
  have hsum :
      padicDivisibilityDepth p (n + 1)
        (f.eval x + h * f.derivative.eval x + serreHenselTaylorDefect p f x h) :=
    padicDivisibilityDepth_add (p := p) (n := n + 1) hlinear' hdef
  change padicDivisibilityDepth p (n + 1) (f.eval (x + h))
  rw [← serreHenselTaylor_linear_add_defect (p := p) f x h]
  exact hsum

end HenselTaylor

end

end SerreNumberTheoryAI
