import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegers

/-!
# Algebraic properties of the project p-adic integers

Independent formalization of the algebraic part of Serre, Chapter 2, §1.2.

Source metadata only: Japanese edition, printed pp. 16–17, uploaded PDF pp. 26–27.
This file continues the project-local inverse-limit construction from `PadicIntegers.lean`.
The initial lemmas expose only general quotient/unit infrastructure needed by the source argument.
It does not use mathlib's completed `PadicInt` theory as a replacement for the source proofs.
-/

namespace SerreNumberTheoryAI

section PadicIntegerProperties

/-- The first-isomorphism-theorem quotient attached to the `n`-th residue projection. -/
noncomputable def serrePadicIntQuotientKerEquiv
    (p n : ℕ) :
    (RingHom.ker (serrePadicIntProj p n)).Quotient ≃+* padicResidueRing p n :=
  RingHom.quotientKerEquivOfSurjective
    (serrePadicIntProj p n) (serrePadicIntProj_surjective p n)

/-- A higher residue coordinate reduces to every lower coordinate of the same compatible sequence. -/
theorem serrePadicIntProj_cast_of_le
    (p : ℕ) (x : SerrePadicInt p) {m n : ℕ} (hmn : m ≤ n) :
    ZMod.castHom
        (pow_dvd_pow p (Nat.add_le_add_right hmn 1))
        (padicResidueRing p m)
        (serrePadicIntProj p n x) =
      serrePadicIntProj p m x := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hmn
  induction k with
  | zero =>
      simp
  | succ k ih =>
      have h₁ : p ^ (m + 1) ∣ p ^ (m + k + 1) := by
        exact pow_dvd_pow p (by omega)
      have h₂ : p ^ (m + k + 1) ∣ p ^ (m + (k + 1) + 1) := by
        exact pow_dvd_pow p (by omega)
      have hcomp :
          (ZMod.castHom h₁ (padicResidueRing p m)).comp
              (padicReduction p (m + k)) =
            ZMod.castHom (dvd_trans h₁ h₂) (padicResidueRing p m) := by
        simpa [padicReduction, padicResidueRing, Nat.add_assoc] using
          (ZMod.castHom_comp h₁ h₂)
      calc
        _ = ZMod.castHom h₁ (padicResidueRing p m)
              (padicReduction p (m + k)
                (serrePadicIntProj p (m + (k + 1)) x)) := by
              have happ := congrArg
                (fun f : padicResidueRing p (m + (k + 1)) →+* padicResidueRing p m =>
                  f (serrePadicIntProj p (m + (k + 1)) x))
                hcomp
              simpa [RingHom.comp_apply] using happ.symm
        _ = ZMod.castHom h₁ (padicResidueRing p m)
              (serrePadicIntProj p (m + k) x) := by
              rw [show m + (k + 1) = (m + k) + 1 by omega,
                serrePadicIntProj_compat]
        _ = serrePadicIntProj p m x := ih

/-- A multiple of `p^(n+1)` vanishes in the `n`-th residue projection. -/
theorem serrePadicIntProj_eq_zero_of_pow_dvd
    (p n : ℕ) [Fact p.Prime] {x : SerrePadicInt p}
    (hx : (p : SerrePadicInt p) ^ (n + 1) ∣ x) :
    serrePadicIntProj p n x = 0 := by
  obtain ⟨y, rfl⟩ := hx
  rw [map_mul, map_pow, map_natCast]
  have hpzero :
      (p : padicResidueRing p n) ^ (n + 1) = 0 := by
    rw [← Nat.cast_pow, ZMod.natCast_self]
  rw [hpzero, zero_mul]

/-- If the first residue vanishes, every higher standard representative is divisible by `p`. -/
theorem p_dvd_serrePadicIntProj_val_of_proj_zero
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : serrePadicIntProj p 0 x = 0) (n : ℕ) :
    p ∣ (serrePadicIntProj p n x).val := by
  have hred :=
    serrePadicIntProj_cast_of_le p x (m := 0) (n := n) (Nat.zero_le n)
  have hred0 :
      ZMod.castHom
          (pow_dvd_pow p (Nat.add_le_add_right (Nat.zero_le n) 1))
          (padicResidueRing p 0)
          (serrePadicIntProj p n x) = 0 :=
    hred.trans hzero
  have hcast :
      ((serrePadicIntProj p n x).val : padicResidueRing p 0) = 0 := by
    exact
      (ZMod.natCast_val (R := padicResidueRing p 0) (serrePadicIntProj p n x)).trans <|
        by simpa only [ZMod.castHom_apply] using hred0
  have hdvd : p ^ (0 + 1) ∣ (serrePadicIntProj p n x).val :=
    (ZMod.natCast_eq_zero_iff _ _).1 hcast
  simpa using hdvd

/-- The coordinate used to divide a compatible sequence by one factor of `p`. -/
def serrePadicIntDivPCoord
    (p : ℕ) (x : SerrePadicInt p) (n : ℕ) : padicResidueRing p n :=
  ((serrePadicIntProj p (n + 1) x).val / p : ℕ)

/-- Multiplying the shifted quotient coordinate by `p` recovers the original lower coordinate. -/
theorem p_mul_serrePadicIntDivPCoord
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : serrePadicIntProj p 0 x = 0) (n : ℕ) :
    (p : padicResidueRing p n) * serrePadicIntDivPCoord p x n =
      serrePadicIntProj p n x := by
  have hdvd : p ∣ (serrePadicIntProj p (n + 1) x).val :=
    p_dvd_serrePadicIntProj_val_of_proj_zero p x hzero (n + 1)
  obtain ⟨q, hq⟩ := hdvd
  have hred :=
    serrePadicIntProj_cast_of_le p x (m := n) (n := n + 1) (Nat.le_succ n)
  calc
    (p : padicResidueRing p n) * serrePadicIntDivPCoord p x n =
        ((serrePadicIntProj p (n + 1) x).val : padicResidueRing p n) := by
          simp [serrePadicIntDivPCoord, hq,
            Nat.mul_div_left _ (Fact.out : p.Prime).pos]
    _ = ZMod.castHom
          (pow_dvd_pow p (Nat.add_le_add_right (Nat.le_succ n) 1))
          (padicResidueRing p n)
          (serrePadicIntProj p (n + 1) x) := by
          exact
            ZMod.natCast_val (R := padicResidueRing p n)
              (serrePadicIntProj p (n + 1) x)
    _ = serrePadicIntProj p n x := hred

/-- The shifted quotient coordinates are compatible whenever the first residue vanishes. -/
theorem serrePadicIntDivPCoord_compatible
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : serrePadicIntProj p 0 x = 0) :
    padicCompatible p (serrePadicIntDivPCoord p x) := by
  intro n
  let a := serrePadicIntProj p (n + 2) x
  let b := serrePadicIntProj p (n + 1) x
  have ha : p ∣ a.val := by
    simpa [a] using
      p_dvd_serrePadicIntProj_val_of_proj_zero p x hzero (n + 2)
  have hb : p ∣ b.val := by
    simpa [b] using
      p_dvd_serrePadicIntProj_val_of_proj_zero p x hzero (n + 1)
  have hcompat : padicReduction p (n + 1) a = b := by
    simpa [a, b] using serrePadicIntProj_compat p (n + 1) x
  have hcast : (a.val : padicResidueRing p (n + 1)) = b := by
    calc
      (a.val : padicResidueRing p (n + 1)) =
          ZMod.castHom
            (pow_dvd_pow p (by omega : n + 2 ≤ n + 3))
            (padicResidueRing p (n + 1)) a := by
              exact ZMod.natCast_val (R := padicResidueRing p (n + 1)) a
      _ = b := by
        simpa [padicReduction, padicResidueRing] using hcompat
  have heq :
      (a.val : padicResidueRing p (n + 1)) =
        (b.val : padicResidueRing p (n + 1)) :=
    hcast.trans (ZMod.natCast_zmod_val b).symm
  have hmod : a.val ≡ b.val [MOD p ^ (n + 2)] := by
    exact (ZMod.natCast_eq_natCast_iff _ _ _).1 heq
  obtain ⟨A, hA⟩ := ha
  obtain ⟨B, hB⟩ := hb
  have hmod' : A ≡ B [MOD p ^ (n + 1)] := by
    apply (Nat.ModEq.mul_left_cancel_iff' (Fact.out : p.Prime).ne_zero).1
    simpa [hA, hB, pow_succ'] using hmod
  simp only [serrePadicIntDivPCoord, a, b]
  rw [hA, hB,
    Nat.mul_div_left _ (Fact.out : p.Prime).pos,
    Nat.mul_div_left _ (Fact.out : p.Prime).pos]
  simpa [padicReduction, padicResidueRing] using
    (ZMod.natCast_eq_natCast_iff A B (p ^ (n + 1))).2 hmod'

/-- Divide a project p-adic integer by `p` when its first residue vanishes. -/
def serrePadicIntDivP
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : serrePadicIntProj p 0 x = 0) : SerrePadicInt p :=
  ⟨serrePadicIntDivPCoord p x, serrePadicIntDivPCoord_compatible p x hzero⟩

/-- The one-step quotient reconstructs the original p-adic integer after multiplication by `p`. -/
theorem p_mul_serrePadicIntDivP
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : serrePadicIntProj p 0 x = 0) :
    (p : SerrePadicInt p) * serrePadicIntDivP p x hzero = x := by
  apply serrePadicInt_ext p
  intro n
  change (p : padicResidueRing p n) * serrePadicIntDivPCoord p x n =
    serrePadicIntProj p n x
  exact p_mul_serrePadicIntDivPCoord p x hzero n

/-- Divisibility by `p` is detected by the first residue projection. -/
theorem p_dvd_serrePadicInt_iff_proj_zero
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p) :
    (p : SerrePadicInt p) ∣ x ↔ serrePadicIntProj p 0 x = 0 := by
  constructor
  · intro hx
    apply serrePadicIntProj_eq_zero_of_pow_dvd p 0
    simpa using hx
  · intro hzero
    refine ⟨serrePadicIntDivP p x hzero, ?_⟩
    exact (p_mul_serrePadicIntDivP p x hzero).symm

/-- The `n`-th projection vanishes exactly on multiples of `p^(n+1)`. -/
theorem pow_dvd_serrePadicInt_iff_proj_zero
    (p n : ℕ) [Fact p.Prime] (x : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 1) ∣ x ↔ serrePadicIntProj p n x = 0 := by
  constructor
  · exact serrePadicIntProj_eq_zero_of_pow_dvd p n
  · induction n generalizing x with
    | zero =>
        intro hzero
        simpa using (p_dvd_serrePadicInt_iff_proj_zero p x).2 hzero
    | succ n ih =>
        intro hproj
        have hred :=
          serrePadicIntProj_cast_of_le p x
            (m := 0) (n := n + 1) (Nat.zero_le (n + 1))
        have hzero : serrePadicIntProj p 0 x = 0 := by
          rw [← hred, hproj]
          simp
        let y := serrePadicIntDivP p x hzero
        have hyproj : serrePadicIntProj p n y = 0 := by
          change serrePadicIntDivPCoord p x n = 0
          simp [serrePadicIntDivPCoord, hproj]
        have hydiv : (p : SerrePadicInt p) ^ (n + 1) ∣ y :=
          (ih y).2 hyproj
        obtain ⟨z, hz⟩ := hydiv
        refine ⟨z, ?_⟩
        calc
          x = (p : SerrePadicInt p) * y :=
            (p_mul_serrePadicIntDivP p x hzero).symm
          _ = (p : SerrePadicInt p) *
              ((p : SerrePadicInt p) ^ (n + 1) * z) := by rw [hz]
          _ = (p : SerrePadicInt p) ^ (Nat.succ n + 1) * z := by
            rw [show Nat.succ n + 1 = (n + 1) + 1 by omega, pow_succ']
            simp [mul_assoc]

/-- The kernel of the `n`-th projection is the principal ideal generated by `p^(n+1)`. -/
theorem ker_serrePadicIntProj_eq_span_pow
    (p n : ℕ) [Fact p.Prime] :
    RingHom.ker (serrePadicIntProj p n) =
      Ideal.span {((p : SerrePadicInt p) ^ (n + 1))} := by
  ext x
  rw [RingHom.mem_ker, Ideal.mem_span_singleton]
  exact (pow_dvd_serrePadicInt_iff_proj_zero p n x).symm

/-- The source quotient by `p^(n+1)` is the corresponding residue ring. -/
noncomputable def serrePadicIntQuotientPowEquiv
    (p n : ℕ) [Fact p.Prime] :
    (Ideal.span {((p : SerrePadicInt p) ^ (n + 1))}).Quotient ≃+*
      padicResidueRing p n :=
  (Ideal.quotEquivOfEq (ker_serrePadicIntProj_eq_span_pow p n).symm).trans
    (serrePadicIntQuotientKerEquiv p n)

/--
At every positive residue level, a class is a unit exactly when its standard representative
is not divisible by `p`.
-/
theorem padicResidueRing_isUnit_iff_not_dvd_val
    (p n : ℕ) [Fact p.Prime] (x : padicResidueRing p n) :
    IsUnit x ↔ ¬ p ∣ x.val := by
  rw [← ZMod.natCast_zmod_val x]
  simpa [padicResidueRing] using
    (ZMod.isUnit_natCast_iff_not_dvd_pow
      (p := p) (d := n + 1) (a := x.val)
      (Fact.out : p.Prime) (Nat.succ_pos n))

/-- A unit at one residue level remains a unit when lifted one step in a compatible tower. -/
theorem isUnit_of_padicReduction_isUnit
    (p n : ℕ) [Fact p.Prime] (x : padicResidueRing p (n + 1))
    (hx : IsUnit (padicReduction p n x)) : IsUnit x := by
  obtain ⟨a, rfl⟩ := ZMod.natCast_zmod_surjective (n := p ^ ((n + 1) + 1))
  have hred :
      padicReduction p n
          (a : padicResidueRing p (n + 1)) =
        (a : padicResidueRing p n) := by
    simp [padicReduction, padicResidueRing]
  rw [hred] at hx
  have hpa : ¬ p ∣ a :=
    (ZMod.isUnit_natCast_iff_not_dvd_pow
      (p := p) (d := n + 1) (a := a)
      (Fact.out : p.Prime) (Nat.succ_pos n)).1 hx
  exact
    (ZMod.isUnit_natCast_iff_not_dvd_pow
      (p := p) (d := (n + 1) + 1) (a := a)
      (Fact.out : p.Prime) (Nat.succ_pos (n + 1))).2 hpa

/-- If a project p-adic integer is a unit, its first residue is nonzero. -/
theorem serrePadicIntProj_zero_ne_zero_of_isUnit
    (p : ℕ) [Fact p.Prime] {x : SerrePadicInt p} (hx : IsUnit x) :
    serrePadicIntProj p 0 x ≠ 0 := by
  have hunit : IsUnit (serrePadicIntProj p 0 x) := hx.map (serrePadicIntProj p 0)
  exact hunit.ne_zero

/-- If one residue coordinate of a compatible sequence is a unit, every higher coordinate is a unit. -/
theorem serrePadicIntProj_isUnit_of_zero_isUnit
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : IsUnit (serrePadicIntProj p 0 x)) :
    ∀ n : ℕ, IsUnit (serrePadicIntProj p n x) := by
  intro n
  induction n with
  | zero => exact hzero
  | succ n ih =>
      apply isUnit_of_padicReduction_isUnit p n
      simpa only [serrePadicIntProj_compat] using ih

/-- If the first residue is a unit, the compatible sequence itself is a unit. -/
theorem serrePadicInt_isUnit_of_proj_zero_isUnit
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p)
    (hzero : IsUnit (serrePadicIntProj p 0 x)) : IsUnit x := by
  have hcoord : ∀ n : ℕ, IsUnit (serrePadicIntProj p n x) :=
    serrePadicIntProj_isUnit_of_zero_isUnit p x hzero
  let u : ∀ n : ℕ, (padicResidueRing p n)ˣ := fun n => (hcoord n).unit
  let y : ∀ n : ℕ, padicResidueRing p n := fun n => ↑((u n)⁻¹)
  have hy : padicCompatible p y := by
    intro n
    have hu : Units.map (padicReduction p n) (u (n + 1)) = u n := by
      apply Units.ext
      rw [Units.coe_map]
      change padicReduction p n (↑(u (n + 1))) = ↑(u n)
      simp only [u, IsUnit.unit_spec]
      exact serrePadicIntProj_compat p n x
    change padicReduction p n (↑((u (n + 1))⁻¹)) = ↑((u n)⁻¹)
    rw [← Units.coe_map, map_inv, hu]
  rw [isUnit_iff_exists_inv]
  refine ⟨⟨y, hy⟩, ?_⟩
  apply serrePadicInt_ext p
  intro n
  change serrePadicIntProj p n x * ↑((u n)⁻¹) = 1
  rw [← IsUnit.unit_spec (hcoord n)]
  simp

/-- A project p-adic integer is a unit exactly when its first residue is nonzero. -/
theorem serrePadicInt_isUnit_iff_proj_zero_ne_zero
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p) :
    IsUnit x ↔ serrePadicIntProj p 0 x ≠ 0 := by
  constructor
  · exact serrePadicIntProj_zero_ne_zero_of_isUnit p
  · intro hx
    apply serrePadicInt_isUnit_of_proj_zero_isUnit p x
    apply (padicResidueRing_isUnit_iff_not_dvd_val p 0 _).2
    intro hdiv
    have hlt : (serrePadicIntProj p 0 x).val < p := by
      simpa [padicResidueRing] using ZMod.val_lt (serrePadicIntProj p 0 x)
    have hval : (serrePadicIntProj p 0 x).val = 0 :=
      Nat.eq_zero_of_dvd_of_lt hdiv hlt
    apply hx
    rw [← ZMod.natCast_zmod_val (serrePadicIntProj p 0 x), hval, Nat.cast_zero]

/-- A project p-adic integer is a unit exactly when it is not divisible by `p`. -/
theorem serrePadicInt_isUnit_iff_not_p_dvd
    (p : ℕ) [Fact p.Prime] (x : SerrePadicInt p) :
    IsUnit x ↔ ¬ (p : SerrePadicInt p) ∣ x := by
  rw [serrePadicInt_isUnit_iff_proj_zero_ne_zero]
  constructor
  · intro hne hdiv
    exact hne ((p_dvd_serrePadicInt_iff_proj_zero p x).1 hdiv)
  · intro hndvd hzero
    exact hndvd ((p_dvd_serrePadicInt_iff_proj_zero p x).2 hzero)

end PadicIntegerProperties

end SerreNumberTheoryAI
