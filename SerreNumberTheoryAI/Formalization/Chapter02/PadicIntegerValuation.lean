import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerProperties

/-!
# p-power factorization for the project p-adic integers

This file continues the project-local treatment of Chapter 2, §1.2.  It extracts the
least residue level detecting a nonzero compatible sequence, uses the principal-kernel
description from `PadicIntegerProperties.lean` to factor off a power of `p`, and derives
that the project p-adic integers have no zero divisors.
-/

namespace SerreNumberTheoryAI

section PadicIntegerValuation

variable (p : ℕ) [Fact p.Prime]

/-- Every nonzero compatible sequence is detected by at least one residue projection. -/
theorem exists_serrePadicIntProj_ne_zero {x : SerrePadicInt p} (hx : x ≠ 0) :
    ∃ n : ℕ, serrePadicIntProj p n x ≠ 0 := by
  by_contra h
  push_neg at h
  apply hx
  apply serrePadicInt_ext p
  intro n
  simpa using h n

/-- The least residue level at which a nonzero project p-adic integer is nonzero. -/
noncomputable def serrePadicIntOrder (x : SerrePadicInt p) (hx : x ≠ 0) : ℕ :=
  Nat.find (exists_serrePadicIntProj_ne_zero p hx)

/-- The defining residue of `serrePadicIntOrder` is nonzero. -/
theorem serrePadicIntOrder_spec {x : SerrePadicInt p} (hx : x ≠ 0) :
    serrePadicIntProj p (serrePadicIntOrder p x hx) x ≠ 0 := by
  exact Nat.find_spec (exists_serrePadicIntProj_ne_zero p hx)

/-- Every residue below the first detecting level vanishes. -/
theorem serrePadicIntProj_eq_zero_of_lt_order {x : SerrePadicInt p} (hx : x ≠ 0)
    {m : ℕ} (hm : m < serrePadicIntOrder p x hx) :
    serrePadicIntProj p m x = 0 := by
  by_contra hne
  exact (Nat.find_min (exists_serrePadicIntProj_ne_zero p hx) hm) hne

/-- The power indexed by the first nonzero residue divides the element. -/
theorem serrePadicInt_pow_order_dvd {x : SerrePadicInt p} (hx : x ≠ 0) :
    (p : SerrePadicInt p) ^ (serrePadicIntOrder p x hx) ∣ x := by
  cases horder : serrePadicIntOrder p x hx with
  | zero =>
      simp [horder]
  | succ n =>
      have hnlt : n < serrePadicIntOrder p x hx := by omega
      have hzero : serrePadicIntProj p n x = 0 :=
        serrePadicIntProj_eq_zero_of_lt_order p hx hnlt
      have hdiv : (p : SerrePadicInt p) ^ (n + 1) ∣ x :=
        (pow_dvd_serrePadicInt_iff_proj_zero p n x).2 hzero
      simpa [horder] using hdiv

/-- One more power of `p` than the order does not divide a nonzero element. -/
theorem serrePadicInt_pow_succ_order_not_dvd {x : SerrePadicInt p} (hx : x ≠ 0) :
    ¬ (p : SerrePadicInt p) ^ (serrePadicIntOrder p x hx + 1) ∣ x := by
  intro hdiv
  have hzero : serrePadicIntProj p (serrePadicIntOrder p x hx) x = 0 :=
    (pow_dvd_serrePadicInt_iff_proj_zero p (serrePadicIntOrder p x hx) x).1 hdiv
  exact (serrePadicIntOrder_spec p hx) hzero

/--
Every nonzero project p-adic integer is a power of `p` times a unit.  The exponent is
chosen by the first nonzero residue projection, so this construction does not use the
ready-made `PadicInt` valuation theory.
-/
theorem exists_pow_mul_isUnit_of_ne_zero {x : SerrePadicInt p} (hx : x ≠ 0) :
    ∃ n : ℕ, ∃ u : SerrePadicInt p,
      IsUnit u ∧ x = (p : SerrePadicInt p) ^ n * u := by
  let n := serrePadicIntOrder p x hx
  have hdiv : (p : SerrePadicInt p) ^ n ∣ x := by
    simpa [n] using serrePadicInt_pow_order_dvd p hx
  obtain ⟨u, hu⟩ := hdiv
  have hunot : ¬ (p : SerrePadicInt p) ∣ u := by
    intro hpdiv
    obtain ⟨v, hv⟩ := hpdiv
    apply serrePadicInt_pow_succ_order_not_dvd p hx
    refine ⟨v, ?_⟩
    calc
      x = (p : SerrePadicInt p) ^ n * u := hu
      _ = (p : SerrePadicInt p) ^ n * ((p : SerrePadicInt p) * v) := by rw [hv]
      _ = (p : SerrePadicInt p) ^ (n + 1) * v := by
        rw [pow_succ]
        ac_rfl
  refine ⟨n, u, (serrePadicInt_isUnit_iff_not_p_dvd p u).2 hunot, hu⟩

/-- No positive power of the prime element vanishes in the project inverse limit. -/
theorem serrePadicInt_p_pow_ne_zero (n : ℕ) :
    (p : SerrePadicInt p) ^ n ≠ 0 := by
  intro hzero
  have hproj :
      serrePadicIntProj p n ((p : SerrePadicInt p) ^ n) = 0 := by
    rw [hzero, map_zero]
  have hcast :
      ((p ^ n : ℕ) : padicResidueRing p n) = 0 := by
    simpa using hproj
  have hdvd : p ^ (n + 1) ∣ p ^ n := by
    exact (ZMod.natCast_eq_zero_iff (p ^ n) (p ^ (n + 1))).1 <|
      by simpa [padicResidueRing] using hcast
  have hle : n + 1 ≤ n :=
    (Nat.pow_dvd_pow_iff_le_right (Fact.out : p.Prime).one_lt).1 hdvd
  omega

/-- The project p-adic integers are nontrivial for prime `p`. -/
instance serrePadicInt_nontrivial : Nontrivial (SerrePadicInt p) := by
  refine ⟨⟨0, 1, ?_⟩⟩
  intro h
  have h01 : (0 : padicResidueRing p 0) = 1 := by
    simpa using congrArg (fun z : SerrePadicInt p => serrePadicIntProj p 0 z) h
  exact zero_ne_one h01

/-- The source factorization immediately rules out zero divisors. -/
instance serrePadicInt_noZeroDivisors : NoZeroDivisors (SerrePadicInt p) where
  eq_zero_or_eq_zero_of_mul_eq_zero {x y} hxy := by
    by_cases hx : x = 0
    · exact Or.inl hx
    by_cases hy : y = 0
    · exact Or.inr hy
    exfalso
    obtain ⟨nx, ux, hux, hxrepr⟩ := exists_pow_mul_isUnit_of_ne_zero p hx
    obtain ⟨ny, uy, huy, hyrepr⟩ := exists_pow_mul_isUnit_of_ne_zero p hy
    have hprod :
        (p : SerrePadicInt p) ^ (nx + ny) * (ux * uy) = 0 := by
      calc
        (p : SerrePadicInt p) ^ (nx + ny) * (ux * uy) =
            ((p : SerrePadicInt p) ^ nx * ux) *
              ((p : SerrePadicInt p) ^ ny * uy) := by
                rw [pow_add]
                ac_rfl
        _ = x * y := by rw [← hxrepr, ← hyrepr]
        _ = 0 := hxy
    have hunit : IsUnit (ux * uy) := hux.mul huy
    let w : (SerrePadicInt p)ˣ := hunit.unit
    have hw : (w : SerrePadicInt p) = ux * uy := IsUnit.unit_spec hunit
    have hprod' :
        (p : SerrePadicInt p) ^ (nx + ny) * (w : SerrePadicInt p) = 0 := by
      simpa [hw] using hprod
    have hcancel := congrArg
      (fun z : SerrePadicInt p => z * (↑(w⁻¹) : SerrePadicInt p)) hprod'
    have hpzero : (p : SerrePadicInt p) ^ (nx + ny) = 0 := by
      simpa [mul_assoc] using hcancel
    exact (serrePadicInt_p_pow_ne_zero p (nx + ny)) hpzero

/-- Consequently the project-local ring `ℤ_p` is an integral domain. -/
instance serrePadicInt_isDomain : IsDomain (SerrePadicInt p) :=
  NoZeroDivisors.to_isDomain _

end PadicIntegerValuation

end SerreNumberTheoryAI
