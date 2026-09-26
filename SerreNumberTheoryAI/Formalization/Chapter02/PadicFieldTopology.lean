import SerreNumberTheoryAI.Formalization.Chapter02.PadicField
import Mathlib.Topology.Algebra.Valued.WithZeroMulInt
import Mathlib.Topology.Algebra.Group.Pointwise

/-!
# Topology on the project p-adic field

This file starts the topological part of Serre, Chapter 2, §1.3, Proposition 4.

The topology is obtained from the discrete valuation attached to the project-local DVR
`SerrePadicInt p`.  The construction remains independent of mathlib's completed
`Padic` / `PadicInt` types.
-/

namespace SerreNumberTheoryAI

open Filter
open scoped Topology

section PadicFieldTopology

variable (p : ℕ) [Fact p.Prime]

/--
The canonical discrete valuation on the project fraction field.

It is the adic valuation of the maximal ideal of the project-local DVR
`SerrePadicInt p`.
-/
noncomputable def serrePadicFieldValuation :
    Valuation (SerrePadicField p) (WithZero (Multiplicative ℤ)) :=
  (IsDiscreteValuationRing.maximalIdeal (SerrePadicInt p)).valuation
    (SerrePadicField p)

/--
The project p-adic field carries the valuation topology attached to
`serrePadicFieldValuation`.
-/
@[instance_reducible]
noncomputable instance serrePadicFieldValued :
    Valued (SerrePadicField p) (WithZero (Multiplicative ℤ)) :=
  Valued.mk' (serrePadicFieldValuation p)

/--
Use the valuation topology, rather than the generic final ring topology carried by
`Localization`, as the canonical topology on the project p-adic field.
-/
noncomputable instance (priority := 1100) serrePadicFieldTopologicalSpace :
    TopologicalSpace (SerrePadicField p) :=
  (serrePadicFieldValued p).toTopologicalSpace

/-- The order-of-vanishing interface is the inverse of the field valuation. -/
theorem serrePadicFieldOrder_eq_valuation_inv (x : SerrePadicField p) :
    serrePadicFieldOrder p x = (serrePadicFieldValuation p x)⁻¹ := by
  simpa [serrePadicFieldOrder, serrePadicFieldValuation] using
    (Ring.ordFrac_eq_valuation_inv (R := SerrePadicInt p) x)

/-- The project prime element has valuation `exp (-1)`. -/
@[simp] theorem serrePadicFieldValuation_prime :
    serrePadicFieldValuation p (serrePadicFieldPrime p) =
      WithZero.exp (-1 : ℤ) := by
  have h :=
    serrePadicFieldOrder_eq_valuation_inv p (serrePadicFieldPrime p)
  rw [serrePadicFieldOrder_prime] at h
  have hinv := congrArg Inv.inv h
  simpa using hinv.symm

/-- Powers of the project prime tend to zero in the p-adic valuation topology. -/
theorem serrePadicFieldPrime_pow_tendsto_zero :
    Filter.Tendsto
      (fun n : ℕ => (serrePadicFieldPrime p) ^ n)
      Filter.atTop (𝓝 0) := by
  apply Valued.tendsto_zero_pow_of_le_exp_neg_one
  change
    serrePadicFieldValuation p (serrePadicFieldPrime p) ≤
      WithZero.exp (-1 : ℤ)
  rw [serrePadicFieldValuation_prime]

/-- The image of project `Z_p` inside its fraction field. -/
def serrePadicIntImage : Subring (SerrePadicField p) :=
  Subring.map (serrePadicIntToField p) ⊤

/--
The image of project `Z_p` is exactly the valuation subring of the project p-adic field.
-/
theorem serrePadicIntImage_eq_valuationSubring :
    serrePadicIntImage p =
      (serrePadicFieldValuation p).valuationSubring.toSubring := by
  simpa [serrePadicIntImage, serrePadicIntToField, serrePadicFieldValuation] using
    (IsDiscreteValuationRing.map_algebraMap_eq_valuationSubring
      (A := SerrePadicInt p) (K := SerrePadicField p))

/--
The project `Z_p` image is open in the valuation topology on the project p-adic field.
This is the openness part of Proposition 4.
-/
theorem isOpen_serrePadicIntImage :
    IsOpen (serrePadicIntImage p : Set (SerrePadicField p)) := by
  rw [serrePadicIntImage_eq_valuationSubring]
  exact Valued.isOpen_valuationSubring (SerrePadicField p)

/--
The canonical embedding of the project p-adic integers into the project p-adic field is
continuous for the inverse-limit topology on `SerrePadicInt p` and the valuation topology
on `SerrePadicField p`.
-/
theorem continuous_serrePadicIntToField :
    Continuous (serrePadicIntToField p) := by
  apply continuous_of_continuousAt_zero (serrePadicIntToField p)
  rw [ContinuousAt, map_zero]
  intro s hs
  obtain ⟨γ, hγ⟩ := Valued.mem_nhds_zero.mp hs
  let ball : Set (SerrePadicField p) :=
    {x | (serrePadicFieldValuation p).restrict x < γ.1}
  have hball : ball ∈ 𝓝 (0 : SerrePadicField p) := by
    apply Valued.mem_nhds_zero.mpr
    exact ⟨γ, by
      intro x hx
      exact hx⟩
  have hevent : ∀ᶠ n : ℕ in atTop,
      (serrePadicFieldPrime p) ^ n ∈ ball :=
    (serrePadicFieldPrime_pow_tendsto_zero p).eventually hball
  rw [Filter.eventually_atTop] at hevent
  obtain ⟨N, hN⟩ := hevent
  have hpN : (serrePadicFieldPrime p) ^ (N + 1) ∈ ball :=
    hN (N + 1) (Nat.le_succ N)
  have hfiber :
      serrePadicIntProjFiber p (0 : SerrePadicInt p) N ∈
        𝓝 (0 : SerrePadicInt p) :=
    (isOpen_serrePadicIntProjFiber p (0 : SerrePadicInt p) N).mem_nhds
      (self_mem_serrePadicIntProjFiber p (0 : SerrePadicInt p) N)
  apply Filter.mem_of_superset hfiber
  intro y hy
  apply hγ
  have hyproj : serrePadicIntProj p N y = 0 := by
    simpa [serrePadicIntProjFiber] using hy
  obtain ⟨z, hz⟩ :=
    (pow_dvd_serrePadicInt_iff_proj_zero p N y).2 hyproj
  have hzmem : serrePadicIntToField p z ∈ serrePadicIntImage p := by
    rw [serrePadicIntImage]
    exact ⟨z, by simp, rfl⟩
  rw [serrePadicIntImage_eq_valuationSubring] at hzmem
  have hzle :
      (serrePadicFieldValuation p).restrict
          (serrePadicIntToField p z) ≤ 1 := by
    rw [Valuation.restrict_le_one_iff]
    exact hzmem
  change
    (serrePadicFieldValuation p).restrict
        (serrePadicIntToField p y) < γ.1
  rw [hz, map_mul, map_pow]
  change
    (serrePadicFieldValuation p).restrict
        ((serrePadicFieldPrime p) ^ (N + 1) *
          serrePadicIntToField p z) < γ.1
  calc
    (serrePadicFieldValuation p).restrict
          ((serrePadicFieldPrime p) ^ (N + 1) *
            serrePadicIntToField p z)
        =
      (serrePadicFieldValuation p).restrict
          ((serrePadicFieldPrime p) ^ (N + 1)) *
        (serrePadicFieldValuation p).restrict
          (serrePadicIntToField p z) := by
            rw [map_mul]
    _ ≤
      (serrePadicFieldValuation p).restrict
          ((serrePadicFieldPrime p) ^ (N + 1)) * 1 := by
            gcongr
    _ =
      (serrePadicFieldValuation p).restrict
          ((serrePadicFieldPrime p) ^ (N + 1)) := by
            rw [mul_one]
    _ < γ.1 := hpN


/-- The embedded project p-adic integers form a compact subset of the project p-adic field. -/
theorem isCompact_serrePadicIntImage :
    IsCompact (serrePadicIntImage p : Set (SerrePadicField p)) := by
  have hcompact :
      IsCompact ((serrePadicIntToField p) '' (Set.univ : Set (SerrePadicInt p))) :=
    isCompact_univ.image (continuous_serrePadicIntToField p)
  simpa [serrePadicIntImage] using hcompact

/-- The embedded project p-adic integers are a compact neighborhood of zero. -/
theorem serrePadicIntImage_mem_nhds_zero :
    (serrePadicIntImage p : Set (SerrePadicField p)) ∈
      𝓝 (0 : SerrePadicField p) := by
  exact (isOpen_serrePadicIntImage p).mem_nhds (by
    rw [serrePadicIntImage]
    exact ⟨0, Set.mem_univ 0, by simp [serrePadicIntToField]⟩)

/--
The project p-adic field is locally compact: its open compact integer subring is a
compact neighborhood of zero, and additive translation gives compact neighborhoods
at every point.
-/
noncomputable instance serrePadicFieldLocallyCompactSpace :
    LocallyCompactSpace (SerrePadicField p) :=
  IsCompact.locallyCompactSpace_of_mem_nhds_of_addGroup
    (isCompact_serrePadicIntImage p)
    (serrePadicIntImage_mem_nhds_zero p)

end PadicFieldTopology

end SerreNumberTheoryAI
