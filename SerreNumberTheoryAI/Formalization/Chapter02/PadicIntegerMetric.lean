import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerValuationAPI

/-!
# Metric groundwork for the project p-adic integers

Independent formalization of the metric layer of Serre, Chapter 2, §1.2, Proposition 3.
The distance is built from the project-local additive valuation developed in the preceding
algebraic slice.  No theorem about mathlib's completed `PadicInt` metric is used.
-/

namespace SerreNumberTheoryAI

section PadicIntegerMetric

variable (p : ℕ) [Fact p.Prime]

/-- The real weight attached to an extended-natural additive valuation. -/
noncomputable def serrePadicRadius : ℕ∞ → ℝ :=
  ENat.recTopCoe 0 (fun n => Real.exp (-(n : ℝ)))

@[simp]
theorem serrePadicRadius_top : serrePadicRadius (⊤ : ℕ∞) = 0 := rfl

@[simp]
theorem serrePadicRadius_natCast (n : ℕ) :
    serrePadicRadius (n : ℕ∞) = Real.exp (-(n : ℝ)) := rfl

/-- The valuation weight is always nonnegative. -/
theorem serrePadicRadius_nonneg (a : ℕ∞) : 0 ≤ serrePadicRadius a := by
  cases a using ENat.recTopCoe with
  | top => simp
  | coe n => simp [Real.exp_pos]

/-- The valuation weight is zero exactly at the infinite valuation. -/
theorem serrePadicRadius_eq_zero_iff (a : ℕ∞) :
    serrePadicRadius a = 0 ↔ a = ⊤ := by
  constructor
  · intro h
    by_contra ha
    obtain ⟨n, hn⟩ := ENat.ne_top_iff_exists.mp ha
    rw [← hn] at h
    simpa using h
  · rintro rfl
    rfl

/-- Larger additive valuation means smaller real radius. -/
theorem serrePadicRadius_antitone : Antitone serrePadicRadius := by
  intro a b hab
  cases b using ENat.recTopCoe with
  | top =>
      simpa using serrePadicRadius_nonneg a
  | coe n =>
      have ha : a ≠ ⊤ := by
        intro htop
        subst a
        simpa using hab
      obtain ⟨m, hm⟩ := ENat.ne_top_iff_exists.mp ha
      rw [← hm] at hab ⊢
      have hmn : m ≤ n := by
        exact_mod_cast hab
      apply Real.exp_le_exp.mpr
      exact neg_le_neg (by exact_mod_cast hmn)

/-- Comparing a radius with the radius of a natural exponent recovers valuation depth. -/
theorem serrePadicRadius_le_natCast_iff (a : ℕ∞) (n : ℕ) :
    serrePadicRadius a ≤ Real.exp (-(n : ℝ)) ↔ (n : ℕ∞) ≤ a := by
  cases a using ENat.recTopCoe with
  | top =>
      simp [Real.exp_pos.le]
  | coe m =>
      rw [serrePadicRadius_natCast, Real.exp_le_exp]
      constructor
      · intro h
        exact_mod_cast (neg_le_neg_iff.mp h)
      · intro h
        exact neg_le_neg (by exact_mod_cast h)

/-- The project additive valuation is infinite exactly at zero. -/
theorem serrePadicIntAddValuation_eq_top_iff (x : SerrePadicInt p) :
    serrePadicIntAddValuation p x = ⊤ ↔ x = 0 := by
  constructor
  · intro htop
    by_contra hx
    have hfinite := serrePadicIntAddValuation_eq_order p hx
    rw [hfinite] at htop
    simpa using htop
  · rintro rfl
    exact serrePadicIntAddValuation_zero p

/-- The source real-valued distance `exp(-v_p(x-y))`, with value zero at infinite valuation. -/
noncomputable def serrePadicIntDist (x y : SerrePadicInt p) : ℝ :=
  serrePadicRadius (serrePadicIntAddValuation p (x - y))

@[simp]
theorem serrePadicIntDist_self (x : SerrePadicInt p) :
    serrePadicIntDist p x x = 0 := by
  simp [serrePadicIntDist]

/-- The source distance is symmetric. -/
theorem serrePadicIntDist_comm (x y : SerrePadicInt p) :
    serrePadicIntDist p x y = serrePadicIntDist p y x := by
  unfold serrePadicIntDist
  have hsub : x - y = -(y - x) := by abel
  rw [hsub]
  simp

/-- The source distance separates points. -/
theorem serrePadicIntDist_eq_zero_iff (x y : SerrePadicInt p) :
    serrePadicIntDist p x y = 0 ↔ x = y := by
  rw [serrePadicIntDist, serrePadicRadius_eq_zero_iff,
    serrePadicIntAddValuation_eq_top_iff, sub_eq_zero]

/-- The source distance is nonnegative. -/
theorem serrePadicIntDist_nonneg (x y : SerrePadicInt p) :
    0 ≤ serrePadicIntDist p x y :=
  serrePadicRadius_nonneg _

/-- The stronger nonarchimedean estimate implies the ordinary triangle inequality. -/
theorem serrePadicIntDist_triangle (x y z : SerrePadicInt p) :
    serrePadicIntDist p x z ≤
      serrePadicIntDist p x y + serrePadicIntDist p y z := by
  let vx := serrePadicIntAddValuation p (x - y)
  let vy := serrePadicIntAddValuation p (y - z)
  let vz := serrePadicIntAddValuation p (x - z)
  have hv : min vx vy ≤ vz := by
    have hadd := serrePadicIntAddValuation_add p (x - y) (y - z)
    have hsum : (x - y) + (y - z) = x - z := by abel
    simpa [vx, vy, vz, hsum] using hadd
  have hanti : serrePadicRadius vz ≤ serrePadicRadius (min vx vy) :=
    serrePadicRadius_antitone hv
  unfold serrePadicIntDist
  change serrePadicRadius vz ≤ serrePadicRadius vx + serrePadicRadius vy
  rcases le_total vx vy with hxy | hyx
  · rw [min_eq_left hxy] at hanti
    exact hanti.trans (le_add_of_nonneg_right (serrePadicRadius_nonneg vy))
  · rw [min_eq_right hyx] at hanti
    exact hanti.trans (le_add_of_nonneg_left (serrePadicRadius_nonneg vx))

/-- A geometric distance bound is exactly divisibility by the corresponding power of `p`. -/
theorem serrePadicIntDist_le_radius_iff_pow_dvd
    (x y : SerrePadicInt p) (n : ℕ) :
    serrePadicIntDist p x y ≤ Real.exp (-(n : ℝ)) ↔
      (p : SerrePadicInt p) ^ n ∣ (x - y) := by
  rw [serrePadicIntDist, serrePadicRadius_le_natCast_iff]
  exact (serrePadicInt_pow_dvd_iff_le_addValuation p n (x - y)).symm

/-- At residue level `n`, equality of coordinates is the closed-ball condition of radius `exp(-(n+1))`. -/
theorem serrePadicIntDist_le_radius_succ_iff_proj_eq
    (x y : SerrePadicInt p) (n : ℕ) :
    serrePadicIntDist p x y ≤ Real.exp (-((n + 1 : ℕ) : ℝ)) ↔
      serrePadicIntProj p n x = serrePadicIntProj p n y := by
  rw [serrePadicIntDist_le_radius_iff_pow_dvd]
  rw [pow_dvd_serrePadicInt_iff_proj_zero]
  simp [map_sub, sub_eq_zero]

end PadicIntegerMetric

end SerreNumberTheoryAI
