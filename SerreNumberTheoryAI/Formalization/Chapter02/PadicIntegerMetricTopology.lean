import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetric
import Mathlib.Topology.MetricSpace.PiNat

/-!
# Topology induced by the project p-adic metric

This file identifies the source metric constructed from the project-local additive valuation with
 the inverse-limit topology already carried by `SerrePadicInt`.  The argument uses only the
finite-coordinate cylinder basis of a product of discrete spaces and the project residue maps.
-/

namespace SerreNumberTheoryAI

section PadicIntegerMetricTopology

variable (p : ℕ) [Fact p.Prime]

/-- Equality at a higher residue level forces equality at every lower level. -/
theorem serrePadicIntProj_eq_of_le
    {x y : SerrePadicInt p} {m n : ℕ} (hmn : m ≤ n)
    (hxy : serrePadicIntProj p n x = serrePadicIntProj p n y) :
    serrePadicIntProj p m x = serrePadicIntProj p m y := by
  have hx := serrePadicIntProj_cast_of_le p x hmn
  have hy := serrePadicIntProj_cast_of_le p y hmn
  rw [← hx, ← hy, hxy]

/-- The residue-level cylinder around a project p-adic integer. -/
def serrePadicIntProjFiber (x : SerrePadicInt p) (n : ℕ) : Set (SerrePadicInt p) :=
  {y | serrePadicIntProj p n y = serrePadicIntProj p n x}

@[simp]
theorem mem_serrePadicIntProjFiber_iff (x y : SerrePadicInt p) (n : ℕ) :
    y ∈ serrePadicIntProjFiber p x n ↔
      serrePadicIntProj p n y = serrePadicIntProj p n x :=
  Iff.rfl

@[simp]
theorem self_mem_serrePadicIntProjFiber (x : SerrePadicInt p) (n : ℕ) :
    x ∈ serrePadicIntProjFiber p x n := by
  rfl

/-- A residue-level fiber is open in the inverse-limit topology. -/
theorem isOpen_serrePadicIntProjFiber (x : SerrePadicInt p) (n : ℕ) :
    IsOpen (serrePadicIntProjFiber p x n) := by
  change IsOpen ((serrePadicIntProj p n) ⁻¹' {serrePadicIntProj p n x})
  exact (isOpen_discrete _).preimage (serrePadicIntProj_continuous p n)

/-- Every inverse-limit open neighborhood contains a single sufficiently high residue fiber. -/
theorem exists_projFiber_subset_of_mem_open
    {s : Set (SerrePadicInt p)} (hs : IsOpen s)
    {x : SerrePadicInt p} (hx : x ∈ s) :
    ∃ n : ℕ, serrePadicIntProjFiber p x n ⊆ s := by
  obtain ⟨u, hu, hus⟩ :=
    (Topology.IsInducing.subtypeVal.isOpen_iff).1 hs
  have hxu : x.1 ∈ u := by
    change x ∈ Subtype.val ⁻¹' u
    rw [hus]
    exact hx
  obtain ⟨v, hv, hxv, hvu⟩ :=
    (PiNat.isTopologicalBasis_cylinders
      (fun n : ℕ => padicResidueRing p n)).exists_subset_of_mem_open hxu hu
  obtain ⟨z, n, rfl⟩ := hv
  refine ⟨n, ?_⟩
  intro y hy
  have hycyl : y.1 ∈ PiNat.cylinder z n := by
    rw [PiNat.mem_cylinder_iff]
    intro i hi
    have hhigh : serrePadicIntProj p n y = serrePadicIntProj p n x := hy
    have hlow : serrePadicIntProj p i y = serrePadicIntProj p i x :=
      serrePadicIntProj_eq_of_le p (Nat.le_of_lt hi) hhigh
    have hxcyl := (PiNat.mem_cylinder_iff.mp hxv) i hi
    exact (by simpa only [serrePadicIntProj_apply] using hlow).trans hxcyl
  have hyu : y.1 ∈ u := hvu hycyl
  change y ∈ Subtype.val ⁻¹' u at hyu
  rw [hus] at hyu
  exact hyu

/--
The source metric open sets are exactly the pre-existing inverse-limit open sets.
This is the compatibility condition required by `MetricSpace.ofDistTopology`.
-/
theorem serrePadicInt_isOpen_iff_dist (s : Set (SerrePadicInt p)) :
    IsOpen s ↔
      ∀ x ∈ s, ∃ ε > 0, ∀ y,
        serrePadicIntDist p x y < ε → y ∈ s := by
  constructor
  · intro hs x hx
    obtain ⟨n, hn⟩ := exists_projFiber_subset_of_mem_open p hs hx
    refine ⟨Real.exp (-((n + 1 : ℕ) : ℝ)), Real.exp_pos _, ?_⟩
    intro y hxy
    apply hn
    exact (serrePadicIntDist_le_radius_succ_iff_proj_eq p x y n).1 hxy.le
  · intro h
    rw [isOpen_iff_mem_nhds]
    intro x hx
    obtain ⟨ε, hε, hball⟩ := h x hx
    let r : ℝ := Real.exp (-1)
    have hr : r < 1 := by
      dsimp [r]
      exact (Real.exp_lt_one_iff).2 (by norm_num)
    obtain ⟨n, hn⟩ := exists_pow_lt_of_lt_one hε hr
    have hnexp : Real.exp (-(n : ℝ)) < ε := by
      simpa [r, ← Real.exp_nat_mul, mul_comm] using hn
    have hnsucc : Real.exp (-((n + 1 : ℕ) : ℝ)) < ε := by
      have hlt : Real.exp (-((n + 1 : ℕ) : ℝ)) < Real.exp (-(n : ℝ)) := by
        apply Real.exp_lt_exp.mpr
        exact neg_lt_neg (by exact_mod_cast Nat.lt_succ_self n)
      exact hlt.trans hnexp
    have hopen := isOpen_serrePadicIntProjFiber p x n
    have hmem := self_mem_serrePadicIntProjFiber p x n
    apply Filter.mem_of_superset (hopen.mem_nhds hmem)
    intro y hy
    apply hball y
    have hle : serrePadicIntDist p x y ≤ Real.exp (-((n + 1 : ℕ) : ℝ)) :=
      (serrePadicIntDist_le_radius_succ_iff_proj_eq p x y n).2 hy
    exact hle.trans_lt hnsucc

/-- The source p-adic distance, bundled as a metric while preserving the inverse-limit topology. -/
noncomputable def serrePadicIntMetricSpace : MetricSpace (SerrePadicInt p) :=
  MetricSpace.ofDistTopology
    (serrePadicIntDist p)
    (serrePadicIntDist_self p)
    (serrePadicIntDist_comm p)
    (serrePadicIntDist_triangle p)
    (serrePadicInt_isOpen_iff_dist p)
    (fun x y h => (serrePadicIntDist_eq_zero_iff p x y).1 h)

end PadicIntegerMetricTopology

end SerreNumberTheoryAI
