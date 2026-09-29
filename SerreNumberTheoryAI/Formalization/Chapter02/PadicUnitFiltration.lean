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

/--
The unique coefficient \`x\` in \`u - 1 = p^(n+1) x\` for a principal unit
\`u ∈ U_(n+1)\`.
-/
noncomputable def serrePadicPrincipalUnitCoeff
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    SerrePadicInt p :=
  Classical.choose
    ((mem_serrePadicPrincipalUnits_succ_iff_pow_dvd p n
      (u : (SerrePadicInt p)ˣ)).1 u.property)

theorem serrePadicPrincipalUnitCoeff_spec
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) =
      (p : SerrePadicInt p) ^ (n + 1) *
        serrePadicPrincipalUnitCoeff p n u := by
  exact Classical.choose_spec
    ((mem_serrePadicPrincipalUnits_succ_iff_pow_dvd p n
      (u : (SerrePadicInt p)ˣ)).1 u.property)

/-- First residue of the coefficient of a principal unit. -/
noncomputable def serrePadicPrincipalUnitCoeffResidue
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    padicResidueRing p 0 :=
  serrePadicIntProj p 0 (serrePadicPrincipalUnitCoeff p n u)

/-- Every source-shaped element \`1 + p^(n+1) x\` is a p-adic unit. -/
theorem serrePadicOneAddPowMul_isUnit
    (n : ℕ) (x : SerrePadicInt p) :
    IsUnit (1 + (p : SerrePadicInt p) ^ (n + 1) * x) := by
  apply serrePadicInt_isUnit_of_proj_zero_isUnit p
  have hpdiv :
      (p : SerrePadicInt p) ∣
        (p : SerrePadicInt p) ^ (n + 1) * x := by
    refine ⟨(p : SerrePadicInt p) ^ n * x, ?_⟩
    rw [pow_succ]
    ring
  have hpzero :
      serrePadicIntProj p 0
          ((p : SerrePadicInt p) ^ (n + 1) * x) = 0 :=
    (p_dvd_serrePadicInt_iff_proj_zero p _).1 hpdiv
  rw [map_add, map_one, hpzero, add_zero]
  exact isUnit_one

/-- The principal unit represented by the coefficient \`x\` at level \`n+1\`. -/
noncomputable def serrePadicPrincipalUnitOfCoeff
    (n : ℕ) (x : SerrePadicInt p) :
    serrePadicPrincipalUnits p (n + 1) := by
  let hunit :=
    serrePadicOneAddPowMul_isUnit p n x
  let u : (SerrePadicInt p)ˣ := hunit.unit
  refine ⟨u, ?_⟩
  rw [mem_serrePadicPrincipalUnits_succ_iff_pow_dvd]
  refine ⟨x, ?_⟩
  have huval :
      (u : SerrePadicInt p) =
        1 + (p : SerrePadicInt p) ^ (n + 1) * x := by
    simpa [u] using IsUnit.unit_spec hunit
  rw [huval]
  ring

@[simp]
theorem serrePadicPrincipalUnitOfCoeff_val
    (n : ℕ) (x : SerrePadicInt p) :
    (((serrePadicPrincipalUnitOfCoeff p n x :
        serrePadicPrincipalUnits p (n + 1)) :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) =
      1 + (p : SerrePadicInt p) ^ (n + 1) * x := by
  simp [serrePadicPrincipalUnitOfCoeff, IsUnit.unit_spec]

@[simp]
theorem serrePadicPrincipalUnitCoeff_ofCoeff
    (n : ℕ) (x : SerrePadicInt p) :
    serrePadicPrincipalUnitCoeff p n
        (serrePadicPrincipalUnitOfCoeff p n x) = x := by
  apply serrePadicInt_mul_pow_injective p (n + 1)
  calc
    (p : SerrePadicInt p) ^ (n + 1) *
        serrePadicPrincipalUnitCoeff p n
          (serrePadicPrincipalUnitOfCoeff p n x) =
        ((((serrePadicPrincipalUnitOfCoeff p n x :
            serrePadicPrincipalUnits p (n + 1)) :
              (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) :=
      (serrePadicPrincipalUnitCoeff_spec p n
        (serrePadicPrincipalUnitOfCoeff p n x)).symm
    _ = (1 + (p : SerrePadicInt p) ^ (n + 1) * x) - 1 := by
      rw [serrePadicPrincipalUnitOfCoeff_val]
    _ = (p : SerrePadicInt p) ^ (n + 1) * x := by ring

@[simp]
theorem serrePadicPrincipalUnitCoeffResidue_ofCoeff
    (n : ℕ) (x : SerrePadicInt p) :
    serrePadicPrincipalUnitCoeffResidue p n
        (serrePadicPrincipalUnitOfCoeff p n x) =
      serrePadicIntProj p 0 x := by
  simp [serrePadicPrincipalUnitCoeffResidue]

/-- Every first residue occurs as the coefficient residue of a principal unit. -/
theorem serrePadicPrincipalUnitCoeffResidue_surjective (n : ℕ) :
    Function.Surjective (serrePadicPrincipalUnitCoeffResidue p n) := by
  intro a
  obtain ⟨x, hx⟩ := serrePadicIntProj_surjective p 0 a
  refine ⟨serrePadicPrincipalUnitOfCoeff p n x, ?_⟩
  simpa using hx

/--
The coefficient has zero first residue exactly when the principal unit lies
one step deeper in the filtration.
-/
theorem serrePadicPrincipalUnitCoeffResidue_eq_zero_iff
    (n : ℕ) (u : serrePadicPrincipalUnits p (n + 1)) :
    serrePadicPrincipalUnitCoeffResidue p n u = 0 ↔
      ((u : (SerrePadicInt p)ˣ) ∈
        serrePadicPrincipalUnits p (n + 2)) := by
  rw [mem_serrePadicPrincipalUnits_succ_iff_pow_dvd]
  constructor
  · intro hzero
    have hpcoeff :
        (p : SerrePadicInt p) ∣ serrePadicPrincipalUnitCoeff p n u := by
      exact (p_dvd_serrePadicInt_iff_proj_zero p _).2 hzero
    obtain ⟨z, hz⟩ := hpcoeff
    refine ⟨z, ?_⟩
    calc
      (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) =
          (p : SerrePadicInt p) ^ (n + 1) *
            serrePadicPrincipalUnitCoeff p n u :=
        serrePadicPrincipalUnitCoeff_spec p n u
      _ = (p : SerrePadicInt p) ^ (n + 1) *
            ((p : SerrePadicInt p) * z) := by rw [hz]
      _ = (p : SerrePadicInt p) ^ (n + 2) * z := by
        rw [show n + 2 = (n + 1) + 1 by omega, pow_succ]
        ring
  · intro hdeep
    obtain ⟨z, hz⟩ := hdeep
    have heq :
        (p : SerrePadicInt p) ^ (n + 1) *
            serrePadicPrincipalUnitCoeff p n u =
          (p : SerrePadicInt p) ^ (n + 1) *
            ((p : SerrePadicInt p) * z) := by
      calc
        (p : SerrePadicInt p) ^ (n + 1) *
            serrePadicPrincipalUnitCoeff p n u =
            (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) :=
          (serrePadicPrincipalUnitCoeff_spec p n u).symm
        _ = (p : SerrePadicInt p) ^ (n + 2) * z := hz
        _ = (p : SerrePadicInt p) ^ (n + 1) *
            ((p : SerrePadicInt p) * z) := by
          rw [show n + 2 = (n + 1) + 1 by omega, pow_succ]
          ring
    have hcoeff :
        serrePadicPrincipalUnitCoeff p n u =
          (p : SerrePadicInt p) * z :=
      serrePadicInt_mul_pow_injective p (n + 1) heq
    change serrePadicIntProj p 0
        (serrePadicPrincipalUnitCoeff p n u) = 0
    apply (p_dvd_serrePadicInt_iff_proj_zero p _).1
    exact ⟨z, hcoeff⟩

/--
Modulo \`p\`, the coefficient of a product of principal units is the sum
of the two coefficients.  This is the homomorphism calculation behind
\`U_(n+1) / U_(n+2)\`.
-/
theorem serrePadicPrincipalUnitCoeffResidue_mul
    (n : ℕ)
    (u v : serrePadicPrincipalUnits p (n + 1)) :
    serrePadicPrincipalUnitCoeffResidue p n (u * v) =
      serrePadicPrincipalUnitCoeffResidue p n u +
        serrePadicPrincipalUnitCoeffResidue p n v := by
  let x := serrePadicPrincipalUnitCoeff p n u
  let y := serrePadicPrincipalUnitCoeff p n v
  let z := serrePadicPrincipalUnitCoeff p n (u * v)
  have huspec :
      (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) =
        (p : SerrePadicInt p) ^ (n + 1) * x := by
    simpa [x] using serrePadicPrincipalUnitCoeff_spec p n u
  have hvspec :
      (((v : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) =
        (p : SerrePadicInt p) ^ (n + 1) * y := by
    simpa [y] using serrePadicPrincipalUnitCoeff_spec p n v
  have hzspec :
      ((((u * v : serrePadicPrincipalUnits p (n + 1)) :
          (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) =
        (p : SerrePadicInt p) ^ (n + 1) * z := by
    simpa [z] using
      serrePadicPrincipalUnitCoeff_spec p n (u * v)
  have huval :
      ((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) =
        1 + (p : SerrePadicInt p) ^ (n + 1) * x := by
    calc
      ((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) =
          (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) + 1 := by ring
      _ = (p : SerrePadicInt p) ^ (n + 1) * x + 1 := by rw [huspec]
      _ = 1 + (p : SerrePadicInt p) ^ (n + 1) * x := by ring
  have hvval :
      ((v : (SerrePadicInt p)ˣ) : SerrePadicInt p) =
        1 + (p : SerrePadicInt p) ^ (n + 1) * y := by
    calc
      ((v : (SerrePadicInt p)ˣ) : SerrePadicInt p) =
          (((v : (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) + 1 := by ring
      _ = (p : SerrePadicInt p) ^ (n + 1) * y + 1 := by rw [hvspec]
      _ = 1 + (p : SerrePadicInt p) ^ (n + 1) * y := by ring
  have heq :
      (p : SerrePadicInt p) ^ (n + 1) * z =
        (p : SerrePadicInt p) ^ (n + 1) *
          ((x + y) + (p : SerrePadicInt p) ^ (n + 1) * (x * y)) := by
    calc
      (p : SerrePadicInt p) ^ (n + 1) * z =
          ((((u * v : serrePadicPrincipalUnits p (n + 1)) :
              (SerrePadicInt p)ˣ) : SerrePadicInt p) - 1) := hzspec.symm
      _ = (((u : (SerrePadicInt p)ˣ) : SerrePadicInt p) *
            ((v : (SerrePadicInt p)ˣ) : SerrePadicInt p)) - 1 := by rfl
      _ = (1 + (p : SerrePadicInt p) ^ (n + 1) * x) *
            (1 + (p : SerrePadicInt p) ^ (n + 1) * y) - 1 := by
          rw [huval, hvval]
      _ = (p : SerrePadicInt p) ^ (n + 1) *
          ((x + y) + (p : SerrePadicInt p) ^ (n + 1) * (x * y)) := by ring
  have hz :
      z = (x + y) +
        (p : SerrePadicInt p) ^ (n + 1) * (x * y) :=
    serrePadicInt_mul_pow_injective p (n + 1) heq
  have hpdiv :
      (p : SerrePadicInt p) ∣
        (p : SerrePadicInt p) ^ (n + 1) * (x * y) := by
    refine ⟨(p : SerrePadicInt p) ^ n * (x * y), ?_⟩
    rw [pow_succ]
    ring
  have hpzero :
      serrePadicIntProj p 0
          ((p : SerrePadicInt p) ^ (n + 1) * (x * y)) = 0 :=
    (p_dvd_serrePadicInt_iff_proj_zero p _).1 hpdiv
  change serrePadicIntProj p 0 z =
    serrePadicIntProj p 0 x + serrePadicIntProj p 0 y
  rw [hz, map_add, map_add, hpzero, add_zero]

/--
The coefficient-residue map as a homomorphism from the multiplicative
principal-unit group to the additive residue group, encoded with
\`Multiplicative\`.
-/
noncomputable def serrePadicPrincipalUnitCoeffResidueHom (n : ℕ) :
    serrePadicPrincipalUnits p (n + 1) →*
      Multiplicative (padicResidueRing p 0) where
  toFun u :=
    Multiplicative.ofAdd
      (serrePadicPrincipalUnitCoeffResidue p n u)
  map_one' := by
    change serrePadicPrincipalUnitCoeffResidue p n 1 = 0
    exact (serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n 1).2 (by simp)
  map_mul' u v := by
    change serrePadicPrincipalUnitCoeffResidue p n (u * v) =
      serrePadicPrincipalUnitCoeffResidue p n u +
        serrePadicPrincipalUnitCoeffResidue p n v
    exact serrePadicPrincipalUnitCoeffResidue_mul p n u v

/-- The coefficient-residue homomorphism has exactly the next filtration level as kernel. -/
theorem serrePadicPrincipalUnitCoeffResidueHom_ker (n : ℕ) :
    (serrePadicPrincipalUnitCoeffResidueHom p n).ker =
      serrePadicPrincipalUnitsNextSubgroup p n := by
  ext u
  change (serrePadicPrincipalUnitCoeffResidueHom p n) u = 1 ↔
    ((u : (SerrePadicInt p)ˣ) ∈
      serrePadicPrincipalUnits p (n + 2))
  change serrePadicPrincipalUnitCoeffResidue p n u = 0 ↔
    ((u : (SerrePadicInt p)ˣ) ∈
      serrePadicPrincipalUnits p (n + 2))
  exact serrePadicPrincipalUnitCoeffResidue_eq_zero_iff p n u

/-- The coefficient-residue homomorphism is onto the first residue ring. -/
theorem serrePadicPrincipalUnitCoeffResidueHom_surjective (n : ℕ) :
    Function.Surjective (serrePadicPrincipalUnitCoeffResidueHom p n) := by
  intro a
  obtain ⟨u, hu⟩ :=
    serrePadicPrincipalUnitCoeffResidue_surjective p n a.toAdd
  refine ⟨u, ?_⟩
  simpa [serrePadicPrincipalUnitCoeffResidueHom] using
    congrArg Multiplicative.ofAdd hu

/--
The source successive quotient:
\`U_(n+1) / U_(n+2)\` is the additive first residue group.
-/
noncomputable def serrePadicPrincipalUnitsSuccessiveQuotientEquiv
    (n : ℕ) :
    serrePadicPrincipalUnitsSuccessiveQuotient p n ≃*
      Multiplicative (padicResidueRing p 0) := by
  rw [← serrePadicPrincipalUnitCoeffResidueHom_ker p n]
  exact QuotientGroup.quotientKerEquivOfSurjective
    (serrePadicPrincipalUnitCoeffResidueHom p n)
    (serrePadicPrincipalUnitCoeffResidueHom_surjective p n)

/--
Source congruence behind the successive quotient map:
for \`n ≥ 1\`, multiplication of \`1 + p^n x\` and \`1 + p^n y\`
agrees with addition of coefficients modulo \`p^(n+1)\`.
-/
theorem serrePadicPrincipalUnit_mul_congruent_add
    (n : ℕ) (hn : 1 ≤ n) (x y : SerrePadicInt p) :
    (p : SerrePadicInt p) ^ (n + 1) ∣
      ((1 + (p : SerrePadicInt p) ^ n * x) *
          (1 + (p : SerrePadicInt p) ^ n * y) -
        (1 + (p : SerrePadicInt p) ^ n * (x + y))) := by
  have hle : n + 1 ≤ 2 * n := by omega
  obtain ⟨z, hz⟩ :=
    pow_dvd_pow (p : SerrePadicInt p) hle
  refine ⟨z * (x * y), ?_⟩
  calc
    (1 + (p : SerrePadicInt p) ^ n * x) *
          (1 + (p : SerrePadicInt p) ^ n * y) -
        (1 + (p : SerrePadicInt p) ^ n * (x + y)) =
        (p : SerrePadicInt p) ^ (2 * n) * (x * y) := by ring
    _ = ((p : SerrePadicInt p) ^ (n + 1) * z) * (x * y) := by rw [hz]
    _ = (p : SerrePadicInt p) ^ (n + 1) * (z * (x * y)) := by ring

/-- Projection form of the source congruence modulo \`p^(n+1)\`. -/
theorem serrePadicPrincipalUnit_mul_proj
    (n : ℕ) (hn : 1 ≤ n) (x y : SerrePadicInt p) :
    serrePadicIntProj p n
        ((1 + (p : SerrePadicInt p) ^ n * x) *
          (1 + (p : SerrePadicInt p) ^ n * y)) =
      serrePadicIntProj p n
        (1 + (p : SerrePadicInt p) ^ n * (x + y)) := by
  have hdiv :=
    serrePadicPrincipalUnit_mul_congruent_add p n hn x y
  have hzero :
      serrePadicIntProj p n
          (((1 + (p : SerrePadicInt p) ^ n * x) *
              (1 + (p : SerrePadicInt p) ^ n * y)) -
            (1 + (p : SerrePadicInt p) ^ n * (x + y))) = 0 :=
    (pow_dvd_serrePadicInt_iff_proj_zero p n _).1 hdiv
  rw [map_sub] at hzero
  exact sub_eq_zero.mp hzero

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
