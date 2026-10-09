import SerreNumberTheoryAI.Formalization.Chapter02.PadicPrincipalUnitResidueQuotient

/-!
# Reconstructing project principal units from coherent finite quotients

The source's inverse-limit argument in §3.2 requires extracting
compatible representatives of every finite principal-unit quotient.
The lemmas below are preparatory: they do not yet claim the resulting
map to project p-adic units is surjective.
-/

namespace SerreNumberTheoryAI

section PadicPrincipalUnitInverseLimitReconstruction

variable (p : ℕ) [Fact p.Prime]

/-- Choose a source principal-unit representative at each finite-quotient level. -/
noncomputable def serrePadicPrincipalUnitFiniteInverseLimitRep
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    serrePadicPrincipalUnits p (n + 1) :=
  Quotient.out
    ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k)

/-- The chosen representative maps to the specified finite quotient class. -/
theorem serrePadicPrincipalUnitFiniteInverseLimitRep_spec
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
      (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) =
    ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) := by
  exact Quotient.out_eq'

/--
Adjacent representatives are congruent in the *shallower* finite quotient.
This is the projective compatibility needed to glue residue coordinates.
-/
theorem serrePadicPrincipalUnitFiniteInverseLimitRep_adjacent
    (n k : ℕ) (x : serrePadicPrincipalUnitFiniteInverseLimit p n) :
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) := by
  calc
    (QuotientGroup.mk'
      (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x) =
      serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
        ((QuotientGroup.mk'
          (serrePadicPrincipalUnitDeepSubgroup p n (k + 2)))
          (serrePadicPrincipalUnitFiniteInverseLimitRep p n (k + 1) x)) := by
            symm
            exact serrePadicPrincipalUnitFiniteQuotientTransition_mk p n (k + 1) _
    _ = serrePadicPrincipalUnitFiniteQuotientTransition p n (k + 1)
          ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1))
            (k + 1)) := by
          rw [serrePadicPrincipalUnitFiniteInverseLimitRep_spec]
    _ = ((x : ∀ k, serrePadicPrincipalUnitFiniteQuotient p n (k + 1)) k) :=
      x.property k
    _ = (QuotientGroup.mk'
        (serrePadicPrincipalUnitDeepSubgroup p n (k + 1)))
        (serrePadicPrincipalUnitFiniteInverseLimitRep p n k x) :=
      (serrePadicPrincipalUnitFiniteInverseLimitRep_spec p n k x).symm

end PadicPrincipalUnitInverseLimitReconstruction

end SerreNumberTheoryAI
