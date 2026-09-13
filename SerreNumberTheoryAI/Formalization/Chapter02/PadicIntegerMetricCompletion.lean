import SerreNumberTheoryAI.Formalization.Chapter02.PadicIntegerMetricTopology

/-!
# Completeness and integer density for the project p-adic integers

The source metric is now known to induce the inverse-limit topology.  Compactness of that existing
 topology therefore yields metric completeness by general uniform-space infrastructure, and the
canonical image of `ℤ` is dense by finite residue approximation.
-/

namespace SerreNumberTheoryAI

section PadicIntegerMetricCompletion

variable (p : ℕ) [Fact p.Prime]

/-- The source metric on the project p-adic integers is complete. -/
noncomputable def serrePadicIntSourceMetricCompleteSpace :
    @CompleteSpace (SerrePadicInt p) (serrePadicIntMetricSpace p).toUniformSpace := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  exact complete_of_compact

/-- Ordinary integers are dense in the project p-adic integers for the source metric topology. -/
theorem serrePadicIntIntCast_denseRange : DenseRange (serrePadicIntIntCast p) := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  rw [Metric.denseRange_iff]
  intro x ε hε
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
  obtain ⟨z, hz⟩ := ZMod.intCast_surjective (serrePadicIntProj p n x)
  refine ⟨z, ?_⟩
  change serrePadicIntDist p x (serrePadicIntIntCast p z) < ε
  have hproj :
      serrePadicIntProj p n x =
        serrePadicIntProj p n (serrePadicIntIntCast p z) := by
    rw [serrePadicIntIntCast_proj]
    exact hz.symm
  have hle :
      serrePadicIntDist p x (serrePadicIntIntCast p z) ≤
        Real.exp (-((n + 1 : ℕ) : ℝ)) :=
    (serrePadicIntDist_le_radius_succ_iff_proj_eq
      p x (serrePadicIntIntCast p z) n).2 hproj
  exact hle.trans_lt hnsucc

end PadicIntegerMetricCompletion

end SerreNumberTheoryAI
