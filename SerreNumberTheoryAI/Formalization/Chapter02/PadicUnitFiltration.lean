import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerValuationAPI
import Mathlib.GroupTheory.QuotientGroup.Basic

/-!
# Principal-unit filtration in the project p-adic integers

This file begins the source-shaped reconstruction of Serre Chapter 2, §3.1.
The filtration is indexed by the source modulus: `U_n` is the kernel of reduction
modulo `p^n` for `n ≥ 1`, while `U_0 = U`.
-/

namespace SerreNumberTheoryAI

section PadicUnitFiltration

variable (p : ℕ) [Fact p.Prime]

/-- Reduction of project p-adic units to one finite residue level. -/
def serrePadicUnitReductionLevel (n : ℕ) :
    (SerrePadicInt p)ˣ →* (padicResidueRing p n)ˣ :=
  Units.map (serrePadicIntProj p n)

/--
The source-indexed principal-unit filtration.  Source `U_(n+1)` is the kernel of
reduction to `Z / p^(n+1) Z`; `U_0` is the full unit group.
-/
def serrePadicPrincipalUnits : ℕ → Subgroup (SerrePadicInt p)ˣ
  | 0 => ⊤
  | n + 1 => (serrePadicUnitReductionLevel p n).ker

@[simp]
theorem serrePadicPrincipalUnits_zero :
    serrePadicPrincipalUnits p 0 = ⊤ := rfl

/-- Membership in `U_(n+1)` is exactly congruence to one modulo `p^(n+1)`. -/
theorem mem_serrePadicPrincipalUnits_succ_iff_pow_dvd
    (n : ℕ) (u : (SerrePadicInt p)ˣ) :
    u ∈ serrePadicPrincipalUnits p (n + 1) ↔
      (p : SerrePadicInt p) ^ (n + 1) ∣
        ((u : SerrePadicInt p) - 1) := by
  constructor
  · intro hu
    change serrePadicUnitReductionLevel p n u = 1 at hu
    have hval := congrArg
      (fun z : (padicResidueRing p n)ˣ => (z : padicResidueRing p n)) hu
    have hval' :
        serrePadicIntProj p n (u : SerrePadicInt p) = 1 := by
      simpa [serrePadicUnitReductionLevel] using hval
    have hzero :
        serrePadicIntProj p n ((u : SerrePadicInt p) - 1) = 0 := by
      rw [map_sub]
      exact sub_eq_zero.mpr hval'
    exact (pow_dvd_serrePadicInt_iff_proj_zero p n _).2 hzero
  · intro hdiv
    change serrePadicUnitReductionLevel p n u = 1
    apply Units.ext
    change serrePadicIntProj p n (u : SerrePadicInt p) = 1
    have hzero :
        serrePadicIntProj p n ((u : SerrePadicInt p) - 1) = 0 :=
      (pow_dvd_serrePadicInt_iff_proj_zero p n _).1 hdiv
    rw [map_sub] at hzero
    exact sub_eq_zero.mp (by simpa using hzero)

/-- The source principal-unit filtration is descending at consecutive positive levels. -/
theorem serrePadicPrincipalUnits_succ_succ_le_succ (n : ℕ) :
    serrePadicPrincipalUnits p (n + 2) ≤ serrePadicPrincipalUnits p (n + 1) := by
  intro u hu
  rw [mem_serrePadicPrincipalUnits_succ_iff_pow_dvd] at hu ⊢
  exact (pow_dvd_pow (p : SerrePadicInt p) (Nat.le_succ (n + 1))).trans hu

/--
The next filtration level, regarded as a subgroup of the current positive level.
This is the subgroup used to form the source successive quotient.
-/
def serrePadicPrincipalUnitsNextSubgroup (n : ℕ) :
    Subgroup (serrePadicPrincipalUnits p (n + 1)) :=
  (serrePadicPrincipalUnits p (n + 2)).comap
    (serrePadicPrincipalUnits p (n + 1)).subtype

@[simp]
theorem mem_serrePadicPrincipalUnitsNextSubgroup
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    u ∈ serrePadicPrincipalUnitsNextSubgroup p n ↔
      (u : (SerrePadicInt p)ˣ) ∈ serrePadicPrincipalUnits p (n + 2) := by
  rfl

/-- The source successive principal-unit quotient at the positive level \`n+1\`. -/
abbrev serrePadicPrincipalUnitsSuccessiveQuotient (n : ℕ) :=
  serrePadicPrincipalUnits p (n + 1) ⧸
    serrePadicPrincipalUnitsNextSubgroup p n

/-- The first reduction map `U → (Z/pZ)ˣ`, expressed in the project residue indexing. -/
def serrePadicUnitReduction :
    (SerrePadicInt p)ˣ →* (padicResidueRing p 0)ˣ :=
  serrePadicUnitReductionLevel p 0

/-- Every unit modulo `p` lifts to a project p-adic unit. -/
theorem serrePadicUnitReduction_surjective :
    Function.Surjective (serrePadicUnitReduction p) := by
  intro v
  obtain ⟨x, hx⟩ :=
    serrePadicIntProj_surjective p 0 (v : padicResidueRing p 0)
  have hxunit : IsUnit (serrePadicIntProj p 0 x) := by
    rw [hx]
    exact v.isUnit
  have hxu : IsUnit x :=
    serrePadicInt_isUnit_of_proj_zero_isUnit p x hxunit
  let u : (SerrePadicInt p)ˣ := hxu.unit
  refine ⟨u, ?_⟩
  apply Units.ext
  change serrePadicIntProj p 0 (u : SerrePadicInt p) = (v : padicResidueRing p 0)
  simpa [u, IsUnit.unit_spec hxu] using hx

/-- The source subgroup `U_1` is the kernel of reduction modulo `p`. -/
theorem serrePadicPrincipalUnits_one_eq_ker :
    serrePadicPrincipalUnits p 1 = (serrePadicUnitReduction p).ker := by
  rfl

/-- The first source quotient `U/U_1` is the unit group of the prime residue ring. -/
noncomputable def serrePadicUnitsQuotientPrincipalOneEquiv :
    (SerrePadicInt p)ˣ ⧸ serrePadicPrincipalUnits p 1 ≃*
      (padicResidueRing p 0)ˣ := by
  rw [serrePadicPrincipalUnits_one_eq_ker]
  exact QuotientGroup.quotientKerEquivOfSurjective
    (serrePadicUnitReduction p) (serrePadicUnitReduction_surjective p)

end PadicUnitFiltration

end SerreNumberTheoryAI
