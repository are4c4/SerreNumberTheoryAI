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
@[instance_reducible]
noncomputable def serrePadicIntSourceMetricCompleteSpace :
    @CompleteSpace (SerrePadicInt p) (serrePadicIntMetricSpace p).toUniformSpace := by
  letI : MetricSpace (SerrePadicInt p) := serrePadicIntMetricSpace p
  letI : CompactSpace (SerrePadicInt p) := serrePadicInt_compactSpace p
  exact complete_of_compact

/-- Ordinary integers are dense in the project p-adic integers for the source metric topology. -/
theorem serrePadicIntIntCast_denseRange : DenseRange (serrePadicIntIntCast p) := by
  change Dense (Set.range (serrePadicIntIntCast p))
  rw [dense_iff_inter_open]
  intro U hU hU_nonempty
  obtain ⟨x, hx⟩ := hU_nonempty
  obtain ⟨n, hn⟩ := exists_projFiber_subset_of_mem_open p hU hx
  obtain ⟨z, hz⟩ := ZMod.intCast_surjective (serrePadicIntProj p n x)
  refine ⟨serrePadicIntIntCast p z, ?_, ⟨z, rfl⟩⟩
  apply hn
  change serrePadicIntProj p n (serrePadicIntIntCast p z) =
    serrePadicIntProj p n x
  rw [serrePadicIntIntCast_proj]
  exact hz

end PadicIntegerMetricCompletion

end SerreNumberTheoryAI
